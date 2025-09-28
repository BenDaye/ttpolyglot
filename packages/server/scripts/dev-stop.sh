#!/bin/bash

# TTPolyglot 开发环境停止脚本
# 使用方法: ./scripts/dev-stop.sh

set -e

echo "🛑 停止 TTPolyglot 开发环境"
echo "============================="

# 停止应用服务器
stop_application() {
    echo "🛑 停止应用服务器..."
    
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        echo "⏳ 正在停止应用服务器..."
        pkill -f "dart run bin/server.dart"
        sleep 2
        
        # 验证是否已停止
        if ! pgrep -f "dart run bin/server.dart" > /dev/null; then
            echo "✅ 应用服务器已停止"
        else
            echo "⚠️  应用服务器仍在运行，强制停止..."
            pkill -9 -f "dart run bin/server.dart"
            sleep 1
        fi
    else
        echo "ℹ️  应用服务器未运行"
    fi
}

# 停止基础设施服务
stop() {
    echo "🛑 停止基础设施服务..."
    
    # 停止数据库和Redis容器（保留容器和数据）
    docker-compose -f docker-compose.dev.yml stop
    
    echo "✅ 基础设施服务已停止"
}


# 显示停止信息
show_stop_info() {
    echo ""
    echo "🎉 开发环境已停止！"
    echo "===================="
    echo ""
    echo "📊 服务状态:"
    echo "   数据库: $(docker ps --filter name=ttpolyglot-dev-db --format 'table {{.Status}}' | tail -n +2 || echo '已停止')"
    echo "   Redis: $(docker ps --filter name=ttpolyglot-dev-redis --format 'table {{.Status}}' | tail -n +2 || echo '已停止')"
    echo "   应用服务器: $(ps aux | grep -c 'dart run bin/server.dart' || echo '已停止')"
    echo ""
    echo "🛠️  管理命令:"
    echo "   启动服务: ./scripts/dev-start.sh"
    echo "   查看日志: tail -f logs/server.log"
    echo "   清理数据: docker-compose -f docker-compose.dev.yml down -v"
}

# 主程序
main() {
    # 停止应用
    stop_application
    
    # 停止基础设施
    stop
    
    # 显示停止信息
    show_stop_info
}

# 运行主程序
main "$@"