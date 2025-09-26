# TTPolyglot 服务端部署方案

## 部署架构

### Docker 容器化部署
使用 Docker Compose 管理多容器应用：
- Nginx (反向代理和负载均衡)
- Dart 应用服务器
- PostgreSQL 数据库
- Redis 缓存

### 系统要求
- Linux 服务器 (推荐 Ubuntu 20.04+)
- Docker 20.10+
- Docker Compose 2.0+
- 至少 2GB RAM
- 至少 20GB 磁盘空间

## Docker 配置

### Dockerfile
```dockerfile
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o bin/server

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/bin/server /app/server
COPY --from=build /app/database/ /app/database/

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

CMD ["/app/server"]
```

### docker-compose.yml
```yaml
version: '3.8'

networks:
  ttpolyglot-network:
    driver: bridge

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

services:
  ttpolyglot-db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=${DB_NAME:-ttpolyglot}
      - POSTGRES_USER=${DB_USER:-ttpolyglot}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_INITDB_ARGS="--encoding=UTF8 --locale=C"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init:/docker-entrypoint-initdb.d
      - ./logs/postgres:/var/log/postgresql
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-ttpolyglot} -d ${DB_NAME:-ttpolyglot}"]
      interval: 30s
      timeout: 10s
      retries: 5

  ttpolyglot-redis:
    image: redis:7-alpine
    environment:
      - REDIS_PASSWORD=${REDIS_PASSWORD:-}
    volumes:
      - redis_data:/data
      - ./logs/redis:/var/log/redis
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    command: >
      sh -c "
        if [ -n \"$$REDIS_PASSWORD\" ]; then
          redis-server --requirepass $$REDIS_PASSWORD --appendonly yes --dir /data
        else
          redis-server --appendonly yes --dir /data
        fi
      "

  ttpolyglot-server:
    build: .
    environment:
      - DATABASE_URL=postgresql://${DB_USER:-ttpolyglot}:${DB_PASSWORD}@ttpolyglot-db:5432/${DB_NAME:-ttpolyglot}
      - REDIS_URL=redis://ttpolyglot-redis:6379
      - REDIS_PASSWORD=${REDIS_PASSWORD:-}
      - JWT_SECRET=${JWT_SECRET}
      - LOG_LEVEL=info
      - SERVER_HOST=0.0.0.0
      - SERVER_PORT=8080
    volumes:
      - ./data:/app/data
      - ./logs:/app/logs
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    depends_on:
      ttpolyglot-db:
        condition: service_healthy
      ttpolyglot-redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  ttpolyglot-nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/ssl/certs
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - ttpolyglot-server
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## Nginx 配置

### nginx/nginx.conf
```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # 基础配置
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 10M;

    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml
        text/plain
        text/css
        text/xml
        text/javascript
        application/xml
        application/rss+xml;

    # 上游服务器配置
    upstream ttpolyglot_backend {
        server ttpolyglot-server:8080;
        keepalive 32;
    }

    # 包含具体的服务器配置
    include /etc/nginx/conf.d/*.conf;
}
```

### nginx/conf.d/ttpolyglot.conf
```nginx
server {
    listen 80;
    server_name localhost your-domain.com;
    
    # 重定向 HTTP 到 HTTPS (生产环境)
    # return 301 https://$server_name$request_uri;
    
    # 开发环境可以直接处理 HTTP 请求
    location / {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 超时配置
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # API 特殊配置
    location /api/ {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # API 请求的特殊超时配置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # API版本控制支持
        add_header X-API-Version "v1" always;
    }

    # 健康检查端点
    location /health {
        proxy_pass http://ttpolyglot_backend/health;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        access_log off;
    }

    # 静态文件缓存 (如果有前端静态资源)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
}

# HTTPS 配置 (生产环境)
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    # SSL 证书配置
    ssl_certificate /etc/ssl/certs/your-domain.crt;
    ssl_certificate_key /etc/ssl/certs/your-domain.key;
    
    # SSL 配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # 安全头
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 超时配置
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # API 特殊配置
    location /api/ {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # API 请求的特殊超时配置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # API版本控制支持
        add_header X-API-Version "v1" always;
    }

    # 健康检查端点
    location /health {
        proxy_pass http://ttpolyglot_backend/health;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        access_log off;
    }
}
```

## 环境配置

### .env 文件
```bash
# 数据库配置
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=your-secure-password-change-in-production
DATABASE_URL=postgresql://ttpolyglot:your-secure-password-change-in-production@ttpolyglot-db:5432/ttpolyglot
DB_POOL_SIZE=20
DB_CONNECTION_TIMEOUT=30

# 服务器配置
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
LOG_LEVEL=info
REQUEST_TIMEOUT=30

# JWT 配置
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRE_HOURS=24
JWT_REFRESH_EXPIRE_DAYS=7

# CORS 配置
CORS_ORIGINS=http://localhost:3000,https://your-domain.com
CORS_ALLOW_CREDENTIALS=true

# 请求限制
MAX_REQUEST_SIZE=10MB
RATE_LIMIT_REQUESTS=1000
RATE_LIMIT_WINDOW_MINUTES=15

# 缓存配置 (Redis)
REDIS_URL=redis://ttpolyglot-redis:6379
REDIS_PASSWORD=your-redis-password-change-in-production

# 缓存TTL配置
CACHE_SESSION_TTL=86400        # 用户会话缓存：24小时
CACHE_API_RESPONSE_TTL=3600    # API响应缓存：1小时
CACHE_CONFIG_TTL=21600         # 系统配置缓存：6小时
CACHE_PERMISSION_TTL=7200      # 权限数据缓存：2小时
CACHE_TEMP_DATA_TTL=300        # 临时数据：5分钟

# Redis连接池配置
REDIS_MAX_CONNECTIONS=10
REDIS_CONNECTION_TIMEOUT=5
REDIS_RETRY_ATTEMPTS=3
REDIS_RETRY_DELAY=1000

# 安全配置
BCRYPT_ROUNDS=12
SESSION_SECRET=your-session-secret-change-in-production

# 监控配置
HEALTH_CHECK_ENABLED=true
METRICS_ENABLED=true
METRICS_PORT=9090

# 邮件配置 (可选)
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
SMTP_FROM_ADDRESS=noreply@your-domain.com

# 开发模式 (dev/prod)
ENVIRONMENT=dev
```

## 部署脚本

### deploy.sh
```bash
#!/bin/bash

# TTPolyglot 服务端部署脚本

set -e

echo "🚀 开始部署 TTPolyglot 服务端..."

# 检查必要文件
if [ ! -f ".env" ]; then
    echo "❌ 错误: .env 文件不存在"
    echo "请复制 .env.example 到 .env 并配置相应参数"
    exit 1
fi

# 创建必要的目录
echo "📁 创建目录结构..."
mkdir -p data logs logs/nginx logs/redis ssl nginx/conf.d

# 检查 Docker 和 Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: Docker 未安装"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: Docker Compose 未安装"
    exit 1
fi

# 构建并启动服务
echo "🔨 构建 Docker 镜像..."
docker-compose build

echo "🚀 启动服务..."
docker-compose up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ 服务启动成功!"
    echo ""
    echo "🌐 访问地址:"
    echo "  HTTP:  http://localhost"
    echo "  HTTPS: https://localhost (如果配置了SSL)"
    echo "  API:   http://localhost/api"
    echo ""
    echo "📊 服务状态:"
    docker-compose ps
else
    echo "❌ 服务启动失败"
    echo "查看日志: docker-compose logs"
    exit 1
fi

echo ""
echo "🎉 部署完成!"
```

### scripts/ssl-setup.sh
```bash
#!/bin/bash

# SSL 证书配置脚本 (使用 Let's Encrypt)

DOMAIN=${1:-localhost}
EMAIL=${2:-admin@example.com}

echo "🔒 为域名 $DOMAIN 配置 SSL 证书..."

# 安装 certbot (如果未安装)
if ! command -v certbot &> /dev/null; then
    echo "📦 安装 Certbot..."
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# 生成证书
echo "🎫 生成 SSL 证书..."
sudo certbot certonly --standalone \
    --preferred-challenges http \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

# 复制证书到项目目录
echo "📋 复制证书文件..."
sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ./ssl/your-domain.crt
sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ./ssl/your-domain.key
sudo chown $USER:$USER ./ssl/*

# 更新 Nginx 配置中的域名
sed -i "s/your-domain.com/$DOMAIN/g" nginx/conf.d/ttpolyglot.conf

echo "✅ SSL 证书配置完成!"
echo "请重启 Docker 服务: docker-compose restart nginx"
```

### scripts/backup.sh
```bash
#!/bin/bash

# 数据备份脚本

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ttpolyglot_backup_$DATE.tar.gz"

echo "💾 开始备份数据..."

# 创建备份目录
mkdir -p $BACKUP_DIR

# 停止应用服务（保持数据库和Redis运行以进行备份）
echo "⏸️  暂停应用服务..."
docker-compose stop ttpolyglot-server nginx

# 备份PostgreSQL数据库
echo "💾 备份数据库..."
DB_BACKUP_FILE="$BACKUP_DIR/database_$DATE.sql"
docker-compose exec -T ttpolyglot-db pg_dump -U ${DB_USER:-ttpolyglot} ${DB_NAME:-ttpolyglot} > "$DB_BACKUP_FILE"

# 备份Redis数据
echo "💾 备份Redis缓存..."
REDIS_BACKUP_FILE="$BACKUP_DIR/redis_$DATE.rdb"
docker-compose exec ttpolyglot-redis redis-cli save
docker cp $(docker-compose ps -q ttpolyglot-redis):/data/dump.rdb "$REDIS_BACKUP_FILE"

# 备份应用数据和配置
echo "📦 创建备份文件..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    data/ \
    logs/ \
    .env \
    nginx/ \
    --exclude="logs/nginx/access.log*" \
    --exclude="logs/nginx/error.log*"

# 将数据库和Redis备份添加到tar文件
tar -rf "${BACKUP_DIR}/${BACKUP_FILE%.tar.gz}.tar" "$DB_BACKUP_FILE" "$REDIS_BACKUP_FILE"
gzip "${BACKUP_DIR}/${BACKUP_FILE%.tar.gz}.tar"
rm "$DB_BACKUP_FILE" "$REDIS_BACKUP_FILE"

# 重启服务
echo "▶️  重启服务..."
docker-compose start ttpolyglot-server nginx

# 清理旧备份（保留最近10个）
echo "🧹 清理旧备份..."
ls -t $BACKUP_DIR/ttpolyglot_backup_*.tar.gz | tail -n +11 | xargs -r rm

echo "✅ 备份完成: $BACKUP_DIR/$BACKUP_FILE"
```

### scripts/restore.sh
```bash
#!/bin/bash

# 数据恢复脚本

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ 用法: $0 <备份文件路径>"
    echo "示例: $0 ./backups/ttpolyglot_backup_20240101_120000.tar.gz"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ 错误: 备份文件 $BACKUP_FILE 不存在"
    exit 1
fi

echo "🔄 开始恢复数据..."
echo "⚠️  警告: 这将覆盖当前数据!"
read -p "确认继续? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 操作已取消"
    exit 1
fi

# 停止服务
echo "⏸️  停止服务..."
docker-compose down

# 备份当前数据
echo "💾 备份当前数据..."
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf "./backups/pre_restore_backup_$DATE.tar.gz" data/ logs/ .env nginx/ 2>/dev/null || true

# 恢复应用数据
echo "📤 恢复应用数据..."
tar -xzf "$BACKUP_FILE"

# 检查是否包含数据库备份文件
if tar -tzf "$BACKUP_FILE" | grep -q "database_.*\.sql"; then
    echo "📥 恢复数据库..."
    # 提取数据库备份文件
    tar -xzf "$BACKUP_FILE" --wildcards "*/database_*.sql" -O > /tmp/db_restore.sql
    
    # 启动数据库服务
    docker-compose up -d ttpolyglot-db
    sleep 10  # 等待数据库启动
    
    # 恢复数据库
    docker-compose exec -T ttpolyglot-db psql -U ${DB_USER:-ttpolyglot} -d ${DB_NAME:-ttpolyglot} < /tmp/db_restore.sql
    rm /tmp/db_restore.sql
    
    echo "✅ 数据库恢复完成"
