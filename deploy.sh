#!/bin/bash
# 快速部署脚本
# 使用方法: ./deploy.sh

# 配置项 - 请修改为你的服务器信息
SERVER_USER="root"
SERVER_IP="your-server-ip"
SERVER_PATH="/var/www/particle-heart"
SSH_PORT="22"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== WebAR粒子系统部署脚本 ===${NC}\n"

# 检查服务器连接
echo -e "${YELLOW}正在检查服务器连接...${NC}"
if ! ssh -p ${SSH_PORT} -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_IP} "echo '连接成功'" 2>/dev/null; then
    echo -e "${RED}错误: 无法连接到服务器，请检查:${NC}"
    echo "1. 服务器IP地址是否正确"
    echo "2. SSH端口是否正确"
    echo "3. 是否已配置SSH密钥或密码"
    exit 1
fi

echo -e "${GREEN}服务器连接成功！${NC}\n"

# 创建服务器目录
echo -e "${YELLOW}创建服务器目录...${NC}"
ssh -p ${SSH_PORT} ${SERVER_USER}@${SERVER_IP} "mkdir -p ${SERVER_PATH} && chmod 755 ${SERVER_PATH}"

# 上传文件
echo -e "${YELLOW}上传文件到服务器...${NC}"
rsync -avz --progress -e "ssh -p ${SSH_PORT}" \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'deploy.sh' \
    --exclude 'DEPLOY.md' \
    ./ ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}文件上传成功！${NC}\n"
else
    echo -e "${RED}文件上传失败！${NC}"
    exit 1
fi

# 检查Nginx是否安装
echo -e "${YELLOW}检查Nginx配置...${NC}"
if ssh -p ${SSH_PORT} ${SERVER_USER}@${SERVER_IP} "command -v nginx" > /dev/null 2>&1; then
    echo -e "${GREEN}检测到Nginx已安装${NC}"
    
    # 重启Nginx
    echo -e "${YELLOW}重启Nginx服务...${NC}"
    ssh -p ${SSH_PORT} ${SERVER_USER}@${SERVER_IP} "sudo systemctl restart nginx"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Nginx重启成功！${NC}\n"
    else
        echo -e "${YELLOW}警告: Nginx重启失败，请手动检查配置${NC}\n"
    fi
else
    echo -e "${YELLOW}未检测到Nginx，跳过Nginx相关操作${NC}"
    echo -e "${YELLOW}提示: 如需使用Nginx，请参考 DEPLOY.md 文档${NC}\n"
fi

# 完成
echo -e "${GREEN}=== 部署完成！ ===${NC}\n"
echo "访问地址: http://${SERVER_IP}"
echo "如需配置HTTPS，请参考 DEPLOY.md 文档"

