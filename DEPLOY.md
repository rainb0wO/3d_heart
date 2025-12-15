# 云服务器部署指南

## 服务器配置推荐

### 方案一：轻量应用服务器（推荐，成本低）

#### 国内云服务商推荐

**1. 腾讯云 Lighthouse（轻量应用服务器）**
- **配置**：1核2G / 2核4G
- **带宽**：3-5Mbps
- **系统**：Ubuntu 20.04/22.04 LTS
- **价格**：约 ¥24-48/月
- **优点**：适合个人项目，带HTTPS证书，管理简单

**2. 阿里云 ECS 共享型**
- **配置**：1核2G
- **带宽**：1-3Mbps（按量付费更灵活）
- **系统**：Ubuntu 20.04/22.04 LTS
- **价格**：约 ¥35-60/月

**3. 华为云 ECS**
- **配置**：1核2G
- **价格**：约 ¥30-50/月

#### 国外云服务商推荐

**1. Vercel（免费，推荐静态部署）**
- **优点**：完全免费，自动HTTPS，全球CDN
- **限制**：仅支持静态文件，无服务器端
- **适合**：这个项目完全适用！

**2. Netlify（免费）**
- **优点**：免费HTTPS，CDN加速
- **适合**：静态网站托管

**3. GitHub Pages（免费）**
- **优点**：完全免费
- **缺点**：需要HTTPS需要自定义域名

**4. DigitalOcean Droplet**
- **配置**：Basic Droplet - $4/月 (1核1G)
- **优点**：性价比高，全球节点

### 方案二：使用云存储 + CDN（最省钱）

**推荐组合**：
- **腾讯云COS / 阿里云OSS** + **CDN加速** + **HTTPS**
- **价格**：存储约 ¥0.1/GB/月，CDN流量约 ¥0.2/GB
- **优点**：按需付费，成本极低

## 服务器系统要求

### 最低配置
- **CPU**：1核
- **内存**：1GB
- **存储**：20GB
- **带宽**：1Mbps（国内）/ 5Mbps（国外）

### 推荐配置（适合多人访问）
- **CPU**：2核
- **内存**：2-4GB
- **存储**：40GB SSD
- **带宽**：3-5Mbps（国内）/ 10Mbps（国外）

## 部署方式

### 方式一：使用 Nginx（推荐）

#### 1. 安装 Nginx

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx -y

# 启动Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

#### 2. 配置 Nginx

创建配置文件：`/etc/nginx/sites-available/particle-heart`

```nginx
server {
    listen 80;
    server_name your-domain.com;  # 替换为你的域名或IP

    root /var/www/particle-heart;
    index index.html;

    # 启用Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript 
               application/javascript application/xml+rss 
               application/json image/svg+xml;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 允许大文件上传（如果需要）
    client_max_body_size 100M;
}
```

#### 3. 启用配置

```bash
# 创建软链接
sudo ln -s /etc/nginx/sites-available/particle-heart /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启Nginx
sudo systemctl restart nginx
```

#### 4. 上传文件

```bash
# 创建目录
sudo mkdir -p /var/www/particle-heart
sudo chown -R $USER:$USER /var/www/particle-heart

# 使用scp上传文件（在本地执行）
scp -r * user@your-server-ip:/var/www/particle-heart/
```

### 方式二：使用 Node.js 服务器

#### 1. 安装 Node.js

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

#### 2. 使用提供的 server.js

将 `server.js` 上传到服务器，然后：

```bash
# 安装pm2（进程管理器）
sudo npm install -g pm2

# 启动服务
pm2 start server.js --name particle-heart

# 设置开机自启
pm2 startup
pm2 save
```

#### 3. 配置 Nginx 反向代理

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 方式三：使用 Python HTTP 服务器

```bash
# 安装Python（通常已预装）
python3 --version

# 使用systemd创建服务
sudo nano /etc/systemd/system/particle-heart.service
```

服务文件内容：

