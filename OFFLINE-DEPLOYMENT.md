# 离线环境部署指南

适用于完全离线（无互联网）的内网环境。

## 部署架构

```
[开发机 Windows - 有网]
    ↓ 构建 + 打包
[U盘/移动硬盘]
    ↓ 拷贝
[服务器 Linux - 离线]
    ↓ 部署
[客户端 Windows - 离线] → 浏览器访问 claudecode.com
```

## 第一次部署（完整部署）

### 阶段 1：开发机准备（有网环境）

#### 1.1 构建项目

```powershell
# 在项目目录执行
.\build-and-pack.ps1
```

这会生成：`claude-docs-YYYYMMDD_HHMMSS.zip`

#### 1.2 准备部署包

创建一个文件夹，命名为 `claudecode-deploy`，包含以下文件：

```
claudecode-deploy/
├── claude-docs-YYYYMMDD_HHMMSS.zip   # 构建产物
├── deploy.sh                          # 部署脚本
├── DEPLOYMENT.md                      # 部署文档
└── README.txt                         # 说明文件
```

创建 `README.txt`：

```
ClaudeCode 文档部署包
===================

部署步骤：
1. 将此文件夹拷贝到 Linux 服务器
2. 将 zip 文件重命名为 claude-docs.zip
3. 将 zip 文件移动到 /tmp/ 目录
4. 执行：sudo bash deploy.sh

详细说明请参考 DEPLOYMENT.md
```

#### 1.3 打包到 U盘

将整个 `claudecode-deploy` 文件夹拷贝到 U盘。

### 阶段 2：服务器部署（离线环境）

#### 2.1 拷贝文件

```bash
# 插入 U盘，假设挂载点为 /mnt/usb
# 拷贝部署包到服务器
cp -r /mnt/usb/claudecode-deploy ~/

cd ~/claudecode-deploy
```

#### 2.2 准备文件

```bash
# 重命名 zip 文件为标准名称
mv claude-docs-*.zip claude-docs.zip

# 移动到 /tmp/
sudo mv claude-docs.zip /tmp/

# 复制部署脚本
sudo cp deploy.sh /tmp/
```

#### 2.3 执行部署

```bash
cd /tmp
sudo bash deploy.sh
```

部署脚本会自动：
- ✅ 创建网站目录 `/var/www/claude-docs`
- ✅ 解压文件
- ✅ 配置 Nginx
- ✅ 设置权限
- ✅ 启动服务

#### 2.4 验证部署

```bash
# 检查 Nginx 状态
sudo systemctl status nginx

# 检查文件是否存在
ls -la /var/www/claude-docs/

# 查看日志
sudo tail -f /var/log/nginx/claude-docs-access.log
```

### 阶段 3：客户端配置（离线环境）

#### 3.1 配置 hosts 文件

**每台 Windows 客户端都需要配置**

```
1. 以管理员身份运行记事本
2. 打开：C:\Windows\System32\drivers\etc\hosts
3. 添加：<服务器IP>  claudecode.com
4. 保存
```

#### 3.2 测试访问

打开浏览器访问：`http://claudecode.com`

应该能看到文档网站首页。

## 日常更新流程（推荐）

### 方案一：只更新内容文件（最快）

**适用场景**：只修改文档内容，不改配置

#### 开发机操作

```powershell
# 1. 修改 docs/ 下的 markdown 文件

# 2. 构建
npm run docs:build

# 3. 只打包必要的文件
Compress-Archive -Path "docs\.vitepress\dist\*" -DestinationPath "update-YYYYMMDD.zip" -Force

# 4. 拷贝到 U盘
```

#### 服务器操作

```bash
# 1. 拷贝更新包到服务器
cp /mnt/usb/update-YYYYMMDD.zip /tmp/

# 2. 备份当前版本（可选但推荐）
sudo cp -r /var/www/claude-docs /var/www/claude-docs.backup.$(date +%Y%m%d)

# 3. 清空旧文件
sudo rm -rf /var/www/claude-docs/*

# 4. 解压新文件
cd /tmp
unzip update-YYYYMMDD.zip -d /tmp/temp-update
sudo cp -r /tmp/temp-update/* /var/www/claude-docs/

# 5. 设置权限
sudo chown -R nginx:nginx /var/www/claude-docs    # CentOS
# sudo chown -R www-data:www-data /var/www/claude-docs  # Ubuntu
sudo chmod -R 755 /var/www/claude-docs

# 6. 清理
rm -rf /tmp/temp-update
rm /tmp/update-YYYYMMDD.zip

# 7. 刷新 Nginx（可选）
sudo nginx -s reload
```

