#!/bin/bash

# TTPolyglot 开发环境停止脚本
# 使用方法: ./scripts/dev-stop.sh

set -e

echo "🛑 停止 TTPolyglot 开发环境"
echo "============================"

# 停止应用服务器
stop_application() {
    echo "🛑 停止应用服务器..."
    
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        pkill -f "dart run bin/server.dart"
        echo "✅ 应用服务器已停止"
    else
        echo "⚠️  应用服务器未运行"
    fi
}

# 停止基础设施服务
stop_infrastructure() {
    echo "🛑 停止基础设施服务..."
    
    # 停止Docker服务
    docker-compose down
    
    echo "✅ 基础设施服务已停止"
}

# 清理临时文件
cleanup() {
    echo "🧹 清理临时文件..."
    
    # 清理PID文件
    rm -f /tmp/ttpolyglot-server.pid
    
    # 清理日志文件（可选）
    if [ "$1" = "--clean-logs" ]; then
        echo "🗑️  清理日志文件..."
        rm -f logs/server.log
        echo "✅ 日志文件已清理"
    fi
    
    echo "✅ 清理完成"
}

# 显示停止状态
show_status() {
    echo ""
    echo "📊 服务状态:"
    echo "============"
    
    # 检查应用服务器
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        echo "❌ 应用服务器仍在运行"
    else
        echo "✅ 应用服务器已停止"
    fi
    
    # 检查Docker服务
    if docker-compose ps | grep -q "Up"; then
        echo "⚠️  部分Docker服务仍在运行:"
        docker-compose ps | grep "Up"
    else
        echo "✅ 所有Docker服务已停止"
    fi
    
    echo ""
    echo "🔄 重新启动: ./scripts/dev-start.sh"
}

# 主程序
main() {
    # 停止应用服务器
    stop_application
    
    # 停止基础设施服务
    stop_infrastructure
    
    # 清理临时文件
    cleanup "$@"
    
    # 显示状态
    show_status
}

# 运行主程序
main "$@"
