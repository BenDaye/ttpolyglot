#!/bin/bash

# TTPolyglot Docker 智能启动脚本
# 版本: 1.0.0
# 说明: 自动读取 .env 中的 ENVIRONMENT 配置，智能启动生产或开发环境

set -e  # 遇到错误立即退出

# ==================== 颜色定义 ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ==================== 工具函数 ====================

# 打印成功信息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 打印错误信息
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 打印警告信息
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 打印信息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 打印标题
print_header() {
    echo -e "${BOLD}${CYAN}$1${NC}"
}

# 打印分隔线
print_separator() {
    echo -e "${CYAN}========================================${NC}"
}

# ==================== 环境检测 ====================

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装"
        print_info "请访问 https://docs.docker.com/get-docker/ 安装 Docker"
        exit 1
    fi
    
    # 检查 Docker 是否运行
    if ! docker info &> /dev/null; then
        print_error "Docker 未运行"
        print_info "请启动 Docker Desktop 或 Docker 服务"
        exit 1
    fi
    
    print_success "Docker 已安装且正在运行"
}

# 检查 Docker Compose 是否安装
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose 未安装"
        print_info "请访问 https://docs.docker.com/compose/install/ 安装 Docker Compose"
        exit 1
    fi
    
    print_success "Docker Compose 已安装"
}

# 检查配置文件
check_config_files() {
    local missing_files=()
    
    if [ ! -f ".env" ]; then
        missing_files+=(".env")
    fi
    
    if [ ! -f "docker-compose.yml" ]; then
        missing_files+=("docker-compose.yml")
    fi
    
    if [ ! -f "Dockerfile" ]; then
        missing_files+=("Dockerfile")
    fi
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "缺少必需的配置文件:"
        
        if [[ " ${missing_files[@]} " =~ " .env " ]]; then
            print_info "创建 .env 文件"
            cp .env.example .env
        fi
    fi
    
    print_success "配置文件检查通过"
}

# 读取环境配置
load_environment() {
    # 加载 .env 文件
    if [ -f ".env" ]; then
        export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)
    fi
    
    # 获取 ENVIRONMENT 变量，默认为 production
    ENVIRONMENT=${ENVIRONMENT:-production}
    
    # 转换为小写（兼容旧版 bash）
    ENVIRONMENT_LOWER=$(echo "$ENVIRONMENT" | tr '[:upper:]' '[:lower:]')
    
    # 判断环境类型
    case "$ENVIRONMENT_LOWER" in
        production|prod)
            ENV_MODE="production"
            COMPOSE_PROFILE="--profile production"
            ENV_DISPLAY="生产环境 (Production)"
            # 生产环境只使用基础 docker-compose.yml
            COMPOSE_FILES="-f docker-compose.yml"
            ;;
        development|develop|dev)
            ENV_MODE="development"
            COMPOSE_PROFILE=""
            ENV_DISPLAY="开发环境 (Development) - 代码热重载"
            # 开发环境使用 docker-compose.yml + docker-compose.dev.yml
            COMPOSE_FILES="-f docker-compose.yml -f docker-compose.dev.yml"
            ;;
        *)
            ENV_MODE="development"
            COMPOSE_PROFILE=""
            ENV_DISPLAY="开发环境 (Development) - 代码热重载 - 默认"
            print_warning "ENVIRONMENT 值 '$ENVIRONMENT' 未识别，使用开发环境"
            # 默认使用开发环境配置
            COMPOSE_FILES="-f docker-compose.yml -f docker-compose.dev.yml"
            ;;
    esac
    
    print_info "当前环境: ${BOLD}${ENV_DISPLAY}${NC}"
    if [ "$ENV_MODE" = "development" ]; then
        print_info "开发模式: 已启用代码热重载，修改代码后会自动重启"
    fi
}

