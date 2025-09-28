-- TTPolyglot 数据库初始化脚本
-- 创建数据库和基础配置

-- 创建数据库（如果在Docker中运行，这步可能不需要）
-- CREATE DATABASE ttpolyglot;

-- 连接到数据库
\c ttpolyglot;

-- 设置时区
SET timezone = 'UTC';

-- 创建通用触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;