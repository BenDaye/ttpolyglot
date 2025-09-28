# TTPolyglot 开发脚本编写指南

## 📋 目录
1. [脚本结构规范](#脚本结构规范)
2. [常用脚本模式](#常用脚本模式)
3. [开发工具脚本](#开发工具脚本)
4. [部署脚本](#部署脚本)
5. [测试脚本](#测试脚本)
6. [最佳实践](#最佳实践)

## 🏗️ 脚本结构规范

### 基础模板
```bash
#!/bin/bash

# 脚本名称和描述
# 使用方法: ./scripts/script-name.sh [参数]

set -e  # 遇到错误立即退出

# 加载环境变量
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# 默认配置
DEFAULT_VALUE=${ENV_VAR:-default_value}

# 帮助信息
show_help() {
    echo "脚本名称"
    echo ""
    echo "用法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
    echo "  command1    - 命令描述"
    echo "  command2    - 命令描述"
    echo ""
    echo "示例:"
    echo "  $0 command1  # 示例用法"
}

# 功能函数
function_name() {
    echo "🔧 执行操作..."
    # 具体实现
    echo "✅ 操作完成"
}

# 主程序
case "$1" in
    command1)
        function_name
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ 错误: 未知命令 '$1'"
        show_help
        exit 1
        ;;
esac
```

## 🛠️ 常用脚本模式

### 1. 服务管理脚本
```bash
#!/bin/bash
# 服务管理脚本模板

set -e

SERVICE_NAME="ttpolyglot-server"
PID_FILE="/tmp/${SERVICE_NAME}.pid"

start_service() {
    echo "🚀 启动 $SERVICE_NAME..."
    
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "⚠️  服务已在运行 (PID: $(cat $PID_FILE))"
        return 0
    fi
    
    # 启动服务
    nohup dart run bin/server.dart > logs/server.log 2>&1 &
    echo $! > "$PID_FILE"
    
    # 等待启动
    sleep 3
    
    # 验证启动
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ 服务启动成功"
    else
        echo "❌ 服务启动失败"
        exit 1
    fi
}

stop_service() {
    echo "🛑 停止 $SERVICE_NAME..."
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 $PID 2>/dev/null; then
            kill $PID
            echo "✅ 服务已停止"
        else
            echo "⚠️  服务未运行"
        fi
        rm -f "$PID_FILE"
    else
        echo "⚠️  PID文件不存在"
    fi
}

status_service() {
    echo "📊 检查服务状态..."
    
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "✅ 服务正在运行 (PID: $(cat $PID_FILE))"
        
        # 检查健康状态
        if curl -f http://localhost:8080/health > /dev/null 2>&1; then
            echo "✅ 服务健康"
        else
            echo "⚠️  服务运行但健康检查失败"
        fi
    else
        echo "❌ 服务未运行"
    fi
}
```

### 2. 数据库操作脚本
```bash
#!/bin/bash
# 数据库操作脚本

set -e

# 数据库配置
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-ttpolyglot}
DB_USER=${DB_USER:-ttpolyglot}
DB_PASSWORD=${DB_PASSWORD:-password}

# 连接字符串
DB_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"

check_db_connection() {
    echo "🔍 检查数据库连接..."
    
    if docker-compose exec ttpolyglot-db pg_isready -U $DB_USER -d $DB_NAME > /dev/null 2>&1; then
        echo "✅ 数据库连接正常"
        return 0
    else
        echo "❌ 数据库连接失败"
        return 1
    fi
}

run_migrations() {
    echo "🔧 运行数据库迁移..."
    
    if check_db_connection; then
        dart run scripts/migrate.dart
        echo "✅ 迁移完成"
    else
        echo "❌ 无法连接数据库"
        exit 1
    fi
}

backup_database() {
    echo "💾 备份数据库..."
    
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_file="backups/${DB_NAME}_backup_${timestamp}.sql"
    
    mkdir -p backups
    
    docker-compose exec -T ttpolyglot-db pg_dump -U $DB_USER $DB_NAME > "$backup_file"
    
    echo "✅ 备份完成: $backup_file"
    echo "📊 文件大小: $(du -h "$backup_file" | cut -f1)"
}
```

### 3. 开发环境脚本
```bash
#!/bin/bash
# 开发环境管理脚本

set -e

setup_dev_environment() {
    echo "🔧 设置开发环境..."
    
    # 检查依赖
    check_dependencies
    
    # 启动基础服务
    start_infrastructure
    
    # 运行迁移
    run_migrations
    
    # 启动应用
    start_application
    
    echo "✅ 开发环境设置完成"
}

check_dependencies() {
    echo "🔍 检查依赖..."
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker 未安装"
        exit 1
    fi
    
    # 检查Dart
    if ! command -v dart &> /dev/null; then
        echo "❌ Dart 未安装"
        exit 1
    fi
    
    # 检查jq
    if ! command -v jq &> /dev/null; then
        echo "❌ jq 未安装，请运行: brew install jq"
        exit 1
    fi
    
    echo "✅ 依赖检查通过"
}

start_infrastructure() {
    echo "🚀 启动基础设施服务..."
    
    # 启动数据库和Redis
    docker-compose up -d ttpolyglot-db ttpolyglot-redis
    
    # 等待服务启动
    echo "⏳ 等待服务启动..."
    sleep 10
    
    # 验证服务
    if docker-compose ps | grep -q "ttpolyglot-db.*Up"; then
        echo "✅ 数据库启动成功"
    else
        echo "❌ 数据库启动失败"
        exit 1
    fi
}
```

## 🧪 测试脚本

### 单元测试脚本
```bash
#!/bin/bash
# 测试脚本

set -e

run_tests() {
    echo "🧪 运行测试..."
    
    # 运行单元测试
    dart test
    
    # 运行集成测试
    dart test test/integration/
    
    echo "✅ 测试完成"
}

run_coverage() {
    echo "📊 生成测试覆盖率报告..."
    
    dart test --coverage=coverage
    dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
    
    echo "✅ 覆盖率报告生成完成: coverage/lcov.info"
}

run_lint() {
    echo "🔍 运行代码检查..."
    
    dart analyze
    
    echo "✅ 代码检查完成"
}
```

## 🚀 部署脚本

### 生产部署脚本
```bash
#!/bin/bash
# 生产部署脚本

set -e

ENVIRONMENT=${1:-production}

deploy() {
    echo "🚀 部署到 $ENVIRONMENT 环境..."
    
    # 备份当前版本
    backup_current_version
    
    # 拉取最新代码
    pull_latest_code
    
    # 安装依赖
    install_dependencies
    
    # 运行迁移
    run_migrations
    
    # 重启服务
    restart_services
    
    # 健康检查
    health_check
    
    echo "✅ 部署完成"
}

backup_current_version() {
    echo "💾 备份当前版本..."
    
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="backups/deploy_${timestamp}"
    
    mkdir -p "$backup_dir"
    cp -r . "$backup_dir/"
    
    echo "✅ 备份完成: $backup_dir"
}

pull_latest_code() {
    echo "📥 拉取最新代码..."
    
    git pull origin main
    
    echo "✅ 代码更新完成"
}

install_dependencies() {
    echo "📦 安装依赖..."
    
    dart pub get
    
    echo "✅ 依赖安装完成"
}

restart_services() {
    echo "🔄 重启服务..."
    
    # 停止现有服务
    pkill -f "dart run bin/server.dart" || true
    
    # 启动新服务
    nohup dart run bin/server.dart > logs/server.log 2>&1 &
    
    echo "✅ 服务重启完成"
}

health_check() {
    echo "🔍 健康检查..."
    
    # 等待服务启动
    sleep 5
    
    # 检查服务状态
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        echo "✅ 服务健康"
    else
        echo "❌ 服务不健康"
        exit 1
    fi
}
```

## 📝 最佳实践

### 1. 错误处理
```bash
# 使用 set -e 遇到错误立即退出
set -e

# 使用 trap 处理清理工作
cleanup() {
    echo "🧹 清理临时文件..."
    rm -f /tmp/temp_file
}

trap cleanup EXIT

# 检查命令执行结果
if ! command_name; then
    echo "❌ 命令执行失败"
    exit 1
fi
```

### 2. 日志记录
```bash
# 创建日志目录
mkdir -p logs

# 记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a logs/script.log
}

log "开始执行操作"
```

### 3. 配置管理
```bash
# 加载环境变量
load_env() {
    if [ -f ".env" ]; then
        export $(cat .env | grep -v '^#' | xargs)
    fi
}

# 使用默认值
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
```

### 4. 用户交互
```bash
# 确认操作
confirm() {
    read -p "确认继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "操作已取消"
        exit 0
    fi
}

# 选择菜单
show_menu() {
    echo "请选择操作:"
    echo "1) 启动服务"
    echo "2) 停止服务"
    echo "3) 重启服务"
    echo "4) 查看状态"
    read -p "输入选择 (1-4): " choice
}
```

### 5. 进度显示
```bash
# 显示进度条
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    
    printf "\r进度: [%-50s] %d%% (%d/%d)" \
        $(printf "%*s" $((percent/2)) | tr ' ' '=') \
        $percent $current $total
}

# 使用示例
for i in {1..10}; do
    show_progress $i 10
    sleep 1
done
echo
```

## 🎯 脚本命名规范

### 文件命名
- `start-*.sh` - 启动脚本
- `stop-*.sh` - 停止脚本
- `restart-*.sh` - 重启脚本
- `status-*.sh` - 状态检查脚本
- `backup-*.sh` - 备份脚本
- `deploy-*.sh` - 部署脚本
- `test-*.sh` - 测试脚本
- `dev-*.sh` - 开发工具脚本

### 函数命名
- `start_*()` - 启动相关函数
- `stop_*()` - 停止相关函数
- `check_*()` - 检查相关函数
- `backup_*()` - 备份相关函数
- `restore_*()` - 恢复相关函数

## 📚 示例脚本

基于现有项目，这里是一些实用的开发脚本示例：

### 1. 开发环境快速启动
```bash
#!/bin/bash
# scripts/dev-start.sh - 开发环境快速启动

set -e

echo "🚀 启动 TTPolyglot 开发环境"
echo "============================="

# 检查依赖
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    exit 1
fi

if ! command -v dart &> /dev/null; then
    echo "❌ Dart 未安装"
    exit 1
fi

# 启动基础设施
echo "🔧 启动基础设施服务..."
docker-compose up -d ttpolyglot-db ttpolyglot-redis

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 启动应用
echo "🚀 启动应用服务器..."
dart run bin/server.dart &

# 等待应用启动
echo "⏳ 等待应用启动..."
sleep 5

# 验证服务
echo "🔍 验证服务..."
if curl -f http://localhost:8080/api/v1/version > /dev/null 2>&1; then
    echo "✅ 开发环境启动成功！"
    echo "🌐 访问地址: http://localhost:8080"
else
    echo "❌ 应用启动失败"
    exit 1
fi
```

### 2. 数据库管理脚本
```bash
#!/bin/bash
# scripts/db-manage.sh - 数据库管理脚本

set -e

show_help() {
    echo "数据库管理工具"
    echo ""
    echo "用法: $0 <命令>"
    echo ""
    echo "命令:"
    echo "  status    - 查看数据库状态"
    echo "  backup    - 备份数据库"
    echo "  restore    - 恢复数据库"
    echo "  reset     - 重置数据库"
    echo "  console   - 打开数据库控制台"
}

db_status() {
    echo "📊 数据库状态:"
    docker-compose ps ttpolyglot-db
    echo ""
    echo "🔍 连接测试:"
    if docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot; then
        echo "✅ 数据库连接正常"
    else
        echo "❌ 数据库连接失败"
    fi
}

db_backup() {
    echo "💾 备份数据库..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_file="backups/ttpolyglot_backup_${timestamp}.sql"
    
    mkdir -p backups
    docker-compose exec -T ttpolyglot-db pg_dump -U ttpolyglot ttpolyglot > "$backup_file"
    
    echo "✅ 备份完成: $backup_file"
}

case "$1" in
    status)
        db_status
        ;;
    backup)
        db_backup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        show_help
        exit 1
        ;;
esac
```

这个指南提供了完整的开发脚本编写规范和实践，你可以根据具体需求创建相应的脚本。
