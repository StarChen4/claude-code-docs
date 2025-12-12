ClaudeCode 文档离线部署包
========================

版本：v1.0
构建日期：2025-01-11
服务器系统：Linux (CentOS 7+ / Ubuntu 18.04+)
访问域名：claudecode.com

文件清单：
---------
1. claude-docs.zip            - 网站静态文件（已构建完成）
2. deploy.sh                  - 服务器部署脚本（一键部署）
3. update.sh                  - 快速更新脚本（日常更新用）
4. configure-client.bat       - 客户端配置脚本（配置 hosts）
5. DEPLOYMENT.md              - 标准部署文档（详细步骤）
6. OFFLINE-DEPLOYMENT.md      - 离线环境部署文档（必读）
7. PACKAGE-CHECKLIST.md       - 部署检查清单
8. README.txt                 - 本文件

快速部署（第一次）：
-------------------
【服务器端 - Linux】
1. 将整个 claudecode-deploy 文件夹拷贝到服务器
2. 执行以下命令：

   cd ~/claudecode-deploy
   sudo mv claude-docs.zip /tmp/
   sudo bash deploy.sh

3. 等待部署完成（约 1-2 分钟）

【客户端 - Windows】
1. 编辑 configure-client.bat：
   - 打开文件
   - 修改第13行的 SERVER_IP 为实际服务器 IP

2. 分发给各个客户端
3. 以管理员身份运行 configure-client.bat
4. 浏览器访问：http://claudecode.com

日常更新流程：
-------------
1. 在开发机构建新版本并打包为 claude-docs.zip
2. 拷贝到服务器 /tmp/ 目录
3. 执行：sudo bash update.sh
4. 客户端浏览器按 Ctrl+F5 强制刷新

服务器环境要求：
---------------
✅ 必需：
   - Nginx（Web 服务器）
   - unzip（解压工具）
   - bash（Shell）

❌ 不需要：
   - Node.js
   - npm
   - Git
   - 互联网连接

所有内容都是纯静态文件，无需任何额外依赖！

故障排查：
---------
1. 如果部署失败：
   - 检查 Nginx 是否安装：nginx -v
   - 查看错误日志：sudo tail -f /var/log/nginx/error.log

2. 如果客户端无法访问：
   - 检查服务器网络：ping <服务器IP>
   - 检查 hosts 配置：C:\Windows\System32\drivers\etc\hosts
   - 检查防火墙：sudo firewall-cmd --list-all (CentOS)

3. 如果更新后看不到变化：
   - 浏览器强制刷新：Ctrl + F5
   - 清除浏览器缓存

详细说明：
---------
请仔细阅读：
- OFFLINE-DEPLOYMENT.md   - 离线环境完整部署指南
- DEPLOYMENT.md           - 标准部署流程和配置
- PACKAGE-CHECKLIST.md    - 部署前检查清单

重要提示：
---------
✓ 部署前会自动备份旧版本
✓ 可随时回滚到之前的版本
✓ 完全离线环境，安全可靠
✓ 更新操作只需要 5 分钟

✗ 不要在生产环境直接测试
✗ 不要跳过客户端 hosts 配置
✗ 不要在更新时访问网站

技术支持：
---------
如遇问题，请提供：
1. 操作系统版本
2. 错误信息截图
3. 日志文件内容
4. 详细的操作步骤

祝部署顺利！
