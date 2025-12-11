# 故障排查

遇到问题时的诊断和解决方案指南。

## 诊断流程

遇到问题时，按以下步骤诊断：

```
1. 识别问题类型
   ↓
2. 检查基本配置
   ↓
3. 查看错误信息
   ↓
4. 尝试常规解决方案
   ↓
5. 查找相关文档
   ↓
6. 提交问题反馈
```

## 常见问题分类

### 启动问题

#### 问题：运行 `claude` 提示"命令不存在"

**症状**：
```bash
> claude
'claude' 不是内部或外部命令...
```

**诊断步骤**：

1. 检查是否安装：
```bash
where claude        # Windows
which claude        # Linux/macOS
```

2. 检查 PATH 环境变量

3. 尝试完整路径运行

**解决方案**：

```bash
# 方案 1：重新安装
npm install -g @anthropic-ai/claude-code

# 方案 2：添加到 PATH（Windows）
setx PATH "%PATH%;C:\path\to\claude"

# 方案 3：使用完整路径
C:\path\to\claude\claude.exe
```

#### 问题：启动后立即崩溃

**症状**：
```bash
> claude
[Error] ...
[程序退出]
```

**诊断步骤**：

1. 查看错误信息
2. 检查 Node.js 版本：
```bash
node --version
# 需要 >= 18.0.0
```

3. 检查权限

**解决方案**：

```bash
# 方案 1：更新 Node.js
# 下载并安装最新 LTS 版本

# 方案 2：使用管理员权限（如果是权限问题）
# Windows：以管理员身份运行

# 方案 3：清除缓存
# Windows
rd /s /q %USERPROFILE%\.claude\cache

# Linux/macOS
rm -rf ~/.claude/cache
```

### 权限问题

#### 问题：频繁请求权限确认

**症状**：
每个操作都要求确认权限

**解决方案**：

```bash
# 方案 1：永久授权（确认时输入大写 Y）
> 删除文件
[权限请求]
Y  # 大写，永久授权

# 方案 2：预设权限
/permissions set file_delete true

# 方案 3：跳过权限（仅测试环境）
claude --dangerously-skip-permissions
```

#### 问题："Permission Denied" 错误

**症状**：
```bash
Error: Permission denied
```

**诊断步骤**：

1. 检查文件权限
2. 检查 ClaudeCode 权限配置
3. 检查系统用户权限

**解决方案**：

```bash
# Windows：以管理员身份运行

# Linux/macOS：检查文件权限
ls -la file.txt
chmod 644 file.txt  # 修改权限

# 检查 ClaudeCode 权限
/permissions list
/permissions set file_write true
```

### 网络问题

#### 问题：内网环境下一直尝试联网

**症状**：
ClaudeCode 频繁尝试访问互联网，导致延迟

**解决方案**：

```bash
# 步骤 1：禁用网络权限
/permissions set web_search false
/permissions set web_fetch false

# 步骤 2：添加到用户 Memory
# 编辑 ~/.claude/CLAUDE.md
```

```markdown
# 网络环境
- 内网环境，无法访问互联网
- 已禁用 web_search 和 web_fetch
- 不要尝试访问外部资源
```

#### 问题：API 调用超时

**症状**：
```bash
Error: Request timeout
```

**解决方案**：

```bash
# 方案 1：检查网络连接
ping api.anthropic.com

# 方案 2：增加超时时间（如果支持）

# 方案 3：使用代理
set HTTP_PROXY=http://proxy:port
set HTTPS_PROXY=http://proxy:port
```

### 上下文和 Memory 问题

#### 问题：ClaudeCode 忘记了之前的对话

**症状**：
询问之前提到的信息，ClaudeCode 说不知道

**诊断步骤**：

1. 检查对话长度
2. 检查是否重启过会话

**解决方案**：

```bash
# 方案 1：定期压缩上下文
/compact

# 方案 2：使用 Memory 保存重要信息
# 编辑 .claude/memory.md
```

```markdown
# 项目关键信息
- 数据库：PostgreSQL
- 端口：5432
- 认证方式：JWT
```

```bash
# 方案 3：使用 SubAgent Resume
> resume a123456
```