fi

# 检查是否包含Redis备份文件
if tar -tzf "$BACKUP_FILE" | grep -q "redis_.*\.rdb"; then
    echo "📥 恢复Redis缓存..."
    # 提取Redis备份文件
    tar -xzf "$BACKUP_FILE" --wildcards "*/redis_*.rdb" -O > /tmp/redis_restore.rdb
    
    # 启动Redis服务
    docker-compose up -d ttpolyglot-redis
    sleep 5  # 等待Redis启动
    
    # 停止Redis以恢复数据
    docker-compose stop ttpolyglot-redis
    
    # 复制备份文件到Redis数据目录
    docker cp /tmp/redis_restore.rdb $(docker-compose ps -q ttpolyglot-redis):/data/dump.rdb
    
    # 重启Redis
    docker-compose start ttpolyglot-redis
    rm /tmp/redis_restore.rdb
    
    echo "✅ Redis缓存恢复完成"
fi

# 重启所有服务
echo "🚀 重启所有服务..."
docker-compose up -d

echo "✅ 数据恢复完成!"
```

## 项目目录结构
```
ttpolyglot-server/
├── bin/
│   └── server.dart              # 服务器入口文件
├── lib/
│   ├── src/
│   │   ├── controllers/         # API 控制器
│   │   ├── models/             # 数据模型
│   │   ├── services/           # 业务逻辑服务
│   │   ├── middleware/         # 中间件
│   │   ├── database/           # 数据库相关
│   │   └── utils/              # 工具类
│   └── server.dart             # 服务器核心逻辑
├── database/
│   ├── migrations/             # 数据库迁移文件
│   ├── seeds/                  # 初始数据
│   └── init/                   # PostgreSQL 初始化脚本
├── test/                       # 测试文件
├── docs/                       # 文档目录
│   ├── ARCHITECTURE.md         # 架构设计
│   ├── DATABASE_DESIGN.md      # 数据库设计
│   ├── API_DESIGN.md          # API 设计
│   └── DEPLOYMENT.md          # 部署方案
├── nginx/
│   ├── nginx.conf              # Nginx 主配置
│   └── conf.d/
│       └── ttpolyglot.conf     # 项目特定配置
├── scripts/
│   ├── ssl-setup.sh            # SSL 配置脚本
│   ├── backup.sh               # 备份脚本
│   └── restore.sh              # 恢复脚本
├── data/                       # 数据文件 (运行时创建)
├── logs/                       # 日志文件 (运行时创建)
│   ├── nginx/                  # Nginx 日志
│   └── redis/                  # Redis 日志
├── ssl/                        # SSL 证书
├── Dockerfile                  # Docker 构建文件
├── docker-compose.yml          # Docker Compose 配置
├── deploy.sh                   # 部署脚本
├── .env.example                # 环境变量示例
├── .env                        # 环境变量 (需要创建)
├── pubspec.yaml                # Dart 依赖配置
└── README.md                   # 项目说明
```

## 快速开始

### 开发环境部署

1. **克隆项目** (未来)
   ```bash
   git clone https://github.com/your-org/ttpolyglot-server.git
   cd ttpolyglot-server
   ```

2. **配置环境变量**
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，设置必要的配置项
   ```

