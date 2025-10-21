#!/bin/bash
# 迁移脚本快捷方式

docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec ttpolyglot-server /app/migrate "$@"
