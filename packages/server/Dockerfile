# TTPolyglot 服务端 Dockerfile
# 使用多阶段构建优化镜像大小

# 构建阶段
FROM dart:stable AS build

# 设置工作目录
WORKDIR /app

# 复制pubspec文件并获取依赖
COPY pubspec.* ./
RUN dart pub get

# 复制源代码
COPY . .

# 编译Dart应用为可执行文件
RUN dart compile exe bin/server.dart -o bin/server

# 运行阶段
FROM debian:bullseye-slim

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
COPY --from=build /app/bin/server /app/server

# 复制数据库相关文件
COPY --from=build /app/database/ /app/database/

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
