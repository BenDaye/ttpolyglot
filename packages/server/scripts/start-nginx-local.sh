#!/bin/bash

# TTPolyglot 本地Nginx启动脚本
# 使用方法: ./scripts/start-nginx-local.sh

set -e

echo "🚀 启动 TTPolyglot 本地Nginx代理"
echo "=================================="

# 检查应用服务器是否运行
echo "🔍 检查应用服务器..."
if ! curl -f http://localhost:8080/health > /dev/null 2>&1; then
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
sudo pkill nginx 2>/dev/null || true

# 复制配置文件
echo "📝 配置Nginx..."
sudo cp nginx-local.conf /opt/homebrew/etc/nginx/servers/ttpolyglot.conf

# 测试Nginx配置
echo "🧪 测试Nginx配置..."
if sudo nginx -t; then
    echo "✅ Nginx配置正确"
else
    echo "❌ Nginx配置错误"
    exit 1
fi

# 启动Nginx
echo "🚀 启动Nginx..."
if sudo nginx; then
    echo "✅ Nginx启动成功"
else
    echo "❌ Nginx启动失败"
    exit 1
fi

# 等待Nginx启动
echo "⏳ 等待Nginx启动..."
sleep 2

# 测试服务
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
    echo "   查看Nginx状态: sudo nginx -s status"
    echo "   重新加载配置: sudo nginx -s reload"
    echo "   停止Nginx: sudo nginx -s stop"
    echo "   查看日志: tail -f /opt/homebrew/var/log/nginx/access.log"
else
    echo "❌ 服务测试失败"
    echo "   检查Nginx日志: tail -f /opt/homebrew/var/log/nginx/error.log"
    exit 1
fi
