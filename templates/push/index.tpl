<div style="padding:10px;">
    <input type="text" id="messageTxt"/>
    <button type="button" id="sendBtn">Send</button>
    <div id="messages" style="width: 375px;margin:10px 0 0 0;border-top: 1px solid black;">
    </div>
</div>
<script>
    function WsRender() {
        let ws = new WebSocket((location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + '/ws1');
        ws.onmessage = function (message) {
            console.log("message", message.data);
        };
        window.setInterval(function () {
            ws.send('ddddddd');
        }, 3000);
    }

    WsRender();
</script>