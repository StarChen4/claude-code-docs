# 部署指南

完整的 Linux 服务器部署步骤。

## 前提条件

### 开发机（Windows）
- Node.js >= 18.0.0
- 项目已构建成功

### 服务器（Linux）
- CentOS 7+ / Ubuntu 18.04+
- Nginx 已安装
- 具有 sudo 权限

## 部署步骤

### 第一步：在 Windows 上构建

```bash
# 进入项目目录
cd "D:\Work\AI-Extension\claude code\claude-code-docs"

# 构建生产版本
npm run docs:build
```

构建成功后，静态文件位于：`docs\.vitepress\dist\`

### 第二步：打包文件

将 `dist` 目录打包为 zip 文件：

**方法一：使用 Windows 资源管理器**
1. 进入 `docs\.vitepress\` 目录
2. 右键点击 `dist` 文件夹
3. 选择"发送到" → "压缩(zipped)文件夹"
4. 重命名为 `claude-docs.zip`

**方法二：使用 PowerShell**
```powershell
# 在项目根目录执行
Compress-Archive -Path "docs\.vitepress\dist\*" -DestinationPath "claude-docs.zip"
```

### 第三步：上传到 Linux 服务器

**方法一：使用 WinSCP**（推荐）
1. 下载安装 WinSCP
2. 连接到服务器
3. 上传 `claude-docs.zip` 到服务器（如 `/tmp/`）

**方法二：使用 scp 命令**
```bash
# 在 PowerShell 中执行
scp claude-docs.zip user@服务器IP:/tmp/
```

### 第四步：在服务器上解压和部署

SSH 登录到服务器：

```bash
ssh user@服务器IP
```

执行以下命令：

```bash
# 1. 创建网站目录
sudo mkdir -p /var/www/claude-docs

# 2. 解压文件
cd /tmp
unzip claude-docs.zip -d /tmp/claude-docs-temp

