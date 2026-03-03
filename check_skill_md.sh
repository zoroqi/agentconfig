#!/bin/bash

# 獨立檢測腳本
# 功能：檢驗指定目錄中的每個子目錄必須包含一個名為 SKILL.md 的文件
# 支持：真實目錄和軟鏈接目錄
# 用法：./check-skill-md.sh [目錄路徑]

dir="${1:-.}"

if [ ! -d "$dir" ] && [ ! -L "$dir" ]; then
    echo "错误: '$dir' 不是一个目录"
    exit 1
fi

# 如果是軟鏈接，檢查其指向的目標是否為目錄
if [ -L "$dir" ] && [ ! -d "$dir" ]; then
    echo "错误: 軟鏈接 '$dir' 指向的目標不是目錄"
    exit 1
fi

echo "SKILL.md 掃描: $dir"
echo "----------------------------------------"

missing_count=0
valid_count=0

for entry in "$dir"/*/; do
    # 移除尾部斜線
    entry="${entry%/}"

    # 檢查是否為目錄或指向目錄的軟鏈接
    if [ -d "$entry" ] || ([ -L "$entry" ] && [ -d "$(readlink -f "$entry")" ]); then
        # 獲取目錄名稱
        dir_name=$(basename "$entry")

        # 檢查是否存在 SKILL.md 文件（支持軟鏈接文件）
        if [ -f "${entry}/SKILL.md" ] || [ -L "${entry}/SKILL.md" ]; then
            echo "✓ $dir_name/SKILL.md"
            ((valid_count++))
        else
            echo "✗ $dir_name/SKILL.md (文件不存在)"
            ((missing_count++))
        fi
    fi
done

echo "----------------------------------------"
echo "总计: 有效 $valid_count 个, 缺失 $missing_count 个"

# 如果有缺失的文件，返回錯誤碼 1
if [ "$missing_count" -gt 0 ]; then
    echo "錯誤：檢測到缺失的 SKILL.md 文件，提交已終止。"
    exit 1
fi

exit 0
