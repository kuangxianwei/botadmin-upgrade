<?php

if (!function_exists('get_process_id')) {
    /*获取流程*/
    function get_process_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if (strlen(str_replace($v['sonclass'], '|', '')) === 0 && strpos($v['classname'], "流程")) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if (strlen(str_replace($v['sonclass'], '|', '')) === 0 && strpos($v['classpath'], "process")) {
                return $v['classid'];
            }
        }
        return 7;
    }
}

if (!function_exists('get_price_id')) {
/*获取价格id*/
    function get_price_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "价格") || strpos($v['classname'], "套餐") || strpos($v['classname'], "费用"))) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classpath'], "price") || strpos($v['classpath'], 'taocan') || strpos($v['classpath'], "feiyong"))) {
                return $v['classid'];
            }
        }
        return 6;
    }
}

if (!function_exists('get_ask_id')) {
/*获取问答id*/
    function get_ask_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "疑难解答") || strpos($v['classname'], "疑难") || strpos($v['classname'], "解答") || strpos($v['classname'], "问答"))) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classpath'], "ask") || strpos($v['classpath'], 'wenda') || strpos($v['classpath'], "jieda"))) {
                return $v['classid'];
            }
        }
        return 12;
    }
}

if (!function_exists('get_about_id')) {
/*获取公司实力id*/
    function get_about_id()
    {
        global $class_r;
        $has = $v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 5;
        foreach ($class_r as $k => $v) {
            if ($has && (strpos($v['classname'], "公司实力") || strpos($v['classname'], "公司") || strpos($v['classname'], "关于") || strpos($v['classname'], "实力"))) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($has && (strpos($v['classpath'], "about") || strpos($v['classpath'], 'gongsi'))) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($has) {
                return $v['classid'];
            }
        }
        return 1;
    }
}

if (!function_exists('get_ivf_id')) {
/*获取试管ID*/
    function get_ivf_id()
    {
        global $class_r;
        $has      = $v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 2;
        $about_id = get_about_id();
        foreach ($class_r as $k => $v) {
            if ($has && $v['classid'] !== $about_id || stripos($v['classpath'], "ivf")) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($has && $v['classid'] !== $about_id) {
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
        global $class_r;
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "联系我们") || strpos($v['classname'], "联系"))) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classpath'], "contact") || strpos($v['classpath'], 'lianxiwomen') || strpos($v['classpath'], "lianxi") || strpos($v['classpath'], "lxwm"))) {
                return $v['classid'];
            }
        }
        return 14;
    }
}

if (!function_exists('get_case_id')) {
/*获取成功案例ID*/
    function get_case_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if (strpos($v['classname'], "成功案例") || strpos($v['classname'], "案例")) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if (strpos($v['classpath'], "case") || strpos($v['classpath'], 'cgal') || strpos($v['classpath'], "anli") || strpos($v['classpath'], "chenggonganli")) {
                return $v['classid'];
            }
        }
        return 14;
    }
}
