#!/bin/bash

# TTPolyglot 开发环境快速启动脚本
# 使用方法: ./scripts/dev-start.sh

set -e

echo "🚀 启动 TTPolyglot 开发环境"
echo "============================="

# 检查依赖
check_dependencies() {
    echo "🔍 检查依赖..."
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker 未安装，请先安装 Docker"
        exit 1
    fi
    
    if ! command -v dart &> /dev/null; then
        echo "❌ Dart 未安装，请先安装 Dart"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "❌ jq 未安装，请运行: brew install jq"
        exit 1
    fi
    
    echo "✅ 依赖检查通过"
}

# 启动基础设施服务
start() {
    echo "🔧 启动基础设施服务..."
    
    # 启动独立的数据库和Redis容器
    docker-compose -f docker-compose.dev.yml up -d
    
    # 等待服务启动
    echo "⏳ 等待服务启动..."
    sleep 10
    
    # 验证数据库
    if docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db pg_isready -U ttpolyglot -d ttpolyglot > /dev/null 2>&1; then
        echo "✅ 数据库启动成功"
    else
        echo "❌ 数据库启动失败"
        exit 1
    fi
    
    # 验证Redis
    if docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli ping > /dev/null 2>&1; then
        echo "✅ Redis启动成功"
    else
        echo "❌ Redis启动失败"
        exit 1
    fi
}

# 生成开发环境配置文件
generate_env_dev() {
    echo "🔧 检查开发环境配置..."
    
    if [ ! -f ".env.dev" ]; then
        if [ -f ".env.example" ]; then
            echo "📋 根据 .env.example 生成 .env.dev 文件..."
            cp .env.example .env.dev
            
            # 修改开发环境特定的配置
            sed -i '' 's/ENVIRONMENT=dev/ENVIRONMENT=dev/' .env.dev
            sed -i '' 's/LOG_LEVEL=info/LOG_LEVEL=debug/' .env.dev
            sed -i '' 's/DEBUG=true/DEBUG=true/' .env.dev
            sed -i '' 's/HOT_RELOAD=true/HOT_RELOAD=true/' .env.dev
            
            echo "✅ .env.dev 文件已生成"
            echo "💡 提示: 如需自定义配置，请编辑 .env.dev 文件"
        else
            echo "❌ 未找到 .env.example 文件，无法生成 .env.dev"
            echo "ℹ️  将使用默认配置启动"
        fi
    else
        echo "✅ .env.dev 文件已存在"
    fi
}

# 启动应用服务器
start_application() {
    echo "🚀 启动应用服务器..."
    
    # 检查是否已有应用在运行
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        echo "⚠️  应用服务器已在运行，先停止现有进程..."
        pkill -f "dart run bin/server.dart"
        sleep 2
    fi
    
    # 生成开发环境配置
    generate_env_dev
    
    # 加载环境变量（如果存在）
    if [ -f ".env.dev" ]; then
        echo "📋 加载开发环境配置..."
        export $(cat .env.dev | grep -v '^#' | xargs)
    else
        echo "ℹ️  未找到 .env.dev 文件，使用默认配置"
    fi
    
    # 启动应用
    nohup dart run bin/server.dart > logs/server.log 2>&1 &
    
    # 等待应用启动
    echo "⏳ 等待应用启动..."
    sleep 5
    
    # 验证应用
    if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
        echo "✅ 应用服务器启动成功"
    else
        echo "❌ 应用服务器启动失败"
        echo "📋 查看日志: tail -f logs/server.log"
        exit 1
    fi
}

# 显示服务信息
show_services() {
    echo ""
    echo "🎉 开发环境启动成功！"
    echo "===================="
    echo ""
    echo "🌐 访问地址:"
    echo "   应用服务器: http://localhost:8080"
    echo "   API版本: http://localhost:8080/api/v1/version"
    echo "   健康检查: http://localhost:8080/health"
    echo ""
    echo "📊 服务状态:"
    echo "   数据库: $(docker-compose -f docker-compose.dev.yml ps ttpolyglot-dev-db --format 'table {{.Status}}' | tail -n +2)"
    echo "   Redis: $(docker-compose -f docker-compose.dev.yml ps ttpolyglot-dev-redis --format 'table {{.Status}}' | tail -n +2)"
    echo "   应用服务器: $(ps aux | grep -c 'dart run bin/server.dart' || echo '未运行')"
    echo ""
    echo "🛠️  管理命令:"
    echo "   停止服务: ./scripts/dev-stop.sh"
    echo "   查看日志: tail -f logs/server.log"
    echo "   数据库控制台: docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db psql -U ttpolyglot -d ttpolyglot"
    echo "   Redis控制台: docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli"
    echo "   重启应用: pkill -f 'dart run bin/server.dart' && dart run bin/server.dart &"
    echo "   清理数据: docker-compose -f docker-compose.dev.yml down -v"
}

# 主程序
main() {
    # 创建日志目录
    mkdir -p logs
    
    # 检查依赖
    check_dependencies
    
    # 启动基础设施
    start
    
    # 启动应用
    start_application
    
    # 显示服务信息
    show_services
}

# 运行主程序
main "$@"