# 3. 移动文件到网站目录
sudo cp -r /tmp/claude-docs-temp/* /var/www/claude-docs/

# 4. 设置权限
sudo chown -R nginx:nginx /var/www/claude-docs
sudo chmod -R 755 /var/www/claude-docs

# 5. 清理临时文件
rm -rf /tmp/claude-docs-temp
rm /tmp/claude-docs.zip
```

**注意**：
- CentOS/RHEL 用户：`nginx:nginx`
- Ubuntu/Debian 用户：使用 `www-data:www-data`

### 第五步：配置 Nginx

#### 5.1 创建 Nginx 配置文件

```bash
sudo nano /etc/nginx/conf.d/claude-docs.conf
```

或者（Ubuntu）：

```bash
sudo nano /etc/nginx/sites-available/claude-docs
```

#### 5.2 添加以下配置

```nginx
server {
    listen 80;
    server_name claude.com;  # 修改为你的域名或 IP

    # 网站根目录
    root /var/www/claude-docs;
    index index.html;

    # 字符集
    charset utf-8;

    # 日志
    access_log /var/log/nginx/claude-docs-access.log;
    error_log /var/log/nginx/claude-docs-error.log;

    # SPA 路由支持
    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # 启用 gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript
               application/x-javascript application/xml+rss
               application/json application/javascript;

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

#### 5.3 启用配置（仅 Ubuntu）

```bash
sudo ln -s /etc/nginx/sites-available/claude-docs /etc/nginx/sites-enabled/
```

#### 5.4 测试配置

```bash
sudo nginx -t
```

如果显示 `syntax is okay` 和 `test is successful`，则配置正确。

#### 5.5 重启 Nginx

```bash
# CentOS/RHEL
sudo systemctl restart nginx

# Ubuntu/Debian
sudo systemctl restart nginx

# 或者
sudo nginx -s reload
```

### 第六步：配置域名解析

#### 内网 DNS 服务器方式

在内网 DNS 服务器上添加 A 记录：

```
claude.com    A    <服务器IP>
```

#### Hosts 文件方式（客户端配置）

Windows 客户端修改 hosts 文件：

**文件位置**：`C:\Windows\System32\drivers\etc\hosts`

**添加内容**：
```
<服务器IP>  claude.com
```

**如何编辑**：
1. 以管理员身份运行记事本
2. 打开 `C:\Windows\System32\drivers\etc\hosts`
3. 添加上述内容
4. 保存

### 第七步：验证部署

在 Windows 客户端浏览器中访问：

```
http://claude.com
```

应该能看到文档网站首页。

### 第八步：防火墙配置（如需要）

如果无法访问，可能需要开放 80 端口：

```bash
# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Ubuntu (ufw)
sudo ufw allow 80/tcp
sudo ufw reload

# 或直接使用 iptables
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo service iptables save
```

## 更新部署

当文档有更新时：

### 1. Windows 上重新构建

```bash
npm run docs:build
```

### 2. 打包新版本

```bash
Compress-Archive -Path "docs\.vitepress\dist\*" -DestinationPath "claude-docs-v2.zip" -Force
```

### 3. 上传到服务器

```bash
scp claude-docs-v2.zip user@服务器IP:/tmp/
```

### 4. 服务器上更新

```bash
# 备份旧版本（可选）
sudo cp -r /var/www/claude-docs /var/www/claude-docs.backup

# 清空旧文件
sudo rm -rf /var/www/claude-docs/*

# 解压新版本
cd /tmp
unzip claude-docs-v2.zip -d /tmp/claude-docs-temp

# 复制新文件
sudo cp -r /tmp/claude-docs-temp/* /var/www/claude-docs/

# 设置权限
sudo chown -R nginx:nginx /var/www/claude-docs
sudo chmod -R 755 /var/www/claude-docs

# 清理
rm -rf /tmp/claude-docs-temp
rm /tmp/claude-docs-v2.zip

# 清除 Nginx 缓存（可选）
sudo nginx -s reload
```

### 5. 验证更新

清除浏览器缓存（Ctrl+F5）后访问网站，确认更新成功。

## HTTPS 配置（可选）

如果需要 HTTPS（内网自签名证书）：

### 1. 生成自签名证书

```bash
sudo mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout claude-docs.key \
  -out claude-docs.crt \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=Company/CN=claude.com"
```

### 2. 修改 Nginx 配置

```nginx
server {
    listen 80;
    server_name claude.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name claude.com;

    ssl_certificate /etc/nginx/ssl/claude-docs.crt;
    ssl_certificate_key /etc/nginx/ssl/claude-docs.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/claude-docs;
    index index.html;

    # 其他配置同上...
}
```

### 3. 重启 Nginx

```bash
sudo nginx -t
sudo systemctl restart nginx
```

**注意**：使用自签名证书时，浏览器会显示安全警告，点击"继续访问"即可。

## 故障排查

### 问题 1：403 Forbidden

**原因**：权限问题

**解决**：
```bash
sudo chown -R nginx:nginx /var/www/claude-docs
sudo chmod -R 755 /var/www/claude-docs
```

### 问题 2：404 Not Found

**原因**：路由配置问题

**解决**：确保 Nginx 配置中有：
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

### 问题 3：样式丢失

**原因**：静态资源路径问题

**解决**：检查 `base` 配置，如果不在根路径，需要在 `config.js` 中设置：
```javascript
export default defineConfig({
  base: '/claude-docs/',  // 如果部署在子目录
  // ...
})
```

### 问题 4：无法访问

**原因**：防火墙或 SELinux

**解决**：
```bash
# 检查防火墙
sudo firewall-cmd --list-all

# 临时关闭 SELinux 测试
sudo setenforce 0

# 如果是 SELinux 问题，永久配置：
sudo setsebool -P httpd_read_user_content 1
```

### 问题 5：Nginx 配置测试失败

**查看详细错误**：
```bash
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

## 性能优化

### 1. 启用 HTTP/2

在 Nginx 配置中（需要 HTTPS）：
```nginx
listen 443 ssl http2;
```

### 2. 添加浏览器缓存

已在配置中包含，静态资源缓存 1 年。

### 3. 启用 Brotli 压缩（可选）

需要安装 Nginx Brotli 模块。

## 备份策略

### 定期备份

创建备份脚本 `/root/backup-claude-docs.sh`：

```bash
#!/bin/bash
BACKUP_DIR="/backup/claude-docs"
DATE=$(date +%Y%m%d)

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/claude-docs-$DATE.tar.gz /var/www/claude-docs

# 只保留最近 7 天的备份
find $BACKUP_DIR -name "claude-docs-*.tar.gz" -mtime +7 -delete
```

添加定时任务：
```bash
sudo crontab -e

# 每天凌晨 2 点备份
0 2 * * * /root/backup-claude-docs.sh
```

## 监控

### 查看访问日志

```bash
sudo tail -f /var/log/nginx/claude-docs-access.log
```

### 查看错误日志

```bash
sudo tail -f /var/log/nginx/claude-docs-error.log
```

### 统计访问量

```bash
sudo cat /var/log/nginx/claude-docs-access.log | wc -l
```

## 联系支持

如果遇到问题：
1. 检查日志文件
2. 验证配置文件
3. 测试网络连接
4. 联系运维团队