# 检查端口占用
check_ports() {
    local ports=()
    
    # Nginx端口（所有环境都需要检查）
    local nginx_http_port=${NGINX_HTTP_PORT:-8080}
    local nginx_https_port=${NGINX_HTTPS_PORT:-4433}
    
    # 生产环境使用默认的80/443，开发环境使用8080/4433
    if [ "$ENV_MODE" = "production" ]; then
        nginx_http_port=${NGINX_HTTP_PORT:-80}
        nginx_https_port=${NGINX_HTTPS_PORT:-443}
    fi
    
    ports=($nginx_http_port $nginx_https_port)
    print_info "检查 Nginx 端口: ${nginx_http_port}, ${nginx_https_port}"
    
    local occupied_ports=()
    
    for port in "${ports[@]}"; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            occupied_ports+=($port)
        fi
    done
    
    if [ ${#occupied_ports[@]} -gt 0 ]; then
        print_warning "以下端口已被占用: ${occupied_ports[*]}"
        print_info "如果是之前的 Docker 服务占用，将自动处理"
        print_info "如果是其他进程占用，可能需要手动停止"
    else
        print_success "端口检查通过"
    fi
}

# ==================== Docker 操作 ====================

# 启动服务
start_services() {
    local BUILD_FLAG=""
    local DETACH_FLAG="-d"
    local RUN_MIGRATE=true
    
    # 解析选项
    for arg in "$@"; do
        case $arg in
            --build)
                BUILD_FLAG="--build"
                ;;
            --foreground|-f)
                DETACH_FLAG=""
                ;;
            --clean)
                print_info "清理旧容器..."
                docker-compose $COMPOSE_FILES down
                ;;
            --no-migrate)
                RUN_MIGRATE=false
                ;;
        esac
    done
    
    print_header "启动 TTPolyglot 服务 - ${ENV_DISPLAY}"
    print_separator
    
    # 创建必要的目录
    print_info "创建必要的目录..."
    mkdir -p data logs/nginx logs/postgres logs/redis ssl uploads
    
    # 启动服务
    print_info "启动 Docker 服务..."
    if [ -n "$BUILD_FLAG" ]; then
        print_info "重新构建镜像..."
    fi
    
    if [ -n "$DETACH_FLAG" ]; then
        docker-compose $COMPOSE_FILES $COMPOSE_PROFILE up $DETACH_FLAG $BUILD_FLAG
    else
        print_warning "前台模式：按 Ctrl+C 停止服务"
        docker-compose $COMPOSE_FILES $COMPOSE_PROFILE up $BUILD_FLAG
        return 0
    fi
    
    # 等待服务健康检查
    print_info "等待服务启动..."
    sleep 5
    
    # 等待数据库健康检查
    print_info "等待 PostgreSQL 健康检查..."
    local count=0
    local max_wait=60
    while [ $count -lt $max_wait ]; do
        if docker-compose $COMPOSE_FILES exec -T ttpolyglot-db pg_isready -U ${DB_USER:-ttpolyglot} &> /dev/null; then
            print_success "PostgreSQL 已就绪"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    if [ $count -ge $max_wait ]; then
        print_error "PostgreSQL 健康检查超时"
        print_info "请使用以下命令查看日志："
        echo "  docker-compose $COMPOSE_FILES logs ttpolyglot-db"
    fi
    
    # 等待 Redis 健康检查
    print_info "等待 Redis 健康检查..."
    count=0
    while [ $count -lt $max_wait ]; do
        if docker-compose $COMPOSE_FILES exec -T ttpolyglot-redis redis-cli ping &> /dev/null; then
            print_success "Redis 已就绪"
            break
        fi
        sleep 2
        count=$((count + 2))
    done
    
    # 运行数据库迁移
    if [ "$RUN_MIGRATE" = true ]; then
        print_info "运行数据库迁移和种子数据..."
        sleep 3  # 等待应用完全启动
        
        if docker-compose $COMPOSE_FILES exec -T ttpolyglot-server /app/migrate; then
            print_success "数据库迁移完成"
        else
            print_warning "数据库迁移失败，请手动执行："
            echo "sh ./migrate.sh"
        fi
    fi
    
    # 显示服务信息
    print_separator
    print_success "服务启动成功！"
    print_separator
    
    echo -e "${BOLD}访问地址:${NC}"
    echo "  HTTP:  http://localhost:${NGINX_HTTP_PORT:-8080}"
    echo "  HTTPS: https://localhost:${NGINX_HTTPS_PORT:-4433}"
    echo "  健康检查: http://localhost:${NGINX_HTTP_PORT:-8080}/health"
    echo ""
    
    echo -e "${BOLD}管理命令:${NC}"
    echo "  查看状态: ./start-docker.sh status"
    echo "  查看日志: ./start-docker.sh logs"
    echo "  停止服务: ./start-docker.sh stop"
    echo ""
    
    echo -e "${BOLD}数据库管理:${NC}"
    echo "  数据库连接: docker-compose $COMPOSE_FILES exec ttpolyglot-db psql -U ${DB_USER:-ttpolyglot} -d ${DB_NAME:-ttpolyglot}"
    echo "  运行迁移: sh ./migrate.sh"
    echo "  迁移状态: sh ./migrate.sh status"
    print_separator
}

