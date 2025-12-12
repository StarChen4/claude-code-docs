# 基本命令

ClaudeCode 提供了一系列命令来增强交互体验和控制工作流程。

## 核心命令

### `/init` - 初始化项目

初始化 ClaudeCode 在当前项目中的配置。让ClaudeCode对项目内容进行初步了解。

#### 用法

```bash
/init
```

#### 功能

- 创建 `.claude` 配置目录
- 设置项目级别的 Memory
- 初始化自定义命令目录
- 配置项目特定设置

#### 何时使用

- **建议第一次打开所有项目都用一下**
- 初次打开一个内容较多的项目
- 让ClaudeCode接手一个陌生项目
- 了解项目整体结构和内容

#### 示例

```bash
> /init
Claude: 已初始化项目配置
创建目录：.claude/
创建文件：.claude/memory.md
创建目录：.claude/commands/
```

### `/compact` - 压缩对话历史

压缩对话历史以节省上下文空间。

#### 用法

```bash
/compact
```

#### 功能

- 总结之前的对话
- 保留重要信息
- 释放上下文窗口
- 提高响应速度

#### 何时使用

- 对话内容过长时
- 感觉响应变慢时
- 开始新的主题前
- 定期清理（建议每 20-30 轮对话）

#### 示例

```bash
> /compact
Claude: 正在压缩对话历史...
已压缩 50 条消息为 5 条摘要
上下文空间已释放 75%
```

::: tip 提示
`/compact` 不会丢失重要信息，只是将其浓缩为摘要形式。
:::

### `/permissions` - 权限管理

管理 ClaudeCode 的操作权限。

#### 用法

```bash
/permissions
/permissions set <权限> <值>
/permissions list
```

#### 常用权限

| 权限 | 说明 | 默认值 |
|------|------|--------|
| `web_search` | 允许网络搜索 | `true` |
| `web_fetch` | 允许访问网页 | `true` |
| `file_write` | 允许写入文件 | `true` |
| `file_delete` | 允许删除文件 | `false` |
| `bash_execution` | 允许执行命令 | `true` |

#### 示例

```bash
# 查看所有权限
> /permissions list

# 禁用网络搜索（内网环境）
> /permissions set web_search false

# 禁用网页访问
> /permissions set web_fetch false

# 启用文件删除权限
> /permissions set file_delete true
```

::: warning 内网环境配置
在没有互联网的内网环境中，建议禁用 `web_search` 和 `web_fetch`：

```bash
/permissions set web_search false
/permissions set web_fetch false
```

这可以避免 ClaudeCode 尝试访问互联网而浪费时间和上下文。
:::

## 辅助命令

### `!` - 切换到命令行

在 ClaudeCode 对话中执行系统命令。

#### 用法

```bash
!<命令>
```

#### 示例

```bash
# 查看当前目录
> !dir

# 查看 Git 状态
> !git status

# 运行测试
> !npm test

# 查看文件内容
> !type README.md
```

::: tip Windows 命令
在 Windows 环境下，使用 Windows 命令（如 `dir`、`type`），而不是 Linux 命令（如 `ls`、`cat`）。
:::

### `/help` - 获取帮助

显示帮助信息和可用命令列表。

```bash
/help
```

### `/clear` - 清空对话

清空当前对话历史（与 `/compact` 不同，这会完全清空）。

```bash
/clear
```

### `/exit` - 退出

退出 ClaudeCode。

```bash
/exit
```

## 高级命令选项

### `--dangerously-skip-permissions`

跳过权限检查直接执行命令（谨慎使用）。

#### 用法

```bash
claude --dangerously-skip-permissions
```

#### 适用场景

- 自动化脚本
- CI/CD 流程
- 信任的批处理任务

::: danger 危险操作
使用此选项会跳过所有权限确认，可能导致意外的文件修改或删除。仅在完全理解后果的情况下使用。
:::

## 命令组合使用

### 场景 1：开始新项目

```bash
# 初始化项目
> /init

# 设置权限（内网环境）
> /permissions set web_search false
> /permissions set web_fetch false

# 开始开发
> 帮我创建项目基础结构
```

### 场景 2：长时间工作后优化

```bash
# 压缩对话历史
> /compact

# 查看 Git 状态
> !git status

# 继续工作
> 继续实现用户登录功能
```

### 场景 3：权限受限环境

```bash
# 查看当前权限
> /permissions list

# 禁用不必要的权限
> /permissions set web_search false
> /permissions set web_fetch false
> /permissions set file_delete false
```

## 快捷技巧

::: tip 效率提示

1. **定期压缩**：养成定期使用 `/compact` 的习惯
2. **项目初始化**：新项目第一件事就是 `/init`
3. **权限预设**：在用户级别 Memory 中设置默认权限
4. **命令简化**：使用自定义命令封装常用操作组合

:::

## 常见问题

### Q: `/compact` 和 `/clear` 有什么区别？

**A:** `/compact` 压缩历史并保留摘要，`/clear` 完全清空历史。

### Q: 为什么要禁用网络权限？

**A:** 在内网环境中，禁用网络权限可以避免 ClaudeCode 尝试访问互联网，节省时间和上下文。

### Q: 如何恢复默认权限？

**A:** 删除 `.claude/permissions.json` 文件，重新运行 `/init`。

## 下一步

- [Memory 使用](/advanced/memory) - 配置项目和用户偏好
- [自定义命令](/advanced/custom-commands) - 创建自己的命令
- [权限管理](/advanced/permissions) - 深入了解权限系统
