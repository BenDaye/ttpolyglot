#!/bin/bash

# TTPolyglot 开发环境重启脚本
# 使用方法: ./scripts/dev-restart.sh [选项]

set -e

echo "🔄 TTPolyglot 开发环境重启"
echo "========================="

# 默认配置
RESTART_TYPE="all"
FORCE=false
CLEAN=false
VERBOSE=false

# 帮助信息
show_help() {
    echo "开发环境重启脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -t, --type <type>     重启类型 (all|app|db|redis|nginx)"
    echo "  -f, --force           强制重启（忽略警告）"
    echo "  -c, --clean           清理后重启"
    echo "  -v, --verbose         详细输出"
    echo "  -h, --help            显示帮助"
    echo ""
    echo "重启类型说明:"
    echo "  all      - 重启所有服务（默认）"
    echo "  app      - 仅重启应用服务器"
    echo "  db       - 仅重启数据库"
    echo "  redis    - 仅重启Redis"
    echo "  nginx    - 仅重启Nginx"
    echo ""
    echo "示例:"
    echo "  $0                    # 重启所有服务"
    echo "  $0 -t app            # 仅重启应用服务器"
    echo "  $0 -c -v             # 清理后重启（详细输出）"
    echo "  $0 -f -t db          # 强制重启数据库"
}

# 解析命令行参数
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                RESTART_TYPE="$2"
                shift 2
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -c|--clean)
                CLEAN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "❌ 未知选项: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 显示当前状态
show_current_status() {
    echo "📊 当前服务状态:"
    echo "==============="
    
    # 检查应用服务器
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        local pid=$(pgrep -f "dart run bin/server.dart")
        echo "✅ 应用服务器: 运行中 (PID: $pid)"
    else
        echo "❌ 应用服务器: 未运行"
    fi
    
    # 检查Docker服务
    if docker-compose ps | grep -q "Up"; then
        echo "✅ Docker服务: 运行中"
        docker-compose ps --format "table {{.Name}}\t{{.Status}}" | grep -v "NAME"
    else
        echo "❌ Docker服务: 未运行"
    fi
    
    # 检查Nginx
    if pgrep nginx > /dev/null; then
        echo "✅ Nginx: 运行中"
    else
        echo "❌ Nginx: 未运行"
    fi
    
    echo ""
}

# 确认重启操作
confirm_restart() {
    if [ "$FORCE" = false ]; then
        echo "⚠️  确认重启操作:"
        echo "   重启类型: $RESTART_TYPE"
        if [ "$CLEAN" = true ]; then
            echo "   清理模式: 是"
        fi
        echo ""
        read -p "确认继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "操作已取消"
            exit 0
        fi
    fi
}

# 停止应用服务器
stop_application() {
    echo "🛑 停止应用服务器..."
    
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        pkill -f "dart run bin/server.dart"
        echo "✅ 应用服务器已停止"
        
        # 等待进程完全停止
        sleep 2
        
        # 检查是否还有残留进程
        if pgrep -f "dart run bin/server.dart" > /dev/null; then
            echo "⚠️  强制停止残留进程..."
            pkill -9 -f "dart run bin/server.dart"
            sleep 1
        fi
    else
        echo "⚠️  应用服务器未运行"
    fi
}

# 停止Docker服务
stop_docker_services() {
    echo "🛑 停止Docker服务..."
    
    if docker-compose ps | grep -q "Up"; then
        docker-compose down
        echo "✅ Docker服务已停止"
    else
        echo "⚠️  Docker服务未运行"
    fi
}

# 停止Nginx
stop_nginx() {
    echo "🛑 停止Nginx..."
    
    if pgrep nginx > /dev/null; then
        pkill nginx
        echo "✅ Nginx已停止"
        
        # 等待进程完全停止
        sleep 2
        
        # 检查是否还有残留进程
        if pgrep nginx > /dev/null; then
            echo "⚠️  强制停止残留进程..."
            pkill -9 nginx
            sleep 1
        fi
    else
        echo "⚠️  Nginx未运行"
    fi
}

