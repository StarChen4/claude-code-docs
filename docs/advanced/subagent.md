# SubAgent 详解

SubAgent（子代理）是 ClaudeCode 的强大功能，可以生成专门的代理来处理特定类型的任务，提高效率和准确性。

## 什么是 SubAgent？

SubAgent 是 ClaudeCode 生成的专门化代理，每种类型的 SubAgent 都针对特定任务优化：

- **Explore Agent**：探索和理解代码库
- **Plan Agent**：制定实现计划
- **General Purpose Agent**：通用任务处理

## SubAgent 类型

### 1. Explore Agent（探索代理）

**用途**：快速探索和理解代码库

**适用场景**：
- 查找特定功能的实现位置
- 了解项目架构
- 分析代码结构
- 查找使用示例

**自动触发**：
- 当你询问"在哪里..."
- 当你询问"如何实现..."
- 当任务需要先了解代码结构

**示例**：

```bash
> 错误处理是在哪里实现的？
[ClaudeCode 自动启动 Explore Agent]
[Agent 搜索和分析代码库]
[返回详细的发现结果]
```

**手动使用**：

```bash
> 使用 Explore Agent 查找所有 API 端点的定义
```

### 2. Plan Agent（计划代理）

**用途**：制定详细的实现计划

**适用场景**：
- 复杂功能开发
- 大规模重构
- 架构设计
- 多步骤任务

**自动触发**：
- 计划模式下自动使用
- 复杂任务需要规划时

**示例**：

```bash
> 重构整个认证系统
[ClaudeCode 进入计划模式]
[Plan Agent 制定详细计划]
[展示计划供审查]
```

### 3. General Purpose Agent（通用代理）

**用途**：处理各种通用任务

**适用场景**：
- 多步骤复杂任务
- 需要多次迭代的任务
- 需要自主决策的任务

**示例**：

```bash
> 搜索并修复所有的 TODO 注释
[General Purpose Agent 自主搜索和处理]
```

## SubAgent 工作流程

### 典型流程

1. **任务分析**：ClaudeCode 分析任务复杂度
2. **选择 Agent**：选择合适的 SubAgent 类型
3. **启动 Agent**：启动 SubAgent 并传递任务
4. **自主执行**：Agent 自主完成任务
5. **返回结果**：将结果返回给主会话

### 流程示例

```bash
用户: 在项目中查找所有数据库查询并优化它们

ClaudeCode:
[分析任务：需要搜索和多步骤处理]
[启动 General Purpose Agent]

Agent 工作中...
1. 搜索所有数据库查询代码
2. 分析每个查询的性能
3. 识别优化机会
4. 实施优化
5. 验证优化效果

[完成]返回优化报告
```

## Resume 功能

**Resume** 允许你恢复之前的 SubAgent 会话，继续未完成的工作。

### 基本用法

当 SubAgent 完成任务后，会返回一个 Agent ID：

```bash
Agent 完成任务
Agent ID: a123456

可以使用 resume 功能继续这个 agent 的工作
```

### 恢复 Agent

```bash
> resume a123456
```

或者

```bash
> 使用 agent a123456 继续优化其他文件
```

### Resume 的优势

1. **保持上下文**：Agent 记住之前的所有工作
2. **节省时间**：不需要重新分析
3. **持续改进**：基于之前的工作继续优化
4. **灵活中断**：可以随时暂停和恢复

### Resume 示例

```bash
# 第一次会话
> 分析项目的性能瓶颈
[Explore Agent 启动]
[分析完成，返回 Agent ID: a789012]

# 稍后恢复
> resume a789012 并实施性能优化建议
[Agent 恢复上下文]
[继续工作]
```

## 并行 Agent

可以同时运行多个 Agent 处理不同任务：

### 并行启动

```bash
> 同时：
> 1. 探索数据库访问代码
> 2. 探索 API 端点定义
> 3. 探索测试覆盖情况

[ClaudeCode 启动 3 个 Explore Agent 并行执行]
```

### 并行场景

- 独立任务可以并行
- 加快整体完成时间
- 每个 Agent 返回独立结果

### 示例

```bash
> 并行任务：
> - Agent 1: 审查 frontend 代码质量
> - Agent 2: 审查 backend 代码质量
> - Agent 3: 审查测试代码

[3 个 Agent 并行工作]
[所有完成后汇总结果]
```

