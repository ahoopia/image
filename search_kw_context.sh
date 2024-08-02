#!/bin/bash

# 检查是否提供了两个参数
if [ $# -ne 2 ]; then
  echo "Usage: $0 <config_file_path> <keyword>"
  exit 1
fi

# 获取命令行参数
config_file=$1
keyword=$2

# 使用 grep 找到所有关键字的行号
line_numbers=$(grep -n "$keyword" "$config_file" | awk -F: '{print $1}')

# 如果没有找到关键字，退出脚本
if [ -z "$line_numbers" ]; then
  echo "Keyword '$keyword' not found in the file '$config_file'"
  exit 1
fi

# 遍历所有找到的行号并打印上下文
for line_number in $line_numbers; do
  # 检查 line_number 是否为有效的数字
  if ! [[ "$line_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid line number: $line_number"
    continue
  fi

  # 计算上下文范围
  start_line=$((line_number - 10))
  end_line=$((line_number + 10))

  # 确保起始行不小于1
  if [ "$start_line" -lt 1 ]; then
    start_line=1
  fi

  # 使用 awk 打印上下文
  echo "Context for keyword '$keyword' at line $line_number:"
  awk -v start="$start_line" -v end="$end_line" 'NR >= start && NR <= end' "$config_file"
  echo "----------------------------------------"
done