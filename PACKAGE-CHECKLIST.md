# 离线部署包准备清单

## 📦 第一次部署包内容

### 必需文件

```
claudecode-deploy/
├── claude-docs-YYYYMMDD_HHMMSS.zip    ✅ 网站文件
├── deploy.sh                          ✅ 服务器部署脚本
├── DEPLOYMENT.md                      ✅ 标准部署文档
├── OFFLINE-DEPLOYMENT.md              ✅ 离线部署文档
└── README.txt                         ✅ 快速说明
```

### 可选文件

```
├── update.sh                          ⭐ 快速更新脚本
├── configure-client.bat               ⭐ 客户端配置脚本
└── backup/
    └── nginx.conf.sample              📄 Nginx 配置示例
```

## 📋 准备步骤

### Step 1: 构建网站

```powershell
# 在项目目录执行
.\build-and-pack.ps1

# 或手动执行
npm run docs:build
Compress-Archive -Path "docs\.vitepress\dist\*" -DestinationPath "claude-docs-$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
```

生成文件：`claude-docs-YYYYMMDD_HHMMSS.zip`

### Step 2: 准备部署包文件夹

```powershell
# 创建部署包目录
New-Item -ItemType Directory -Path "claudecode-deploy"

# 复制必需文件
Copy-Item "claude-docs-*.zip" -Destination "claudecode-deploy/"
Copy-Item "deploy.sh" -Destination "claudecode-deploy/"
Copy-Item "update.sh" -Destination "claudecode-deploy/"
Copy-Item "DEPLOYMENT.md" -Destination "claudecode-deploy/"
Copy-Item "OFFLINE-DEPLOYMENT.md" -Destination "claudecode-deploy/"
Copy-Item "configure-client.bat" -Destination "claudecode-deploy/"
```

### Step 3: 创建 README.txt

```powershell
# 在 claudecode-deploy/ 目录下创建
@"
ClaudeCode 文档离线部署包
========================

版本：v1.0
构建日期：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
服务器系统：Linux (CentOS 7+ / Ubuntu 18.04+)
访问域名：claudecode.com

文件清单：
---------
1. claude-docs-*.zip          - 网站静态文件
2. deploy.sh                  - 服务器部署脚本
3. update.sh                  - 快速更新脚本
4. configure-client.bat       - 客户端配置脚本
5. DEPLOYMENT.md              - 标准部署文档
6. OFFLINE-DEPLOYMENT.md      - 离线环境部署文档
7. README.txt                 - 本文件

快速部署：
---------
【服务器端】
1. 将此文件夹拷贝到服务器
2. 将 zip 文件重命名为：claude-docs.zip
3. 移动 zip 到 /tmp/：sudo mv claude-docs.zip /tmp/
4. 执行部署：sudo bash deploy.sh

【客户端】
1. 修改 configure-client.bat 中的 SERVER_IP（第13行）
2. 分发给各客户端
3. 以管理员身份运行
4. 浏览器访问：http://claudecode.com

日常更新：
---------
1. 构建新版本并拷贝到服务器 /tmp/claude-docs.zip
2. 执行：sudo bash update.sh

详细说明：
---------
请参考 OFFLINE-DEPLOYMENT.md

注意事项：
---------
- 服务器需要已安装 Nginx
- 客户端需要配置 hosts 文件
- 完全离线环境，无需互联网
- 更新后客户端需清除浏览器缓存（Ctrl+F5）

技术支持：
---------
[您的联系方式]
"@ | Out-File -FilePath "claudecode-deploy\README.txt" -Encoding UTF8
```

### Step 4: 准备客户端配置脚本

```powershell
# 编辑 configure-client.bat 中的 SERVER_IP
# 将第13行的 IP 改为实际服务器 IP：
# set SERVER_IP=192.168.1.100
```

### Step 5: 验证文件

```powershell
# 列出所有文件
Get-ChildItem -Path "claudecode-deploy" -Recurse

# 应该看到所有必需文件
```

### Step 6: 拷贝到 U盘

```powershell
# 假设 U盘盘符为 E:
Copy-Item -Path "claudecode-deploy" -Destination "E:\" -Recurse

# 验证拷贝成功
Get-ChildItem -Path "E:\claudecode-deploy"
```

