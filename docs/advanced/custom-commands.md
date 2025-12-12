# 自定义命令

通过自定义命令，你可以创建项目专属的快捷命令，封装常用操作，提高团队协作效率。

## 什么是自定义命令？

自定义命令（Custom Commands）允许你在 `.claude/commands/` 目录下创建 Markdown 文件，定义可以通过 `/` 前缀调用的命令。

## 创建自定义命令

### 1. 初始化命令目录

```bash
> /init
```

这会创建 `.claude/commands/` 目录。

### 2. 创建命令文件

在 `.claude/commands/` 目录下创建 Markdown 文件：

```bash
.claude/commands/review.md
```

### 3. 编写命令内容

文件内容就是发送给 ClaudeCode 的提示词：

```markdown
请进行代码审查，关注以下方面：

1. 代码质量和可读性
2. 潜在的 Bug 和错误处理
3. 性能问题
4. 安全漏洞
5. 是否符合项目编码规范

请给出详细的审查报告和改进建议。
```

### 4. 使用命令

```bash
> /review
```

ClaudeCode 会读取 `review.md` 的内容并执行。

## 命令文件命名

- 文件名即命令名（不含 `.md` 后缀）
- 使用小写字母和连字符
- 例如：`code-review.md` → `/code-review`

## 实用命令示例

### 代码审查命令

**文件**：`.claude/commands/review.md`

```markdown
进行全面的代码审查，包括：

## 检查项
1. **代码质量**
   - 是否遵循项目编码规范
   - 命名是否清晰
   - 是否有重复代码

2. **错误处理**
   - 异常处理是否完善
   - 边界情况是否考虑

3. **性能**
   - 是否有性能瓶颈
   - 算法复杂度是否合理

4. **安全性**
   - 是否有安全漏洞
   - 输入验证是否充分

5. **测试**
   - 测试覆盖是否充分
   - 测试用例是否合理

请提供详细的审查报告和改进建议。
```

### 测试命令

**文件**：`.claude/commands/test.md`

```markdown
执行以下测试流程：

1. 运行所有单元测试
2. 检查测试覆盖率
3. 如果测试失败，分析失败原因并修复
4. 确保所有测试通过

最后提供测试报告。
```

### 部署前检查

**文件**：`.claude/commands/pre-deploy.md`

```markdown
执行部署前检查：

1. 运行所有测试
2. 检查代码质量（lint）
3. 检查依赖安全漏洞
4. 构建项目
5. 检查构建输出
6. 生成变更日志

所有检查通过后，提示可以部署。
```

### Git 提交命令

**文件**：`.claude/commands/commit.md`

```markdown
分析当前的 Git 更改，然后：

1. 查看 `git status` 和 `git diff`
2. 根据更改内容生成规范的提交信息
3. 提交信息格式：

   <type>: <subject>

   <body>

   type 可以是：
   - feat: 新功能
   - fix: 修复 Bug
   - docs: 文档更新
   - style: 代码格式
   - refactor: 重构
   - test: 测试
   - chore: 构建/工具变动

4. 执行 git commit

不要自动 push，让用户决定何时推送。
```

### 重构命令

**文件**：`.claude/commands/refactor.md`

```markdown
对指定的代码进行重构，遵循以下原则：

1. **保持功能不变**：重构不改变外部行为
2. **提高可读性**：使代码更易理解
3. **消除重复**：DRY 原则
4. **简化复杂度**：降低圈复杂度
5. **改善命名**：使用清晰的命名
6. **添加注释**：关键逻辑添加中文注释

重构后运行测试确保功能正常。
```

### 文档生成命令

**文件**：`.claude/commands/docs.md`

```markdown
为当前代码生成文档：

1. 分析代码结构
2. 为每个公共函数/类生成文档注释
3. 生成 README.md（如果不存在）
4. 生成 API 文档（如果是 API 项目）
5. 更新变更日志

文档使用中文，格式清晰，包含示例。
```

### 性能优化命令

**文件**：`.claude/commands/optimize.md`

```markdown
分析并优化代码性能：

1. 识别性能瓶颈
2. 分析时间复杂度和空间复杂度
3. 提出优化建议
4. 实施优化（经用户确认）
5. 对比优化前后的性能

优化时保持代码可读性。
```

## 带参数的命令

虽然自定义命令本身不支持参数，但可以在命令中提示用户提供信息：

**文件**：`.claude/commands/create-component.md`

