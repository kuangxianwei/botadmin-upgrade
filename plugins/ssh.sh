#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Name:ssh
# Alias:网页SSH
# Intro:一个简单的 Web 应用程序，用作 ssh 客户端以连接到您的 ssh 服务器。它是用 Python 编写的，基于 tornado、paramiko 和 xterm.js
# Args:

# 插件名称
# shellcheck disable=SC2034
PLUGIN_NAME="网页SSH"
# 当前脚本目录
CUR_DIR=$(dirname "$(readlink -f "$0")")
. "$CUR_DIR/include/init.sh" || exit 1

# 安装
Install() {
  if ! command -v python; then
    echo "服务器没有安装Python" 1>&2
    exit 1
  fi
  if ! command -v pip; then
    # 下载pip安装脚本
    if python --version 2>&1 | grep "2\.7"; then
      curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o ~/get-pip.py
    else
      curl https://bootstrap.pypa.io/pip/get-pip.py -o ~/get-pip.py
    fi
    # 安装pip
    if ! python ~/get-pip.py; then
      exit 1
    fi
  fi
  # 更新pip
  if ! python -m pip install --upgrade pip; then
    echo "更新pip失败" 1>&2
    exit 1
  fi
  # 安装webssh
  if ! pip install webssh; then
    echo "安装webssh失败" 1>&2
    exit 1
  fi
  Firewall_Enable 8888/tcp
}
# 卸载
Uninstall() {
  pip uninstall -y webssh
  Firewall_Disable 8888
}
# 执行安装或卸载
Execute "$@"
