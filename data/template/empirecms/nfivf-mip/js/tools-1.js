function hidead() {
    document.getElementById("result").innerHTML = ('');
}

function tools_Submit() {
    var box = document.getElementsByName("tjx");
    //保存所有选中项目
    var selected_values = new Array();
    for (var i = 0; i < box.length; i++) {
        if (box[i].checked) {
            //复选框给选中后，再去取复选框对应的下拉框的值
            var select_id_str = box[i].id + '_select';
            var select_obj = document.getElementById(select_id_str);
            //取到下拉选项的所有选中的项的值
            selected_values.push(select_obj.value);
        }
    }
    //alert(selected_values);
    if (selected_values.length == 0) {
        alert('请勾选选项卡再提交！');
        return false;
    } else if (selected_values.length <= 3) {
        alert('您提交的问题不够清楚，最少勾选4项！试试重新选择！');
        return false;
    } else if (selected_values.indexOf('A2') >= 0 && selected_values.indexOf('B4') >= 0) {
        alert('您选择了捐精又选择了捐卵，似乎不合乎常理吧？试试重新选择！');
        return false;
    } else if (selected_values.indexOf('C1') >= 0 && selected_values.indexOf('D2') >= 0) {
        alert('您选择了自己怀孕，一般都是不用公司托管的！试试重新选择！');
        return false;
    } else if ((selected_values.indexOf('B2') >= 0 || selected_values.indexOf('B3') >= 0) && (selected_values.indexOf('F2') >= 0 || selected_values.indexOf('F3') >= 0)) {
        document.getElementById('test_result').innerHTML = ('您选择的年龄不适合做包成功的套餐！');
    }else if (selected_values.indexOf('C1') >= 0) {
        /*C1*/
        if (selected_values.indexOf('B4') >= 0) {
            if (selected_values.indexOf('E2') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自怀、捐卵、选性别 </strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、捐卵费用在3-6万之间，看捐卵者质量定价格。</p><p>3、性别选择费2万元。</p> <p>共计：15-18万元。</p>');
            } else {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自怀、捐卵 </strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、捐卵费用在3-6万之间，看捐卵者质量定价格。</p> <p>共计：13-16万元。</p>');
            }
        } else if (selected_values.indexOf('A2') >= 0) {
            if (selected_values.indexOf('E2') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、自怀、捐精、选性别 </strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、捐精费用在1万左右，看捐精者质量定价格。</p><p>3、性别选择费2万元。</p> <p>共计：13万元</p>');
            } else if (selected_values.indexOf('F3') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、自怀、捐精、选性别 </strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、捐精费用在1万左右，看捐精者质量定价格。</p><p>3、性别选择费2万元。</p> <p>共计：13万元<br />根据您选择的情况可以做包性别的套餐！</p>');
            } else {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、自怀、捐精</strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、捐精费用在1万左右，看捐精者质量定价格。</p> <p>共计：11万元</p>');
            }
        } else if (selected_values.indexOf('E2') >= 0) {
            document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、自怀、选性别 </strong></p><p>费用:</p><p>1、自怀加手术费、公司介绍费10万。</p><p>2、性别选择费2万元。</p> <p>共计：12万元</p>');
        } else {
            document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、自怀</strong></p><p>费用:</p>自怀加手术费、公司介绍费10万。');
        }
    }
    /*C2*/
    else if (selected_values.indexOf('C2') >= 0) {
        if (selected_values.indexOf('B4') >= 0) {
            if (selected_values.indexOf('E2') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：代怀、捐卵、选性别 、自己托管</strong></p><p>费用:</p><p>1、手术费、公司介绍费10万。</p><p>2、代母介绍费3万。</p><p>3、捐卵费用在3-6万之间，看捐卵者质量定价格。</p>4、性别选择费2万元。<br /> <p>共计：18-21万元。</p>');
            } else {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：代怀、捐卵、自己托管</strong></p><p>费用:</p><p>1、手术费、公司介绍费10万。</p><p>2、代母介绍费3万。</p><p>3、捐卵费用在3-6万之间，看捐卵者质量定价格。</p> <p>共计：16-19万元。</p>');
            }
        } else if (selected_values.indexOf('A2') >= 0) {
            if (selected_values.indexOf('E2') >= 0) {
                if (selected_values.indexOf('D2') >= 0) {
                    document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、捐精、选性别、包托管</strong></p><p>费用:</p><p>1、代孕包托管的总费用在38万。</p><br /><p>3、捐精费用在1万左右，看捐精者质量定价格。</p>4、性别选择费2万元。<br /> <p>共计：41万元。</p>');
                } else {
                    document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、捐精、自己托管</strong></p><p>费用:</p><p>1、手术费、公司介绍费10万。</p><p>2、代母介绍费3万。</p><p>3、捐精费用在1万左右，看捐卵者质量定价格。</p> <p>共计：14万元。</p>');
                }
            } else if (selected_values.indexOf('D2') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、捐精、公司托管</strong></p><p>费用:</p><p>1、代孕包托管的总费用在38万。</p><p>2、捐精费用在1万左右，看捐精者质量定价格。</p> <p>共计：39万元。</p>');
            } else {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、捐精、自己托管</strong></p><p>费用:</p><p>1、手术费、公司介绍费10万。</p><p>2、代母介绍费3万。</p><p>3、捐精费用在1万左右，看捐卵者质量定价格。</p> <p>共计：14万元。</p>');
            }
        } else if (selected_values.indexOf('D2') >= 0) {
            if (selected_values.indexOf('E2') >= 0) {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、选性别、包托管</strong></p><p>费用:</p><p>1、代孕包托管的总费用在38万。</p><br />4、性别选择费2万元。<br /> <p>共计：40万元。</p>');
            } else {
                document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、包托管</strong></p><p>费用:</p>代孕包托管的总费用在38万。<br /> <p>共计：38万元。</p>');
            }
        } else {
            document.getElementById('test_result').innerHTML = ('<p><strong>您选择了：自供卵、代怀、自己托管</strong></p><p>费用:</p><p>1、手术费、公司介绍费10万。</p><p>2、代母介绍费3万。</p> <p>共计：13万元。</p>');
        }
    } else {
        /*C1*/
        document.getElementById('test_result').innerHTML = ('您好！您的选择可能没有录入数据库，重新选择后者查看');
    }
    outRnd('test_result');
}

function test_hidead() {
    document.getElementById("test_result").innerHTML = ('');
}