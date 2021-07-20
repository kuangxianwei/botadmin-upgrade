#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:chromium
# Alias:Chromium
# Intro:安装Chromium的依赖库和字体库 如果安装失败,请先升级软件包 yum -y upgrade
# Args:

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="Chromium"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1

# 安装
Install() {
  if ! yum install -y pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 \
    ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc; then
    Error "安装Chromium依赖库失败"
  fi
}
# 卸载
Uninstall() {
  if ! yum remove -y pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 \
    ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc; then
    Error "卸载Chromium依赖库失败"
  fi
}

# 执行安装或卸载
Execute "$@"
