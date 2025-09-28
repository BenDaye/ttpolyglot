# TTPolyglot 开发环境设置指南

## 概述

开发环境使用独立的 Docker 容器来提供数据库和 Redis 服务，而应用服务器在本地运行。这种设置允许开发者：

- 快速启动和停止基础设施服务
- 在本地运行应用服务器，便于调试
- 独立管理数据库和 Redis 数据
- 避免在开发环境中产生应用容器

## 文件结构

```
packages/server/
├── docker-compose.dev.yml          # 开发环境基础设施配置
├── scripts/
│   ├── dev-start.sh               # 开发环境启动脚本
│   └── dev-stop.sh                # 开发环境停止脚本
└── .env.dev.example              # 开发环境配置示例
```

## 快速开始

### 1. 启动开发环境

```bash
# 进入服务器目录
cd packages/server

# 启动开发环境
./scripts/dev-start.sh
```

这将：
- 启动 PostgreSQL 数据库容器 (端口 5432)
- 启动 Redis 容器 (端口 6379)
- 在本地运行应用服务器 (端口 8080)

### 2. 停止开发环境

```bash
# 停止所有服务
./scripts/dev-stop.sh
```

### 3. 清理数据

```bash
# 停止并清理所有数据
docker-compose -f docker-compose.dev.yml down -v
```

## 服务配置

### 数据库配置
- **容器名**: `ttpolyglot-dev-db`
- **端口**: `5432`
- **数据库**: `ttpolyglot`
- **用户名**: `ttpolyglot`
- **密码**: `password`

### Redis 配置
- **容器名**: `ttpolyglot-dev-redis`
- **端口**: `6379`
- **密码**: 无（开发环境）

### 应用服务器配置
- **端口**: `8080`
- **数据库连接**: `postgresql://ttpolyglot:password@localhost:5432/ttpolyglot`
- **Redis连接**: `redis://localhost:6379`

## 环境变量

开发环境使用以下默认配置：

```bash
# 数据库配置
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=password
DATABASE_URL=postgresql://ttpolyglot:password@localhost:5432/ttpolyglot

# Redis配置
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=

# JWT配置
JWT_SECRET=dev-jwt-secret-change-in-production

# 服务器配置
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
LOG_LEVEL=debug
ENVIRONMENT=dev
```

## 常用命令

### 查看服务状态
```bash
# 查看容器状态
docker-compose -f docker-compose.dev.yml ps

# 查看应用进程
ps aux | grep "dart run bin/server.dart"
```

### 查看日志
```bash
# 应用日志
tail -f logs/server.log

# 数据库日志
docker-compose -f docker-compose.dev.yml logs ttpolyglot-dev-db

# Redis日志
docker-compose -f docker-compose.dev.yml logs ttpolyglot-dev-redis
```

### 数据库管理
```bash
# 连接数据库
docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db psql -U ttpolyglot -d ttpolyglot

# 备份数据库
docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-db pg_dump -U ttpolyglot ttpolyglot > backup.sql
```

### Redis管理
```bash
# 连接Redis
docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli

# 清空Redis数据
docker-compose -f docker-compose.dev.yml exec ttpolyglot-dev-redis redis-cli FLUSHALL
```

## 故障排除

### 端口冲突
如果遇到端口冲突，可以修改 `docker-compose.dev.yml` 中的端口映射：

```yaml
ports:
  - "5433:5432"  # 将数据库端口改为 5433
  - "6380:6379"  # 将Redis端口改为 6380
```

### 容器启动失败
```bash
# 查看容器日志
docker-compose -f docker-compose.dev.yml logs

# 重启容器
docker-compose -f docker-compose.dev.yml restart
```

### 应用服务器启动失败
```bash
# 查看应用日志
tail -f logs/server.log

# 检查依赖
dart pub get
```

## 与生产环境的区别

| 特性 | 开发环境 | 生产环境 |
|------|----------|----------|
| 应用服务器 | 本地运行 | Docker容器 |
| 数据库 | 独立容器 | 独立容器 |
| Redis | 独立容器 | 独立容器 |
| 数据持久化 | 开发数据卷 | 生产数据卷 |
| 日志级别 | debug | info |
| 热重载 | 支持 | 不支持 |

## 注意事项

1. **数据安全**: 开发环境使用默认密码，不要在生产环境使用
2. **端口管理**: 确保端口 5432、6379、8080 未被其他服务占用
3. **资源清理**: 定期清理不需要的数据卷以节省磁盘空间
4. **环境隔离**: 开发环境与生产环境完全隔离，数据不会相互影响
