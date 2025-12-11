# 命令速查表

快速查找 ClaudeCode 的所有命令和用法。

## 内置命令

### 核心命令

| 命令 | 说明 | 用法 |
|------|------|------|
| `/init` | 初始化项目配置 | `/init` |
| `/compact` | 压缩对话历史 | `/compact` |
| `/permissions` | 管理权限 | `/permissions [list\|set]` |
| `/help` | 显示帮助信息 | `/help` |
| `/clear` | 清空对话历史 | `/clear` |
| `/exit` | 退出 ClaudeCode | `/exit` |

### 权限命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/permissions list` | 列出所有权限 | `/permissions list` |
| `/permissions get <权限>` | 查看单个权限 | `/permissions get file_write` |
| `/permissions set <权限> <值>` | 设置权限 | `/permissions set web_search false` |

## 命令行选项

### 启动选项

```bash
# 基本启动
claude

# 跳过权限确认（危险）
claude --dangerously-skip-permissions

# 指定工作目录
claude --cwd /path/to/project

# 显示版本
claude --version

# 显示帮助
claude --help
```

## 特殊符号

### `!` - 执行系统命令

```bash
# Windows
> !dir                   # 列出文件
> !type file.txt        # 查看文件
> !git status           # Git 状态

# Linux/macOS
> !ls -la               # 列出文件
> !cat file.txt         # 查看文件
> !git status           # Git 状态
```

## 常用操作速查

### 文件操作

```bash
# 读取文件
> 读取 src/index.js

# 创建文件
> 创建 src/utils/helper.js

# 修改文件
> 修改 src/index.js 添加错误处理

# 删除文件（需要权限）
> 删除 temp.txt
```

### Git 操作

```bash
# 查看状态
> 查看 Git 状态
> !git status

# 查看差异
> 查看我做了什么更改
> !git diff

# 提交
> 提交这些更改

# 创建分支
> 创建分支 feature/new-feature

# 切换分支
> 切换到 develop 分支

# 合并分支
> 合并 feature/login 到当前分支

# 创建 PR
> 创建 Pull Request
```

### 项目管理

```bash
# 初始化项目
> /init

# 创建需求文档
> 创建项目需求文档

# 制定开发计划
> 制定详细的开发计划

# 更新进度
> 在开发计划中标记任务已完成
```

### 代码质量

```bash
# 代码审查
> 审查这段代码

# 重构
> 重构这个函数使其更易读

# 优化性能
> 优化这段代码的性能

# 添加测试
> 为这个函数添加单元测试

# 添加注释
> 为这段代码添加中文注释
```

### 调试和测试

```bash
# 运行测试
> 运行所有测试
> !npm test

# 分析错误
> 分析这个错误并修复

# 调试
> 帮我调试登录功能失败的问题

# 性能分析
> 分析这段代码的性能瓶颈
```

## 自定义命令示例

### 创建自定义命令

1. 在 `.claude/commands/` 创建 `.md` 文件
2. 文件名即命令名
3. 文件内容为提示词

### 常用自定义命令

```bash
# 代码审查
> /review

# 运行测试
> /test

# 部署前检查
> /pre-deploy

# Git 提交流程
> /commit

# 生成文档
> /docs
```

## 快捷模式

### 对话模式

```bash
# 只回答问题，不修改代码
> 只解释：这段代码做什么？
> 为什么要这样实现？
```

### 计划模式

```bash
# 先制定计划再执行
> 请先制定计划：重构认证模块
```

### 探索模式

```bash
# 使用 Explore Agent
> 探索数据库访问代码
> 查找 API 端点定义
```

## Memory 管理

### 用户级 Memory

**位置**：`~/.claude/CLAUDE.md`

```markdown
# 语言规范
- 使用中文

# 系统环境
- Windows 11

# 编码规范
- 4 空格缩进
- 驼峰命名
```

### 项目级 Memory

**位置**：`.claude/memory.md`

```markdown
# 项目信息
- 技术栈：Node.js + React
- 数据库：PostgreSQL

# 编码规范
- ESLint 配置
- Prettier 格式化
```

## SubAgent 和 Resume

### 使用 SubAgent

```bash
# 自动选择 Agent
> 探索项目结构

# 并行 Agent
> 同时分析前端和后端代码

# 计划 Agent
[复杂任务自动使用]
```

### Resume Agent

```bash
# 恢复 Agent
> resume a123456

# 恢复并给新任务
> resume a123456 继续优化
```

## 权限速查

| 权限 | 默认 | 说明 |
|------|------|------|
| `file_read` | ✅ | 读取文件 |
| `file_write` | ✅ | 写入文件 |
| `file_delete` | ❌ | 删除文件 |
| `bash_execution` | ✅ | 执行命令 |
| `web_search` | ✅ | 网络搜索 |
| `web_fetch` | ✅ | 访问网页 |

### 内网环境配置

```bash
/permissions set web_search false
/permissions set web_fetch false
```

## 常用组合操作

### 功能开发流程

```bash
1. 创建分支
2. 实现功能
3. 添加测试
4. 代码审查
5. 提交代码
6. 创建 PR
```

### Bug 修复流程

```bash
1. 分析问题
2. 创建修复分支
3. 修复代码
4. 测试验证
5. 提交修复
6. 创建 PR
```

### 重构流程

```bash
1. 制定重构计划
2. 创建分支
3. 执行重构
4. 运行测试
5. 代码审查
6. 提交更改
```

## Windows vs Linux 命令对照

| 操作 | Windows | Linux/macOS |
|------|---------|-------------|
| 列出文件 | `dir` | `ls -la` |
| 查看文件 | `type` | `cat` |
| 创建目录 | `mkdir` | `mkdir -p` |
| 删除文件 | `del` | `rm` |
| 复制文件 | `copy` | `cp` |
| 移动文件 | `move` | `mv` |
| 查找文件 | `dir /s` | `find` |
| 查找文本 | `findstr` | `grep` |
| 环境变量 | `%VAR%` | `$VAR` |
| 路径分隔 | `\` | `/` |

## 快捷提示

::: tip 提高效率的技巧

1. 使用 `/compact` 定期压缩历史
2. 设置用户级 Memory 避免重复说明
3. 创建项目级 Memory 定义规范
4. 使用自定义命令封装常用操作
5. 善用 SubAgent 处理复杂任务
6. 利用 Resume 保持上下文连续性

:::

## 下一步

- [常见问题](/reference/faq) - 解答常见疑问
- [故障排查](/reference/troubleshooting) - 问题诊断和解决
- [基本命令](/guide/basic-commands) - 详细命令说明