3. **启动开发环境**
   ```bash
   # 使用 Docker Compose 启动
   ./deploy.sh
   
   # 或手动启动
   docker-compose up -d
   ```

4. **验证部署**
   ```bash
   # 检查服务状态
   curl http://localhost/health
   
   # 测试API端点
   curl http://localhost/api/v1/version
   
   # 查看日志
   docker-compose logs -f
   ```

### 生产环境部署

1. **SSL 证书配置**
   ```bash
   # 配置 SSL 证书 (Let's Encrypt)
   chmod +x scripts/ssl-setup.sh
   ./scripts/ssl-setup.sh your-domain.com your-email@example.com
   ```

2. **更新配置**
   ```bash
   # 更新 .env 文件中的生产环境配置
   # 设置强密码、正确的域名等
   ```

3. **启动生产服务**
   ```bash
   ENVIRONMENT=prod ./deploy.sh
   ```

## 常用命令

### 服务管理
```bash
# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs ttpolyglot-server
docker-compose logs ttpolyglot-db
docker-compose logs ttpolyglot-redis
docker-compose logs nginx

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 更新服务
docker-compose pull
docker-compose up -d --build

# 仅重启应用服务（保持数据库运行）
docker-compose restart ttpolyglot-server nginx

# 清理未使用的Docker资源
docker system prune -f
docker volume prune -f
```

### 数据库操作
```bash
# 连接到数据库
docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot

# 查看数据库状态
docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot

# 手动备份数据库
docker-compose exec ttpolyglot-db pg_dump -U ttpolyglot ttpolyglot > backup.sql

# 手动恢复数据库
docker-compose exec -T ttpolyglot-db psql -U ttpolyglot -d ttpolyglot < backup.sql

# 查看数据库大小
docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot -c "\l+"
```

### Redis 操作
```bash
# 连接到Redis
docker-compose exec ttpolyglot-redis redis-cli

# 如果Redis有密码，使用AUTH命令
# docker-compose exec ttpolyglot-redis redis-cli -a your-redis-password

# 查看Redis信息
docker-compose exec ttpolyglot-redis redis-cli info

# 查看Redis缓存统计
docker-compose exec ttpolyglot-redis redis-cli info stats

# 查看Redis内存使用情况
docker-compose exec ttpolyglot-redis redis-cli info memory

# 查看特定类型的缓存键
docker-compose exec ttpolyglot-redis redis-cli keys "user:session:*"
docker-compose exec ttpolyglot-redis redis-cli keys "config:*"
docker-compose exec ttpolyglot-redis redis-cli keys "api:response:*"

# 查看缓存命中率
docker-compose exec ttpolyglot-redis redis-cli info stats | grep "keyspace_hits\|keyspace_misses"

# 监控Redis实时命令
docker-compose exec ttpolyglot-redis redis-cli monitor

# 查看特定key的信息
docker-compose exec ttpolyglot-redis redis-cli type "user:session:123"
docker-compose exec ttpolyglot-redis redis-cli ttl "user:session:123"
docker-compose exec ttpolyglot-redis redis-cli get "config:system:max_upload_size"

# 删除特定缓存
docker-compose exec ttpolyglot-redis redis-cli del "user:session:123"

# 批量删除缓存
docker-compose exec ttpolyglot-redis redis-cli eval "return redis.call('del', unpack(redis.call('keys', ARGV[1])))" 0 "user:session:*"

# 查看Redis连接数
docker-compose exec ttpolyglot-redis redis-cli info clients

# 清空Redis缓存（谨慎使用）
docker-compose exec ttpolyglot-redis redis-cli flushall

# 仅清空当前数据库（默认db 0）
docker-compose exec ttpolyglot-redis redis-cli flushdb
```

