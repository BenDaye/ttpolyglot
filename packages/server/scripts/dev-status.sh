#!/bin/bash

# TTPolyglot 开发环境状态检查脚本
# 使用方法: ./scripts/dev-status.sh

set -e

echo "📊 TTPolyglot 开发环境状态"
echo "=========================="

# 检查Docker是否运行
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker 未运行或无法访问"
        return 1
    fi
    echo "✅ Docker 运行正常"
    return 0
}

# 检查基础设施容器状态
check_infrastructure() {
    echo ""
    echo "🔧 基础设施服务状态:"
    echo "-------------------"
    
    # 检查数据库容器
    if docker ps --filter name=ttpolyglot-dev-db --format "{{.Names}}" | grep -q ttpolyglot-dev-db; then
        db_status=$(docker ps --filter name=ttpolyglot-dev-db --format "{{.Status}}")
        echo "📊 数据库: $db_status"
        
        # 检查数据库连接
        if docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db pg_isready -U ttpolyglot -d ttpolyglot > /dev/null 2>&1; then
            echo "   ✅ 数据库连接正常"
        else
            echo "   ❌ 数据库连接失败"
        fi
    else
        echo "📊 数据库: 未运行"
    fi
    
    # 检查Redis容器
    if docker ps --filter name=ttpolyglot-dev-redis --format "{{.Names}}" | grep -q ttpolyglot-dev-redis; then
        redis_status=$(docker ps --filter name=ttpolyglot-dev-redis --format "{{.Status}}")
        echo "📊 Redis: $redis_status"
        
        # 检查Redis连接
        if docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli ping > /dev/null 2>&1; then
            echo "   ✅ Redis连接正常"
        else
            echo "   ❌ Redis连接失败"
        fi
    else
        echo "📊 Redis: 未运行"
    fi
}

# 检查应用服务器状态
check_application() {
    echo ""
    echo "🚀 应用服务器状态:"
    echo "-----------------"
    
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        app_pid=$(pgrep -f "dart run bin/server.dart")
        echo "📊 应用服务器: 运行中 (PID: $app_pid)"
        
        # 检查应用健康状态
        if curl -f http://localhost:8080/health > /dev/null 2>&1; then
            echo "   ✅ 应用服务器健康检查通过"
        else
            echo "   ⚠️  应用服务器运行但健康检查失败"
        fi
        
        # 检查API版本
        if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
            version=$(curl -s http://localhost:8080/api/v1/version 2>/dev/null | jq -r '.version // "unknown"' 2>/dev/null || echo "unknown")
            echo "   📋 API版本: $version"
        fi
    else
        echo "📊 应用服务器: 未运行"
    fi
}

# 检查端口占用
check_ports() {
    echo ""
    echo "🔌 端口占用情况:"
    echo "---------------"
    
    # 检查数据库端口
    if lsof -i :5432 > /dev/null 2>&1; then
        echo "📊 端口 5432 (数据库): 已占用"
    else
        echo "📊 端口 5432 (数据库): 空闲"
    fi
    
    # 检查Redis端口
    if lsof -i :6379 > /dev/null 2>&1; then
        echo "📊 端口 6379 (Redis): 已占用"
    else
        echo "📊 端口 6379 (Redis): 空闲"
    fi
    
    # 检查应用端口
    if lsof -i :8080 > /dev/null 2>&1; then
        echo "📊 端口 8080 (应用): 已占用"
    else
        echo "📊 端口 8080 (应用): 空闲"
    fi
}

# 检查日志文件
check_logs() {
    echo ""
    echo "📋 日志文件状态:"
    echo "---------------"
    
    if [ -f "logs/server.log" ]; then
        log_size=$(du -h logs/server.log | cut -f1)
        log_lines=$(wc -l < logs/server.log)
        echo "📊 应用日志: 存在 (大小: $log_size, 行数: $log_lines)"
        
        # 显示最近的错误
        if grep -q "ERROR\|FATAL" logs/server.log 2>/dev/null; then
            error_count=$(grep -c "ERROR\|FATAL" logs/server.log)
            echo "   ⚠️  发现 $error_count 个错误日志"
        else
            echo "   ✅ 无错误日志"
        fi
    else
        echo "📊 应用日志: 不存在"
    fi
}

# 显示资源使用情况
check_resources() {
    echo ""
    echo "💾 资源使用情况:"
    echo "---------------"
    
    # Docker容器资源使用
    if docker ps --filter name=ttpolyglot-dev --format "{{.Names}}" | grep -q ttpolyglot-dev; then
        echo "📊 Docker容器资源:"
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" $(docker ps --filter name=ttpolyglot-dev --format "{{.Names}}") 2>/dev/null || echo "   无法获取容器资源信息"
    fi
    
    # 应用进程资源使用
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        app_pid=$(pgrep -f "dart run bin/server.dart")
        echo "📊 应用进程资源:"
        ps -p $app_pid -o pid,ppid,pcpu,pmem,etime,command --no-headers 2>/dev/null || echo "   无法获取进程资源信息"
    fi
}

# 显示快速操作命令
show_quick_commands() {
    echo ""
    echo "🛠️  快速操作命令:"
    echo "---------------"
    echo "   启动环境: ./scripts/dev-start.sh"
    echo "   停止环境: ./scripts/dev-stop.sh"
    echo "   查看应用日志: tail -f logs/server.log"
    echo "   重启应用: pkill -f 'dart run bin/server.dart' && dart run bin/server.dart &"
    echo "   数据库控制台: docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db psql -U ttpolyglot -d ttpolyglot"
    echo "   Redis控制台: docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli"
    echo "   清理数据: docker-compose -f docker-compose.dev.yml down -v"
}

# 主程序
main() {
    # 检查Docker
    if ! check_docker; then
        echo ""
        echo "❌ 请先启动Docker"
        exit 1
    fi
    
    # 检查基础设施
    check_infrastructure
    
    # 检查应用服务器
    check_application
    
    # 检查端口占用
    check_ports
    
    # 检查日志文件
    check_logs
    
    # 检查资源使用
    check_resources
    
    # 显示快速操作命令
    show_quick_commands
    
    echo ""
    echo "✅ 状态检查完成"
}

# 运行主程序
main "$@"
