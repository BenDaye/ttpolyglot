#!/bin/bash

# TTPolyglot 生产环境启动脚本
# 使用方法: ./scripts/start-production.sh

set -e

echo "🚀 启动 TTPolyglot 生产环境"
echo "================================"

# 检查Docker和Docker Compose是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "⚠️  未找到 .env 文件，创建生产环境配置..."
    cp .env.example .env
    echo "📝 请编辑 .env 文件，配置生产环境参数"
    echo "   特别是数据库密码、JWT密钥等敏感信息"
    read -p "按回车键继续..."
fi

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p logs/nginx logs/postgres ssl data uploads

# 检查SSL证书（生产环境）
if [ ! -f ssl/ttpolyglot.crt ] || [ ! -f ssl/ttpolyglot.key ]; then
    echo "⚠️  SSL证书未找到，生成自签名证书（仅用于测试）..."
    echo "   生产环境请使用正式的SSL证书"
    
    # 生成自签名证书
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/ttpolyglot.key \
        -out ssl/ttpolyglot.crt \
        -subj "/C=CN/ST=State/L=City/O=Organization/CN=localhost"
    
    echo "✅ 自签名证书已生成"
fi

# 启动服务
echo "🐳 启动 Docker 服务..."
docker-compose --profile production up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
docker-compose ps

# 测试健康检查
echo "🏥 测试健康检查..."
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo "✅ 服务启动成功！"
    echo ""
    echo "🌐 访问地址:"
    echo "   HTTP:  http://localhost"
    echo "   HTTPS: https://localhost (如果配置了SSL)"
    echo "   健康检查: http://localhost/health"
    echo "   API版本: http://localhost/api/v1/version"
    echo ""
    echo "📊 监控命令:"
    echo "   查看日志: docker-compose logs -f"
    echo "   停止服务: docker-compose down"
    echo "   重启服务: docker-compose restart"
else
    echo "❌ 服务启动失败，请检查日志:"
    echo "   docker-compose logs"
    exit 1
fi