#### 问题：Memory 设置不生效

**症状**：
在 Memory 中设置了规则，但 ClaudeCode 没有遵守

**诊断步骤**：

1. 检查 Memory 文件位置
2. 检查 Memory 文件格式
3. 重启 ClaudeCode

**解决方案**：

```bash
# 步骤 1：确认文件位置
# 用户级：~/.claude/CLAUDE.md
# 项目级：.claude/memory.md

# 步骤 2：确认格式正确（Markdown）

# 步骤 3：重启 ClaudeCode
/exit
claude

# 步骤 4：或使用 compact 刷新
/compact
```

### 命令执行问题

#### 问题：系统命令执行失败

**症状**：
```bash
> !ls
[错误]
```

**诊断步骤**：

1. 检查操作系统
2. 检查命令是否存在
3. 检查权限

**解决方案**：

```bash
# Windows：使用 Windows 命令
> !dir          # 而不是 ls
> !type file    # 而不是 cat

# 在用户 Memory 中设置
```

```markdown
# 系统环境
- 操作系统：Windows
- 使用 Windows 命令
- dir 而不是 ls
- type 而不是 cat
```

#### 问题：Git 命令失败

**症状**：
```bash
> !git status
fatal: not a git repository
```

**解决方案**：

```bash
# 步骤 1：初始化 Git 仓库
> !git init

# 步骤 2：检查当前目录
> !cd
# 确保在正确的项目目录

# 步骤 3：检查 Git 安装
> !git --version
```

### 文件操作问题

#### 问题：无法读取文件

**症状**：
```bash
Error: File not found: src/index.js
```

**诊断步骤**：

1. 检查文件是否存在
2. 检查路径是否正确
3. 检查文件权限

**解决方案**：

```bash
# 步骤 1：确认文件存在
> !dir src\index.js        # Windows
> !ls src/index.js         # Linux/macOS

# 步骤 2：使用正确的路径
# Windows：使用 \ 或 /
# Linux/macOS：使用 /

# 步骤 3：检查权限
/permissions list
/permissions set file_read true
```

#### 问题：文件修改丢失

**症状**：
ClaudeCode 说修改了文件，但实际没变化

**诊断步骤**：

1. 检查文件写权限
2. 检查是否保存
3. 检查文件是否锁定

**解决方案**：

```bash
# 步骤 1：确认权限
/permissions get file_write

# 步骤 2：检查文件
> !type src\index.js       # 查看实际内容

# 步骤 3：关闭其他编辑器
# 确保文件没被其他程序锁定

# 步骤 4：重试
> 再次修改 src/index.js
```

### Git 集成问题

#### 问题：提交失败

**症状**：
```bash
Error: nothing to commit
```

**解决方案**：

```bash
# 步骤 1：检查状态
> !git status

# 步骤 2：添加文件
> !git add .

# 步骤 3：再次提交
> 提交更改
```

#### 问题：合并冲突无法解决

**症状**：
ClaudeCode 无法自动解决合并冲突

**解决方案**：

```bash
# 方案 1：查看冲突
> !git status
> !git diff

# 方案 2：手动指导
> 在 src/auth.js 中保留当前分支的更改

# 方案 3：手动解决
# 使用编辑器手动解决冲突
# 然后告诉 ClaudeCode
> 我已解决冲突，请标记为已解决并提交
```

#### 问题：无法创建 Pull Request

**症状**：
```bash
Error: gh command not found
```

**解决方案**：

```bash
# 安装 GitHub CLI
# Windows：使用 winget 或下载安装包
winget install --id GitHub.cli

# Linux：
sudo apt install gh

# macOS：
brew install gh

# 配置
gh auth login
```

### SubAgent 和 Resume 问题

#### 问题：Agent ID 无效

**症状**：
```bash
> resume a123456
Error: Agent not found
```

**原因**：
- Agent 已过期
- 会话已关闭
- ID 输入错误

**解决方案**：

```bash
# 方案 1：检查 ID 拼写
# 复制粘贴 ID 避免错误

# 方案 2：在同一会话中使用
# Agent ID 仅在当前会话有效

# 方案 3：重新启动 Agent
> 重新分析代码库
[获取新的 Agent ID]
```

