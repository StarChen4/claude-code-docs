# 命令行操作

深入了解 ClaudeCode 的命令行功能，掌握高效的终端操作技巧。

## 使用 `!` 执行系统命令

在 ClaudeCode 对话中，使用 `!` 前缀可以直接执行系统命令。

### 基本用法

```bash
!<命令>
```

### 常用示例

#### 文件和目录操作

```bash
# Windows
> !dir                    # 列出当前目录
> !dir /s *.js           # 递归查找 JS 文件
> !type package.json     # 查看文件内容
> !mkdir src             # 创建目录
> !cd src && dir         # 切换目录并列出内容

# Linux/macOS
> !ls -la                # 列出详细信息
> !find . -name "*.js"   # 查找 JS 文件
> !cat package.json      # 查看文件内容
> !mkdir -p src/utils    # 创建多层目录
```

#### Git 操作

```bash
# 查看状态
> !git status

# 查看差异
> !git diff

# 查看提交历史
> !git log --oneline -5

# 查看分支
> !git branch

# 查看远程仓库
> !git remote -v
```

#### npm/yarn 操作

```bash
# 安装依赖
> !npm install

# 运行脚本
> !npm run dev
> !npm test

# 查看已安装的包
> !npm list --depth=0

# 检查更新
> !npm outdated
```

#### 其他常用命令

```bash
# 查看 Node.js 版本
> !node --version

# 查看 Python 版本
> !python --version

# 查看环境变量
> !echo %PATH%           # Windows
> !echo $PATH            # Linux/macOS

# 查找进程
> !tasklist | findstr node    # Windows
> !ps aux | grep node         # Linux/macOS
```

## 命令输出集成

ClaudeCode 会自动读取命令输出，并将其纳入上下文。

### 示例工作流

```bash
# 1. 查看测试失败情况
> !npm test

# 2. ClaudeCode 分析输出
> 根据测试输出修复失败的测试用例

# 3. 验证修复
> !npm test
```

### 组合命令

```bash
# Windows
> !dir src && type src\index.js

# Linux/macOS
> !ls src && cat src/index.js
```

## 最佳实践

### 1. 善用命令输出

让 ClaudeCode 分析命令输出：

```bash
> !npm run build
> 分析构建错误并修复
```

### 2. 检查前置条件

在执行任务前，先检查状态：

```bash
> !git status
> 基于当前 Git 状态，帮我创建一个新功能分支并实现登录功能
```

### 3. 验证修改结果

修改代码后，立即验证：

```bash
> 修复 Bug
[ClaudeCode 修复代码]
> !npm test
> 运行成功！
```

## 跨平台兼容

### Windows vs Linux/macOS

| 操作 | Windows | Linux/macOS |
|------|---------|-------------|
| 列出文件 | `dir` | `ls` |
| 查看文件 | `type` | `cat` |
| 查找文件 | `dir /s` | `find` |
| 环境变量 | `%VAR%` | `$VAR` |
| 路径分隔符 | `\` | `/` |
| 删除文件 | `del` | `rm` |
| 复制文件 | `copy` | `cp` |
| 移动文件 | `move` | `mv` |

### 配置 Memory 避免跨平台问题

在用户级 Memory 中指定系统：

```markdown
# 系统环境
- 操作系统：Windows 11
- Shell：PowerShell
- 使用 Windows 命令而不是 Linux 命令
```

## 常见使用场景

### 场景 1：调试错误

```bash
# 1. 运行程序看错误
> !npm start

# 2. 分析错误
> 根据错误信息修复代码

# 3. 再次运行验证
> !npm start
```

### 场景 2：Git 工作流

```bash
# 1. 查看当前状态
> !git status

# 2. 请求协助
> 帮我提交这些更改，提交信息为 "添加用户认证功能"

# 3. ClaudeCode 执行
[自动执行 git add, git commit]

# 4. 验证
> !git log -1
```

### 场景 3：依赖管理

```bash
# 1. 检查过时的包
> !npm outdated

# 2. 请求更新
> 更新这些过时的包，注意向后兼容性

# 3. ClaudeCode 更新 package.json 和执行安装
```

### 场景 4：项目初始化

```bash
# 1. 创建项目结构
> 创建一个 Express 项目结构

# 2. 验证创建结果
> !tree /F        # Windows
> !tree           # Linux/macOS

# 3. 初始化 Git
> !git init

# 4. 安装依赖
> !npm install
```

## 限制和注意事项

::: warning 命令执行限制

1. **交互式命令不支持**：不能使用需要用户输入的命令（如 `git rebase -i`）
2. **长时间运行**：超时命令会被中断
3. **权限限制**：受系统用户权限限制
4. **环境变量**：使用当前 Shell 的环境变量

:::

### 不支持的命令示例

```bash
# ❌ 交互式命令
> !vim file.txt           # 需要交互
> !git rebase -i HEAD~3   # 需要交互
> !npm init               # 需要交互

# ✅ 替代方案
> 请帮我编辑 file.txt
> 请帮我交互式变基最近 3 个提交
> 使用默认值创建 package.json
```

## 高级技巧

### 1. 条件执行

```bash
# Windows
> !npm test && npm run build

# Linux/macOS
> !npm test && npm run build
```

### 2. 输出重定向

```bash
# 保存输出到文件
> !npm list > dependencies.txt

# 追加输出
> !git log >> history.txt
```

### 3. 管道操作

```bash
# Windows
> !dir | findstr ".js"

# Linux/macOS
> !ls -la | grep ".js"
```

### 4. 环境变量设置

```bash
# Windows
> !set NODE_ENV=production && npm run build

# Linux/macOS
> !NODE_ENV=production npm run build
```

## 与 ClaudeCode 功能结合

### 自动化工作流

```bash
> !git status
> 分析当前更改，自动提交并创建 PR
```

ClaudeCode 会：
1. 读取 `git status` 输出
2. 分析更改的文件
3. 执行 `git add`
4. 生成合适的提交信息
5. 执行 `git commit`
6. 创建 Pull Request

### 智能错误处理

```bash
> !npm run build
> 根据构建错误自动修复代码
```

ClaudeCode 会：
1. 读取构建错误输出
2. 定位错误文件和行号
3. 分析错误原因
4. 修复代码
5. 重新运行构建验证

## 下一步

- [权限管理](/advanced/permissions) - 控制命令执行权限
- [自定义命令](/advanced/custom-commands) - 封装常用命令组合
- [Git 集成](/advanced/git-integration) - 深度 Git 工作流
