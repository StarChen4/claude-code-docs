# 常见问题 (FAQ)

解答 ClaudeCode 使用过程中的常见问题。

## 安装和配置

### Q: 如何检查 ClaudeCode 是否安装成功？

**A:** 运行以下命令：

```bash
claude --version
```

如果显示版本号，说明安装成功。

### Q: 为什么运行 `claude` 提示命令不存在？

**A:** 可能的原因：

1. **未安装**：确认已完成安装
2. **环境变量未配置**：将 ClaudeCode 添加到 PATH
3. **需要重启终端**：安装后重新打开终端

### Q: 如何更新 ClaudeCode？

**A:** 根据安装方式：

```bash
# npm 安装
npm update -g @anthropic-ai/claude-code

# 其他方式参考安装文档
```

## 基本使用

### Q: 如何开始使用 ClaudeCode？

**A:** 在项目目录下运行：

```bash
claude
```

然后直接输入你的需求。

### Q: 如何退出 ClaudeCode？

**A:** 使用以下任一方式：

- 输入 `/exit`
- 按 `Ctrl+C` 两次
- 按 `Ctrl+D`（Linux/macOS）

### Q: ClaudeCode 支持哪些语言？

**A:** ClaudeCode 支持多种编程语言，包括但不限于：

- JavaScript/TypeScript
- Python
- Java
- C/C++
- Go
- Rust
- PHP
- Ruby
- 等等

### Q: 如何让 ClaudeCode 使用中文？

**A:** 在用户级 Memory（`~/.claude/CLAUDE.md`）中添加：

```markdown
# 语言规范
- 所有交互使用中文
- 代码注释使用中文
- 文档使用中文
```

## 权限和安全

### Q: 为什么 ClaudeCode 总是请求权限确认？

**A:** 这是安全机制。可以：

1. 永久授权：在确认时选择 `Y`（大写）
2. 修改默认权限：`/permissions set <权限> true`
3. 跳过所有确认（不推荐）：`claude --dangerously-skip-permissions`

### Q: 内网环境下如何禁用网络功能？

**A:** 设置权限：

```bash
/permissions set web_search false
/permissions set web_fetch false
```

并在用户 Memory 中添加：

```markdown
# 网络环境
- 内网环境，无互联网
- 禁用所有网络功能
```

### Q: ClaudeCode 会不会泄露代码？

**A:** 不会。ClaudeCode：

- 代码仅在本地处理
- 不会上传到云端（除非使用云端 API）
- 遵循隐私保护原则

### Q: 如何控制 ClaudeCode 可以修改哪些文件？

**A:** 使用权限管理：

```bash
# 设置为只读模式
/permissions set file_write false
/permissions set file_delete false
```

## Memory 和上下文

### Q: 用户级 Memory 和项目级 Memory 有什么区别？

**A:**

| 特性 | 用户级 Memory | 项目级 Memory |
|------|--------------|---------------|
| 位置 | `~/.claude/CLAUDE.md` | `.claude/memory.md` |
| 范围 | 所有项目 | 当前项目 |
| 内容 | 个人偏好、系统环境 | 项目规范、架构信息 |

### Q: 如何清空对话历史？

**A:** 两种方式：

- `/compact`：压缩但保留摘要
- `/clear`：完全清空

### Q: 为什么 ClaudeCode 忘记了之前的对话？

**A:** 可能原因：

1. 上下文窗口已满：使用 `/compact` 压缩
2. 会话已结束：重新启动 ClaudeCode
3. 信息在太久之前：定期压缩可避免

### Q: 如何让 ClaudeCode 记住项目规范？

**A:** 在项目 Memory（`.claude/memory.md`）中添加：

```markdown
# 项目规范
- 缩进：2 空格
- 命名：camelCase
- 测试：必须 > 80% 覆盖率
```

## 模式和功能

### Q: 什么时候使用计划模式？

**A:** 计划模式适用于：

- 复杂功能开发
- 大规模重构
- 多文件修改
- 不确定的需求

对于简单任务，使用正常模式更快。

### Q: 如何强制使用计划模式？

**A:** 明确要求：

```bash
> 请先制定计划：[任务描述]
```

### Q: SubAgent 是什么？什么时候使用？

**A:** SubAgent 是专门化的代理：

- **Explore Agent**：探索代码库
- **Plan Agent**：制定计划
- **General Purpose**：通用任务

ClaudeCode 会自动选择合适的 Agent，你也可以明确要求：

```bash
> 使用 Explore Agent 查找 API 定义
```

### Q: 如何恢复之前的 Agent？

**A:** 使用 Resume：

```bash
> resume a123456
```

Agent ID 在 Agent 完成时会显示。

## 文件操作

### Q: ClaudeCode 可以创建文件吗？

**A:** 可以，需要 `file_write` 权限。

```bash
> 创建 src/utils/helper.js
```

### Q: ClaudeCode 可以删除文件吗？

**A:** 可以，但需要 `file_delete` 权限（默认禁用）：

```bash
# 临时启用
/permissions set file_delete true

# 删除文件
> 删除 temp.txt

# 禁用
/permissions set file_delete false
```

### Q: 如何让 ClaudeCode 只读不修改？

**A:**

```bash
/permissions set file_write false
/permissions set file_delete false
```

### Q: ClaudeCode 会覆盖我的代码吗？

