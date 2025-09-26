#!/bin/bash

# TTPolyglot 服务端开发环境快速设置脚本

set -e

echo "🚀 TTPolyglot 服务端开发环境设置"
echo "================================="

# 检查必要工具
echo "📋 检查必要工具..."

if ! command -v dart &> /dev/null; then
    echo "❌ 错误: Dart SDK 未安装"
    echo "请访问 https://dart.dev/get-dart 安装 Dart SDK"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ 错误: Docker 未安装"
    echo "请访问 https://docs.docker.com/get-docker/ 安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: Docker Compose 未安装"
    echo "请访问 https://docs.docker.com/compose/install/ 安装 Docker Compose"
    exit 1
fi

echo "✅ 必要工具检查完成"

# 创建必要目录
echo "📁 创建项目目录..."
mkdir -p data logs logs/nginx logs/redis logs/postgres ssl nginx/conf.d

# 创建环境变量文件
echo "⚙️  创建环境变量文件..."
if [ ! -f ".env" ]; then
    cat > .env << EOF
# TTPolyglot 服务端开发环境配置
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=dev_password_123
DATABASE_URL=postgresql://ttpolyglot:dev_password_123@localhost:5432/ttpolyglot
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
LOG_LEVEL=debug
JWT_SECRET=dev-jwt-secret-not-for-production
REDIS_URL=redis://localhost:6379
ENVIRONMENT=dev
EOF
    echo "✅ 已创建 .env 文件"
else
    echo "⚠️  .env 文件已存在，跳过创建"
fi

# 安装Dart依赖
echo "📦 安装 Dart 依赖..."
dart pub get

# 启动基础服务（数据库和Redis）
echo "🐳 启动数据库和 Redis 服务..."
docker-compose up -d ttpolyglot-db ttpolyglot-redis

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
if docker-compose ps | grep -q "ttpolyglot-db.*Up"; then
    echo "✅ PostgreSQL 服务启动成功"
else
    echo "❌ PostgreSQL 服务启动失败"
    docker-compose logs ttpolyglot-db
    exit 1
fi

if docker-compose ps | grep -q "ttpolyglot-redis.*Up"; then
    echo "✅ Redis 服务启动成功"
else
    echo "❌ Redis 服务启动失败"
    docker-compose logs ttpolyglot-redis
    exit 1
fi

echo ""
echo "🎉 开发环境设置完成！"
echo ""
echo "📋 接下来的步骤:"
echo "  1. 启动服务器: dart run bin/server.dart"
echo "  2. 访问健康检查: curl http://localhost:8080/health"
echo "  3. 访问API文档: http://localhost:8080/api/v1/version"
echo ""
echo "🔧 常用命令:"
echo "  • 查看数据库日志: docker-compose logs ttpolyglot-db"
echo "  • 查看Redis日志: docker-compose logs ttpolyglot-redis"
echo "  • 连接数据库: docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot"
echo "  • 连接Redis: docker-compose exec ttpolyglot-redis redis-cli"
echo "  • 停止服务: docker-compose stop"
echo ""
echo "✨ 开始愉快的开发吧！"
