#!/bin/bash

# 使用 comm 找出當前忽略列表中有，但 ignored_list 中沒有的文件
NEW_FILES=$(comm -13 <(sort ignored_list 2>/dev/null) <(git ls-files -o -i --exclude-standard | sort))

if [ -n "$NEW_FILES" ]; then
    echo "發現新增的被忽略文件："
    echo "$NEW_FILES"
else
    echo "沒有新增文件。"
fi

echo "更新 ignored_list 文件"
git ls-files -o -i --exclude-standard > ignored_list
