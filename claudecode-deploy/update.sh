#!/bin/bash

##############################################
# ClaudeCode 文档快速更新脚本
# 用途：快速更新已部署的文档网站
# 使用：sudo bash update.sh
##############################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SITE_DIR="/var/www/claude-docs"
ZIP_FILE="/tmp/claude-docs.zip"
BACKUP_DIR="/var/www/claude-docs.backup.$(date +%Y%m%d_%H%M%S)"

# 检测系统类型
if [ -f /etc/redhat-release ]; then
    WEB_USER="nginx"
elif [ -f /etc/lsb-release ]; then
    WEB_USER="www-data"
else
    echo -e "${RED}不支持的操作系统${NC}"
    exit 1
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}   ClaudeCode 文档快速更新${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# 检查是否以 root 运行
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}错误：请使用 sudo 运行此脚本${NC}"
    exit 1
fi

# 检查 zip 文件
if [ ! -f "$ZIP_FILE" ]; then
    echo -e "${RED}错误：未找到 $ZIP_FILE${NC}"
    echo -e "${YELLOW}请先将更新包上传到 /tmp/ 并重命名为 claude-docs.zip${NC}"
    exit 1
fi

# 检查网站目录
if [ ! -d "$SITE_DIR" ]; then
    echo -e "${RED}错误：网站目录不存在: $SITE_DIR${NC}"
    echo -e "${YELLOW}请先执行初始部署（deploy.sh）${NC}"
    exit 1
fi

echo -e "${GREEN}[1/5] 备份当前版本...${NC}"
cp -r $SITE_DIR $BACKUP_DIR
echo -e "${GREEN}✓ 已备份到: $BACKUP_DIR${NC}"
echo ""

echo -e "${GREEN}[2/5] 清空旧文件...${NC}"
rm -rf ${SITE_DIR}/*
echo -e "${GREEN}✓ 旧文件已清空${NC}"
echo ""

echo -e "${GREEN}[3/5] 解压新版本...${NC}"
TEMP_DIR="/tmp/update-temp-$(date +%s)"
mkdir -p $TEMP_DIR
unzip -q $ZIP_FILE -d $TEMP_DIR
cp -r ${TEMP_DIR}/* $SITE_DIR/
echo -e "${GREEN}✓ 新文件已部署${NC}"
echo ""

echo -e "${GREEN}[4/5] 设置权限...${NC}"
chown -R ${WEB_USER}:${WEB_USER} $SITE_DIR
chmod -R 755 $SITE_DIR
echo -e "${GREEN}✓ 权限已设置${NC}"
echo ""

echo -e "${GREEN}[5/5] 重载 Nginx...${NC}"
nginx -s reload
echo -e "${GREEN}✓ Nginx 已重载${NC}"
echo ""

echo -e "${GREEN}[清理] 删除临时文件...${NC}"
rm -rf $TEMP_DIR
rm -f $ZIP_FILE
echo -e "${GREEN}✓ 临时文件已清理${NC}"
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}   更新完成！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "备份位置: ${YELLOW}$BACKUP_DIR${NC}"
echo ""
echo -e "${YELLOW}提示：${NC}"
echo -e "1. 请在浏览器中按 Ctrl+F5 强制刷新查看更新"
echo -e "2. 如需回滚："
echo -e "   sudo rm -rf $SITE_DIR"
echo -e "   sudo cp -r $BACKUP_DIR $SITE_DIR"
echo -e "   sudo nginx -s reload"
echo ""
