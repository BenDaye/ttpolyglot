# Docker 智能启动脚本说明

## 📋 概述

`start-docker.sh` 是一个智能 Docker 启动脚本，能够**自动读取 `.env` 文件中的 `ENVIRONMENT` 配置**来判断启动生产环境还是开发环境。

## 🎯 核心特性

### 1. 自动环境检测
- 📄 读取 `.env` 文件中的 `ENVIRONMENT` 变量
- 🔄 根据配置值自动选择启动模式
- ⚙️ 支持的环境值：
  - `production` / `prod` → 启动生产环境
  - `development` / `develop` / `dev` → 启动开发环境
  - 未设置或其他值 → 默认开发环境

### 2. 环境配置示例

**开发环境 `.env`:**
```bash
ENVIRONMENT=develop
# 或
ENVIRONMENT=development
# 或
ENVIRONMENT=dev
```

**生产环境 `.env`:**
```bash
ENVIRONMENT=production
# 或
ENVIRONMENT=prod
```

## 📖 使用方法

### 基本用法

```bash
# 根据 .env 自动判断环境启动
./scripts/start-docker.sh

# 或者使用完整路径
cd /path/to/packages/server
./scripts/start-docker.sh
```

### 命令格式

```bash
./scripts/start-docker.sh [操作] [选项]
```

**操作**:
- `start` (默认) - 启动服务
- `stop` - 停止服务
- `restart` - 重启服务
- `status` - 查看服务状态
- `logs` - 查看服务日志
- `clean` - 清理容器和数据
- `rebuild` - 重新构建并启动

**选项**:
- `--detach` / `-d` - 后台运行（默认）
- `--foreground` / `-f` - 前台运行，显示实时日志
- `--build` - 强制重新构建镜像
- `--clean` - 启动前清理旧容器
- `--no-migrate` - 跳过数据库迁移

## 🔧 使用示例

### 1. 日常使用

```bash
# 启动服务（自动检测环境）
./scripts/start-docker.sh

# 停止服务
./scripts/start-docker.sh stop

# 重启服务
./scripts/start-docker.sh restart

# 查看状态
./scripts/start-docker.sh status

# 查看日志
./scripts/start-docker.sh logs

# 实时查看日志
./scripts/start-docker.sh logs -f
```

### 2. 开发场景

```bash
# 前台运行查看日志（方便调试）
./scripts/start-docker.sh start --foreground

# 重新构建并启动
./scripts/start-docker.sh rebuild

# 清理后重新启动
./scripts/start-docker.sh start --clean --build
```

### 3. 生产场景

```bash
# 确保 .env 设置为生产环境
echo "ENVIRONMENT=production" > .env

# 首次部署
./scripts/start-docker.sh start --build

# 更新部署
./scripts/start-docker.sh rebuild

# 查看服务状态
./scripts/start-docker.sh status
```

## 🔄 环境切换

### 切换到开发环境

```bash
# 1. 修改 .env 文件
sed -i '' 's/ENVIRONMENT=.*/ENVIRONMENT=develop/' .env

# 2. 重启服务
./scripts/start-docker.sh restart
```

### 切换到生产环境

```bash
# 1. 修改 .env 文件
sed -i '' 's/ENVIRONMENT=.*/ENVIRONMENT=production/' .env

# 2. 重启服务
./scripts/start-docker.sh restart
```

## 🌐 环境差异

### 开发环境 (ENVIRONMENT=develop)
- ✅ 使用 `docker-compose.yml` 基础配置
- ✅ 不启动 Nginx（直接访问应用端口 8080）
- ✅ 详细日志输出 (LOG_LEVEL=debug)
- ✅ 可能暴露数据库端口（便于本地工具连接）
- ✅ 代码热重载（如果配置了卷映射）
- ✅ 不强制 SSL
- 📍 访问地址: `http://localhost:8080`