### 备份恢复
```bash
# 数据备份
./scripts/backup.sh

# 数据恢复
./scripts/restore.sh ./backups/backup_file.tar.gz
```

## 监控和维护

### 日志监控
```bash
# 实时查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f ttpolyglot-server

# 查看最近的日志（最后100行）
docker-compose logs --tail=100 ttpolyglot-server
```

### 健康检查
```bash
# 检查服务健康状态
curl http://localhost/health

# 检查数据库连接
curl http://localhost/health/db

# 检查服务就绪状态
curl http://localhost/health/ready
```

### 性能监控
```bash
# 查看容器资源使用情况
docker stats

# 查看特定容器的资源使用
docker stats ttpolyglot-server ttpolyglot-db ttpolyglot-redis
```

## 安全建议

### 生产环境安全配置
1. **更改默认密码**: 确保所有服务使用强密码
2. **启用 HTTPS**: 配置 SSL 证书
3. **防火墙配置**: 只开放必要的端口（80, 443）
4. **定期更新**: 保持 Docker 镜像和系统更新
5. **备份策略**: 建立定期备份机制
6. **监控告警**: 配置系统监控和告警

### 访问控制
```bash
# 限制数据库只能从应用容器访问
# 在 docker-compose.yml 中不暴露数据库端口到主机

# 使用防火墙限制访问
sudo ufw allow 80
sudo ufw allow 443
sudo ufw deny 5432  # PostgreSQL
sudo ufw deny 6379  # Redis
```

---

*此文档会根据开发进度持续更新和完善*