**A:** 不会意外覆盖。ClaudeCode：

- 修改前会显示更改
- 可以在 Git 中回滚
- 可以设置只读模式

建议：重要修改前先提交代码。

## Git 集成

### Q: ClaudeCode 可以自动提交代码吗？

**A:** 可以，但需要明确要求：

```bash
> 提交这些更改
```

ClaudeCode 会分析更改并生成提交信息。

### Q: 提交信息是什么格式？

**A:** 遵循 Conventional Commits：

```
<type>: <subject>

<body>

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Q: ClaudeCode 会自动推送代码吗？

**A:** 默认不会。需要明确要求：

```bash
> 提交并推送到远程
```

### Q: 如何让 ClaudeCode 创建 Pull Request？

**A:**

```bash
> 创建 Pull Request
```

需要配置 GitHub CLI (`gh`)。

### Q: ClaudeCode 可以解决合并冲突吗？

**A:** 可以尝试自动解决简单冲突，复杂冲突需要人工决策。

## 自定义命令

### Q: 如何创建自定义命令？

**A:**

1. 运行 `/init` 初始化项目
2. 在 `.claude/commands/` 创建 `.md` 文件
3. 文件名即命令名，内容为提示词

示例：`.claude/commands/review.md`

```markdown
进行代码审查，检查：
1. 代码质量
2. 潜在 Bug
3. 性能问题
```

使用：`/review`

### Q: 自定义命令支持参数吗？

**A:** 不直接支持，但可以在命令中提示用户提供信息：

```markdown
创建新组件，请提供组件名称。
```

### Q: 如何查看所有可用命令？

**A:**

```bash
# 查看内置命令
/help

# 查看自定义命令
!dir .claude\commands      # Windows
!ls .claude/commands       # Linux/macOS
```

## 性能和限制

### Q: ClaudeCode 有上下文长度限制吗？

**A:** 是的，但通过自动摘要机制，实际上是无限的。建议：

- 定期使用 `/compact` 压缩
- 大型项目分阶段处理

### Q: ClaudeCode 运行很慢怎么办？

**A:** 可能原因和解决：

1. **上下文过长**：使用 `/compact`
2. **网络慢**：禁用不必要的网络功能
3. **任务复杂**：分解为小任务

### Q: ClaudeCode 消耗多少资源？

**A:**

- CPU：中等
- 内存：通常 < 500MB
- 网络：取决于是否使用云端 API

### Q: 可以同时运行多个 ClaudeCode 实例吗？

**A:** 可以，在不同终端窗口中运行。

## 错误和故障

### Q: ClaudeCode 报错"Permission Denied"怎么办？

**A:**

1. 检查文件权限
2. 检查 ClaudeCode 权限设置
3. 使用管理员权限运行（如需要）

### Q: 为什么 ClaudeCode 执行了错误的操作？

**A:**

1. 立即停止：按 `Ctrl+C`
2. 使用 Git 回滚
3. 改进提示词，更明确描述需求

### Q: ClaudeCode 一直重复错误的操作怎么办？

**A:**

1. `/compact` 压缩上下文
2. `/clear` 清空历史重新开始
3. 在 Memory 中添加约束

### Q: 命令没有反应怎么办？

**A:**

1. 检查命令拼写
2. 查看是否在等待输入
3. 重启 ClaudeCode
4. 检查网络连接（如使用云端 API）

## Windows 特定问题

### Q: Windows 下为什么总是使用错误的命令？

**A:** 在用户 Memory 中指定系统：

```markdown
# 系统环境
- 操作系统：Windows
- 使用 Windows 命令（dir、type 等）
- 不使用 Linux 命令（ls、cat 等）
```

### Q: PowerShell 和 CMD 有什么区别？

**A:** ClaudeCode 支持两者，PowerShell 功能更强大：

- 推荐使用 PowerShell
- 在 Memory 中指定 Shell 类型

### Q: Windows 路径问题怎么处理？

**A:**

- Windows 使用 `\`，但也支持 `/`
- ClaudeCode 会自动处理
- 路径有空格时使用引号：`"C:\Program Files\"`

## 其他

### Q: ClaudeCode 支持插件吗？

**A:** 支持 MCP（Model Context Protocol）服务器，可以扩展功能。

### Q: 如何给 ClaudeCode 反馈问题？

**A:**

- GitHub Issues：https://github.com/anthropics/claude-code/issues
- 在命令行运行 `claude --help` 查看反馈渠道

### Q: ClaudeCode 适合新手吗？

**A:** 适合，但建议：

- 先学习基本的 Git 和命令行知识
- 从简单任务开始
- 查看示例和教程
- 在非重要项目上练习

### Q: 团队协作如何使用 ClaudeCode？

**A:**

- 将 `.claude/` 目录纳入版本控制（除了 `.claude/cache/`）
- 共享项目 Memory 和自定义命令
- 统一编码规范和工作流

### Q: ClaudeCode 可以替代开发者吗？

**A:** 不能。ClaudeCode 是辅助工具：

- 提高效率
- 减少重复劳动
- 辅助决策
- 但仍需要人工审查和判断

## 下一步

- [故障排查](/reference/troubleshooting) - 详细的问题诊断
- [命令速查](/reference/commands) - 快速查找命令
- [基本命令](/guide/basic-commands) - 命令详细说明
