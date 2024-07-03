#!/bin/bash

# 检查是否提供了两个参数
if [ $# -ne 2 ]; then
  echo "Usage: $0 <config_file_path> <keyword>"
  exit 1
fi

# 获取命令行参数
config_file=$1
keyword=$2

# 使用 grep 找到关键字行号
line_number=$(grep -n "$keyword" "$config_file" | cut -d: -f1)

# 如果没有找到关键字，退出脚本
if [ -z "$line_number" ]; then
  echo "Keyword '$keyword' not found in the file '$config_file'"
  exit 1
fi

# 计算上下文范围
start_line=$((line_number - 10))
end_line=$((line_number + 10))

# 确保起始行不小于1
if [ $start_line -lt 1 ]; then
  start_line=1
fi

# 使用 awk 打印上下文
awk "NR >= $start_line && NR <= $end_line" "$config_file"
