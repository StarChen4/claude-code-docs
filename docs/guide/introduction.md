# ClaudeCode 介绍

## 什么是 ClaudeCode？

ClaudeCode 是由 Anthropic 开发的 AI 辅助编程工具，它可以帮助开发者：

- 自动生成代码
- 理解和解释代码
- 重构和优化代码
- 调试和修复问题
- 自动化重复性任务
- 当然，您想编写文档也是不在话下

## 核心特性

### 1. 智能代码生成

ClaudeCode 可以根据自然语言描述生成代码，支持多种编程语言。

### 2. 上下文理解

通过分析项目文件和代码结构，ClaudeCode 能够理解项目上下文，提供更准确的建议。

### 3. 多模式操作

支持不同的工作模式，适应各种开发场景（详见 [模式切换](/guide/modes)）。

### 4. 记忆功能

通过 Memory 功能记住用户偏好和项目规范（详见 [Memory 使用](/advanced/memory)）。

## 使用方式

ClaudeCode 提供三种使用方式：

### CLI 命令行

最基础和核心的使用方式，通过命令行与 ClaudeCode 交互。

```bash
claude
```

### VSCode 插件

在 Visual Studio Code 中集成使用，提供更便捷的编辑器内体验。

### JetBrains 插件

在 IntelliJ IDEA、PyCharm 等 JetBrains 系列 IDE 中使用。

## 基本工作流程

1. **启动 ClaudeCode**：在项目目录下运行 `claude` 命令
2. **描述需求**：用自然语言描述你想要做什么
3. **审查结果**：查看 ClaudeCode 生成的代码或修改
4. **迭代优化**：根据需要继续对话，完善结果

## 示例

### 创建新文件

```
用户: 帮我创建一个 Python 函数，用于计算斐波那契数列
ClaudeCode: [生成代码]
```

### 修复Bug

```
用户: 这个函数有问题，输入负数时会出错
ClaudeCode: [分析并修复代码]
```

### 代码重构

```
用户: 重构这个函数，使其更易读
ClaudeCode: [提供重构建议并执行]
```

## 最佳实践

::: tip 提示
- 清晰描述需求，提供足够的上下文
- 利用 Memory 功能设置项目规范
- 合理使用不同模式
- 定期使用 `/compact` 压缩对话历史
:::

## 下一步

- [模式切换](/guide/modes) - 了解不同的工作模式
- [基本命令](/guide/basic-commands) - 掌握常用命令
- [Memory 使用](/advanced/memory) - 配置个人和项目偏好