# 清理操作
clean_environment() {
    if [ "$CLEAN" = true ]; then
        echo "🧹 清理环境..."
        
        # 清理日志文件
        if [ -d "logs" ]; then
            echo "🗑️  清理日志文件..."
            rm -f logs/*.log
        fi
        
        # 清理临时文件
        echo "🗑️  清理临时文件..."
        rm -f /tmp/ttpolyglot-*.pid
        rm -f /tmp/ttpolyglot-*.tmp
        
        # 清理Docker资源（可选）
        if [ "$FORCE" = true ]; then
            echo "🗑️  清理Docker资源..."
            docker system prune -f > /dev/null 2>&1 || true
        fi
        
        echo "✅ 清理完成"
    fi
}

# 启动数据库
start_database() {
    echo "🚀 启动数据库..."
    
    docker-compose up -d ttpolyglot-db
    
    # 等待数据库启动
    echo "⏳ 等待数据库启动..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot > /dev/null 2>&1; then
            echo "✅ 数据库启动成功"
            return 0
        fi
        
        attempt=$((attempt + 1))
        sleep 2
    done
    
    echo "❌ 数据库启动超时"
    return 1
}

# 启动Redis
start_redis() {
    echo "🚀 启动Redis..."
    
    docker-compose up -d ttpolyglot-redis
    
    # 等待Redis启动
    echo "⏳ 等待Redis启动..."
    local max_attempts=15
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if docker-compose exec ttpolyglot-redis redis-cli ping > /dev/null 2>&1; then
            echo "✅ Redis启动成功"
            return 0
        fi
        
        attempt=$((attempt + 1))
        sleep 2
    done
    
    echo "❌ Redis启动超时"
    return 1
}

# 启动应用服务器
start_application() {
    echo "🚀 启动应用服务器..."
    
    # 创建日志目录
    mkdir -p logs
    
    # 启动应用
    nohup dart run bin/server.dart > logs/server.log 2>&1 &
    
    # 等待应用启动
    echo "⏳ 等待应用启动..."
    local max_attempts=15
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
            echo "✅ 应用服务器启动成功"
            return 0
        fi
        
        attempt=$((attempt + 1))
        sleep 2
    done
    
    echo "❌ 应用服务器启动超时"
    echo "📋 查看日志: tail -f logs/server.log"
    return 1
}

# 启动Nginx
start_nginx() {
    echo "🚀 启动Nginx..."
    
    # 检查Nginx配置
    if [ -f "~/nginx-simple.conf" ]; then
        if nginx -t -c ~/nginx-simple.conf > /dev/null 2>&1; then
            nginx -c ~/nginx-simple.conf -g "daemon on;"
            echo "✅ Nginx启动成功"
        else
            echo "❌ Nginx配置错误"
            return 1
        fi
    else
        echo "⚠️  Nginx配置文件不存在，跳过启动"
    fi
}

# 验证服务状态
verify_services() {
    echo "🔍 验证服务状态..."
    
    local all_ok=true
    
    # 验证应用服务器
    if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
        echo "✅ 应用服务器: 正常"
    else
        echo "❌ 应用服务器: 异常"
        all_ok=false
    fi
    
    # 验证数据库
    if docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot > /dev/null 2>&1; then
        echo "✅ 数据库: 正常"
    else
        echo "❌ 数据库: 异常"
        all_ok=false
    fi
    
    # 验证Redis
    if docker-compose exec ttpolyglot-redis redis-cli ping > /dev/null 2>&1; then
        echo "✅ Redis: 正常"
    else
        echo "❌ Redis: 异常"
        all_ok=false
    fi
    
    # 验证Nginx（如果运行）
    if pgrep nginx > /dev/null; then
        if curl -f http://localhost:8081/api/v1/version > /dev/null 2>&1; then
            echo "✅ Nginx: 正常"
        else
            echo "❌ Nginx: 异常"
            all_ok=false
        fi
    fi
    
    if [ "$all_ok" = true ]; then
        echo "🎉 所有服务重启成功！"
    else
        echo "⚠️  部分服务异常，请检查日志"
    fi
}

# 显示重启后信息
show_restart_info() {
    echo ""
    echo "📊 重启后服务信息:"
    echo "================="
    echo ""
    echo "🌐 访问地址:"
    echo "   应用服务器: http://localhost:8080"
    echo "   API版本: http://localhost:8080/api/v1/version"
    echo "   健康检查: http://localhost:8080/health"
    
    if pgrep nginx > /dev/null; then
        echo "   Nginx代理: http://localhost:8081"
    fi
    
    echo ""
    echo "🛠️  管理命令:"
    echo "   查看状态: ./scripts/dev-status.sh"
    echo "   查看日志: tail -f logs/server.log"
    echo "   停止服务: ./scripts/dev-stop.sh"
    echo "   重启服务: ./scripts/dev-restart.sh"
    echo ""
}

# 根据类型执行重启
restart_by_type() {
    case $RESTART_TYPE in
        all)
            echo "🔄 重启所有服务..."
            stop_application
            stop_nginx
            stop_docker_services
            clean_environment
            start_database
            start_redis
            start_application
            start_nginx
            ;;
        app)
            echo "🔄 重启应用服务器..."
            stop_application
            clean_environment
            start_application
            ;;
        db)
            echo "🔄 重启数据库..."
            stop_docker_services
            clean_environment
            start_database
            ;;
        redis)
            echo "🔄 重启Redis..."
            stop_docker_services
            clean_environment
            start_redis
            ;;
        nginx)
            echo "🔄 重启Nginx..."
            stop_nginx
            clean_environment
            start_nginx
            ;;
        *)
            echo "❌ 未知重启类型: $RESTART_TYPE"
            show_help
            exit 1
            ;;
    esac
}

# 主程序
main() {
    # 解析参数
    parse_arguments "$@"
    
    # 显示当前状态
    show_current_status
    
    # 确认重启
    confirm_restart
    
    # 执行重启
    restart_by_type
    
    # 验证服务
    verify_services
    
    # 显示信息
    show_restart_info
}

# 运行主程序
main "$@"
