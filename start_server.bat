@echo off
chcp 65001 >nul
echo ============================================
echo 3D粒子爱心互动网页 - 本地服务器
echo ============================================
echo.

REM 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未检测到Python
    echo 请先安装Python: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

REM 启动服务器
python start_server.py

pause