```markdown
创建一个新的 React 组件。

请提供组件名称，然后我将：

1. 创建组件文件（.tsx）
2. 创建样式文件（.module.css）
3. 创建测试文件（.test.tsx）
4. 在 index.ts 中导出
5. 创建基本的组件结构

组件将遵循项目规范：
- 使用 TypeScript
- 使用函数组件和 Hooks
- 包含 PropTypes
- 添加中文注释
```

使用时：

```bash
> /create-component
Claude: 请提供组件名称
> UserProfile
[ClaudeCode 创建组件]
```

## 命令组合

可以在一个命令中组合多个操作：

**文件**：`.claude/commands/feature.md`

```markdown
开发一个完整的功能，按以下流程：

1. **需求分析**：确认功能需求和实现细节
2. **创建分支**：创建 feature 分支
3. **实现功能**：编写代码
4. **编写测试**：添加单元测试
5. **运行测试**：确保测试通过
6. **代码审查**：自我审查代码质量
7. **提交代码**：生成规范的提交信息
8. **准备 PR**：生成 PR 描述

每个步骤完成后请确认是否继续下一步。
```

## 团队协作命令

为团队创建统一的工作流命令：

**文件**：`.claude/commands/pr.md`

```markdown
创建 Pull Request：

1. 检查当前分支不是 main/master
2. 查看所有更改
3. 确保所有测试通过
4. 确保代码符合 lint 规范
5. 生成 PR 标题和描述：
   - 标题格式：[类型] 简短描述
   - 描述包含：
     - 变更内容
     - 测试情况
     - 截图（如果是 UI 更改）
     - 相关 Issue 编号
6. 推送分支到远程
7. 提供 PR 创建命令（不自动执行）

格式遵循团队规范。
```

## 条件逻辑

虽然 Markdown 命令是静态的，但可以用自然语言描述条件：

**文件**：`.claude/commands/fix-build.md`

```markdown
修复构建错误：

1. 运行构建命令
2. 如果构建成功，报告成功并退出
3. 如果构建失败：
   a. 分析错误信息
   b. 定位错误文件
   c. 修复错误
   d. 重新构建
   e. 重复直到构建成功或达到 3 次尝试
4. 如果 3 次尝试后仍失败，提供详细的错误分析和手动修复建议
```

## 项目模板命令

**文件**：`.claude/commands/init-feature.md`

```markdown
初始化新功能模块：

根据项目结构创建：

```
src/features/<功能名>/
├── components/       # 组件
├── hooks/           # 自定义 Hooks
├── services/        # API 服务
├── types/           # TypeScript 类型
├── utils/           # 工具函数
├── index.ts         # 导出
└── README.md        # 功能文档
```

并创建基础的 index.ts 和 README.md。
```

## 最佳实践

::: tip 自定义命令建议

1. **命名清晰**：使用描述性的命令名
2. **文档化**：在命令中解释其用途
3. **步骤明确**：列出清晰的执行步骤
4. **可重用**：设计通用的命令
5. **团队共享**：将命令纳入版本控制

:::

::: warning 注意事项

- 命令文件必须是 Markdown 格式（`.md`）
- 文件名不能包含空格
- 避免过于复杂的命令（应拆分）
- 定期审查和更新命令

:::

## 调试自定义命令

### 查看命令内容

```bash
# Windows
> !type .claude\commands\review.md

# Linux/macOS
> !cat .claude/commands/review.md
```

### 测试命令

```bash
> /review
# 观察 ClaudeCode 的执行过程
# 根据需要调整命令内容
```

### 命令不工作？

1. 检查文件名和路径
2. 确认文件格式是 `.md`
3. 检查文件内容是否有语法错误
4. 重启 ClaudeCode

## 命令示例库

### Python 项目

```markdown
<!-- .claude/commands/test-py.md -->
运行 Python 测试：

1. 激活虚拟环境
2. 运行 pytest
3. 生成覆盖率报告
4. 如果测试失败，分析并修复
```

### Node.js 项目

```markdown
<!-- .claude/commands/audit.md -->
安全审计：

1. 运行 npm audit
2. 分析漏洞
3. 如果有高危漏洞，尝试自动修复
4. 生成安全报告
```

### 前端项目

```markdown
<!-- .claude/commands/build-check.md -->
构建检查：

1. 运行 lint
2. 运行类型检查
3. 运行测试
4. 执行构建
5. 分析构建大小
6. 如果有问题，提供优化建议
```

## 下一步

- [SubAgent 详解](/advanced/subagent) - 使用子任务代理
- [Git 集成](/advanced/git-integration) - Git 工作流命令
- [需求驱动开发](/advanced/requirement-driven) - 项目管理命令
