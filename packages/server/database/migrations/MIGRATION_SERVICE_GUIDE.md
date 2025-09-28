# MigrationService 使用指南

## 概述

MigrationService 是一个根据字段更新最佳实践指南重新设计的数据库迁移服务，提供了安全、可靠的数据库迁移功能。

## 主要特性

### 1. 安全的字段操作
- 所有字段操作都使用 `IF EXISTS` / `IF NOT EXISTS` 确保幂等性
- 提供安全的添加、删除、修改列的方法
- 支持约束和索引的安全操作

### 2. 迁移前后验证
- 迁移前检查表结构和数据
- 迁移后验证数据完整性
- 自动检测数据变化

### 3. 智能回滚支持
- 开发环境直接回滚
- 生产环境自动生成回滚迁移文件
- 支持复杂迁移的自动回滚生成

### 4. 备份和恢复
- 生产环境数据库备份
- 备份文件管理
- 数据库恢复功能

## 使用方法

### 基本命令

```bash
# 运行所有迁移
dart migrate.dart

# 仅运行迁移
dart migrate.dart migrate

# 运行种子数据
dart migrate.dart seed

# 查看迁移状态
dart migrate.dart status
```

### 安全检查命令

```bash
# 检查表结构
dart migrate.dart check users

# 迁移前检查
dart migrate.dart precheck users

# 迁移后验证
dart migrate.dart validate users

# 查看外键约束
dart migrate.dart foreign-keys users
```

### 回滚操作

```bash
# 开发环境回滚
dart migrate.dart rollback 004_example_safe_field_update

# 创建生产环境回滚迁移
dart migrate.dart create-rollback 004_example_safe_field_update
```

### 备份操作

```bash
# 备份数据库
dart migrate.dart backup

# 列出备份文件
dart migrate.dart list-backups

# 恢复数据库
dart migrate.dart restore backup_file.sql

# 删除备份文件
dart migrate.dart delete-backup backup_file.sql
```

## 迁移文件编写规范

### 1. 文件命名
```
001_create_core_tables.sql
002_create_translation_tables.sql
003_create_system_tables.sql
004_update_user_table_fields.sql
```

### 2. 文件结构
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

### 3. 安全操作示例

#### 添加字段
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

#### 修改字段类型
```sql
-- 扩展字段长度（通常安全）
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(30);

-- 复杂类型修改（需要分步进行）
ALTER TABLE users ADD COLUMN new_field_new_type NEW_TYPE;
UPDATE users SET new_field_new_type = old_field::NEW_TYPE;
ALTER TABLE users DROP COLUMN old_field;
ALTER TABLE users RENAME COLUMN new_field_new_type TO old_field;
```

#### 添加约束
```sql
-- 添加检查约束
ALTER TABLE users ADD CONSTRAINT IF NOT EXISTS check_bio_length 
CHECK (length(profile_bio) <= 500);

-- 添加外键约束
ALTER TABLE projects ADD CONSTRAINT IF NOT EXISTS fk_owner_user 
FOREIGN KEY (owner_id) REFERENCES users(id);
```

#### 添加索引
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

## 最佳实践

### 1. 迁移前准备
- 在开发环境充分测试
- 备份生产环境数据
- 检查应用程序兼容性

### 2. 迁移执行
- 使用事务确保原子性
- 分步进行复杂操作
- 验证每个步骤的结果

### 3. 迁移后验证
- 检查数据完整性
- 验证应用程序功能
- 监控系统性能

### 4. 回滚准备
- 准备回滚策略
- 测试回滚流程
- 准备数据恢复方案

## 安全注意事项

1. **生产环境操作**
   - 始终先备份数据
   - 在维护窗口执行
   - 准备回滚计划

2. **字段类型修改**
   - 可能导致数据丢失
   - 需要充分测试
   - 考虑数据转换

3. **约束添加**
   - 检查现有数据合规性
   - 可能需要数据清理
   - 考虑性能影响

4. **索引操作**
   - 大表索引创建耗时
   - 考虑在线创建
   - 监控锁等待

## 故障排除

### 常见问题

1. **迁移失败**
   - 检查 SQL 语法
   - 验证数据约束
   - 查看详细错误信息

2. **回滚失败**
   - 检查依赖关系
   - 手动处理数据
   - 从备份恢复

3. **性能问题**
   - 优化索引策略
   - 分批处理数据
   - 监控系统资源

### 调试技巧

1. 使用 `precheck` 命令检查表结构
2. 使用 `validate` 命令验证迁移结果
3. 查看详细的日志输出
4. 在测试环境重现问题

## 示例文件

- `004_example_safe_field_update.sql` - 安全字段更新示例
- `005_rollback_example_safe_field_update.sql` - 回滚迁移示例

## 技术支持

如遇到问题，请：
1. 查看详细日志
2. 在测试环境重现
3. 检查迁移文件语法
4. 参考最佳实践指南
