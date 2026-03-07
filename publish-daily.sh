#!/bin/bash

# 老浪的每日博客发布脚本
# 将 memory 目录下的日记转换成博客文章并发布到 GitHub Pages

set -e

BLOG_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="$(dirname "$(dirname "$BLOG_DIR")")"
MEMORY_DIR="$WORKSPACE_DIR/memory"
POSTS_DIR="$BLOG_DIR/_posts"

mkdir -p "$POSTS_DIR"

echo "🌊 老浪的每日博客发布工具"
echo "=========================="
echo ""

# 检查 Git 状态
check_git() {
    cd "$BLOG_DIR"
    if ! git status >/dev/null 2>&1; then
        echo "❌ 不是一个 Git 仓库"
        return 1
    fi
}

# 转换记忆文件为博客文章
convert_memory_to_post() {
    local memory_file="$1"
    local filename=$(basename "$memory_file")
    local date_str=$(echo "$filename" | cut -d. -f1)
    
    # 检查文件名格式是否为 YYYY-MM-DD.md
    if ! [[ "$date_str" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "⚠️  跳过 $filename (文件名格式不对)"
        return 0
    fi
    
    local year=$(echo "$date_str" | cut -d- -f1)
    local month=$(echo "$date_str" | cut -d- -f2)
    local day=$(echo "$date_str" | cut -d- -f3)
    
    # 生成博客文章文件名
    local post_file="$POSTS_DIR/$date_str-daily.md"
    
    # 如果文章已存在，跳过
    if [ -f "$post_file" ]; then
        echo "⚠️  $date_str 的博客文章已存在，跳过"
        return 0
    fi
    
    echo "📝 处理 $date_str 的记忆..."
    
    # 读取记忆文件内容
    local content=$(cat "$memory_file")
    
    # 提取标题（第一行 # 后面的内容）
    local title=$(echo "$content" | grep -m1 "^# " | sed 's/^# //')
    if [ -z "$title" ]; then
        title="$date_str 学习记录"
    fi
    
    # 生成 Front Matter
    cat > "$post_file" <<EOF
---
layout: post
title:  "$title"
date:   $date_str $(date +"%H:%M:%S %z")
categories: daily
tags: [学习记录, 技术]
---

EOF
    
    # 添加内容（去掉第一行的标题）
    echo "$content" | sed '1d' >> "$post_file"
    
    echo "✅ 已创建: $post_file"
}

# 发布到 GitHub
publish_to_github() {
    cd "$BLOG_DIR"
    
    echo ""
    echo "🚀 准备发布到 GitHub..."
    
    git add .
    
    if git diff --staged --quiet; then
        echo "ℹ️  没有新内容需要提交"
        return 0
    fi
    
    local commit_msg="📝 更新博客 - $(date +"%Y-%m-%d %H:%M")"
    git commit -m "$commit_msg"
    
    echo "🔄 推送到 GitHub..."
    git push origin main
    
    echo "✅ 发布成功！"
    echo "🌐 博客地址: https://shenyizhou.github.io"
}

# 主函数
main() {
    check_git
    
    echo "📂 记忆文件目录: $MEMORY_DIR"
    echo "📂 博客文章目录: $POSTS_DIR"
    echo ""
    
    # 转换所有记忆文件
    local found=0
    for memory_file in "$MEMORY_DIR"/*.md; do
        if [ -f "$memory_file" ]; then
            convert_memory_to_post "$memory_file"
            found=1
        fi
    done
    
    if [ $found -eq 0 ]; then
        echo "❌ 没有找到记忆文件"
        exit 1
    fi
    
    echo ""
    read -p "是否发布到 GitHub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        publish_to_github
    else
        echo "ℹ️  已生成文章但未发布，你可以手动检查后再提交"
    fi
}

# 如果传入日期参数，只处理指定日期
if [ $# -eq 1 ]; then
    target_date="$1"
    target_file="$MEMORY_DIR/$target_date.md"
    if [ -f "$target_file" ]; then
        check_git
        convert_memory_to_post "$target_file"
        echo ""
        read -p "是否发布到 GitHub? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            publish_to_github
        fi
    else
        echo "❌ 找不到指定日期的记忆文件: $target_file"
        exit 1
    fi
else
    main
fi