### 生产环境 (ENVIRONMENT=production)
- ✅ 使用 `docker-compose.yml` + profile 配置
- ✅ 启动 Nginx 反向代理
- ✅ 标准日志输出 (LOG_LEVEL=info)
- ✅ 数据库端口不对外暴露（仅内网）
- ✅ 自动重启策略
- ✅ SSL/TLS 支持
- ✅ 资源限制和优化
- 📍 访问地址: `http://localhost` 或 `https://your-domain.com`

## 📁 .env 文件完整示例

### 开发环境 .env

```bash
# 环境配置（关键）
ENVIRONMENT=develop

# 数据库配置
DB_NAME=ttpolyglot_dev
DB_USER=ttpolyglot
DB_PASSWORD=dev_password_123

# Redis 配置
REDIS_PASSWORD=

# JWT 配置
JWT_SECRET=dev-jwt-secret-key

# 日志配置
LOG_LEVEL=debug

# 服务器配置
SERVER_PORT=8080
SERVER_HOST=0.0.0.0
```

### 生产环境 .env

```bash
# 环境配置（关键）
ENVIRONMENT=production

# 数据库配置
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=your_strong_password_here

# Redis 配置
REDIS_PASSWORD=your_redis_password

# JWT 配置
JWT_SECRET=your_jwt_secret_key_here

# 日志配置
LOG_LEVEL=info

# 服务器配置
SERVER_PORT=8080
SERVER_HOST=0.0.0.0
```

## 🔍 脚本工作流程

```
1. 检查前置条件
   ├─ Docker 是否安装
   ├─ Docker Compose 是否安装
   └─ .env 文件是否存在

2. 读取环境配置
   ├─ 从 .env 读取 ENVIRONMENT 变量
   ├─ 判断环境类型（develop/production）
   └─ 显示当前环境

3. 检查端口占用
   ├─ 开发环境: 检查 8080, 5432, 6379
   └─ 生产环境: 检查 80, 443

4. 根据环境启动服务
   ├─ 开发环境: docker-compose up（不含 Nginx）
   └─ 生产环境: docker-compose --profile production up

5. 等待服务健康检查
   ├─ PostgreSQL 健康检查
   ├─ Redis 健康检查
   └─ 应用服务健康检查

6. 自动运行数据库迁移
   └─ docker-compose exec server dart run scripts/migrate.dart

7. 显示服务信息
   ├─ 服务 URL
   ├─ 数据库连接信息
   └─ 日志查看命令
```

## ⚙️ 配置文件要求

### 必需文件
- ✅ `.env` - 环境变量配置（**必须包含 ENVIRONMENT**）
- ✅ `docker-compose.yml` - Docker Compose 配置
- ✅ `Dockerfile` - 应用镜像定义

### 可选文件
- `docker-compose.override.yml` - 本地覆盖配置
- `.env.example` - 环境变量示例

## 🐛 故障排除

### 问题 1: 脚本无法读取 .env

**症状**: 提示 "未找到 .env 文件"

**解决方案**:
```bash
# 检查文件是否存在
ls -la .env

# 创建 .env 文件
cp .env.example .env
# 或
echo "ENVIRONMENT=develop" > .env
```

### 问题 2: 环境未正确识别

**症状**: 环境检测不正确

**解决方案**:
```bash
# 检查 .env 文件内容
cat .env | grep ENVIRONMENT

# 确保格式正确（无空格）
ENVIRONMENT=develop  # ✅ 正确
ENVIRONMENT = develop  # ❌ 错误（有空格）
ENVIRONMENT="develop"  # ✅ 可以（有引号）
```

### 问题 3: 端口已被占用

**症状**: 启动失败，提示端口被占用

**解决方案**:
```bash
# 查看占用端口的进程
lsof -i :8080  # 开发环境
lsof -i :80    # 生产环境

# 停止占用端口的进程
kill -9 <PID>

# 或修改 .env 中的端口配置
```

