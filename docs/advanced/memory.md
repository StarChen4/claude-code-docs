# Memory 使用指南

Memory 是 ClaudeCode 的记忆功能，可以记住你的偏好、项目规范和常用设置，避免每次都要重复说明。

## Memory 类型

ClaudeCode 提供两种级别的 Memory：

### 1. 用户级 Memory（全局）

**位置**：`~/.claude/CLAUDE.md`（用户主目录）

**作用范围**：所有项目

**适用内容**：
- 个人编码风格
- 语言偏好
- 操作系统信息
- 常用工具和环境
- 全局禁用的功能

### 2. 项目级 Memory（本地）

**位置**：`<项目目录>/.claude/memory.md`

**作用范围**：当前项目

**适用内容**：
- 项目架构说明
- 技术栈信息
- 编码规范
- 命名约定
- 项目特定的配置

## 用户级 Memory 配置

### 创建用户级 Memory

```bash
# Windows
notepad %USERPROFILE%\.claude\CLAUDE.md

# Linux/macOS
nano ~/.claude/CLAUDE.md
```

### 推荐配置示例

```markdown
# 语言规范
遵循以下语言规范：
- 所有对话和文档都使用中文
- 注释使用中文
- 错误提示使用中文
- 文档中使用中文 MarkDown 格式

# 系统情况
- 当前运行环境为 Windows 系统
- 注意 PowerShell/CMD 命令语法差异
- 避免使用 Linux 专有命令（如 `grep`、`sed` 等，除非明确安装了）

# 网络环境
- 内网环境，无法访问互联网
- 禁用所有网络搜索和网页访问功能

# 编码风格
- 使用 4 空格缩进（不使用 Tab）
- 函数命名使用小驼峰 camelCase
- 类命名使用大驼峰 PascalCase
- 常量使用全大写 UPPER_CASE

# 文件组织
- 配置文件统一放在 config/ 目录
- 工具函数放在 utils/ 目录
- 测试文件与源文件同目录，后缀 .test.js
```

### 关键配置项

#### 1. 语言规范

```markdown
# 语言规范
- 所有交互使用中文
- 代码注释使用中文
- 文档使用中文
```

**效果**：ClaudeCode 会使用中文回答问题和编写注释。

#### 2. 系统环境

```markdown
# 系统环境
- 操作系统：Windows 11
- Shell：PowerShell 7
- 避免使用 bash 专有命令
```

**效果**：避免 ClaudeCode 使用 `ls`、`cat` 等 Linux 命令，改用 `dir`、`type`。

#### 3. 网络限制

```markdown
# 网络环境
- 内网环境，无互联网访问
- 禁用 web_search 和 web_fetch
```

**效果**：ClaudeCode 不会尝试访问互联网，节省时间。

#### 4. 编码规范

```markdown
# 编码规范
- 缩进：4 空格
- 引号：单引号
- 分号：不使用分号（JavaScript）
- 行尾：LF（不是 CRLF）
```

## 项目级 Memory 配置

### 初始化项目 Memory

```bash
# 在项目目录下
claude
> /init
```

这会创建 `.claude/memory.md` 文件。

### 项目 Memory 示例

```markdown
# 项目信息
- 项目名称：用户管理系统
- 技术栈：Node.js + Express + PostgreSQL
- 版本：v2.0.0

# 项目结构
```
src/
├── controllers/  # 控制器
├── models/       # 数据模型
├── routes/       # 路由定义
├── services/     # 业务逻辑
├── utils/        # 工具函数
└── config/       # 配置文件
```

# 编码规范
- 所有数据库操作必须使用事务
- 敏感信息记录日志时必须脱敏
- API 响应统一格式：{ code, message, data }
- 错误处理统一使用 try-catch

# 命名约定
- 数据库表名：snake_case（如 user_profiles）
- 变量和函数：camelCase（如 getUserById）
- 类名：PascalCase（如 UserService）
- 常量：UPPER_SNAKE_CASE（如 MAX_LOGIN_ATTEMPTS）

# 依赖管理
- 使用 npm 管理依赖（不使用 yarn）
- 新增依赖前必须评估必要性
- 定期运行 npm audit 检查安全漏洞

# 测试要求
- 所有 API 端点必须有集成测试
- 核心业务逻辑必须有单元测试
- 测试覆盖率不低于 80%
```

