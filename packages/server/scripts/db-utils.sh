#!/bin/bash

# TTPolyglot 数据库工具脚本

set -e

# 加载环境变量
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

DB_NAME=${DB_NAME:-ttpolyglot}
DB_USER=${DB_USER:-ttpolyglot}
DB_PASSWORD=${DB_PASSWORD:-password}

show_help() {
    echo "TTPolyglot 数据库工具"
    echo ""
    echo "用法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
    echo "  status      - 显示数据库连接状态"
    echo "  create      - 创建数据库"
    echo "  drop        - 删除数据库"
    echo "  reset       - 重置数据库（删除并重新创建）"
    echo "  backup      - 备份数据库"
    echo "  restore     - 恢复数据库"
    echo "  migrate     - 运行迁移"
    echo "  seed        - 运行种子数据"
    echo "  console     - 打开数据库控制台"
    echo "  logs        - 查看数据库日志"
    echo ""
    echo "示例:"
    echo "  $0 status              # 检查数据库状态"
    echo "  $0 backup              # 备份数据库"
    echo "  $0 restore backup.sql  # 恢复数据库"
    echo "  $0 console             # 连接到数据库"
}

check_db_container() {
    if ! docker-compose ps | grep -q "ttpolyglot-db.*Up"; then
        echo "❌ 数据库容器未运行，请先启动: docker-compose up -d ttpolyglot-db"
        exit 1
    fi
}

db_status() {
    echo "📊 检查数据库状态..."
    
    if docker-compose ps | grep -q "ttpolyglot-db.*Up"; then
        echo "✅ 数据库容器正在运行"
        
        # 检查数据库连接
        if docker-compose exec ttpolyglot-db pg_isready -U $DB_USER -d $DB_NAME > /dev/null 2>&1; then
            echo "✅ 数据库连接正常"
            
            # 显示数据库信息
            echo ""
            echo "📋 数据库信息:"
            docker-compose exec ttpolyglot-db psql -U $DB_USER -d $DB_NAME -c "\l" | grep $DB_NAME
            
            # 显示表数量
            table_count=$(docker-compose exec ttpolyglot-db psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | xargs)
            echo "📊 公共模式表数量: $table_count"
            
        else
            echo "❌ 数据库连接失败"
        fi
    else
        echo "❌ 数据库容器未运行"
        docker-compose ps | grep ttpolyglot-db || echo "容器不存在"
    fi
}

db_create() {
    echo "🔨 创建数据库..."
    check_db_container
    
    # 检查数据库是否已存在
    if docker-compose exec ttpolyglot-db psql -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        echo "⚠️  数据库 '$DB_NAME' 已存在"
        return 0
    fi
    
    docker-compose exec ttpolyglot-db createdb -U $DB_USER $DB_NAME
    echo "✅ 数据库创建成功"
}

db_drop() {
    echo "🗑️  删除数据库..."
    check_db_container
    
    echo "⚠️  警告: 这将删除数据库 '$DB_NAME' 及其所有数据!"
    read -p "确认继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        return 0
    fi
    
    docker-compose exec ttpolyglot-db dropdb -U $DB_USER --if-exists $DB_NAME
    echo "✅ 数据库删除成功"
}

db_reset() {
    echo "🔄 重置数据库..."
    db_drop
    db_create
    echo "✅ 数据库重置完成"
}

db_backup() {
    echo "💾 备份数据库..."
    check_db_container
    
    # 创建备份目录
    mkdir -p backups
    
    # 生成备份文件名
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_file="backups/${DB_NAME}_backup_${timestamp}.sql"
    
    # 执行备份
    docker-compose exec -T ttpolyglot-db pg_dump -U $DB_USER $DB_NAME > "$backup_file"
    
    echo "✅ 数据库备份完成: $backup_file"
    
    # 显示备份文件大小
    size=$(du -h "$backup_file" | cut -f1)
    echo "📊 备份文件大小: $size"
}

db_restore() {
    backup_file=$1
    
    if [ -z "$backup_file" ]; then
        echo "❌ 错误: 请指定备份文件"
        echo "用法: $0 restore <backup_file>"
        return 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        echo "❌ 错误: 备份文件不存在: $backup_file"
        return 1
    fi
    
    echo "📥 恢复数据库..."
    check_db_container
    
    echo "⚠️  警告: 这将覆盖数据库 '$DB_NAME' 的所有数据!"
    read -p "确认继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        return 0
    fi
    
    # 删除并重新创建数据库
    db_reset
    
    # 恢复数据
    docker-compose exec -T ttpolyglot-db psql -U $DB_USER -d $DB_NAME < "$backup_file"
    
    echo "✅ 数据库恢复完成"
}

db_migrate() {
    echo "🔧 运行数据库迁移..."
    echo "注意: 迁移将在服务器启动时自动运行"
    echo "如需手动运行迁移，请启动服务器: dart run bin/server.dart"
}

db_seed() {
    echo "🌱 运行种子数据..."
    echo "注意: 种子数据将在服务器启动时自动运行（如果数据库为空）"
    echo "如需手动运行种子数据，请启动服务器: dart run bin/server.dart"
}

db_console() {
    echo "💻 连接到数据库控制台..."
    check_db_container
    
    echo "连接到数据库: $DB_NAME@$DB_USER"
    echo "输入 \q 退出控制台"
    echo ""
    
    docker-compose exec ttpolyglot-db psql -U $DB_USER -d $DB_NAME
}

db_logs() {
    echo "📋 数据库日志..."
    docker-compose logs ttpolyglot-db
}

# 主程序
case "$1" in
    status)
        db_status
        ;;
    create)
        db_create
        ;;
    drop)
        db_drop
        ;;
    reset)
        db_reset
        ;;
    backup)
        db_backup
        ;;
    restore)
        db_restore "$2"
        ;;
    migrate)
        db_migrate
        ;;
    seed)
        db_seed
        ;;
    console)
        db_console
        ;;
    logs)
        db_logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ 错误: 未知命令 '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac
