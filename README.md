# 3D粒子爱心互动网页

一个基于WebGL和手势识别的3D粒子互动网页，通过摄像头检测手势来控制粒子的行为。

## 功能特点

- 🎨 **3D粒子系统**: 使用Three.js创建500个3D旋转粒子
- 📸 **照片粒子**: 将photos文件夹中的照片作为粒子纹理
- ✊ **手势识别**: 
  - 握拳 → 粒子聚拢成爱心形状
  - 张开手掌 → 粒子像烟花一样散开
  - 指向屏幕 → 随机显示照片
- 🔄 **旋转控制**: 根据手指位置控制粒子旋转，靠近屏幕边缘速度更快
- 📹 **自动摄像头**: 页面加载后自动请求摄像头权限

## 使用方法

### 方法一：使用Python服务器（推荐，最简单）

1. **Windows用户**：
   - 双击运行 `start_server.bat`
   - 浏览器会自动打开

2. **Mac/Linux用户**：
   ```bash
   chmod +x start_server.sh
   ./start_server.sh
   ```

3. **手动启动（所有系统）**：
   ```bash
   python start_server.py
   ```
   或
   ```bash
   python3 start_server.py
   ```

### 方法二：使用Node.js服务器

如果您安装了Node.js：

```bash
node server.js
```

### 方法三：使用VS Code Live Server

1. 安装VS Code的"Live Server"扩展
2. 右键点击 `index.html`
3. 选择"Open with Live Server"

### 方法四：使用Python内置服务器

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```

然后在浏览器中访问：`http://localhost:8000/index.html`

## 系统要求

- 现代浏览器（Chrome、Edge、Firefox、Safari最新版本）
- 摄像头（用于手势识别）
- Python 3.x（如果使用Python服务器）
- Node.js（如果使用Node.js服务器，可选）

## 注意事项

⚠️ **重要**: 浏览器安全策略要求摄像头访问必须通过HTTPS或localhost，这是无法绕过的安全限制。直接双击打开HTML文件**无法访问摄像头**，必须使用本地服务器。

## 手势说明

- **握拳** 👊: 粒子会聚拢形成爱心形状
- **张开手掌** 🖐: 粒子会像烟花一样随机散开
- **指向屏幕** 👉: 随机显示photos文件夹中的一张照片
- **移动手指**: 粒子会跟随手指方向旋转，手指越靠近屏幕边缘，旋转速度越快

## 技术栈

- Three.js - 3D图形渲染
- MediaPipe Hands - 手势识别
- WebGL - 硬件加速图形

## 文件结构

```
粒子爱心网页/
├── index.html          # 主HTML文件
├── photos/             # 照片文件夹
│   ├── IMG_20251008_213503.jpg
│   ├── IMG_20251008_213539.jpg
│   └── ...
├── start_server.py     # Python服务器脚本
├── start_server.bat    # Windows启动脚本
├── start_server.sh     # Mac/Linux启动脚本
├── server.js           # Node.js服务器脚本
└── README.md           # 说明文档
```

## 故障排除

### 摄像头无法访问
- 确保使用了本地服务器（不能直接打开HTML文件）
- 检查浏览器权限设置
- 尝试使用Chrome或Edge浏览器

### 手势识别不工作
- 确保光线充足
- 手部应该清晰可见
- 尝试调整与摄像头的距离

### 图片无法加载
- 检查photos文件夹是否存在
- 确保图片文件名正确
- 查看浏览器控制台的错误信息

