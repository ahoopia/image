#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 列出通过 dpkg 安装的软件包
echo -e "${GREEN}List of installed packages (dpkg):${NC}"
dpkg --list | awk '/^ii/ {printf "'${YELLOW}'%-40s'${NC}' %s\n", $2, $3}'
echo

# 列出通过 apt 安装的软件包
echo -e "${GREEN}List of installed packages (apt):${NC}"
apt list --installed 2>/dev/null | awk -F/ 'NR>1 {printf "'${YELLOW}'%-40s'${NC}' %s\n", $1, $2}'
echo

# 列出通过 snap 安装的软件包
echo -e "${GREEN}List of installed packages (snap):${NC}"
snap list | awk 'NR>1 {printf "'${YELLOW}'%-40s'${NC}' %s\n", $1, $2}'
