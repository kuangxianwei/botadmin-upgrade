<?php
if (!function_exists('get_process_id')) {
    /*获取流程*/
    function get_process_id()
    {
        return get_class_id(array('流程','过程'),array('process','liuchen'),7);
    }
}

if (!function_exists('get_price_id')) {
/*获取价格id*/
    function get_price_id()
    {
        return get_class_id(array('价格','套餐','费用'),array('price','taocan','feiyong'),6);
    }
}

if (!function_exists('get_ask_id')) {
/*获取问答id*/
    function get_ask_id()
    {
        return get_class_id(array('疑难解答','疑难','解答','问答'),array('ask','wenda','jieda'),12);
    }
}

if (!function_exists('get_about_id')) {
/*获取公司实力id*/
    function get_about_id()
    {
        return get_class_id(array('公司实力','公司','关于','实力'),array('about','gongsi'),1);
    }
}

if (!function_exists('get_ivf_id')) {
/*获取试管ID*/
    function get_ivf_id()
    {
        global $class_r;
        $about_id = get_about_id();
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 2 && $v['classid'] !== $about_id || stripos($v['classpath'], "ivf") !== false) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 2 && $v['classid'] !== $about_id) {
                return $v['classid'];
            }
        }
        return 8;
    }
}

if (!function_exists('get_other_id')) {
/*获取其他*/
    function get_other_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && $v['classid'] !== get_about_id() && $v['classid'] !== get_ivf_id() && $v['classid'] !== get_ask_id() && $v['classid'] !== get_price_id() && $v['classid'] !== get_process_id()) {
                return $v['classid'];
            }
        }
        return 11;
    }
}

if (!function_exists('get_contact_id')) {
/*获取联系我们ID*/
    function get_contact_id()
    {
        return get_class_id(array('联系我们','联系'),array('contact','lianxiwomen','lianxi','lxwm'),14);
    }
}

if (!function_exists('get_case_id')) {
/*获取成功案例ID*/
    function get_case_id()
    {
        return get_class_id(array('成功案例','案例'),array('case','cgal','anli','chenggonganli'),14);
    }
}