#### 问题：Resume 后上下文丢失

**症状**：
Resume Agent 后，似乎忘记了之前的工作

**解决方案**：

```bash
# 方案 1：使用 compact 而不是 clear
/compact  # 而不是 /clear

# 方案 2：明确说明任务
> resume a123456 继续之前的性能优化工作

# 方案 3：查看 Agent 历史
> 总结 agent a123456 之前做了什么
```

### 性能问题

#### 问题：响应很慢

**症状**：
ClaudeCode 反应迟缓

**诊断步骤**：

1. 检查上下文长度
2. 检查网络连接
3. 检查系统资源

**解决方案**：

```bash
# 方案 1：压缩上下文
/compact

# 方案 2：禁用不必要功能
/permissions set web_search false
/permissions set web_fetch false

# 方案 3：分解任务
# 将大任务分解为小任务逐个执行

# 方案 4：重启
/exit
claude
```

#### 问题：内存占用过高

**症状**：
ClaudeCode 占用大量内存

**解决方案**：

```bash
# 方案 1：压缩上下文
/compact

# 方案 2：清空历史
/clear

# 方案 3：重启
/exit
claude

# 方案 4：清除缓存
# Windows
rd /s /q %USERPROFILE%\.claude\cache

# Linux/macOS
rm -rf ~/.claude/cache
```

## 日志和调试

### 查看日志

```bash
# Windows
type %USERPROFILE%\.claude\logs\claude.log

# Linux/macOS
cat ~/.claude/logs/claude.log
```

### 启用详细日志

```bash
# 设置环境变量
set DEBUG=claude:*        # Windows
export DEBUG=claude:*     # Linux/macOS

claude
```

### 收集诊断信息

提交 bug 报告时，请包含：

1. ClaudeCode 版本
```bash
claude --version
```

2. 操作系统信息
```bash
# Windows
ver

# Linux/macOS
uname -a
```

3. Node.js 版本
```bash
node --version
```

4. 错误信息和日志

5. 重现步骤

## 高级故障排查

### 完全重置 ClaudeCode

```bash
# 步骤 1：备份配置（可选）
# 备份 ~/.claude/

# 步骤 2：删除配置
# Windows
rd /s /q %USERPROFILE%\.claude

# Linux/macOS
rm -rf ~/.claude

# 步骤 3：重新初始化
claude
/init
```

### 冲突的配置

如果用户级和项目级 Memory 冲突：

**优先级**：项目级 > 用户级

**解决方案**：

1. 检查两个 Memory 文件
2. 在项目级 Memory 中明确覆盖
3. 或删除冲突的配置

### 环境变量问题

```bash
# 检查环境变量
# Windows
set

# Linux/macOS
env

# 常见变量：
# - PATH
# - HTTP_PROXY
# - HTTPS_PROXY
# - NODE_ENV
```

## 获取帮助

如果问题仍未解决：

1. **查阅文档**
   - [常见问题](/reference/faq)
   - [命令速查](/reference/commands)

2. **搜索已知问题**
   - GitHub Issues

3. **提交问题**
   - 提供详细信息
   - 包含错误日志
   - 说明重现步骤

4. **社区支持**
   - 论坛讨论
   - 用户群组

## 预防性维护

### 定期操作

```bash
# 每天
/compact                  # 压缩上下文

# 每周
# 清理无用分支
!git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# 每月
# 更新 ClaudeCode
npm update -g @anthropic-ai/claude-code

# 清理缓存
# Windows
rd /s /q %USERPROFILE%\.claude\cache

# Linux/macOS
rm -rf ~/.claude/cache
```

### 最佳实践

::: tip 避免问题的建议

1. **定期 compact**：避免上下文过长
2. **使用 Memory**：减少重复说明
3. **Git 提交**：重要修改前先提交
4. **权限管理**：合理设置权限
5. **分解任务**：避免单个任务过于复杂
6. **文档化**：记录项目规范和配置

:::

## 下一步

- [常见问题](/reference/faq) - 快速解答
- [命令速查](/reference/commands) - 命令参考
- [基本命令](/guide/basic-commands) - 详细说明