**更新时间**：< 5 分钟

### 方案二：使用快速更新脚本（更简单）

我来创建一个专门的更新脚本。

#### 开发机操作

使用 `build-and-pack.ps1` 构建并打包。

#### 服务器操作

使用专门的更新脚本（见下文）。

## 更新频率建议

根据更新内容选择方案：

| 更新类型 | 推荐方案 | 频率 |
|---------|---------|------|
| 小改动（修正错别字） | 方案一 | 随时 |
| 中等更新（添加章节） | 方案一 | 每周 |
| 大更新（结构调整） | 完整部署 | 每月 |

## 版本管理建议

### 1. 在开发机上使用 Git

```bash
# 初始化 Git 仓库
git init
git add .
git commit -m "初始版本"

# 每次更新前提交
git add .
git commit -m "更新：添加 XXX 章节"

# 可以随时回滚
git log
git checkout <commit-id>
```

### 2. 服务器上保留版本

```bash
# 每次更新前备份
sudo cp -r /var/www/claude-docs /backup/claude-docs-$(date +%Y%m%d)

# 定期清理旧备份（保留最近 7 天）
find /backup -name "claude-docs-*" -mtime +7 -exec rm -rf {} \;
```

## 常见问题

### Q1: 更新后客户端看不到新内容？

**A:** 清除浏览器缓存

```
方法一：Ctrl + F5（强制刷新）
方法二：Ctrl + Shift + Delete（清除缓存）
```

### Q2: 更新过程中网站会中断吗？

**A:** 会有短暂中断（几秒钟）。建议在非工作时间更新。

### Q3: 可以同时保留多个版本吗？

**A:** 可以，使用不同的目录：

```bash
/var/www/claude-docs-v1/
/var/www/claude-docs-v2/
/var/www/claude-docs-latest/
```

配置不同的域名或端口访问。

### Q4: 如何回滚到之前的版本？

**A:**
```bash
# 如果有备份
sudo rm -rf /var/www/claude-docs
sudo cp -r /var/www/claude-docs.backup.20250111 /var/www/claude-docs
sudo nginx -s reload
```

## 离线环境特殊说明

### 1. 无需互联网

- ✅ 所有资源都在本地
- ✅ 无外部依赖
- ✅ 字体、图标都已内置
- ✅ 搜索功能离线可用

### 2. 性能优化

构建时已启用：
- ✅ 代码分割
- ✅ 资源压缩
- ✅ 缓存优化

### 3. 安全性

- ✅ 纯静态文件，无安全风险
- ✅ 不执行任何外部脚本
- ✅ 不收集用户数据

## 批量客户端配置

如果有大量 Windows 客户端需要配置 hosts：

### 方法一：脚本配置（推荐）

创建 `configure-client.bat`：

```batch
@echo off
echo 配置 ClaudeCode 文档访问...

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 错误：需要管理员权限
    echo 请右键点击此文件，选择"以管理员身份运行"
    pause
    exit /b 1
)

:: 设置服务器 IP（请修改为实际 IP）
set SERVER_IP=192.168.1.100

:: 检查是否已配置
findstr /C:"%SERVER_IP%  claudecode.com" C:\Windows\System32\drivers\etc\hosts >nul
if %errorLevel% equ 0 (
    echo 已经配置过，跳过
) else (
    echo %SERVER_IP%  claudecode.com >> C:\Windows\System32\drivers\etc\hosts
    echo 配置完成！
)

echo.
echo 请在浏览器中访问：http://claudecode.com
pause
```

分发此脚本到各客户端，以管理员身份运行即可。

### 方法二：组策略（域环境）

如果是域环境，可以通过组策略统一配置。

## 故障处理

### 服务器无法启动

```bash
# 查看 Nginx 错误
sudo nginx -t
sudo tail -f /var/log/nginx/error.log

# 检查端口占用
sudo netstat -tulpn | grep :80

# 重启 Nginx
sudo systemctl restart nginx
```

### 文件权限问题

```bash
# 重新设置权限
sudo chown -R nginx:nginx /var/www/claude-docs
sudo chmod -R 755 /var/www/claude-docs
```

### 磁盘空间不足

```bash
# 查看磁盘使用
df -h

# 清理旧备份
sudo rm -rf /var/www/claude-docs.backup.*

# 清理临时文件
sudo rm -rf /tmp/claude-docs-*
```

## 联系支持

遇到问题时提供以下信息：
1. 服务器操作系统版本
2. Nginx 版本
3. 错误日志内容
4. 部署步骤记录
