#!/bin/bash

# TTPolyglot 生产环境启动脚本（使用本地Nginx）
# 使用方法: ./scripts/start-production-local.sh

set -e

echo "🚀 启动 TTPolyglot 生产环境（本地Nginx）"
echo "=============================================="

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请启动 Docker"
    exit 1
fi

# 检查Nginx是否安装
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx 未安装，请先安装 Nginx"
    echo "   macOS: brew install nginx"
    echo "   Ubuntu: sudo apt install nginx"
    echo "   CentOS: sudo yum install nginx"
    exit 1
fi

# 启动数据库和Redis
echo "🐳 启动数据库和Redis..."
docker-compose up -d ttpolyglot-db ttpolyglot-redis

# 等待数据库启动
echo "⏳ 等待数据库启动..."
sleep 5

# 启动应用服务器
echo "🚀 启动应用服务器..."
dart run bin/server.dart &
APP_PID=$!

# 等待应用启动
echo "⏳ 等待应用启动..."
sleep 3

# 检查应用是否启动成功
if ! curl -f http://localhost:8080/health > /dev/null 2>&1; then
    echo "❌ 应用服务器启动失败"
    kill $APP_PID 2>/dev/null || true
    exit 1
fi

echo "✅ 应用服务器启动成功"

# 配置Nginx
echo "🔧 配置Nginx..."

# 创建Nginx配置目录
sudo mkdir -p /usr/local/etc/nginx/servers

# 复制Nginx配置
sudo cp nginx/conf.d/ttpolyglot.conf /usr/local/etc/nginx/servers/ttpolyglot.conf

# 测试Nginx配置
if sudo nginx -t; then
    echo "✅ Nginx配置正确"
    
    # 启动Nginx
    if sudo nginx -s reload 2>/dev/null || sudo nginx; then
        echo "✅ Nginx启动成功"
    else
        echo "❌ Nginx启动失败"
        kill $APP_PID 2>/dev/null || true
        exit 1
    fi
else
    echo "❌ Nginx配置错误"
    kill $APP_PID 2>/dev/null || true
    exit 1
fi

# 测试完整服务
echo "🔍 测试服务..."
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo "✅ 生产环境启动成功！"
    echo ""
    echo "🌐 访问地址:"
    echo "   HTTP:  http://localhost"
    echo "   健康检查: http://localhost/health"
    echo "   API版本: http://localhost/api/v1/version"
    echo ""
    echo "📊 管理命令:"
    echo "   查看应用日志: tail -f logs/app.log"
    echo "   查看Nginx日志: tail -f /usr/local/var/log/nginx/access.log"
    echo "   停止服务: ./scripts/stop-production-local.sh"
    echo ""
    echo "🆔 应用进程ID: $APP_PID"
    echo $APP_PID > .app.pid
else
    echo "❌ 服务测试失败"
    kill $APP_PID 2>/dev/null || true
    exit 1
fi
