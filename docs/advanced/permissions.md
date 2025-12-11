# 权限管理

ClaudeCode 的权限系统可以精细控制其操作能力，确保安全性和适应不同环境需求。

## 权限系统概述

权限系统控制 ClaudeCode 可以执行的操作类型，例如：
- 是否可以访问网络
- 是否可以修改文件
- 是否可以执行系统命令
- 是否可以删除文件

## 查看权限

### 列出所有权限

```bash
> /permissions list
```

输出示例：

```
当前权限设置：
✅ file_read: true          # 允许读取文件
✅ file_write: true         # 允许写入文件
❌ file_delete: false       # 禁止删除文件
✅ bash_execution: true     # 允许执行命令
❌ web_search: false        # 禁止网络搜索
❌ web_fetch: false         # 禁止网页访问
```

### 查看单个权限

```bash
> /permissions get file_write
```

## 修改权限

### 基本语法

```bash
/permissions set <权限名> <true|false>
```

### 示例

```bash
# 禁用网络搜索
> /permissions set web_search false

# 启用文件删除
> /permissions set file_delete true

# 禁用命令执行
> /permissions set bash_execution false
```

## 权限详解

### 文件操作权限

#### `file_read`

**说明**：允许读取文件内容

**默认值**：`true`

**影响**：
- ✅ 启用：可以读取项目文件
- ❌ 禁用：无法查看代码，功能受限

**建议**：保持启用

```bash
# 通常不需要禁用
/permissions set file_read true
```

#### `file_write`

**说明**：允许写入和修改文件

**默认值**：`true`

**影响**：
- ✅ 启用：可以创建和修改文件
- ❌ 禁用：只能查看，不能修改

**场景**：
- 生产环境审查：禁用
- 开发环境：启用

```bash
# 只读模式
/permissions set file_write false

# 开发模式
/permissions set file_write true
```

#### `file_delete`

**说明**：允许删除文件

**默认值**：`false`

**影响**：
- ✅ 启用：可以删除不需要的文件
- ❌ 禁用：无法删除文件（更安全）

**建议**：根据需要临时启用

```bash
# 需要清理文件时临时启用
/permissions set file_delete true

# 完成后禁用
/permissions set file_delete false
```

### 网络权限

#### `web_search`

**说明**：允许使用网络搜索功能

**默认值**：`true`

**影响**：
- ✅ 启用：可以搜索最新文档和信息
- ❌ 禁用：无法访问互联网搜索

**内网环境**：必须禁用

```bash
# 内网环境
/permissions set web_search false
```

#### `web_fetch`

**说明**：允许访问和获取网页内容

**默认值**：`true`

**影响**：
- ✅ 启用：可以获取在线文档
- ❌ 禁用：无法访问网页

**内网环境**：必须禁用

```bash
# 内网环境
/permissions set web_fetch false
```

### 执行权限

#### `bash_execution`

**说明**：允许执行系统命令

**默认值**：`true`

**影响**：
- ✅ 启用：可以运行 git、npm 等命令
- ❌ 禁用：无法执行任何系统命令

**建议**：通常保持启用

```bash
# 正常开发环境
/permissions set bash_execution true

# 极度安全的环境
/permissions set bash_execution false
```

## 环境配置方案

### 内网开发环境

**特点**：无互联网访问，需要修改文件

```bash
/permissions set web_search false
/permissions set web_fetch false
/permissions set file_write true
/permissions set file_delete false
/permissions set bash_execution true
```

**配置到 Memory**：

```markdown
# 权限配置
自动使用以下权限设置：
- 禁用网络搜索和访问（内网环境）
- 允许文件读写
- 禁止文件删除（安全考虑）
- 允许命令执行
```

### 生产环境审查

**特点**：只读，不修改文件

```bash
/permissions set file_write false
/permissions set file_delete false
/permissions set bash_execution true  # 允许运行查询命令
```

### 自动化 CI/CD

**特点**：无需确认，自动执行

```bash
claude --dangerously-skip-permissions
```

::: danger 危险操作
`--dangerously-skip-permissions` 会跳过所有权限确认！仅在完全可控的自动化环境中使用。
:::

### 学习和探索模式

**特点**：安全地学习代码