# 停止服务（不删除容器）
stop_services() {
    print_header "停止 TTPolyglot 服务"
    print_separator
    
    docker-compose $COMPOSE_FILES stop
    
    print_success "服务已停止（容器保留）"
    print_info "如需删除容器，请使用: ./start-docker.sh down"
}

# 停止并删除服务
down_services() {
    print_header "停止并删除 TTPolyglot 服务"
    print_separator
    
    docker-compose $COMPOSE_FILES down
    
    print_success "服务已停止并删除"
}

# 重启服务
restart_services() {
    print_header "重启 TTPolyglot 服务"
    print_separator
    
    down_services
    echo ""
    start_services "$@"
}

# 查看服务状态
show_status() {
    print_header "TTPolyglot 服务状态 - ${ENV_DISPLAY}"
    print_separator
    
    docker-compose $COMPOSE_FILES ps
    
    echo ""
    print_info "容器详细状态："
    docker-compose $COMPOSE_FILES ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
}

# 查看日志
show_logs() {
    print_header "TTPolyglot 服务日志 - ${ENV_DISPLAY}"
    print_separator
    
    # 解析选项
    local LOG_ARGS=""
    for arg in "$@"; do
        case $arg in
            -f|--follow)
                LOG_ARGS="$LOG_ARGS -f"
                ;;
            --tail=*)
                LOG_ARGS="$LOG_ARGS $arg"
                ;;
            *)
                # 服务名称
                LOG_ARGS="$LOG_ARGS $arg"
                ;;
        esac
    done
    
    docker-compose $COMPOSE_FILES logs $LOG_ARGS
}

# 清理环境
clean_environment() {
    print_header "清理 TTPolyglot 环境"
    print_separator
    
    # 检查是否删除卷
    local VOLUMES_FLAG=""
    for arg in "$@"; do
        if [ "$arg" = "--volumes" ] || [ "$arg" = "-v" ]; then
            VOLUMES_FLAG="-v"
            print_warning "将删除所有数据卷（包括数据库数据）！"
            
            read -p "确认继续? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "操作已取消"
                exit 0
            fi
        fi
    done
    
    # 停止并删除容器
    docker-compose $COMPOSE_FILES down $VOLUMES_FLAG
    
    if [ -n "$VOLUMES_FLAG" ]; then
        print_success "容器和数据卷已清理"
    else
        print_success "容器已清理（数据卷保留）"
    fi
    
    # 清理未使用的镜像
    read -p "是否清理未使用的 Docker 镜像? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker image prune -f
        print_success "未使用的镜像已清理"
    fi
}

# 重新构建并启动
rebuild_services() {
    print_header "重新构建 TTPolyglot 服务"
    print_separator
    
    print_info "停止现有服务..."
    docker-compose $COMPOSE_FILES down
    
    print_info "重新构建镜像..."
    docker-compose $COMPOSE_FILES $COMPOSE_PROFILE build --no-cache
    
    print_info "启动服务..."
    start_services --build
}

