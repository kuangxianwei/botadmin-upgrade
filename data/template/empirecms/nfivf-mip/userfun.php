<?php
if (!function_exists('get_process_id')) {
    /*获取流程*/
    function get_process_id()
    {
        global $class_r;
        foreach ($class_r as $k => $v) {
            if (strlen(str_replace($v['sonclass'], '|', '')) === 0 && strpos($v['classname'], "流程") !== false) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if (strlen(str_replace($v['sonclass'], '|', '')) === 0 && stripos($v['classpath'], "process") !== false) {
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
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "价格") !== false || strpos($v['classname'], "套餐") !== false || strpos($v['classname'], "费用") !== false)) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (stripos($v['classpath'], "price") !== false || stripos($v['classpath'], 'taocan') !== false || stripos($v['classpath'], "feiyong") !== false)) {
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
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "疑难解答") !== false || strpos($v['classname'], "疑难") !== false || strpos($v['classname'], "解答") !== false || strpos($v['classname'], "问答") !== false)) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (stripos($v['classpath'], "ask") !== false || stripos($v['classpath'], 'wenda') !== false || stripos($v['classpath'], "jieda") !== false)) {
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
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 5 && (strpos($v['classname'], "公司实力") !== false || strpos($v['classname'], "公司") !== false || strpos($v['classname'], "关于") !== false || strpos($v['classname'], "实力") !== false)) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 5 && (stripos($v['classpath'], "about") !== false || stripos($v['classpath'], 'gongsi') !== false)) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && substr_count($v['sonclass'], '|') >= 5) {
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
        global $class_r;
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (strpos($v['classname'], "联系我们") !== false || strpos($v['classname'], "联系") !== false)) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if ($v['bclassid'] === 0 && (stripos($v['classpath'], "contact") !== false || stripos($v['classpath'], 'lianxiwomen') !== false || stripos($v['classpath'], "lianxi") !== false || stripos($v['classpath'], "lxwm") !== false)) {
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
            if (strpos($v['classname'], "成功案例") !== false || strpos($v['classname'], "案例") !== false) {
                return $v['classid'];
            }
        }
        foreach ($class_r as $k => $v) {
            if (stripos($v['classpath'], "case") !== false || stripos($v['classpath'], 'cgal') !== false || stripos($v['classpath'], "anli") !== false || stripos($v['classpath'], "chenggonganli") !== false) {
                return $v['classid'];
            }
        }
        return 14;
    }
}
