-- TTPolyglot 数据库初始化脚本
-- 创建数据库和基础配置

-- 创建数据库（如果在Docker中运行，这步可能不需要）
-- CREATE DATABASE ttpolyglot;

-- 连接到数据库
\c ttpolyglot;

-- 启用必要的扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS "pg_trgm";

CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- 设置时区
SET timezone = 'UTC';

-- 创建通用触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 创建通用分区管理函数
CREATE OR REPLACE FUNCTION create_monthly_partitions(table_name text, months_ahead integer DEFAULT 6)
RETURNS void AS $$
DECLARE
    start_date date;
    end_date date;
    partition_name text;
    sql_cmd text;
BEGIN
    FOR i IN 0..months_ahead LOOP
        start_date := date_trunc('month', CURRENT_DATE + (i || ' months')::interval);
        end_date := start_date + interval '1 month';
        partition_name := table_name || '_' || to_char(start_date, 'YYYYMM');
        
        sql_cmd := format('CREATE TABLE IF NOT EXISTS %I PARTITION OF %I FOR VALUES FROM (%L) TO (%L)',
                         partition_name, table_name, start_date, end_date);
        
        EXECUTE sql_cmd;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 创建清理旧分区函数
CREATE OR REPLACE FUNCTION drop_old_partitions(table_name text, keep_months integer DEFAULT 12)
RETURNS void AS $$
DECLARE
    cutoff_date date;
    partition_record record;
    sql_cmd text;
BEGIN
    cutoff_date := date_trunc('month', CURRENT_DATE - (keep_months || ' months')::interval);
    
    FOR partition_record IN 
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE tablename LIKE table_name || '_%'
        AND schemaname = 'public'
    LOOP
        IF substring(partition_record.tablename from '.{6}$')::date < cutoff_date THEN
            sql_cmd := format('DROP TABLE IF EXISTS %I.%I', 
                             partition_record.schemaname, partition_record.tablename);
            EXECUTE sql_cmd;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;