#!/bin/bash

# TTPolyglot 简化Nginx启动脚本
# 使用方法: ./scripts/start-nginx-simple.sh

set -e

echo "🚀 启动 TTPolyglot 简化Nginx代理"
echo "=================================="

# 检查应用服务器是否运行
echo "🔍 检查应用服务器..."
if ! curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
    echo "❌ 应用服务器未运行，请先启动应用服务器"
    echo "   运行: dart run bin/server.dart"
    exit 1
fi

echo "✅ 应用服务器运行正常"

# 检查Nginx是否安装
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx 未安装，请先安装 Nginx"
    echo "   运行: brew install nginx"
    exit 1
fi

# 停止现有的Nginx进程
echo "🛑 停止现有Nginx进程..."
pkill nginx 2>/dev/null || true

# 创建简化的Nginx配置
echo "📝 创建Nginx配置..."
cat > ~/nginx-simple.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream ttpolyglot_backend {
        server localhost:8080;
    }
    
    server {
        listen 8081;  # 使用8081端口避免权限问题
        server_name localhost;
        
        location / {
            proxy_pass http://ttpolyglot_backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        location /health {
            proxy_pass http://ttpolyglot_backend/health;
            access_log off;
        }
        
        location /api/ {
            proxy_pass http://ttpolyglot_backend/api/;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# 测试Nginx配置
echo "🧪 测试Nginx配置..."
if nginx -t -c ~/nginx-simple.conf; then
    echo "✅ Nginx配置正确"
else
    echo "❌ Nginx配置错误"
    exit 1
fi

# 启动Nginx
echo "🚀 启动Nginx..."
nginx -c ~/nginx-simple.conf -g "daemon on;"

# 等待Nginx启动
echo "⏳ 等待Nginx启动..."
sleep 2

# 测试服务
echo "🔍 测试服务..."
if curl -f http://localhost:8081/health > /dev/null 2>&1; then
    echo "✅ 生产环境启动成功！"
    echo ""
    echo "🌐 访问地址:"
    echo "   HTTP:  http://localhost:8081"
    echo "   健康检查: http://localhost:8081/health"
    echo "   API版本: http://localhost:8081/api/v1/version"
    echo ""
    echo "📊 管理命令:"
    echo "   停止Nginx: pkill nginx"
    echo "   查看进程: ps aux | grep nginx"
    echo "   查看配置: cat ~/nginx-simple.conf"
else
    echo "❌ 服务测试失败"
    echo "   检查Nginx进程: ps aux | grep nginx"
    exit 1
fi