```ini
[Unit]
Description=Particle Heart Web Server
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/particle-heart
ExecStart=/usr/bin/python3 -m http.server 8000
Restart=always

[Install]
WantedBy=multi-user.target
```

启动服务：

```bash
sudo systemctl daemon-reload
sudo systemctl start particle-heart
sudo systemctl enable particle-heart
```

## HTTPS 配置（必须！摄像头访问需要）

### 使用 Let's Encrypt 免费证书

#### 1. 安装 Certbot

```bash
sudo apt install certbot python3-certbot-nginx -y
```

#### 2. 获取证书

```bash
# 如果有域名
sudo certbot --nginx -d your-domain.com

# 如果只有IP，需要使用DNS验证
sudo certbot certonly --manual -d your-domain.com
```

#### 3. 自动续期

```bash
# Certbot会自动配置定时任务，也可以手动测试
sudo certbot renew --dry-run
```

### Nginx HTTPS 配置示例

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # SSL优化
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /var/www/particle-heart;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## 性能优化建议

### 1. 启用 CDN（内容分发网络）

- **腾讯云CDN**：国内访问加速
- **Cloudflare**：全球CDN，免费版足够用
- **阿里云CDN**：国内主流选择

### 2. 压缩静态资源

```bash
# 安装压缩工具
sudo apt install gzip

# 或者使用Webpack等打包工具压缩JS
```

### 3. 浏览器缓存

已在上面的Nginx配置中包含了缓存设置。

### 4. 图片优化

```bash
# 压缩图片（可选）
# 使用工具如：imagemin, tinypng等
```

## 监控和维护

### 1. 查看访问日志

```bash
# Nginx日志
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### 2. 服务器监控

```bash
# 查看资源使用
htop
df -h
free -h
```

### 3. 设置防火墙

```bash
# Ubuntu UFW
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

## 快速部署脚本

创建一个部署脚本 `deploy.sh`：

```bash
#!/bin/bash

# 配置
SERVER_USER="your-username"
SERVER_IP="your-server-ip"
SERVER_PATH="/var/www/particle-heart"

# 上传文件
echo "上传文件到服务器..."
scp -r * ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/

# 重启服务
echo "重启Nginx..."
ssh ${SERVER_USER}@${SERVER_IP} "sudo systemctl restart nginx"

echo "部署完成！"
```

使用方法：

```bash
chmod +x deploy.sh
./deploy.sh
```

## 成本估算

### 方案对比

| 方案 | 月成本 | 适合场景 |
|------|--------|----------|
| Vercel/Netlify | 免费 | 个人项目，测试 |
| 腾讯云 Lighthouse 1核2G | ¥24-48 | 国内访问，个人项目 |
| 阿里云 ECS 1核2G | ¥35-60 | 国内访问，稳定需求 |
| 云存储+CDN | ¥5-20 | 流量不大时最省钱 |
| DigitalOcean $4套餐 | $4 (约¥28) | 国外访问 |

## 注意事项

1. **必须使用HTTPS**：浏览器安全策略要求摄像头访问必须通过HTTPS
2. **域名解析**：如果使用域名，需要在DNS服务商处配置A记录
3. **防火墙规则**：确保开放80和443端口
4. **资源限制**：如果访问量大，考虑升级配置或使用CDN
5. **备份**：定期备份网站文件

## 推荐方案总结

**个人项目/测试**：
- 使用 **Vercel** 或 **Netlify**（免费，自动HTTPS）

**正式部署（国内）**：
- **腾讯云 Lighthouse 1核2G** + **Nginx** + **Let's Encrypt证书**
- 总成本：约 ¥30-50/月

**正式部署（国外）**：
- **DigitalOcean $4套餐** + **Nginx** + **Let's Encrypt证书**
- 总成本：约 $4/月（¥28）

**极致性价比**：
- **云存储（COS/OSS）** + **CDN** + **HTTPS**
- 总成本：¥5-20/月（按流量计费）

