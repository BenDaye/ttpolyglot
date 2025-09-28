# TTPolyglot 服务端

TTPolyglot 多语言翻译管理系统的服务端实现，基于 Dart 和 Shelf 框架构建。

## 功能特性

- 🔐 **JWT 身份验证**: 基于 JSON Web Token 的安全认证
- 👥 **用户管理**: 用户注册、登录、权限管理
- 📝 **项目管理**: 多项目支持，项目成员管理
- 🌍 **翻译管理**: 翻译条目 CRUD，状态流转，历史记录
- 🗣️ **多语言支持**: 灵活的语言配置和管理
- 🔒 **权限控制**: 基于角色的访问控制 (RBAC)
- ⚡ **Redis 缓存**: 高性能缓存层，支持会话存储
- 📊 **API 标准化**: RESTful API 设计，统一错误处理
- 🐳 **Docker 部署**: 容器化部署，支持 Docker Compose
- 📈 **监控支持**: 健康检查、指标收集

## 技术栈

- **语言**: Dart 3.6+
- **框架**: Shelf + Shelf Router
- **数据库**: PostgreSQL 15+
- **缓存**: Redis 7+
- **身份验证**: JWT
- **容器化**: Docker + Docker Compose

## 快速开始

### 前置要求

- Dart SDK 3.6+
- Docker & Docker Compose
- PostgreSQL 15+ (如使用 Docker 可跳过)
- Redis 7+ (如使用 Docker 可跳过)

### 本地开发

1. **安装依赖**
   ```bash
   dart pub get
   ```

2. **配置环境变量**
   ```bash
   # 创建并编辑环境变量文件
   cp .env.example .env
   # 编辑 .env 文件，配置数据库和 Redis 连接信息
   ```

3. **启动数据库和 Redis (使用 Docker)**
   ```bash
   docker-compose up -d ttpolyglot-db ttpolyglot-redis
   ```

4. **运行数据库迁移**
   ```bash
   dart run scripts/migrate.dart
   ```

5. **启动开发服务器**
   ```bash
   dart run bin/server.dart
   ```

6. **验证服务**
   ```bash
   curl http://localhost:8080/health
   curl http://localhost:8080/api/v1/version
   ```

### Docker 部署

1. **完整部署 (推荐)**
   ```bash
   # 克隆项目
   git clone <repository-url>
   cd ttpolyglot-server
   
   # 配置环境变量
   cp .env.example .env
   # 编辑 .env 文件
   
   # 启动所有服务
   chmod +x deploy.sh
   ./deploy.sh
   ```

2. **手动部署**
   ```bash
   # 构建并启动
   docker-compose up -d
   
   # 查看日志
   docker-compose logs -f
   
   # 查看服务状态
   docker-compose ps
   ```

## 项目结构

```
packages/server/
├── bin/
│   └── server.dart              # 服务器入口文件
├── lib/
│   ├── server.dart              # 库导出文件
│   └── src/
│       ├── config/              # 配置管理
│       ├── controllers/         # API 控制器
│       ├── middleware/          # 中间件
│       ├── models/              # 数据模型
│       ├── routes/              # 路由配置
│       ├── services/            # 业务服务
│       └── utils/               # 工具类
├── database/
│   ├── migrations/              # 数据库迁移
│   ├── seeds/                   # 初始数据
│   └── init/                    # 初始化脚本
├── docs/                        # 文档
│   ├── ARCHITECTURE.md          # 架构设计
│   ├── DATABASE_DESIGN.md       # 数据库设计
│   ├── API_DESIGN.md           # API 设计
│   ├── DEPLOYMENT.md           # 部署方案
│   └── DEVELOPMENT_PLAN.md     # 开发计划
├── test/                        # 测试文件
├── docker-compose.yml           # Docker Compose 配置
├── Dockerfile                   # Docker 构建文件
├── .env.example                 # 环境变量示例
└── pubspec.yaml                 # Dart 依赖配置
```

## API 文档

### 认证端点
- `POST /api/v1/auth/login` - 用户登录
- `POST /api/v1/auth/logout` - 用户登出
- `POST /api/v1/auth/refresh` - 刷新 Token
- `POST /api/v1/auth/register` - 用户注册

### 项目管理
- `GET /api/v1/projects` - 获取项目列表
- `POST /api/v1/projects` - 创建项目
- `GET /api/v1/projects/{id}` - 获取项目详情
- `PUT /api/v1/projects/{id}` - 更新项目

### 翻译管理
- `GET /api/v1/projects/{id}/translations` - 获取翻译条目
- `POST /api/v1/projects/{id}/translations` - 创建翻译条目
- `PUT /api/v1/projects/{id}/translations/{entryId}` - 更新翻译条目

### 健康检查
- `GET /health` - 基础健康检查
- `GET /health/db` - 数据库连接检查
- `GET /health/ready` - 服务就绪检查

完整的 API 文档请参考 [API_DESIGN.md](docs/API_DESIGN.md)

## 开发指南

### 代码规范
- 遵循 Dart 官方代码风格
- 使用 `dart format` 格式化代码
- 使用 `dart analyze` 进行静态分析

### 测试
```bash
# 运行所有测试
dart test

# 运行特定测试
dart test test/services/auth_service_test.dart

# 生成测试覆盖率报告
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html
```

### 日志规范
```bash
final logger = LoggerFactory.getLogger('TTPolyglotServer');

logger.info('一般信息');
```

## 配置说明

### 环境变量

主要配置项：

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `DATABASE_URL` | 数据库连接字符串 | `postgresql://ttpolyglot:password@localhost:5432/ttpolyglot` |
| `REDIS_URL` | Redis 连接字符串 | `redis://localhost:6379` |
| `JWT_SECRET` | JWT 签名密钥 | 需要设置 |
| `SERVER_PORT` | 服务器端口 | `8080` |
| `LOG_LEVEL` | 日志级别 | `info` |

完整配置请参考 `.env.example` 文件。

### 生产环境注意事项

1. **安全设置**
   - 修改默认密码
   - 设置强 JWT 密钥
   - 配置 HTTPS

2. **性能调优**
   - 调整数据库连接池大小
   - 配置 Redis 缓存 TTL
   - 启用 Nginx 压缩

3. **监控**
   - 设置健康检查
   - 配置日志收集
   - 监控系统资源

## 部署

详细部署说明请参考 [DEPLOYMENT.md](docs/DEPLOYMENT.md)

### Docker Compose 部署
```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f ttpolyglot-server

# 停止服务
docker-compose down
```

### 备份和恢复
```bash
# 数据备份
./scripts/backup.sh

# 数据恢复
./scripts/restore.sh ./backups/backup_file.tar.gz
```

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目使用 MIT 许可证。详情请参考 [LICENSE](LICENSE) 文件。

## 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [GitHub Issues]
- 文档: [Documentation]

## 更新日志

### v1.0.0 (待发布)
- 🎉 初始版本发布
- ✅ 基础架构搭建完成
- ✅ 用户认证系统
- ✅ 项目管理功能
- ✅ 翻译管理功能
- ✅ Docker 容器化部署