## 实战案例

### 案例 1：理解新项目

```bash
# 步骤 1：整体探索
> 使用 Explore Agent 了解这个项目的整体结构

[Explore Agent 工作]
[返回项目结构分析，Agent ID: a111111]

# 步骤 2：深入特定模块
> resume a111111 并深入分析用户认证模块

[Agent 基于之前的理解深入分析]
[返回详细的认证模块分析]
```

### 案例 2：大型重构

```bash
# 步骤 1：制定计划
> 将项目从 JavaScript 迁移到 TypeScript，请先制定计划

[进入计划模式，Plan Agent 启动]
[返回详细计划，Agent ID: a222222]

# 步骤 2：开始执行
> 批准计划，开始执行

[General Purpose Agent 启动执行]
[Agent ID: a333333]

# 步骤 3：如果中断，恢复继续
> resume a333333 继续迁移剩余文件

[恢复并继续工作]
```

### 案例 3：代码库清理

```bash
# 查找问题
> 使用 Explore Agent 查找所有 deprecated 的代码

[Explore Agent: 找到 25 处 deprecated 代码]
[Agent ID: a444444]

# 清理问题
> resume a444444 并移除所有找到的 deprecated 代码

[Agent 基于搜索结果逐个清理]
```

### 案例 4：性能优化项目

```bash
# 第一阶段：分析
> 全面分析项目性能瓶颈

[General Purpose Agent 分析]
[Agent ID: a555555]

# 第二阶段：优化数据库
> resume a555555 优化数据库查询

[Agent 优化数据库]

# 第三阶段：优化前端
> resume a555555 优化前端渲染

[Agent 优化前端]

# 第四阶段：验证
> resume a555555 验证所有优化效果

[Agent 生成性能对比报告]
```

## SubAgent 最佳实践

::: tip Agent 使用建议

1. **明确任务范围**：清晰描述要 Agent 做什么
2. **选择合适的 Agent 类型**：根据任务选择 Explore/Plan/General
3. **善用 Resume**：对于多阶段任务，利用 Resume 保持上下文
4. **并行处理独立任务**：提高效率
5. **记录 Agent ID**：重要任务记下 ID 以便后续恢复

:::

::: warning 注意事项

- Agent 会消耗额外的 tokens
- 不是所有任务都需要 Agent
- 简单任务直接处理更快
- Resume 的上下文有时间限制

:::

## Agent 对比

| 特性 | Explore Agent | Plan Agent | General Purpose |
|------|---------------|------------|-----------------|
| 主要用途 | 代码探索 | 制定计划 | 通用任务 |
| 速度 | 快 | 中 | 慢 |
| 适合任务 | 搜索、分析 | 规划、设计 | 复杂执行 |
| 可 Resume | ✅ | ✅ | ✅ |
| 自主性 | 中 | 低 | 高 |

## 何时使用 SubAgent

### 应该使用

- ✅ 需要深入探索代码库
- ✅ 复杂的多步骤任务
- ✅ 需要制定详细计划
- ✅ 大规模重构或迁移
- ✅ 需要自主决策的任务

### 不必使用

- ❌ 简单的单文件修改
- ❌ 明确的小任务
- ❌ 快速问答
- ❌ 已知具体位置的修改

## 常见问题

### Q: 如何知道使用了哪个 Agent？

**A:** ClaudeCode 会显示 Agent 启动信息：

```bash
[启动 Explore Agent]
正在探索代码库...
```

### Q: Agent ID 在哪里找？

**A:** Agent 完成后会显示：

```bash
任务完成
Agent ID: a123456 (用于 resume)
```

### Q: Resume 的上下文保留多久？

**A:** 通常保留到会话结束，具体取决于上下文窗口大小。

### Q: 可以中断 Agent 吗？

**A:** 可以，使用 Ctrl+C 中断，之后可以 Resume。

### Q: Agent 失败了怎么办？

**A:** Resume Agent 并描述问题，或重新启动新的 Agent。

## 下一步

- [Resume 功能](/advanced/resume) - 深入 Resume 机制
- [Git 集成](/advanced/git-integration) - 使用 Agent 处理 Git 任务
- [需求驱动开发](/advanced/requirement-driven) - Agent 在项目管理中的应用