### 问题 4: 数据库迁移失败

**症状**: 启动成功但数据库未初始化

**解决方案**:
```bash
# 手动运行迁移
docker-compose exec ttpolyglot-server dart run scripts/migrate.dart

# 查看迁移状态
docker-compose exec ttpolyglot-server dart run scripts/migrate.dart status
```

## 📊 服务管理

### 查看运行的容器

```bash
# 所有容器
docker-compose ps

# 或使用脚本
./scripts/start-docker.sh status
```

### 查看日志

```bash
# 所有服务日志
./scripts/start-docker.sh logs

# 特定服务
docker-compose logs ttpolyglot-server
docker-compose logs ttpolyglot-db

# 实时跟踪
./scripts/start-docker.sh logs -f
```

### 进入容器

```bash
# 进入应用容器
docker-compose exec ttpolyglot-server sh

# 进入数据库容器
docker-compose exec ttpolyglot-db psql -U ttpolyglot
```

### 清理环境

```bash
# 温和清理（保留数据卷）
./scripts/start-docker.sh clean

# 完全清理（删除所有数据）
./scripts/start-docker.sh clean --volumes

# 手动清理
docker-compose down -v
docker system prune -a
```

## 🔒 安全建议

### 开发环境
1. ✅ 使用简单密码即可
2. ✅ 可以暴露数据库端口
3. ⚠️ 不要在开发环境使用生产数据

### 生产环境
1. ✅ 必须使用强密码（至少 32 位随机字符）
2. ✅ 不对外暴露数据库和 Redis 端口
3. ✅ 启用 SSL/TLS
4. ✅ 定期备份数据
5. ✅ 配置防火墙
6. ✅ 使用 Docker secrets 管理敏感信息

## 🚀 快速开始

### 首次使用（开发环境）

```bash
# 1. 进入项目目录
cd packages/server

# 2. 创建 .env 文件
cat > .env << EOF
ENVIRONMENT=develop
DB_NAME=ttpolyglot_dev
DB_USER=ttpolyglot
DB_PASSWORD=dev123
REDIS_PASSWORD=
JWT_SECRET=dev-secret
LOG_LEVEL=debug
EOF

# 3. 启动服务
./scripts/start-docker.sh

# 4. 访问应用
open http://localhost:8080/health
```

### 首次使用（生产环境）

```bash
# 1. 进入项目目录
cd packages/server

# 2. 创建安全的 .env 文件
cat > .env << EOF
ENVIRONMENT=production
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 64)
LOG_LEVEL=info
EOF

# 3. 配置 SSL 证书（如果有）
mkdir -p ssl
cp /path/to/certificate.crt ssl/
cp /path/to/private.key ssl/

# 4. 构建并启动
./scripts/start-docker.sh start --build

# 5. 验证服务
curl http://localhost/health
```

## 📞 获取帮助

```bash
# 显示帮助信息
./scripts/start-docker.sh --help

# 显示版本信息
./scripts/start-docker.sh --version

# 显示当前环境配置
./scripts/start-docker.sh info
```

## 📚 相关文档

- [Docker Compose 配置](../docker-compose.yml)
- [数据库迁移指南](./migrate.dart)
- [开发环境设置](../DEVELOPMENT_SETUP.md)
- [生产部署指南](../PRODUCTION_DEPLOYMENT.md)

---

**脚本特性总结**:
- ✅ 自动读取 `.env` 中的 `ENVIRONMENT` 配置
- ✅ 智能判断启动生产或开发环境
- ✅ 完整的前置检查（Docker、端口、配置）
- ✅ 自动健康检查等待
- ✅ 自动运行数据库迁移
- ✅ 彩色输出和进度提示
- ✅ 详细的错误提示和解决建议
- ✅ 支持多种操作（start/stop/restart/status/logs/clean）

**最后更新**: 2025-01-11  
**维护者**: TTPolyglot Team