```bash
/permissions set file_write false
/permissions set file_delete false
/permissions set web_search true   # 允许查询学习资料
```

## 权限持久化

### 用户级默认权限

在 `~/.claude/permissions.json` 中设置默认权限：

```json
{
  "file_read": true,
  "file_write": true,
  "file_delete": false,
  "bash_execution": true,
  "web_search": false,
  "web_fetch": false
}
```

### 项目级权限

在项目的 `.claude/permissions.json` 中覆盖默认值：

```json
{
  "file_delete": true,
  "web_search": true
}
```

**优先级**：项目级 > 用户级 > 系统默认

## 实战案例

### 案例 1：内网环境配置

**问题**：ClaudeCode 一直尝试访问互联网，浪费时间

**解决方案**：

1. 禁用网络权限：

```bash
/permissions set web_search false
/permissions set web_fetch false
```

2. 添加到用户 Memory：

```markdown
# 网络环境
- 内网环境，无互联网
- 已禁用 web_search 和 web_fetch
```

3. 验证：

```bash
> /permissions list
# 确认 web_search 和 web_fetch 为 false
```

### 案例 2：安全的代码审查

**需求**：审查代码但不允许修改

**解决方案**：

```bash
# 切换到只读模式
/permissions set file_write false
/permissions set file_delete false

# 进行代码审查
> 审查 src/ 目录下的代码质量

# 审查完成后恢复
/permissions set file_write true
```

### 案例 3：临时清理文件

**需求**：删除不需要的文件

**解决方案**：

```bash
# 临时启用删除权限
/permissions set file_delete true

# 执行清理
> 删除所有 .log 文件

# 完成后立即禁用
/permissions set file_delete false
```

### 案例 4：自动化脚本

**需求**：CI/CD 流水线中自动生成代码

**解决方案**：

```bash
# 使用跳过权限模式
claude --dangerously-skip-permissions << EOF
根据 API 规范生成客户端代码
运行测试
提交更改
EOF
```

## 权限确认流程

当权限不足时，ClaudeCode 会请求确认：

```bash
> 删除 temp.txt

Claude: ⚠️  权限确认
需要 file_delete 权限来删除文件。
当前权限: file_delete = false

是否允许？[y/N]
```

选项：
- `y` - 仅本次允许
- `Y` - 永久允许（更新权限配置）
- `n` / `N` - 拒绝

## 最佳实践

::: tip 权限管理建议

1. **最小权限原则**：只启用必需的权限
2. **环境区分**：不同环境使用不同权限配置
3. **定期审查**：定期检查权限设置是否合理
4. **临时提权**：需要时临时启用，用完立即禁用
5. **记录配置**：在 Memory 中记录权限配置原因

:::

::: warning 安全注意事项

- 不要在不信任的代码上启用 `file_delete`
- 内网环境必须禁用网络权限
- 谨慎使用 `--dangerously-skip-permissions`
- 定期审查自动化脚本的权限需求

:::

## 常见问题

### Q: 如何重置所有权限到默认值？

**A:** 删除权限配置文件：

```bash
# Windows
> !del %USERPROFILE%\.claude\permissions.json

# Linux/macOS
> !rm ~/.claude/permissions.json
```

### Q: 项目权限和用户权限冲突怎么办？

**A:** 项目权限优先级更高，会覆盖用户权限。

### Q: 如何为特定命令临时提权？

**A:** 使用一次性确认：

```bash
> 删除文件
[ClaudeCode 请求 file_delete 权限]
[输入 'y' 仅本次允许]
```

### Q: `--dangerously-skip-permissions` 有多危险？

**A:** 非常危险！它会：
- 跳过所有权限检查
- 自动执行所有操作
- 可能意外删除文件
- 可能执行危险命令

仅在完全可控的环境中使用。

## 权限配置速查表

| 场景 | file_read | file_write | file_delete | bash_execution | web_search | web_fetch |
|------|-----------|------------|-------------|----------------|------------|-----------|
| 开发环境 | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| 内网开发 | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| 代码审查 | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |
| 自动化 | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| 学习模式 | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |

## 下一步

- [自定义命令](/advanced/custom-commands) - 封装权限设置
- [SubAgent 详解](/advanced/subagent) - 子任务权限控制
- [Git 集成](/advanced/git-integration) - 版本控制权限
