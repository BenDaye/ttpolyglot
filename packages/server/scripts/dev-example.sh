#!/bin/bash

# TTPolyglot 开发脚本使用示例
# 演示如何使用各种开发脚本

set -e

echo "📚 TTPolyglot 开发脚本使用示例"
echo "==============================="
echo ""

# 显示所有可用的开发脚本
show_available_scripts() {
    echo "🛠️  可用的开发脚本:"
    echo "==================="
    echo ""
    echo "📋 环境管理:"
    echo "  ./scripts/dev-start.sh     - 启动开发环境"
    echo "  ./scripts/dev-stop.sh      - 停止开发环境"
    echo "  ./scripts/dev-status.sh    - 查看环境状态"
    echo ""
    echo "🗄️  数据库管理:"
    echo "  ./scripts/db-utils.sh status    - 数据库状态"
    echo "  ./scripts/db-utils.sh backup   - 备份数据库"
    echo "  ./scripts/db-utils.sh restore  - 恢复数据库"
    echo "  ./scripts/db-utils.sh console  - 数据库控制台"
    echo ""
    echo "🌐 生产环境:"
    echo "  ./scripts/start-nginx-simple.sh - 启动Nginx代理"
    echo ""
    echo "📊 其他工具:"
    echo "  ./scripts/migrate.dart          - 数据库迁移"
    echo ""
}

# 演示完整开发流程
demo_development_workflow() {
    echo "🚀 完整开发流程演示:"
    echo "==================="
    echo ""
    
    echo "1️⃣ 启动开发环境:"
    echo "   ./scripts/dev-start.sh"
    echo ""
    
    echo "2️⃣ 检查环境状态:"
    echo "   ./scripts/dev-status.sh"
    echo ""
    
    echo "3️⃣ 数据库操作:"
    echo "   ./scripts/db-utils.sh status    # 查看数据库状态"
    echo "   ./scripts/db-utils.sh backup    # 备份数据库"
    echo "   ./scripts/db-utils.sh console   # 打开数据库控制台"
    echo ""
    
    echo "4️⃣ 开发调试:"
    echo "   tail -f logs/server.log        # 查看应用日志"
    echo "   curl http://localhost:8080/api/v1/version  # 测试API"
    echo ""
    
    echo "5️⃣ 停止开发环境:"
    echo "   ./scripts/dev-stop.sh"
    echo ""
}

# 演示常见问题解决
demo_troubleshooting() {
    echo "🔧 常见问题解决:"
    echo "==============="
    echo ""
    
    echo "❌ 应用服务器启动失败:"
    echo "   1. 检查端口占用: lsof -i :8080"
    echo "   2. 查看日志: tail -f logs/server.log"
    echo "   3. 重启应用: pkill -f 'dart run bin/server.dart' && dart run bin/server.dart &"
    echo ""
    
    echo "❌ 数据库连接失败:"
    echo "   1. 检查容器状态: docker-compose ps"
    echo "   2. 重启数据库: docker-compose restart ttpolyglot-db"
    echo "   3. 查看数据库日志: docker-compose logs ttpolyglot-db"
    echo ""
    
    echo "❌ Redis连接失败:"
    echo "   1. 检查容器状态: docker-compose ps"
    echo "   2. 重启Redis: docker-compose restart ttpolyglot-redis"
    echo "   3. 查看Redis日志: docker-compose logs ttpolyglot-redis"
    echo ""
    
    echo "❌ 端口冲突:"
    echo "   1. 查看端口使用: lsof -i :8080"
    echo "   2. 停止冲突进程: kill -9 <PID>"
    echo "   3. 修改配置: 编辑 .env 文件"
    echo ""
}

# 演示脚本编写最佳实践
demo_script_best_practices() {
    echo "📝 脚本编写最佳实践:"
    echo "==================="
    echo ""
    
    echo "✅ 脚本结构:"
    echo "   #!/bin/bash"
    echo "   set -e  # 遇到错误立即退出"
    echo "   # 加载环境变量"
    echo "   # 定义函数"
    echo "   # 主程序逻辑"
    echo ""
    
    echo "✅ 错误处理:"
    echo "   if ! command_name; then"
    echo "       echo '❌ 命令执行失败'"
    echo "       exit 1"
    echo "   fi"
    echo ""
    
    echo "✅ 用户交互:"
    echo "   read -p '确认继续? (y/N): ' -n 1 -r"
    echo "   if [[ ! \$REPLY =~ ^[Yy]\$ ]]; then"
    echo "       echo '操作已取消'"
    echo "       exit 0"
    echo "   fi"
    echo ""
    
    echo "✅ 日志记录:"
    echo "   echo '[$(date)] 操作开始' | tee -a logs/script.log"
    echo ""
    
    echo "✅ 状态检查:"
    echo "   if curl -f http://localhost:8080/health > /dev/null 2>&1; then"
    echo "       echo '✅ 服务正常'"
    echo "   else"
    echo "       echo '❌ 服务异常'"
    echo "   fi"
    echo ""
}

# 演示自定义脚本创建
demo_custom_script() {
    echo "🛠️  创建自定义脚本示例:"
    echo "======================="
    echo ""
    
    echo "📄 创建新脚本模板:"
    echo "   #!/bin/bash"
    echo "   # 脚本名称和描述"
    echo "   # 使用方法: ./scripts/script-name.sh [参数]"
    echo ""
    echo "   set -e"
    echo ""
    echo "   # 加载环境变量"
    echo "   if [ -f '.env' ]; then"
    echo "       export \$(cat .env | grep -v '^#' | xargs)"
    echo "   fi"
    echo ""
    echo "   # 帮助信息"
    echo "   show_help() {"
    echo "       echo '脚本名称'"
    echo "       echo '用法: \$0 <命令>'"
    echo "   }"
    echo ""
    echo "   # 功能函数"
    echo "   function_name() {"
    echo "       echo '🔧 执行操作...'"
    echo "       # 具体实现"
    echo "       echo '✅ 操作完成'"
    echo "   }"
    echo ""
    echo "   # 主程序"
    echo "   case \"\$1\" in"
    echo "       command)"
    echo "           function_name"
    echo "           ;;"
    echo "       help|--help|-h)"
    echo "           show_help"
    echo "           ;;"
    echo "       *)"
    echo "           echo '❌ 错误: 未知命令'"
    echo "           show_help"
    echo "           exit 1"
    echo "           ;;"
    echo "   esac"
    echo ""
}

# 主程序
main() {
    show_available_scripts
    echo ""
    demo_development_workflow
    echo ""
    demo_troubleshooting
    echo ""
    demo_script_best_practices
    echo ""
    demo_custom_script
}

# 运行主程序
main "$@"
