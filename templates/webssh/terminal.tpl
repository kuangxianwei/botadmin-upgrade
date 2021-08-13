<link href="/static/webssh/xterm.css" rel="stylesheet">
<link href="/static/webssh/toastr.min.css" rel="stylesheet">
<div class="layui-card">
    <div class="layui-card-body" id="terminal"></div>
</div>
<script src="/static/layui/layui.js"></script>
<script src="/static/webssh/zmodem.js"></script>
<script src="/static/webssh/xterm.js"></script>
<script src="/static/webssh/bootbox.min.js"></script>
<script src="/static/webssh/toastr.min.js"></script>
<script>
    // 增加刷新关闭提示属性
    function checkWindow() {
        event.returnValue = false;
    }

    class WebSSH {
        constructor() {
            // utf-8编码转为base64编码
            this.utf8ToB64 = (rawString) => {
                return btoa(unescape(encodeURIComponent(rawString)));
            };
            // base64编码转为utf-8编码
            this.b64ToUtf8 = (encodeString) => {
                return decodeURIComponent(escape(atob(encodeString)));
            };
            // 字节转为人类识别的B/KB/MB/GB
            this.bytesHuman = (bytes, precision) => {
                if (!/^([-+])?|(\.\d+)(\d+(\.\d+)?|(\d+\.)|Infinity)$/.test(bytes)) {
                    return '-'
                }
                if (bytes === 0) return '0';
                if (typeof precision === 'undefined') precision = 1;
                const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', 'BB'];
                const num = Math.floor(Math.log(bytes) / Math.log(1024));
                const value = (bytes / Math.pow(1024, Math.floor(num))).toFixed(precision);
                return `${value} ${units[num]}`
            };
            // 获取终端大小
            this.getTermSize = () => {
                let init_width = 9,
                    init_height = 17,
                    windows_width = $(window).width() - 30,
                    windows_height = $(window).height() - 20;
                return {
                    cols: Math.floor(windows_width / init_width),
                    rows: Math.floor(windows_height / init_height),
                }
            };
            // 连接终端
            this.connect = (data) => {
                let othis = this,
                    cols_rows = this.getTermSize(),
                    socketUri = ((location.protocol === 'https:') ? 'wss://' : 'ws://') + location.host + '/ws/webssh';
                data.cols = cols_rows.cols;
                data.rows = cols_rows.rows;
                let term = new Terminal({
                    rendererType: 'canvas',
                    cols: data.cols,
                    rows: data.rows,
                    useStyle: true,
                    cursorBlink: true,
                    theme: {
                        foreground: '#7e9192',
                        background: '#002833',
                    }
                });
                toastr.options.closeButton = false;
                toastr.options.showMethod = 'slideDown';
                toastr.options.hideMethod = 'fadeOut';
                toastr.options.closeMethod = 'fadeOut';
                toastr.options.timeOut = 5000;
                toastr.options.extendedTimeOut = 3000;
                // toastr.options.progressBar = true;
                toastr.options.positionClass = 'toast-top-right';
                let socket = new WebSocket(socketUri, ['webssh']);
                // let socket = new WebSocket('ws://127.0.0.1:80/ws/webssh', ['webssh']);
                socket.binaryType = "arraybuffer";
                // 切换到终端
                term.open(document.getElementById('terminal'));
                term.focus();
                $("body").attr("onbeforeunload", 'checkWindow()'); //增加刷新关闭提示属性

                function uploadFile(zSession) {
                    let uploadHtml = "<div>" +
                        "<label class='upload-area' style='width:100%;text-align:center;' for='fupload'>" +
                        "<input id='fupload' name='fupload' type='file' style='display:none;' multiple='true'>" +
                        "<i class='fa fa-cloud-upload fa-3x'></i>" +
                        "<br />" +
                        "点击选择文件" +
                        "</label>" +
                        "<br />" +
                        "<span style='margin-left:5px !important;' id='fileList'></span>" +
                        "</div><div class='clearfix'></div>";

                    let upload_dialog = bootbox.dialog({
                        message: uploadHtml,
                        title: "上传文件",
                        buttons: {
                            cancel: {
                                label: '关闭',
                                className: 'btn-default',
                                callback: function (res) {
                                    console.log(res);
                                    try {
                                        // zsession 每 5s 发送一个 ZACK 包，5s 后会出现提示最后一个包是 ”ZACK“ 无法正常关闭
                                        // 这里直接设置 _last_header_name 为 ZRINIT，就可以强制关闭了
                                        zSession._last_header_name = "ZRINIT";
                                        zSession.close();
                                    } catch (e) {
                                        console.log(e);
                                    }
                                }
                            },
                        },
                        closeButton: false,
                    });

                    function hideModal() {
                        upload_dialog.modal('hide');
                    }

                    let file_el = document.getElementById("fupload");

                    return new Promise((res) => {
                        file_el.onchange = function (e) {
                            console.warn(e);
                            let files_obj = file_el.files;
                            hideModal();
                            let files = [];
                            for (let i of files_obj) {
                                if (i.size <= 2048 * 1024 * 1024) {
                                    files.push(i);
                                } else {
                                    toastr.warning(`${i.name} 超过 2048 MB, 无法上传`);
                                    // console.log(i.name, i.size, '超过 2048 MB, 无法上传');
                                }
                            }
                            if (files.length === 0) {
                                try {
                                    // zsession 每 5s 发送一个 ZACK 包，5s 后会出现提示最后一个包是 ”ZACK“ 无法正常关闭
                                    // 这里直接设置 _last_header_name 为 ZRINIT，就可以强制关闭了
                                    zSession._last_header_name = "ZRINIT";
                                    zSession.close();
                                } catch (e) {
                                    console.log(e);
                                }
                                return
                            } else if (files.length >= 25) {
                                toastr.warning("上传文件个数不能超过 25 个");
                                try {
                                    // zsession 每 5s 发送一个 ZACK 包，5s 后会出现提示最后一个包是 ”ZACK“ 无法正常关闭
                                    // 这里直接设置 _last_header_name 为 ZRINIT，就可以强制关闭了
                                    zSession._last_header_name = "ZRINIT";
                                    zSession.close();
                                } catch (e) {
                                    console.log(e);
                                }
                                return
                            }
                            //Zmodem.Browser.send_files(zsession, files, {
                            Zmodem.Browser.send_block_files(zSession, files, {
                                    on_offer_response(obj, xfe) {
                                        if (xfe) {
                                            // term.write("\r\n");
                                        } else {
                                            term.write(obj.name + " was upload skipped\r\n");
                                            // socket.send(JSON.stringify({ type: "ignore", data: othis.utf8ToB64("\r\n" + obj.name + " was upload skipped\r\n") }));
                                        }
                                    },
                                    on_progress(obj, xfer) {
                                        updateProgress(xfer);
                                    },
                                    on_file_complete(obj) {
                                        term.write("\r\n");
                                        socket.send(JSON.stringify({
                                            type: "ignore",
                                            data: othis.utf8ToB64(obj.name + "(" + obj.size + ") was upload success")
                                        }));
                                    },
                                }
                            ).then(zSession.close.bind(zSession), console.error.bind(console)
                            ).then(() => {
                                res();
                            });
                        };
                    });
                }

                function saveFile(xfe, buffer) {
                    return Zmodem.Browser.save_to_disk(buffer, xfe.get_details().name);
                }

                async function updateProgress(xfe, action = 'upload') {
                    let detail = xfe.get_details();
                    let name = detail.name;
                    let total = detail.size;
                    let offset = xfe.get_offset();
                    let percent;
                    if (total === 0 || total === offset) {
                        percent = 100
                    } else {
                        percent = Math.round(offset / total * 100);
                    }
                    // term.write("\r" + name + ": " + total + " " + offset + " " + percent + "% ");
                    term.write("\r" + action + ' ' + name + ": " + othis.bytesHuman(offset) + " " + othis.bytesHuman(total) + " " + percent + "% ");
                }

                function downloadFile(zSession) {
                    zSession.on("offer", function (xfer) {
                        function on_form_submit() {
                            if (xfer.get_details().size > 2048 * 1024 * 1024) {
                                xfer.skip();
                                toastr.warning(`${xfer.get_details().name} 超过 2048 MB, 无法下载`);
                                return
                            }
                            let FILE_BUFFER = [];
                            xfer.on("input", (payload) => {
                                updateProgress(xfer, "download");
                                FILE_BUFFER.push(new Uint8Array(payload));
                            });

                            xfer.accept().then(
                                () => {
                                    saveFile(xfer, FILE_BUFFER);
                                    term.write("\r\n");
                                    socket.send(JSON.stringify({
                                        type: "ignore",
                                        data: othis.utf8ToB64(xfer.get_details().name + "(" + xfer.get_details().size + ") was download success")
                                    }));
                                },
                                console.error.bind(console)
                            );
                        }

                        on_form_submit();
                    });
                    let promise = new Promise((res) => {
                        zSession.on("session_end", () => {
                            res();
                        });
                    });
                    zSession.start();
                    return promise;
                }

                let zSentry = new Zmodem.Sentry({
                    to_terminal: function (octets) {
                    },  //i.e. send to the terminal
                    on_detect: function (detection) {
                        let zSession = detection.confirm(), promise;
                        if (zSession.type === "receive") {
                            promise = downloadFile(zSession);
                        } else {
                            promise = uploadFile(zSession);
                        }
                        promise.catch(console.error.bind(console)).then(() => {
                            //
                        });
                    },
                    on_retract: function () {
                    },
                    sender: function (octets) {
                        socket.send(new Uint8Array(octets))
                    },
                });

                socket.onopen = function () {
                    socket.send(JSON.stringify({type: "store", id: data.id}));
                    // 发送窗口大小
                    socket.send(JSON.stringify({type: "resize", cols: data.cols, rows: data.rows}));
                    // 客户端设置窗口大小
                    term.resize(data.cols, data.rows);
                    // 如果有初始命令则发送
                    if (data.stdin) {
                        socket.send(JSON.stringify({type: "stdin", data: othis.utf8ToB64(data.stdin + "\r")}));
                    }
                    // v4 xterm.js
                    term.onData(function (data) {
                        socket.send(JSON.stringify({type: "stdin", data: othis.utf8ToB64(data)}));
                    });
                };

                // 接收数据
                socket.onmessage = function (res) {
                    if (typeof res.data === 'object') {
                        zSentry.consume(res.data);
                    } else {
                        try {
                            let msg = JSON.parse(res.data);
                            switch (msg.type) {
                                case "stdout":
                                case "stderr":
                                    term.write(othis.b64ToUtf8(msg.data));
                                    break;
                                case "console":
                                    console.log(othis.b64ToUtf8(msg.data));
                                    break;
                                case "alert":
                                    toastr.warning(othis.b64ToUtf8(msg.data));
                                    break;
                                default:
                                    console.log('unsupport type msg', msg);
                            }
                        } catch (e) {
                            console.log('unsupport data', res.data, e);
                        }
                    }
                };

                // 连接错误
                socket.onerror = function (e) {
                    console.log(e);
                    term.write('connect error');
                    term.write(JSON.stringify(e));
                    layer.confirm('连接出错了!', {title: false, icon: 2, btn: ['退出终端', "取消"]},
                        function (index) {
                            layer.close(index);
                            let parentIndex = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                            parent.layer.close(parentIndex); //再执行关闭
                        });
                };

                // 关闭连接
                socket.onclose = function (e) {
                    term.write('disconnect');
                    term.write(JSON.stringify(e));
                    layer.confirm('连接已断开!', {title: false, icon: 3, btn: ['退出终端', "取消"]},
                        function (index) {
                            layer.close(index);
                            let parentIndex = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                            parent.layer.close(parentIndex); //再执行关闭
                        });
                };

                // 监听浏览器窗口, 根据浏览器窗口大小修改终端大小, 延迟改变
                let timer = 0;
                $(window).resize(function () {
                    clearTimeout(timer);
                    timer = setTimeout(function () {
                        let cols_rows = othis.getTermSize();
                        term.resize(cols_rows.cols, cols_rows.rows);
                        socket.send(JSON.stringify({type: "resize", cols: cols_rows.cols, rows: cols_rows.rows}));
                    }, 100)
                });
            }
        }
    }

    layui.use(['index', 'main'], function () {
        let id = {{.id}},
            stdin = {{.stdin}},
            webssh = new WebSSH();
        webssh.connect({id: (id ? id : 0), stdin: (stdin ? stdin : ""),})
    });
</script>