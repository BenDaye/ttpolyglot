# TTPolyglot 服务端 Dockerfile
# 多阶段构建，优化镜像大小

# ============================================
# 构建阶段
# ============================================
FROM dart:stable AS build

# 设置工作目录
WORKDIR /app

# 复制工作区根目录的配置文件
COPY pubspec.yaml pubspec.lock ./
COPY melos.yaml ./

# 复制所有 packages
COPY packages/ ./packages/

# 进入 server 包目录
WORKDIR /app/packages/server

# 安装依赖
RUN dart pub get

# 编译 Dart 应用为原生可执行文件
# 使用 AOT 编译以获得最佳性能
RUN dart compile exe bin/server.dart -o server

# 编译迁移脚本为独立可执行文件
RUN dart compile exe scripts/migrate.dart -o migrate

# ============================================
# 运行阶段
# ============================================
FROM debian:bookworm-slim AS runtime

# 安装运行时依赖
# - ca-certificates: HTTPS 连接所需
# - curl: 健康检查所需
# - postgresql-client: 数据库备份和管理工具
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  postgresql-client && \
  rm -rf /var/lib/apt/lists/*

# 创建非 root 用户运行应用
RUN groupadd -r ttpolyglot && \
  useradd -r -g ttpolyglot -s /bin/false ttpolyglot

# 设置工作目录
WORKDIR /app

# 从构建阶段复制编译好的可执行文件
COPY --from=build --chown=ttpolyglot:ttpolyglot /app/packages/server/server ./server
COPY --from=build --chown=ttpolyglot:ttpolyglot /app/packages/server/migrate ./migrate

# 复制数据库迁移脚本目录（如果需要在容器内运行迁移）
COPY --from=build --chown=ttpolyglot:ttpolyglot /app/packages/server/database ./database
COPY --from=build --chown=ttpolyglot:ttpolyglot /app/packages/server/scripts ./scripts

# 创建必要的目录并设置权限
RUN mkdir -p /app/data /app/logs /app/uploads && \
  chown -R ttpolyglot:ttpolyglot /app

# 切换到非 root 用户
USER ttpolyglot

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# 启动应用
CMD ["./server"]