## 🔄 日常更新包内容

### 更新包（最小化）

```
claudecode-update/
├── claude-docs-YYYYMMDD.zip           ✅ 更新文件
├── update.sh                          ✅ 更新脚本
└── UPDATE-README.txt                  ✅ 更新说明
```

### 准备更新包

```powershell
# 1. 构建新版本
npm run docs:build
Compress-Archive -Path "docs\.vitepress\dist\*" -DestinationPath "claude-docs-$(Get-Date -Format 'yyyyMMdd').zip" -Force

# 2. 创建更新包文件夹
New-Item -ItemType Directory -Path "claudecode-update"

# 3. 复制文件
Copy-Item "claude-docs-*.zip" -Destination "claudecode-update/"
Copy-Item "update.sh" -Destination "claudecode-update/"

# 4. 创建更新说明
@"
ClaudeCode 文档更新包
====================

版本：v1.x
更新日期：$(Get-Date -Format 'yyyy-MM-dd')

更新内容：
---------
[在此列出本次更新的内容]
- 修复：XXX
- 新增：XXX
- 优化：XXX

更新步骤：
---------
1. 将此文件夹拷贝到服务器
2. 将 zip 文件重命名为：claude-docs.zip
3. 移动到 /tmp/：sudo mv claude-docs.zip /tmp/
4. 执行更新：sudo bash update.sh

注意事项：
---------
- 更新前会自动备份当前版本
- 更新后客户端需清除浏览器缓存（Ctrl+F5）
- 如有问题可回滚到备份版本
"@ | Out-File -FilePath "claudecode-update\UPDATE-README.txt" -Encoding UTF8

# 5. 拷贝到 U盘
Copy-Item -Path "claudecode-update" -Destination "E:\" -Recurse
```

## ✅ 部署前检查清单

### 开发机检查

- [ ] Node.js 版本 >= 18.0.0
- [ ] 项目依赖已安装（node_modules 存在）
- [ ] 构建成功（docs/.vitepress/dist/ 存在）
- [ ] zip 文件已生成且完整
- [ ] 所有部署脚本已准备
- [ ] README.txt 已创建
- [ ] configure-client.bat 中的 IP 已修改

### U盘检查

- [ ] 文件夹结构正确
- [ ] 文件完整无损
- [ ] README.txt 可读
- [ ] 总大小合适（通常 < 20MB）

### 服务器环境检查

- [ ] Nginx 已安装
- [ ] 具有 sudo 权限
- [ ] 磁盘空间充足（> 100MB）
- [ ] 80 端口未被占用

### 客户端环境检查

- [ ] Windows 7/10/11
- [ ] 有管理员权限
- [ ] 可访问服务器网络
- [ ] 浏览器已安装（Chrome/Edge/Firefox）

## 📊 文件大小参考

| 文件 | 大小 | 说明 |
|------|------|------|
| claude-docs-*.zip | ~10-15 MB | 网站文件 |
| deploy.sh | ~3 KB | 部署脚本 |
| update.sh | ~2 KB | 更新脚本 |
| DEPLOYMENT.md | ~20 KB | 文档 |
| OFFLINE-DEPLOYMENT.md | ~15 KB | 文档 |
| configure-client.bat | ~2 KB | 配置脚本 |
| **总计** | **~15-20 MB** | 完整包 |

## 🎯 快速参考命令

### Windows PowerShell

```powershell
# 一键准备部署包
.\build-and-pack.ps1

# 查看文件列表
Get-ChildItem -Recurse

# 计算总大小
(Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
```

### Linux Bash

```bash
# 查看文件
ls -lh

# 解压
unzip claude-docs.zip -d /tmp/test

# 部署
sudo bash deploy.sh

# 更新
sudo bash update.sh
```

## 💡 提示

1. **备份重要**：每次更新前服务器会自动备份
2. **测试先行**：在测试环境先部署一次
3. **文档同步**：确保部署文档与实际操作一致
4. **版本记录**：记录每次部署的版本和日期
5. **客户端配置**：准备批量配置脚本减少工作量

## 📞 支持

遇到问题时记录：
1. 操作系统版本
2. 错误信息截图
3. 日志文件内容
4. 操作步骤记录
