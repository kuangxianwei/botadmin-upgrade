let html_test = document.createElement("div");
html_test.innerHTML = `<div class="box_bg">
<div class="box">
    <div class="close1"></div>
    <div class="title">
        试管帮手<p>已有<span>13567</span>人测试</p>
    </div>
    <div class="content">
        <div class="jie">根据泰国生殖医生DR.THITIKORN WANICHKUL
            M.D等人提出的前三次试管婴儿成功率（活产率）预测模型，为准备试管的姐妹打造了这个新功能，只要轻松填写你的信息，就能分分钟帮你分析成功率！试管不用愁！</div>
        <div class="con_01">
            <div class="begin">
                想要了解你的试管成功率吗？<br>
                赶紧来测试一下吧！<br>
                <div class="button btn_01">开始测试</div>
            </div>
        </div>
        <div class="bar">
            <div class="bar_length"></div>
            <span><i class="bar_sco" style="font-style: inherit">0</i>%</span>
        </div>
        <div class="conts con_02 cont_00">
            <div class="pink_box" id="aide">
                <p>准妈妈年龄（岁）</p>
                <div class="">
                    <input type="radio" id="01_A" name="1" value="A">
                    <label for="01_A">A.20-30</label>
                </div>
                <div>
                    <input type="radio" id="01_B" name="1" value="B">
                    <label for="01_B">B.30-35</label>
                </div>
                <div>
                    <input type="radio" id="01_C" name="1" value="C">
                    <label for="01_C">C.35-40</label>
                </div>
                <div>
                    <input type="radio" id="01_D" name="1" value="D">
                    <label for="01_D">D.40以上</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>备孕难题</p>
                <div class="">
                    <input type="radio" id="02_A" name="2" value="A">
                    <label for="02_A">A.男方情况</label>
                </div>
                <div>
                    <input type="radio" id="02_B" name="2" value="B">
                    <label for="02_B">B.子宫情况</label>
                </div>
                <div>
                    <input type="radio" id="02_C" name="2" value="C">
                    <label for="02_C">C.卵巢情况</label>
                </div>
                <div>
                    <input type="radio" id="02_D" name="2" value="D">
                    <label for="02_D">D.其他</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>试管次数</p>
                <div class="">
                    <input type="radio" id="03_A" name="3" value="A">
                    <label for="03_A">A.0</label>
                </div>
                <div>
                    <input type="radio" id="03_B" name="3" value="B">
                    <label for="03_B">B.1</label>
                </div>
                <div>
                    <input type="radio" id="03_C" name="3" value="C">
                    <label for="03_C">C.2</label>
                </div>
                <div>
                    <input type="radio" id="03_D" name="3" value="D">
                    <label for="03_D">D.3次及以上</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>男方情况</p>
                <div class="">
                    <input type="radio" id="04_A" name="4" value="A">
                    <label for="04_A">A.正常</label>
                </div>
                <div>
                    <input type="radio" id="04_B" name="4" value="B">
                    <label for="04_B">B.少精/弱精</label>
                </div>
                <div>
                    <input type="radio" id="04_C" name="4" value="C">
                    <label for="04_C">C.无精</label>
                </div>
                <div>
                    <input type="radio" id="04_D" name="4" value="D">
                    <label for="04_D">D.其他</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>子宫情况</p>
                <div class="">
                    <input type="radio" id="05_A" name="5" value="A">
                    <label for="05_A">A.正常</label>
                </div>
                <div>
                    <input type="radio" id="05_B" name="5" value="B">
                    <label for="05_B">B.子宫内膜异位</label>
                </div>
                <div>
                    <input type="radio" id="05_C" name="5" value="C">
                    <label for="05_C">C.子宫肌瘤</label>
                </div>
                <div>
                    <input type="radio" id="05_D" name="5" value="D">
                    <label for="05_D">D.其他</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>准妈妈AMH（ng/ml）</p>
                <div class="">
                    <input type="radio" id="06_A" name="6" value="A">
                    <label for="06_A">A.0-2</label>
                </div>
                <div>
                    <input type="radio" id="06_B" name="6" value="B">
                    <label for="06_B">B.2-6.8</label>
                </div>
                <div>
                    <input type="radio" id="06_C" name="6" value="C">
                    <label for="06_C">C.6.8以上</label>
                </div>
                <div>
                    <input type="radio" id="06_D" name="6" value="D">
                    <label for="06_D">D.不清楚</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>准妈妈卵泡个数</p>
                <div class="">
                    <input type="radio" id="07_A" name="7" value="A">
                    <label for="07_A">A.10个以上</label>
                </div>
                <div>
                    <input type="radio" id="07_B" name="7" value="B">
                    <label for="07_B">B.5-10个</label>
                </div>
                <div>
                    <input type="radio" id="07_C" name="7" value="C">
                    <label for="07_C">C.0-5个</label>
                </div>
                <div>
                    <input type="radio" id="07_D" name="7" value="D">
                    <label for="07_D">D.不清楚</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>准妈妈FSH(mIU/ml）</p>
                <div class="">
                    <input type="radio" id="08_A" name="8" value="A">
                    <label for="08_A">A.10-15</label>
                </div>
                <div>
                    <input type="radio" id="08_B" name="8" value="B">
                    <label for="08_B">B.6-10</label>
                </div>
                <div>
                    <input type="radio" id="08_C" name="8" value="C">
                    <label for="08_C">C.4-6</label>
                </div>
                <div>
                    <input type="radio" id="08_D" name="8" value="D">
                    <label for="08_D">D.不清楚</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>准爸爸精子活力（A+B%)</p>
                <div class="">
                    <input type="radio" id="09_A" name="9" value="A">
                    <label for="09_A">A.40以上</label>
                </div>
                <div>
                    <input type="radio" id="09_B" name="9" value="B">
                    <label for="09_B">B.20-40</label>
                </div>
                <div>
                    <input type="radio" id="09_C" name="9" value="C">
                    <label for="09_C">C.0-20</label>
                </div>
                <div>
                    <input type="radio" id="09_D" name="9" value="D">
                    <label for="09_D">D.不清楚</label>
                </div>
            </div>
        </div>
        <div class="conts con_02">
            <div class="pink_box" id="aide">
                <p>宝宝性别要求</p>
                <div class="">
                    <input type="radio" id="10_A" name="10" value="A">
                    <label for="10_A">A.随缘</label>
                </div>
                <div>
                    <input type="radio" id="10_B" name="10" value="B">
                    <label for="10_B">B.女宝</label>
                </div>
                <div>
                    <input type="radio" id="10_C" name="10" value="C">
                    <label for="10_C">C.男宝</label>
                </div>
                <div>
                    <input type="radio" id="10_D" name="10" value="D">
                    <label for="10_D">D.龙凤</label>
                </div>
            </div>
        </div>

        <div class="conts con_03  btn_02">
            <div class="pink_box">
                <p>试管帮手成功率的算法基于真实用户的大数据信息，为防止虚假数据干扰准确性，请输入手机号以确保用户信息的真实性：</p>
                <input class="phone" type="text" placeholder="请输入您的手机号"><br>
                <div class="button btn_02 aidesubmit">马上预测</div>
                <input type="hidden" name="dosubmit" value="1" />
            </div>
        </div>
        <div class="con_04 cont_01">
            <div class="white_box">
                <div>测试结果 <br>您的试管成功率为<span><span class="change">1</span>%</span></div>
            </div>
            <div class="newsubmit">重新测试</div>
        </div>
    </div>
</div>
</div>`;

