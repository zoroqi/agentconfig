#!/bin/bash

# 检查软链接目标是否存在的脚本（仅扫描指定目录，不递归）

dir="${1:-.}"

if [ ! -d "$dir" ]; then
    echo "错误: '$dir' 不是一个目录"
    exit 1
fi

echo "扫描目录: $dir"
echo "----------------------------------------"

broken_count=0
valid_count=0

for item in "$dir"/*; do
    # 检查是否是软链接
    if [ -L "$item" ]; then
        target=$(readlink "$item")
        
        # 检查目标是否存在
        if [ -e "$item" ]; then
            echo "✓ $item -> $target"
            ((valid_count++))
        else
            echo "✗ $item -> $target (目标不存在)"
            ((broken_count++))
        fi
    fi
done

echo "----------------------------------------"
echo "总计: 有效 $valid_count 个, 损坏 $broken_count 个"

# 新增邏輯：如果有損壞的連結，返回錯誤碼 1
if [ "$broken_count" -gt 0 ]; then
    echo "錯誤：檢測到失效的軟鏈接，提交已終止。"
    exit 1
fi

exit 0
