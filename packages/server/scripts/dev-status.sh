#!/bin/bash

# TTPolyglot 开发环境状态检查脚本
# 使用方法: ./scripts/dev-status.sh

set -e

echo "📊 TTPolyglot 开发环境状态"
echo "============================"

# 检查应用服务器状态
check_application() {
    echo "🚀 应用服务器状态:"
    
    if pgrep -f "dart run bin/server.dart" > /dev/null; then
        PID=$(pgrep -f "dart run bin/server.dart")
        echo "✅ 运行中 (PID: $PID)"
        
        # 检查健康状态
        if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
            echo "✅ API响应正常"
            
            # 获取版本信息
            VERSION=$(curl -s http://localhost:8080/api/v1/version | jq -r '.data.version' 2>/dev/null || echo "未知")
            echo "📋 版本: $VERSION"
        else
            echo "⚠️  API响应异常"
        fi
        
        # 检查健康检查端点
        HEALTH_STATUS=$(curl -s http://localhost:8080/health | jq -r '.status' 2>/dev/null || echo "未知")
        echo "🏥 健康状态: $HEALTH_STATUS"
        
    else
        echo "❌ 未运行"
    fi
    echo ""
}

# 检查数据库状态
check_database() {
    echo "🗄️  数据库状态:"
    
    if docker-compose ps ttpolyglot-db | grep -q "Up"; then
        echo "✅ 容器运行中"
        
        # 检查数据库连接
        if docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot > /dev/null 2>&1; then
            echo "✅ 数据库连接正常"
            
            # 获取数据库信息
            DB_SIZE=$(docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot -t -c "SELECT pg_size_pretty(pg_database_size('ttpolyglot'));" 2>/dev/null | xargs || echo "未知")
            echo "📊 数据库大小: $DB_SIZE"
            
            # 获取表数量
            TABLE_COUNT=$(docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | xargs || echo "未知")
            echo "📋 表数量: $TABLE_COUNT"
            
        else
            echo "❌ 数据库连接失败"
        fi
    else
        echo "❌ 容器未运行"
    fi
    echo ""
}

# 检查Redis状态
check_redis() {
    echo "🔴 Redis状态:"
    
    if docker-compose ps ttpolyglot-redis | grep -q "Up"; then
        echo "✅ 容器运行中"
        
        # 检查Redis连接
        if docker-compose exec ttpolyglot-redis redis-cli ping > /dev/null 2>&1; then
            echo "✅ Redis连接正常"
            
            # 获取Redis信息
            REDIS_INFO=$(docker-compose exec ttpolyglot-redis redis-cli info server | grep "redis_version" | cut -d: -f2 | xargs 2>/dev/null || echo "未知")
            echo "📋 Redis版本: $REDIS_INFO"
            
            # 获取内存使用
            MEMORY_USAGE=$(docker-compose exec ttpolyglot-redis redis-cli info memory | grep "used_memory_human" | cut -d: -f2 | xargs 2>/dev/null || echo "未知")
            echo "💾 内存使用: $MEMORY_USAGE"
            
        else
            echo "❌ Redis连接失败"
        fi
    else
        echo "❌ 容器未运行"
    fi
    echo ""
}

# 检查端口使用
check_ports() {
    echo "🔌 端口使用情况:"
    
    # 检查应用端口
    if lsof -i :8080 > /dev/null 2>&1; then
        echo "✅ 端口 8080: 应用服务器"
    else
        echo "❌ 端口 8080: 未使用"
    fi
    
    # 检查数据库端口
    if lsof -i :5432 > /dev/null 2>&1; then
        echo "✅ 端口 5432: 数据库"
    else
        echo "❌ 端口 5432: 未使用"
    fi
    
    # 检查Redis端口
    if lsof -i :6379 > /dev/null 2>&1; then
        echo "✅ 端口 6379: Redis"
    else
        echo "❌ 端口 6379: 未使用"
    fi
    
    # 检查Nginx端口（如果运行）
    if lsof -i :8081 > /dev/null 2>&1; then
        echo "✅ 端口 8081: Nginx代理"
    fi
    echo ""
}

# 检查日志文件
check_logs() {
    echo "📋 日志文件:"
    
    if [ -f "logs/server.log" ]; then
        LOG_SIZE=$(du -h logs/server.log | cut -f1)
        echo "📄 应用日志: logs/server.log ($LOG_SIZE)"
        
        # 显示最近的错误
        ERROR_COUNT=$(grep -c "ERROR\|FATAL" logs/server.log 2>/dev/null || echo "0")
        if [ "$ERROR_COUNT" -gt 0 ]; then
            echo "⚠️  发现 $ERROR_COUNT 个错误"
        else
            echo "✅ 无错误日志"
        fi
    else
        echo "❌ 应用日志文件不存在"
    fi
    echo ""
}

# 显示系统资源
show_resources() {
    echo "💻 系统资源:"
    
    # CPU使用率
    CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//' 2>/dev/null || echo "未知")
    echo "🖥️  CPU使用率: $CPU_USAGE%"
    
    # 内存使用
    MEMORY_USAGE=$(top -l 1 | grep "PhysMem" | awk '{print $2}' 2>/dev/null || echo "未知")
    echo "💾 内存使用: $MEMORY_USAGE"
    
    # 磁盘使用
    DISK_USAGE=$(df -h . | tail -1 | awk '{print $5}' 2>/dev/null || echo "未知")
    echo "💿 磁盘使用: $DISK_USAGE"
    echo ""
}

# 显示快速操作
show_quick_actions() {
    echo "🛠️  快速操作:"
    echo "   启动环境: ./scripts/dev-start.sh"
    echo "   停止环境: ./scripts/dev-stop.sh"
    echo "   重启应用: pkill -f 'dart run bin/server.dart' && dart run bin/server.dart &"
    echo "   查看日志: tail -f logs/server.log"
    echo "   数据库控制台: ./scripts/db-utils.sh console"
    echo "   备份数据库: ./scripts/db-utils.sh backup"
    echo ""
}

# 主程序
main() {
    check_application
    check_database
    check_redis
    check_ports
    check_logs
    show_resources
    show_quick_actions
}

# 运行主程序
main "$@"