document.querySelector("body").append(html_test);

let subjectObj = {
    "准妈妈年龄（岁）": ["20-30", "30-35", "35-40", "40以上"],
    备孕难题: ["男方情况", "子宫情况", "卵巢情况", "其他"],
    试管次数: ["0", "1", "2", "3"],
    男方情况: ["正常", "少精/弱精", "无精", "其他"],
    子宫情况: ["正常", "子宫内膜异位", "子宫肌瘤", "其他"],
    "准妈妈AMH（ng/ml）": ["0-2", "2-6.8", "6.8以上", "其他"],
    准妈妈卵泡个数: ["10个以上", "5-10个", "0-5个", "其他"],
    "准妈妈FSH(mIU/ml）": ["10-15", "6-10", "4-6", "其他"],
    "准爸爸精子活力（A+B%)": ["40以上", "20-40", "0-20", "其他"],
    宝宝性别要求: ["随缘", "女宝", "男宝", "龙凤"],
};

$(".close1").click(function () {
    $(".box_bg").fadeOut();
});
$(".btn_01").click(function () {
    beg();
});
$(".test-ivf").click(function () {
    $(".box_bg").css("display", "block");
});

function beg() {
    $(".bar").show();
    $(".cont_00").show();
    $(".con_01").hide();
}
$(".pink_box label").click(function () {
    $(this).parent("div").addClass("radio_add");
    $(this).parent("div").siblings("div").removeClass("radio_add");
    $(this).closest(".conts").addClass("sco");
    $(this).closest(".conts").addClass("hide");
    $(this).closest(".conts").next(".conts").addClass("show");
    setTimeout(function () {
        $(".hide").hide();
        $(".show").show();
        $(".hide").removeClass("hide");
        $(".show").removeClass("show");
    }, 200);
    var con2 = $(".sco");
    var len = con2.length;
    $(".bar_sco").html(10 * len);
    $(".bar_length").animate({
        width: 10 * len + "%"
    });
    var w = $(".bar_length").width();
    if ((w = 360)) {
        $(".bar_length").css({
            borderRadius: "20px"
        });
    } else {}
});
$(".con_02:eq(9) label").click(function () {
    $(".bar").fadeOut(200);
});

