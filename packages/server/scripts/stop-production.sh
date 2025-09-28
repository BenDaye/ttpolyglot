#!/bin/bash

# TTPolyglot 生产环境停止脚本
# 使用方法: ./scripts/stop-production.sh

set -e

echo "🛑 停止 TTPolyglot 生产环境"
echo "================================"

# 停止所有服务
echo "🐳 停止 Docker 服务..."
docker-compose --profile production down

echo "✅ 所有服务已停止"
echo ""
echo "💡 提示:"
echo "   完全清理: docker-compose down -v --remove-orphans"
echo "   清理镜像: docker system prune -a"
