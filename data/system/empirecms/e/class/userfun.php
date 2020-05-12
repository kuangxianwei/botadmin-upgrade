<?php
/*
get_contact_r() 返回电话号码数组
abs_url($url) 返回绝对url
parse_host() 获取网站 url数组 返回 scheme、host 和 host_uri
 */

if (!function_exists('get_contact_r')) {
    function get_contact_r()
    {
        /*返回电话号码数组*/
        global $public_r;
        $tel_r = array();
        if (isset($public_r) && isset($public_r['add_contact'])) {
            foreach (preg_split("/\\r\\n|\\n|\\r/", $public_r['add_contact']) as $k => $v) {
                preg_match('/([0-9]{11})/', str_replace(array('-', '_', ' '), '', str_replace(array('-', '_', ' '), '', $v)), $matches);
                if (isset($matches[1])) {
                    $tel_r[$matches[1]] = $v;
                }
            }
        }
        return $tel_r;
    }
}

/*解析host 返回数组*/
if (!function_exists('parse_host')) {

    /*解析host 返回数组*/
    function parse_host()
    {
        global $public_r;
        if (isset($public_r)) {
            $host_uri = trim(isset($public_r['add_host_uri']) ? $public_r['add_host_uri'] : (isset($public_r['newsurl']) ? $public_r['newsurl'] : ''));
            if (preg_match('/^https?:\/\//i', $host_uri)) {
                $host_r = parse_url($host_uri);
                if (isset($host_r['host'])) {
                    return array(
                        'scheme'   => $host_r['scheme'],
                        'host'     => $host_r['host'],
                        'host_uri' => $host_r['scheme'] . '://' . $host_r['host']);
                }
            }
        }
        /*如果没有设置 自定义变量 add_host_uri 就取访问URI*/
        $scheme = isset($_SERVER['REQUEST_SCHEME']) ? $_SERVER['REQUEST_SCHEME'] : 'http';
        $host   = isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : '';
        return array(
            'scheme'   => $scheme,
            'host'     => $host,
            'host_uri' => $scheme . '://' . $host,
        );
    }
}

/*返回绝对url*/
if (!function_exists('abs_url')) {
    function abs_url($url)
    {
        if (preg_match('/^https?:\/\//i', $url)) {
            return $url;
        }
        global $HOST_R;
        if (isset($HOST_R['host'])) {
            $HOST_R = parse_host();
        }
        if (strpos($url, '//') === 0) {
            return $HOST_R['scheme'] . $url;
        }
        if (strpos($url, '/') === 0) {
            return $HOST_R['host_uri'] . $url;
        }
        return $HOST_R['host_uri'] . '/' . $url;
    }
}

/*返回网站 信息*/
if (!function_exists('get_site_r')) {

    /*获取网站的 标题 关键词 和描述*/
    function get_site_r()
    {
        global $public_r;
        if (isset($public_r['site_r'])) {
            return $public_r['site_r'];
        }
        global $empire, $dbtbpre;
        if (isset($empire)) {
            $site_r = $empire->fetch1("select newsurl,sitename,sitekey,siteintro,indexpagedt from {$dbtbpre}enewspublic limit 1");
            return array(
                'host'        => abs_url(isset($site_r['newsurl']) ? $site_r['newsurl'] : '/'),
                'title'       => isset($site_r['sitename']) ? $site_r['sitename'] : '',
                'keywords'    => explode(",", isset($site_r['sitekey']) ? $site_r['sitekey'] : ''),
                'description' => isset($site_r['siteintro']) ? $site_r['siteintro'] : '',
            );
        }
        return array(
            'host'        => abs_url('/'),
            'title'       => '',
            'keywords'    => array(),
            'description' => '',
        );
    }
}
/*全局变量*/
$HOST_R = parse_host();