$(".newsubmit").click(function () {
    console.log("111111");
    $(".bar").show();
    $(".cont_00").show().siblings(".conts").hide();
    $(".con_04").hide();
    $(".con_02 input").prop("checked", false);
    $(".code").attr("value", "");
    $(".con_02 .pink_box div").removeClass("radio_add");
    $(".conts").removeClass("sco");
    $(".bar_length").css({
        width: 0
    });
    $(".bar_sco").html(0);
});

// var url = 'https://webapi.amap.com/maps?v=1.4.15&key=eefc6af0d0c8ef389483c5016e7a5bde&callback=onLoad';
// var jsapi = document.createElement('script');
// jsapi.charset = 'utf-8';
// jsapi.src = url;
// document.head.appendChild(jsapi);

// window.onLoad = function () {
$(".aidesubmit").click(function () {
    console.log("1");
    let phone = document.querySelector(".phone").value;
    if (!/^1[3456789]\d{9}$/.test(phone)) {
        return alert("手机号码有误，请重填");
    }
    var arr = new Array();
    var arrA = new Array();
    var arrB = new Array();
    var arrC = new Array();
    var arrD = new Array();
    $("input[type='radio']:checked").each(function () {
        arr.push($(this).val());
    });

    let arry = Object.keys(subjectObj);
    let info = Object.create(null);
    arry.forEach((p, index) => {
        if (arr[index] == "A") {
            info[p] = subjectObj[p][0];
        } else if (arr[index] == "B") {
            info[p] = subjectObj[p][1];
        } else if (arr[index] == "C") {
            info[p] = subjectObj[p][2];
        } else {
            info[p] = subjectObj[p][3];
        }
    });

    let params = {
        phone,
        info,
    };

    $.ajax({
        url: `http://www.ruiguohealth.com/calculation`,
        type: "post",
        data: params,
        success: function (res) {
            for (var i = 0; i < arr.length; i++) {
                if (arr[i] == "A") {
                    arrA.push(arr[i]);
                } else if (arr[i] == "B") {
                    arrB.push(arr[i]);
                } else if (arr[i] == "C") {
                    arrC.push(arr[i]);
                } else if (arr[i] == "D") {
                    arrD.push(arr[i]);
                }
            }
            var Alength = arrA.length;
            var Blength = arrB.length;
            var Clength = arrC.length;
            var Dlength = arrD.length;
            var score = Alength * 8.5 + Blength * 6.2 + Clength * 4.5 + Dlength * 2.3;
            var index = 0;
            star = setInterval(function () {
                // body...
                if (index <= score) {
                    index += 0.2;
                    b = index.toFixed(1);
                    $(".change").html(b);
                    $(".con_04").show();
                    $(".conts").hide();
                }
            }, 6);
        },
    });
});
// };