# 显示环境信息
show_info() {
    print_header "TTPolyglot 环境信息"
    print_separator
    
    echo -e "${BOLD}环境配置:${NC}"
    echo "  环境类型: ${ENV_DISPLAY}"
    echo "  数据库名: ${DB_NAME:-ttpolyglot}"
    echo "  数据库用户: ${DB_USER:-ttpolyglot}"
    echo "  日志级别: ${LOG_LEVEL:-info}"
    echo ""
    
    echo -e "${BOLD}Docker 信息:${NC}"
    echo "  Docker 版本: $(docker --version | cut -d' ' -f3 | tr -d ',')"
    echo "  Docker Compose 版本: $(docker-compose --version | cut -d' ' -f4 | tr -d ',')"
    echo ""
    
    echo -e "${BOLD}通用特性:${NC}"
    echo "  ✅ Nginx 反向代理（所有环境）"
    echo "  ✅ SSL/TLS 支持"
    echo "  ✅ 自动重启"
    echo "  ✅ 健康检查"
    echo ""
    
    if [ "$ENV_MODE" = "production" ]; then
        echo -e "${BOLD}生产环境配置:${NC}"
        echo "  HTTP端口: ${NGINX_HTTP_PORT:-80}"
        echo "  HTTPS端口: ${NGINX_HTTPS_PORT:-443}"
    else
        echo -e "${BOLD}开发环境配置:${NC}"
        echo "  HTTP端口: ${NGINX_HTTP_PORT:-8080}"
        echo "  HTTPS端口: ${NGINX_HTTPS_PORT:-4433}"
        echo "  详细日志输出"
        echo "  调试模式"
    fi
    
    echo ""
    
    # 显示运行中的容器
    if docker-compose $COMPOSE_FILES ps | grep -q "Up"; then
        echo -e "${BOLD}运行中的服务:${NC}"
        docker-compose $COMPOSE_FILES ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    else
        print_info "当前没有运行中的服务"
    fi
}

# 显示帮助信息
show_help() {
    print_header "TTPolyglot Docker 启动脚本"
    print_separator
    
    cat << EOF

${BOLD}用法:${NC}
  ./start-docker.sh [操作] [选项]

${BOLD}操作:${NC}
  start          启动服务（默认，根据 .env 自动判断环境）
  stop           停止服务（保留容器）
  down           停止并删除服务容器
  restart        重启服务
  status         查看服务状态
  logs           查看服务日志
  clean          清理容器和数据
  rebuild        重新构建并启动
  info           显示环境信息
  help           显示此帮助信息

${BOLD}选项:${NC}
  --detach, -d        后台运行（默认）
  --foreground, -f    前台运行，显示实时日志
  --build             强制重新构建镜像
  --clean             启动前清理旧容器
  --no-migrate        跳过数据库迁移
  --volumes, -v       清理时删除数据卷（仅用于 clean）

${BOLD}示例:${NC}
  # 启动服务（自动检测环境）
  ./start-docker.sh

  # 前台运行查看日志
  ./start-docker.sh start --foreground

  # 重新构建并启动
  ./start-docker.sh rebuild

  # 查看状态
  ./start-docker.sh status

  # 查看实时日志
  ./start-docker.sh logs -f

  # 清理环境
  ./start-docker.sh clean

${BOLD}环境配置:${NC}
  脚本会自动读取 .env 文件中的 ENVIRONMENT 变量：
  
  开发环境:
    ENVIRONMENT=develop
    NGINX_HTTP_PORT=8080    # Nginx HTTP端口（默认8080）
    NGINX_HTTPS_PORT=4433   # Nginx HTTPS端口（默认4433）

  生产环境:
    ENVIRONMENT=production
    NGINX_HTTP_PORT=80      # Nginx HTTP端口（默认80）
    NGINX_HTTPS_PORT=443    # Nginx HTTPS端口（默认443）

${BOLD}注意:${NC}
  • Nginx 在所有环境下都会启动
  • 可通过 .env 文件配置 Nginx 端口

${BOLD}更多信息:${NC}
  查看详细文档: ./START_DOCKER_README.md

EOF
}

# 显示版本信息
show_version() {
    echo "TTPolyglot Docker 启动脚本 v1.0.0"
}

# ==================== 主函数 ====================

main() {
    # 获取脚本所在目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # 切换到项目根目录（脚本现在在根目录，所以不需要 /..）
    cd "$SCRIPT_DIR"
    
    print_header "🚀 TTPolyglot Docker 启动脚本"
    print_separator
    
    # 检查前置条件
    check_docker
    check_docker_compose
    check_config_files
    
    # 读取环境配置
    load_environment
    
    print_separator
    
    # 解析命令
    local COMMAND="${1:-start}"
    shift || true
    
    case "$COMMAND" in
        start)
            check_ports
            start_services "$@"
            ;;
        stop)
            stop_services
            ;;
        down)
            down_services
            ;;
        restart)
            restart_services "$@"
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "$@"
            ;;
        clean)
            clean_environment "$@"
            ;;
        rebuild)
            rebuild_services
            ;;
        info)
            show_info
            ;;
        --help|-h|help)
            show_help
            ;;
        --version|-v)
            show_version
            ;;
        *)
            print_error "未知命令: $COMMAND"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"

