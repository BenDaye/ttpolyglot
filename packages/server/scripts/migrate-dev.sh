#!/bin/sh
# 开发环境下的迁移脚本 wrapper
# 用于在未编译的情况下运行迁移

cd /app/packages/server
dart run scripts/migrate.dart "$@"

