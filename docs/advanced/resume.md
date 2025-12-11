# Resume 功能

Resume 功能允许你恢复之前的 SubAgent 会话，继续未完成的工作或基于之前的成果继续开发。

## Resume 基础

### 什么是 Resume？

Resume 是 ClaudeCode 的会话恢复功能，可以：

- 恢复之前的 SubAgent 及其上下文
- 继续未完成的任务
- 基于之前的分析继续工作
- 在多个阶段间保持连续性

### 为什么需要 Resume？

1. **保持上下文**：Agent 记住所有之前的工作
2. **节省时间**：避免重复分析和搜索
3. **分阶段工作**：长任务可以分多次完成
4. **灵活中断**：随时暂停，稍后恢复

## 获取 Agent ID

当 SubAgent 完成任务后，会返回 Agent ID：

```bash
[Agent 完成探索]

发现：
- 20 个 API 端点
- 5 个数据模型
- 3 个服务层文件

完成。Agent ID: a12b34c
可以使用 'resume a12b34c' 继续这个 agent 的工作
```

## 使用 Resume

### 基本语法

```bash
> resume <agent-id>
```

### 示例

```bash
# 简单恢复
> resume a12b34c

# 恢复并给新任务
> resume a12b34c 并实现 API 端点

# 恢复并继续之前的工作
> resume a12b34c 继续优化剩余文件
```

### 无需明确 resume 关键字

也可以直接引用 Agent：

```bash
> 使用 agent a12b34c 分析数据库查询
> 让 agent a12b34c 继续工作
```

## Resume 工作流程

### 典型流程

```
1. 启动 Agent 执行任务
   ↓
2. Agent 完成并返回 ID
   ↓
3. 记录 Agent ID
   ↓
4. 稍后 Resume Agent
   ↓
5. Agent 基于之前上下文继续工作
```

### 流程示例

```bash
# 阶段 1：探索
> 探索用户认证相关代码

[Explore Agent 启动]
[分析项目，找到 auth/ 目录]
[Agent ID: auth_001]

# 阶段 2：分析（稍后）
> resume auth_001 分析认证流程的安全性

[Agent 恢复，基于之前的发现分析安全性]
[Agent ID: 仍然是 auth_001]

# 阶段 3：改进（更晚）
> resume auth_001 实施安全改进建议

[Agent 基于之前的分析实施改进]
```

## 实战案例

### 案例 1：渐进式项目理解

**场景**：新加入一个大型项目，需要逐步理解

```bash
# 第 1 天：整体概览
> 使用 Explore Agent 了解项目整体结构

[Explore Agent: 分析项目结构]
[Agent ID: explore_001]

# 第 2 天：深入前端
> resume explore_001 深入分析前端架构

[Agent 基于第 1 天的发现，深入前端]

# 第 3 天：深入后端
> resume explore_001 深入分析后端 API

[Agent 继续分析后端]

# 第 4 天：分析数据层
> resume explore_001 分析数据库设计

[Agent 分析数据层]
```

**优势**：
- 每天的分析都基于之前的理解
- 避免重复探索
- 逐步建立完整认知

### 案例 2：大型重构项目

**场景**：将 JavaScript 项目迁移到 TypeScript

```bash
# 第 1 阶段：制定计划
> 制定 JS 到 TS 迁移计划

[Plan Agent: 制定详细计划]
[Agent ID: migrate_plan]

# 第 2 阶段：迁移工具函数
> resume migrate_plan 开始迁移 utils/ 目录

[General Purpose Agent: 迁移 utils/]
[Agent ID: migrate_utils]

# 第 3 阶段：迁移组件
> resume migrate_plan 迁移 components/ 目录

[Agent 基于之前经验迁移组件]

# 第 4 阶段：修复类型错误
> resume migrate_plan 修复所有类型错误

[Agent 处理类型问题]

# 第 5 阶段：验证
> resume migrate_plan 验证迁移完整性

[Agent 全面测试]
```

### 案例 3：性能优化项目

**场景**：系统性能优化

```bash
# 阶段 1：性能分析
> 全面分析系统性能瓶颈

[General Purpose Agent: 性能分析]
发现：
1. 数据库查询慢
2. 前端渲染瓶颈
3. API 响应慢
[Agent ID: perf_001]

# 阶段 2：优化数据库
> resume perf_001 优化数据库查询

[Agent 基于分析优化数据库]
优化了 15 个查询
平均速度提升 60%

# 阶段 3：优化前端
> resume perf_001 优化前端渲染

[Agent 优化前端]
减少重渲染 40%
首屏时间提升 35%

# 阶段 4：优化 API
> resume perf_001 优化 API 响应时间

[Agent 优化 API]
添加缓存
响应时间减少 50%

# 阶段 5：最终报告
> resume perf_001 生成性能优化报告

[Agent 生成对比报告]
整体性能提升 55%
```

