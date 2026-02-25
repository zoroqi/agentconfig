#!/bin/bash


echo "初始化 submodule"
git submodule update --init --recursive

echo "更新 submodule 到主幹"
git submodule foreach git switch main

echo "正在配置 Git Hooks..."
git config core.hooksPath .githooks

echo "生成已排除文件列表 ignored_list"
git ls-files -o -i --exclude-standard > ignored_list

echo "完成！"
