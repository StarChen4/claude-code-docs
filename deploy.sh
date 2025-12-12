#!/bin/bash

##############################################
# ClaudeCode 文档部署脚本
# 用途：在 Linux 服务器上快速部署文档网站
# 使用：sudo bash deploy.sh
##############################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置变量
SITE_NAME="claude-docs"
SITE_DIR="/var/www/claude-docs"
NGINX_CONF_DIR="/etc/nginx/conf.d"
DOMAIN="claude.com"
ZIP_FILE="/tmp/claude-docs.zip"

# 检测系统类型
if [ -f /etc/redhat-release ]; then
    OS_TYPE="centos"
    WEB_USER="nginx"
elif [ -f /etc/lsb-release ]; then
    OS_TYPE="ubuntu"
    WEB_USER="www-data"
    NGINX_CONF_DIR="/etc/nginx/sites-available"
else
    echo -e "${RED}不支持的操作系统${NC}"
    exit 1
fi

echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}   ClaudeCode 文档部署脚本${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""
echo -e "检测到系统类型: ${YELLOW}$OS_TYPE${NC}"
echo -e "Web 用户: ${YELLOW}$WEB_USER${NC}"
echo ""

# 检查是否以 root 运行
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}错误：请使用 sudo 运行此脚本${NC}"
    exit 1
fi

# 检查 zip 文件是否存在
if [ ! -f "$ZIP_FILE" ]; then
    echo -e "${RED}错误：未找到 $ZIP_FILE${NC}"
    echo -e "${YELLOW}请先上传 claude-docs.zip 到 /tmp/ 目录${NC}"
    exit 1
fi

echo -e "${GREEN}[1/7] 检查 Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    echo -e "${RED}错误：Nginx 未安装${NC}"
    echo -e "${YELLOW}请先安装 Nginx${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Nginx 已安装${NC}"
echo ""

echo -e "${GREEN}[2/7] 创建网站目录...${NC}"
mkdir -p $SITE_DIR
echo -e "${GREEN}✓ 目录创建成功: $SITE_DIR${NC}"
echo ""

echo -e "${GREEN}[3/7] 备份旧版本（如果存在）...${NC}"
if [ -d "$SITE_DIR" ] && [ "$(ls -A $SITE_DIR)" ]; then
    BACKUP_DIR="${SITE_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    cp -r $SITE_DIR $BACKUP_DIR
    echo -e "${GREEN}✓ 已备份到: $BACKUP_DIR${NC}"
    rm -rf ${SITE_DIR}/*
else
    echo -e "${YELLOW}  没有旧版本，跳过备份${NC}"
fi
echo ""

echo -e "${GREEN}[4/7] 解压文件...${NC}"
TEMP_DIR="/tmp/claude-docs-temp"
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
unzip -q $ZIP_FILE -d $TEMP_DIR
cp -r ${TEMP_DIR}/* $SITE_DIR/
echo -e "${GREEN}✓ 文件解压完成${NC}"
echo ""

echo -e "${GREEN}[5/7] 设置权限...${NC}"
chown -R ${WEB_USER}:${WEB_USER} $SITE_DIR
chmod -R 755 $SITE_DIR
echo -e "${GREEN}✓ 权限设置完成${NC}"
echo ""

echo -e "${GREEN}[6/7] 配置 Nginx...${NC}"
NGINX_CONF="${NGINX_CONF_DIR}/${SITE_NAME}.conf"

# 创建 Nginx 配置
cat > $NGINX_CONF <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $SITE_DIR;
    index index.html;

    charset utf-8;

    access_log /var/log/nginx/${SITE_NAME}-access.log;
    error_log /var/log/nginx/${SITE_NAME}-error.log;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript
               application/x-javascript application/xml+rss
               application/json application/javascript;

    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
EOF

echo -e "${GREEN}✓ Nginx 配置创建: $NGINX_CONF${NC}"

# Ubuntu 需要创建软链接
if [ "$OS_TYPE" = "ubuntu" ]; then
    ln -sf $NGINX_CONF /etc/nginx/sites-enabled/${SITE_NAME}.conf
    echo -e "${GREEN}✓ 已创建软链接到 sites-enabled${NC}"
fi
echo ""

echo -e "${GREEN}[7/7] 测试并重启 Nginx...${NC}"
if nginx -t; then
    systemctl restart nginx
    echo -e "${GREEN}✓ Nginx 重启成功${NC}"
else
    echo -e "${RED}✗ Nginx 配置测试失败${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}[清理] 删除临时文件...${NC}"
rm -rf $TEMP_DIR
rm -f $ZIP_FILE
echo -e "${GREEN}✓ 临时文件已清理${NC}"
echo ""

echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}   部署完成！${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""
echo -e "访问地址: ${YELLOW}http://$DOMAIN${NC}"
echo ""
echo -e "${YELLOW}提示：${NC}"
echo -e "1. 确保在客户端 hosts 文件中添加了域名映射"
echo -e "2. 如果无法访问，检查防火墙设置"
echo -e "3. 查看日志: sudo tail -f /var/log/nginx/${SITE_NAME}-error.log"
echo ""
