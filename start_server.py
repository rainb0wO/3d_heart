#!/usr/bin/env python3
"""
简单的HTTP服务器启动脚本
用于运行3D粒子爱心互动网页
"""

import http.server
import socketserver
import webbrowser
import os
import sys

PORT = 8000

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # 添加CORS和必要的HTTP头
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()

def main():
    # 切换到脚本所在目录
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    # 检查端口是否被占用
    try:
        with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
            print("=" * 60)
            print("3D粒子爱心互动网页 - 本地服务器")
            print("=" * 60)
            print(f"服务器地址: http://localhost:{PORT}")
            print(f"请在浏览器中打开: http://localhost:{PORT}/index.html")
            print("按 Ctrl+C 停止服务器")
            print("=" * 60)
            
            # 自动打开浏览器
            try:
                webbrowser.open(f'http://localhost:{PORT}/index.html')
                print("\n已自动打开浏览器...")
            except:
                print("\n无法自动打开浏览器，请手动访问上述地址")
            
            # 启动服务器
            httpd.serve_forever()
    except OSError:
        print(f"错误: 端口 {PORT} 已被占用")
        print(f"请关闭占用该端口的程序，或修改脚本中的 PORT 变量")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\n服务器已停止")
        sys.exit(0)

if __name__ == "__main__":
    main()

