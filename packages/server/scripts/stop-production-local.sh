#!/bin/bash

# TTPolyglot 生产环境停止脚本（本地Nginx）
# 使用方法: ./scripts/stop-production-local.sh

set -e

echo "🛑 停止 TTPolyglot 生产环境"
echo "================================"

# 停止应用服务器
if [ -f .app.pid ]; then
    APP_PID=$(cat .app.pid)
    if kill -0 $APP_PID 2>/dev/null; then
        echo "🛑 停止应用服务器 (PID: $APP_PID)..."
        kill $APP_PID
        rm .app.pid
        echo "✅ 应用服务器已停止"
    else
        echo "⚠️  应用服务器未运行"
        rm .app.pid
    fi
else
    echo "⚠️  未找到应用进程ID文件"
fi

# 停止Nginx
echo "🛑 停止Nginx..."
if sudo nginx -s quit 2>/dev/null; then
    echo "✅ Nginx已停止"
else
    echo "⚠️  Nginx可能未运行或停止失败"
fi

# 停止Docker服务
echo "🐳 停止Docker服务..."
docker-compose down

echo "✅ 所有服务已停止"
echo ""
echo "💡 提示:"
echo "   完全清理Docker: docker-compose down -v --remove-orphans"
echo "   清理Docker镜像: docker system prune -a"
