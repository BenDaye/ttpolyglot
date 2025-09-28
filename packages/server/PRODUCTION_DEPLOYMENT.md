# TTPolyglot 生产环境部署指南

## 🚀 快速启动

### 1. 使用Docker Compose（推荐）

```bash
# 启动生产环境（包含Nginx）
docker-compose --profile production up -d

# 或者使用脚本
./scripts/start-production.sh
```

### 2. 手动启动

```bash
# 1. 启动数据库和Redis
docker-compose up -d ttpolyglot-db ttpolyglot-redis

# 2. 启动应用服务器
docker-compose up -d ttpolyglot-server

# 3. 启动Nginx
docker-compose up -d ttpolyglot-nginx
```

## 🔧 配置说明

### 环境变量配置

1. **复制环境变量文件**：
   ```bash
   cp .env.example .env
   ```

2. **修改生产环境配置**：
   - 修改数据库密码
   - 修改JWT密钥
   - 修改Redis密码
   - 配置域名和SSL证书

### Nginx配置

Nginx配置文件位于：
- 主配置：`nginx/nginx.conf`
- 站点配置：`nginx/conf.d/ttpolyglot.conf`

### SSL证书配置

1. **获取SSL证书**：
   ```bash
   # 使用Let's Encrypt（推荐）
   certbot certonly --standalone -d your-domain.com
   
   # 或使用自签名证书（仅测试）
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout ssl/ttpolyglot.key \
     -out ssl/ttpolyglot.crt
   ```

2. **配置证书路径**：
   修改 `nginx/conf.d/ttpolyglot.conf` 中的证书路径

## 📊 监控和管理

### 查看服务状态
```bash
# 查看所有服务
docker-compose ps

# 查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f ttpolyglot-server
docker-compose logs -f ttpolyglot-nginx
```

### 健康检查
```bash
# 检查应用健康状态
curl http://localhost/health

# 检查API版本
curl http://localhost/api/v1/version
```

### 停止服务
```bash
# 停止所有服务
docker-compose --profile production down

# 或使用脚本
./scripts/stop-production.sh
```

## 🔒 安全配置

### 1. 修改默认密码
- 数据库密码
- Redis密码
- JWT密钥
- 会话密钥

### 2. 配置防火墙
```bash
# 只开放必要端口
ufw allow 80/tcp
ufw allow 443/tcp
ufw deny 5432/tcp  # 数据库端口不对外开放
ufw deny 6379/tcp  # Redis端口不对外开放
ufw deny 8080/tcp  # 应用端口不对外开放
```

### 3. 配置SSL/TLS
- 使用HTTPS
- 配置HSTS
- 设置安全头

## 📈 性能优化

### 1. Nginx优化
- 启用Gzip压缩
- 配置缓存
- 设置连接池

### 2. 数据库优化
- 调整连接池大小
- 配置索引
- 定期备份

### 3. Redis优化
- 配置内存限制
- 设置过期策略
- 监控内存使用

## 🚨 故障排除

### 常见问题

1. **服务启动失败**
   ```bash
   # 查看详细日志
   docker-compose logs
   
   # 检查端口占用
   netstat -tulpn | grep :80
   netstat -tulpn | grep :443
   ```

2. **数据库连接失败**
   ```bash
   # 检查数据库状态
   docker-compose exec ttpolyglot-db pg_isready
   
   # 检查网络连接
   docker-compose exec ttpolyglot-server ping ttpolyglot-db
   ```

3. **Nginx配置错误**
   ```bash
   # 测试Nginx配置
   docker-compose exec ttpolyglot-nginx nginx -t
   
   # 重新加载配置
   docker-compose exec ttpolyglot-nginx nginx -s reload
   ```

### 日志位置
- 应用日志：`logs/`
- Nginx日志：`logs/nginx/`
- 数据库日志：`logs/postgres/`

## 📝 维护任务

### 定期备份
```bash
# 数据库备份
docker-compose exec ttpolyglot-db pg_dump -U ttpolyglot ttpolyglot > backup.sql

# 恢复备份
docker-compose exec -T ttpolyglot-db psql -U ttpolyglot ttpolyglot < backup.sql
```

### 更新服务
```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose --profile production up -d
```

### 清理资源
```bash
# 清理未使用的镜像
docker system prune -a

# 清理日志文件
find logs/ -name "*.log" -mtime +7 -delete
```
