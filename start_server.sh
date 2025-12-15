#!/bin/bash
# 简单的HTTP服务器启动脚本（适用于Mac/Linux）

echo "============================================"
echo "3D粒子爱心互动网页 - 本地服务器"
echo "============================================"
echo ""

PORT=8000

# 检查Python是否安装
if command -v python3 &> /dev/null; then
    PYTHON_CMD=python3
elif command -v python &> /dev/null; then
    PYTHON_CMD=python
else
    echo "错误: 未检测到Python"
    echo "请先安装Python: https://www.python.org/downloads/"
    exit 1
fi

# 启动服务器
cd "$(dirname "$0")"
echo "服务器地址: http://localhost:$PORT"
echo "请在浏览器中打开: http://localhost:$PORT/index.html"
echo "按 Ctrl+C 停止服务器"
echo ""

# 尝试自动打开浏览器
if command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open "http://localhost:$PORT/index.html" &
elif command -v open &> /dev/null; then
    # Mac
    open "http://localhost:$PORT/index.html" &
fi

$PYTHON_CMD -m http.server $PORT