## Memory 优先级

当用户级和项目级 Memory 冲突时：

**项目级 Memory > 用户级 Memory**

例如：
- 用户级设置：缩进 4 空格
- 项目级设置：缩进 2 空格
- **结果**：使用 2 空格（项目级优先）

## 实战案例

### 案例 1：避免 Linux 命令

**问题**：ClaudeCode 总是使用 `ls`、`cat` 等 Linux 命令，在 Windows 上会失败。

**解决**：在用户级 Memory 中添加：

```markdown
# 系统环境
- 操作系统：Windows
- 使用 PowerShell/CMD 命令
- 使用 dir 而不是 ls
- 使用 type 而不是 cat
```

### 案例 2：内网环境优化

**问题**：ClaudeCode 频繁尝试访问互联网，浪费时间。

**解决**：在用户级 Memory 中添加：

```markdown
# 网络环境
- 内网环境，无法访问互联网
- 禁用 web_search 功能
- 禁用 web_fetch 功能
- 不要尝试访问外部资源
```

然后执行：

```bash
/permissions set web_search false
/permissions set web_fetch false
```

### 案例 3：统一项目规范

**问题**：团队成员编码风格不一致。

**解决**：在项目级 Memory 中添加详细的编码规范：

```markdown
# 代码规范
- ESLint 配置：.eslintrc.json
- 提交前必须通过 lint 检查
- 使用 Prettier 格式化代码
- Git 提交信息格式：<type>: <subject>

# 分支策略
- 主分支：main
- 开发分支：develop
- 功能分支：feature/<feature-name>
- 修复分支：fix/<bug-name>

# 代码审查
- 所有代码必须经过 PR 审查
- 至少一人批准才能合并
- 禁止直接推送到 main 分支
```

## 最佳实践

::: tip Memory 编写建议

1. **简洁明确**：使用简短明确的语句
2. **分类组织**：使用标题分类不同类型的信息
3. **优先级高的在前**：重要的规则写在前面
4. **定期更新**：项目规范变化时及时更新
5. **避免冲突**：确保用户级和项目级 Memory 不冲突

:::

::: warning 注意事项

- Memory 文件使用 Markdown 格式
- 避免包含敏感信息（密码、密钥等）
- 不要写过于详细的实现细节
- 保持 Memory 文件大小合理（建议不超过 2KB）

:::

## 常见 Memory 配置

### Python 项目

```markdown
# Python 版本
- Python 3.11

# 代码规范
- 遵循 PEP 8
- 使用 Black 格式化
- 使用类型提示（Type Hints）
- Docstring 使用 Google 风格

# 包管理
- 使用 Poetry 管理依赖
- 虚拟环境：.venv
```

### JavaScript/TypeScript 项目

```markdown
# 运行环境
- Node.js 18 LTS
- 包管理器：npm

# 代码规范
- TypeScript strict 模式
- ESLint + Prettier
- 使用 ES6+ 语法
- 异步操作使用 async/await

# 测试
- 测试框架：Jest
- 覆盖率要求：>80%
```

### Java 项目

```markdown
# Java 版本
- JDK 17

# 构建工具
- Maven 3.9

# 代码规范
- 遵循阿里巴巴 Java 开发手册
- 使用 Lombok 简化代码
- 注释使用 Javadoc 格式

# 架构
- 分层架构：Controller -> Service -> DAO
- 使用 Spring Boot
```

## 调试 Memory

### 验证 Memory 是否生效

```bash
> 请告诉我当前的系统环境和编码规范
```

ClaudeCode 应该会引用你在 Memory 中设置的内容。

### 清除 Memory 缓存

如果修改 Memory 后没有生效：

```bash
# 退出重启
> /exit
claude

# 或使用 compact
> /compact
```

## 下一步

- [命令行操作](/advanced/cli-operations) - 深入使用命令行功能
- [自定义命令](/advanced/custom-commands) - 创建项目专属命令
- [权限管理](/advanced/permissions) - 精细控制 ClaudeCode 权限