### 案例 4：代码质量提升

**场景**：系统性改善代码质量

```bash
# 第 1 步：代码审查
> 审查整个项目的代码质量

[General Purpose Agent: 代码审查]
发现 50 个问题：
- 15 个性能问题
- 20 个可读性问题
- 10 个安全问题
- 5 个架构问题
[Agent ID: quality_001]

# 第 2 步：修复性能问题
> resume quality_001 修复所有性能问题

[Agent 逐个修复]
已修复 15/15 个性能问题

# 第 3 步：改善可读性
> resume quality_001 改善代码可读性

[Agent 重构代码]
已改善 20/20 个可读性问题

# 第 4 步：修复安全问题
> resume quality_001 修复安全问题

[Agent 修复安全漏洞]
已修复 10/10 个安全问题

# 第 5 步：架构改进
> resume quality_001 实施架构改进

[Agent 重构架构]
已完成 5/5 个架构改进

# 第 6 步：验证
> resume quality_001 验证所有修复并生成报告

[Agent 验证并生成报告]
```

## Resume 的高级用法

### 1. 跨 Agent 类型 Resume

```bash
# Explore 后转 Plan
> 探索认证模块
[Explore Agent ID: ex_001]

> resume ex_001 制定重构认证模块的计划
[转为 Plan Agent，保持 Explore 的发现]
```

### 2. 组合多个 Agent

```bash
# Agent 1: 前端分析
> 分析前端架构
[Agent ID: frontend_001]

# Agent 2: 后端分析
> 分析后端架构
[Agent ID: backend_001]

# 组合分析
> 基于 frontend_001 和 backend_001 的发现，提出全栈改进方案
[新 Agent 基于两个 Agent 的结果]
```

### 3. 分支工作流

```bash
# 主线任务
> 重构用户模块
[Agent ID: user_refactor]

# 分支 1：同时处理测试
> resume user_refactor 补充单元测试

# 分支 2：同时更新文档
> resume user_refactor 更新相关文档

# 合并
> resume user_refactor 整合所有更改
```

## Resume 最佳实践

::: tip Resume 使用建议

1. **记录 Agent ID**：重要任务记录 ID 备用
2. **描述性恢复**：Resume 时说明要做什么
3. **分阶段任务**：大任务分成多个 Resume 阶段
4. **定期检查点**：关键节点记录 Agent ID
5. **命名约定**：用注释标记 Agent 用途

:::

::: warning 注意事项

- Agent 上下文有大小限制
- 会话关闭后 Agent ID 可能失效
- 不是所有任务都需要 Resume
- 过度 Resume 可能增加复杂度

:::

## 管理 Agent 历史

### 查看活跃的 Agents

```bash
> 列出当前所有 agent
```

### 命名和组织

为 Agent 任务创建笔记：

```markdown
<!-- agents.md -->
# Project Agent History

## 性能优化项目
- `perf_001`: 初始性能分析 (2025-01-10)
- `perf_db`: 数据库优化 (2025-01-11)
- `perf_frontend`: 前端优化 (2025-01-12)

## 代码重构
- `refactor_auth`: 认证模块重构 (2025-01-15)
- `refactor_api`: API 重构 (2025-01-16)
```

## Resume 故障排查

### Agent ID 无效

**问题**：Resume 时提示 Agent ID 不存在

**可能原因**：
- 会话已关闭
- Agent 超时
- ID 输入错误

**解决**：
- 检查 ID 拼写
- 在同一会话中使用
- 重新启动 Agent

### 上下文丢失

**问题**：Resume 后 Agent 似乎忘记了之前的工作

**可能原因**：
- 上下文窗口已满
- Agent 类型不匹配

**解决**：
- 使用 `/compact` 压缩上下文
- 重新启动新 Agent

### 任务冲突

**问题**：Resume 后的任务与之前的工作冲突

**解决**：
- 明确说明要做什么
- 检查之前 Agent 的输出
- 考虑启动新 Agent

## 常见问题

### Q: Resume 可以跨会话吗？

**A:** 通常不行。Agent ID 在会话内有效，关闭后失效。

### Q: 一个 Agent 可以 Resume 多少次？

**A:** 理论上无限次，但要注意上下文窗口限制。

### Q: Resume 会增加成本吗？

**A:** 会，因为恢复时要加载之前的上下文。

### Q: 如何选择何时 Resume vs 启动新 Agent？

**A:**
- 继续相关工作 → Resume
- 开始新任务 → 新 Agent
- 不确定 → 尝试 Resume，不行再启动新的

## 下一步

- [Git 集成](/advanced/git-integration) - 使用 Agent 处理 Git 工作流
- [需求驱动开发](/advanced/requirement-driven) - Agent 在项目管理中的应用
- [SubAgent 详解](/advanced/subagent) - 深入理解 Agent 机制
