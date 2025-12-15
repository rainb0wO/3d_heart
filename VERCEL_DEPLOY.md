# Vercel 部署指南

Vercel 是最简单快速的部署方式，完全免费，自动提供 HTTPS 和全球 CDN 加速。

## 方式一：通过网页界面部署（推荐，最简单）

### 步骤 1：准备文件

确保项目文件完整：
```
粒子爱心网页/
├── index.html
├── photos/
│   ├── IMG_20251008_213503.jpg
│   ├── IMG_20251008_213539.jpg
│   └── ...
└── vercel.json (可选配置文件)
```

### 步骤 2：访问 Vercel

1. 打开浏览器，访问：https://vercel.com
2. 点击右上角 **"Sign Up"** 或 **"Log In"**

### 步骤 3：注册/登录

- **推荐使用 GitHub 账号登录**（最方便）
- 也可以使用邮箱注册

### 步骤 4：创建新项目

1. 登录后，点击 **"Add New..."** → **"Project"**
2. 选择 **"Import Git Repository"** 或 **"Browse"**

#### 选项 A：直接上传文件夹（最简单）

1. 点击 **"Browse"** 或拖拽文件夹
2. 选择整个项目文件夹
3. 点击 **"Upload"**

#### 选项 B：连接 GitHub（推荐，便于更新）

1. 如果项目已上传到 GitHub：
   - 选择你的仓库
   - 点击 **"Import"**
2. 如果还没上传到 GitHub：
   - 先将项目上传到 GitHub
   - 然后连接仓库

### 步骤 5：配置项目

1. **Project Name**: 输入项目名称（例如：particle-heart）
2. **Framework Preset**: 选择 **"Other"** 或 **"Static Site"**
3. **Root Directory**: 保持默认（./）
4. **Build Command**: 留空（这是静态文件，不需要构建）
5. **Output Directory**: 留空（index.html 在根目录）

### 步骤 6：部署

1. 点击 **"Deploy"** 按钮
2. 等待 1-2 分钟，部署完成
3. 会自动获得一个域名，例如：`particle-heart.vercel.app`

### 步骤 7：访问网站

部署完成后，你会看到：
- ✅ **部署成功提示**
- 🌐 **访问链接**（例如：https://particle-heart.vercel.app）

点击链接即可访问你的网站！

---

## 方式二：通过 Vercel CLI 部署（命令行）

### 步骤 1：安装 Vercel CLI

```bash
# 使用 npm 安装（需要先安装 Node.js）
npm install -g vercel

# 或者使用 yarn
yarn global add vercel
```

### 步骤 2：登录 Vercel

```bash
vercel login
```

会打开浏览器完成登录。

### 步骤 3：部署

在项目目录下运行：

```bash
# 首次部署
vercel

# 生产环境部署
vercel --prod
```

按提示操作：
- **Set up and deploy?** → 输入 `Y`
- **Which scope?** → 选择你的账号
- **Link to existing project?** → 输入 `N`（首次部署）
- **What's your project's name?** → 输入项目名称
- **In which directory is your code located?** → 输入 `./` 或直接回车

### 步骤 4：查看部署

部署完成后会显示：
- 预览 URL（用于测试）
- 生产 URL（正式域名）

---

## 配置文件（可选）

为了优化部署，可以创建 `vercel.json` 配置文件：

```json
{
  "version": 2,
  "builds": [
    {
      "src": "index.html",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/$1"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    },
    {
      "source": "/photos/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

这个配置文件会：
- 设置安全响应头
- 优化图片缓存

---

## 自定义域名（可选）

### 步骤 1：添加域名

1. 在 Vercel 项目页面，点击 **"Settings"**
2. 选择 **"Domains"**
3. 输入你的域名（例如：particle.example.com）
4. 点击 **"Add"**

### 步骤 2：配置 DNS

Vercel 会显示需要配置的 DNS 记录：

**方式 A：CNAME 记录（推荐）**
```
类型: CNAME
名称: particle (或 @)
值: cname.vercel-dns.com
```

**方式 B：A 记录**
```
类型: A
名称: particle (或 @)
值: 76.76.21.21
```

在你的域名服务商（如阿里云、腾讯云、GoDaddy等）配置 DNS 记录。

### 步骤 3：等待生效

DNS 生效通常需要几分钟到几小时，Vercel 会自动检测并激活 HTTPS 证书。

---

## 更新部署

### 通过网页界面

1. 重新上传文件
2. 或如果连接了 GitHub，推送代码后会自动部署

### 通过 CLI

```bash
# 更新并部署到生产环境
vercel --prod
```

---

## 常见问题

### Q1: 图片无法加载？

**A**: 检查 `photos` 文件夹是否已上传，确保图片路径正确。

### Q2: 摄像头无法访问？

**A**: Vercel 已自动配置 HTTPS，确保访问的是 `https://` 开头的链接。

### Q3: 如何查看部署日志？

**A**: 在 Vercel 项目页面，点击 **"Deployments"** → 选择某个部署 → 查看日志。

### Q4: 免费额度是多少？

**A**: 
- 100GB 带宽/月
- 100 次部署/天
- 完全足够个人项目使用

### Q5: 如何删除项目？

**A**: 
1. 进入项目设置
2. 滚动到底部
3. 点击 **"Delete Project"**

### Q6: 部署后如何回滚到之前的版本？

**A**:
1. 进入 **"Deployments"** 页面
2. 找到之前的部署
3. 点击 **"..."** → **"Promote to Production"**

---

## 优势总结

✅ **完全免费**（个人项目足够用）  
✅ **自动 HTTPS**（无需配置证书）  
✅ **全球 CDN**（访问速度快）  
✅ **自动部署**（连接 GitHub 后）  
✅ **无限项目数**  
✅ **简单易用**（5分钟即可部署完成）

---

## 快速开始清单

- [ ] 访问 https://vercel.com 并注册/登录
- [ ] 点击 "Add New" → "Project"
- [ ] 选择 "Browse" 上传项目文件夹
- [ ] 点击 "Deploy"
- [ ] 等待部署完成
- [ ] 访问生成的域名
- [ ] 允许摄像头权限测试功能

**就是这么简单！5分钟即可完成部署！** 🚀

