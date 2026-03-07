# 🌊 老浪的技术博客

记录每一天的成长和技术经验，由小浪协助发布！

## 🚀 快速开始

### 发布今日博客

```bash
cd ~/.openclaw/workspace/projects/shenyizhou.github.io
./publish-daily.sh
```

### 发布指定日期的博客

```bash
./publish-daily.sh 2026-03-06
```

## 📁 目录结构

```
shenyizhou.github.io/
├── _config.yml          # Jekyll 配置
├── about.md             # 关于页面
├── publish-daily.sh     # 每日发布脚本
├── _posts/              # 博客文章目录（自动生成）
└── README.md            # 本说明
```

## 🔧 工作原理

1. **读取记忆文件**: 从 `~/workspace/memory/` 目录读取每日记录
2. **转换格式**: 将 Markdown 转换为 Jekyll 博客格式
3. **添加 Front Matter**: 自动生成标题、日期、分类等元数据
4. **发布到 GitHub**: 自动 commit 并 push 到 GitHub Pages

## 📝 记忆文件格式

记忆文件需要放在 `~/workspace/memory/` 目录，文件名格式：`YYYY-MM-DD.md`

文件内容示例：
```markdown
# 2026-03-06 学习记录

## 今日任务

- 完成了项目 A
- 学习了技术 B

## 遇到的问题

...
```

## 🌐 访问博客

博客地址: https://shenyizhou.github.io

---

*和小浪一起，每天进步一点点！* 🌊
