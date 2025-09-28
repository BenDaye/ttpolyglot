# 数据表字段更新最佳实践指南

## 概述

当您需要对已存在的数据表进行字段更新时，请遵循本指南以确保数据安全和迁移的可靠性。

## 基本流程

### 1. 创建新的迁移文件

按照现有命名规范创建新的迁移文件：
```
004_update_user_table_fields.sql
005_add_translation_cache.sql
006_modify_project_settings.sql
```

### 2. 迁移文件结构

每个迁移文件应包含以下部分：

```sql
-- 迁移: 004 - 更新用户表字段
-- 创建时间: 2024-12-26
-- 描述: 为用户表添加新字段，修改现有字段

-- 1. 添加新字段
-- 2. 修改现有字段
-- 3. 添加/删除约束
-- 4. 添加/删除索引
-- 5. 数据迁移（如果需要）
-- 6. 添加注释
```

## 字段操作类型

### 1. 添加新字段

**安全方式：**
```sql
-- 添加可空字段
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_bio TEXT;

-- 添加有默认值的字段
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_preferences JSONB DEFAULT '{}';

-- 添加非空字段（需要分步进行）
ALTER TABLE users ADD COLUMN IF NOT EXISTS new_field VARCHAR(50);
UPDATE users SET new_field = 'default_value' WHERE new_field IS NULL;
ALTER TABLE users ALTER COLUMN new_field SET NOT NULL;
```

### 2. 修改字段类型

**安全方式：**
```sql
-- 扩展字段长度（通常安全）
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(30);

-- 修改字段类型（需要谨慎）
-- 先添加新字段，迁移数据，再删除旧字段
ALTER TABLE users ADD COLUMN new_field_new_type NEW_TYPE;
UPDATE users SET new_field_new_type = old_field::NEW_TYPE;
ALTER TABLE users DROP COLUMN old_field;
ALTER TABLE users RENAME COLUMN new_field_new_type TO old_field;
```

### 3. 删除字段

**安全方式：**
```sql
-- 检查字段是否被引用
SELECT * FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'old_field';

-- 安全删除字段
ALTER TABLE users DROP COLUMN IF EXISTS old_field;
```

### 4. 添加约束

**安全方式：**
```sql
-- 添加检查约束
ALTER TABLE users ADD CONSTRAINT IF NOT EXISTS check_bio_length 
CHECK (length(profile_bio) <= 500);

-- 添加外键约束
ALTER TABLE projects ADD CONSTRAINT IF NOT EXISTS fk_owner_user 
FOREIGN KEY (owner_id) REFERENCES users(id);
```

### 5. 添加索引

**安全方式：**
```sql
-- 添加普通索引
CREATE INDEX IF NOT EXISTS idx_users_bio ON users (profile_bio);

-- 添加部分索引
CREATE INDEX IF NOT EXISTS idx_users_bio_not_null ON users (profile_bio) 
WHERE profile_bio IS NOT NULL;

-- 添加全文搜索索引
CREATE INDEX IF NOT EXISTS idx_users_bio_search ON users 
USING gin(to_tsvector('english', profile_bio));
```

## 数据迁移

### 1. 设置默认值

```sql
-- 为新字段设置默认值
UPDATE users SET notification_preferences = '{"email": true}'::jsonb 
WHERE notification_preferences IS NULL;
```

### 2. 数据转换

```sql
-- 将现有数据转换为新格式
UPDATE users SET social_links = jsonb_build_object('github', github_url) 
WHERE github_url IS NOT NULL;
```

### 3. 批量数据迁移

```sql
-- 使用事务确保数据一致性
BEGIN;
UPDATE users SET new_field = calculated_value WHERE condition;
-- 验证数据
SELECT COUNT(*) FROM users WHERE new_field IS NULL;
COMMIT;
```

## 安全检查

### 1. 迁移前检查

```bash
# 检查表结构
dart migrate.dart check users

# 查看迁移状态
dart migrate.dart status

# 备份数据库（生产环境必须）
pg_dump your_database > backup_before_migration.sql
```

### 2. 迁移后验证

```sql
-- 验证表结构
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- 验证数据完整性
SELECT COUNT(*) FROM users WHERE new_field IS NULL;

-- 验证索引
SELECT indexname, indexdef FROM pg_indexes 
WHERE tablename = 'users';
```

## 常见问题处理

### 1. 字段名冲突

```sql
-- 重命名字段
ALTER TABLE users RENAME COLUMN old_name TO new_name;
```

### 2. 约束冲突

```sql
-- 删除冲突的约束
ALTER TABLE users DROP CONSTRAINT IF EXISTS old_constraint;
-- 添加新约束
ALTER TABLE users ADD CONSTRAINT new_constraint CHECK (...);
```

### 3. 索引冲突

```sql
-- 删除旧索引
DROP INDEX IF EXISTS old_index_name;
-- 创建新索引
CREATE INDEX new_index_name ON users (column_name);
```

## 回滚策略

### 1. 开发环境回滚

```bash
# 回滚特定迁移
dart migrate.dart rollback 004_update_user_table_fields
```

### 2. 生产环境回滚

生产环境不支持自动回滚，需要手动创建回滚迁移：

```sql
-- 005_rollback_user_fields_update.sql
-- 回滚 004_update_user_table_fields.sql 的更改

-- 删除添加的字段
ALTER TABLE users DROP COLUMN IF EXISTS profile_bio;
ALTER TABLE users DROP COLUMN IF EXISTS social_links;

-- 恢复原始字段类型
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(20);

-- 删除添加的约束
ALTER TABLE users DROP CONSTRAINT IF EXISTS check_profile_bio_length;

-- 删除添加的索引
DROP INDEX IF EXISTS idx_users_profile_bio;
DROP INDEX IF EXISTS idx_users_social_links;
```

## 最佳实践总结

1. **始终使用 IF NOT EXISTS 或 IF EXISTS**：避免重复执行错误
2. **分步进行复杂操作**：将复杂迁移分解为多个步骤
3. **使用事务**：确保操作的原子性
4. **先测试后生产**：在开发环境充分测试
5. **备份数据**：生产环境迁移前必须备份
6. **验证结果**：迁移后验证数据完整性
7. **文档记录**：详细记录每次迁移的目的和影响
8. **渐进式部署**：考虑向后兼容性

## 迁移工具使用

```bash
# 运行所有迁移
dart migrate.dart

# 仅运行迁移
dart migrate.dart migrate

# 检查表结构
dart migrate.dart check users

# 查看迁移状态
dart migrate.dart status

# 运行种子数据
dart migrate.dart seed
```

## 注意事项

1. **生产环境谨慎操作**：字段类型修改可能导致数据丢失
2. **考虑性能影响**：大表添加索引或约束可能耗时较长
3. **应用程序兼容性**：确保应用程序代码与数据库结构匹配
4. **监控系统**：迁移后监控系统性能和错误日志
