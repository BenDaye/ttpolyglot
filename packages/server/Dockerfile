# TTPolyglot 服务端 Dockerfile
# 使用多阶段构建优化镜像大小

# 构建阶段
FROM dart:stable AS build

# 设置工作目录
WORKDIR /app

# 复制 workspace 根目录的 pubspec
COPY pubspec.yaml ./

# 复制 .env 文件
COPY .env ./

# 复制 .env.example 文件
COPY .env.example ./

# 复制 server package
COPY packages/server/pubspec.yaml ./packages/server/
COPY packages/server/pubspec_overrides.yaml* ./packages/server/

# 复制 core package（server 依赖）
COPY packages/core/pubspec.yaml ./packages/core/

# 复制其他依赖的 packages
COPY packages/parsers/pubspec.yaml ./packages/parsers/
COPY packages/translators/pubspec.yaml* ./packages/translators/

# 获取 server 依赖
WORKDIR /app/packages/server
RUN dart pub get

# 复制 server 源代码
COPY packages/server/ ./

# 复制 core 源代码（依赖）
WORKDIR /app
COPY packages/core/ ./packages/core/
COPY packages/parsers/ ./packages/parsers/
COPY packages/translators/ ./packages/translators/

# 编译 server
WORKDIR /app/packages/server
RUN dart compile exe bin/server.dart -o bin/server

# 运行阶段（使用 debian-slim，兼容 glibc）
FROM debian:12-slim

# 安装运行时依赖
RUN apt-get update && apt-get install -y \
  ca-certificates \
  curl \
  && rm -rf /var/lib/apt/lists/*

# 创建应用用户
RUN useradd -r -s /bin/false ttpolyglot

# 创建应用目录
RUN mkdir -p /app/data /app/logs && \
  chown -R ttpolyglot:ttpolyglot /app

# 复制编译后的可执行文件
COPY --from=build /app/packages/server/bin/server /app/server

# 复制数据库相关文件（迁移脚本需要）
COPY --from=build /app/packages/server/database/ /app/database/
COPY --from=build /app/packages/server/scripts/ /app/scripts/

# 设置权限
RUN chmod +x /app/server && \
  chown ttpolyglot:ttpolyglot /app/server

# 切换到应用用户
USER ttpolyglot

# 设置工作目录
WORKDIR /app

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# 启动应用
CMD ["./server"]
