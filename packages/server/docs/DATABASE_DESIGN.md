# TTPolyglot 数据库设计

## 概述

本文档详细描述了 TTPolyglot 服务端的数据库设计，包括表结构、索引、约束、触发器等。

使用 PostgreSQL 15+ 作为主数据库，采用分区、索引优化等高级特性。

## 核心表结构

### 1. 用户表 (users)

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  email_encrypted TEXT,  -- 加密存储邮箱（可选，用于敏感环境）
  password_hash CHAR(60) NOT NULL,  -- bcrypt 固定长度
  display_name VARCHAR(100),
  avatar_url TEXT,
  phone VARCHAR(20),  -- 新增：电话号码
  timezone VARCHAR(50) DEFAULT 'UTC',  -- 新增：用户时区
  locale VARCHAR(10) DEFAULT 'en-US',  -- 新增：用户语言偏好
  two_factor_enabled BOOLEAN DEFAULT FALSE,  -- 新增：双因子认证
  two_factor_secret TEXT,  -- 新增：2FA密钥
  is_active BOOLEAN DEFAULT TRUE,
  is_email_verified BOOLEAN DEFAULT FALSE,
  email_verified_at TIMESTAMPTZ,  -- 新增：邮箱验证时间
  last_login_at TIMESTAMPTZ,
  last_login_ip INET,  -- 新增：最后登录IP
  login_attempts INTEGER DEFAULT 0,  -- 新增：登录尝试次数
  locked_until TIMESTAMPTZ,  -- 新增：账户锁定时间
  password_changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,  -- 新增：密码修改时间
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  -- 约束条件
  CONSTRAINT check_username_length CHECK (length(username) >= 3),
  CONSTRAINT check_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  CONSTRAINT check_display_name_length CHECK (length(display_name) <= 100)
);

-- 用户表索引优化
CREATE INDEX idx_users_email ON users(email) WHERE is_active = true;
CREATE INDEX idx_users_username ON users(username) WHERE is_active = true;
CREATE INDEX idx_users_last_login ON users(last_login_at DESC) WHERE is_active = true;
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_active_verified ON users(is_active, is_email_verified);
```

### 2. 角色表 (roles)

```sql
CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  is_system BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,  -- 新增：角色启用状态
  priority INTEGER DEFAULT 0,  -- 新增：角色优先级（用于权限计算）
  permissions_cache JSONB,  -- 新增：权限缓存，避免频繁JOIN查询
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  -- 约束条件
  CONSTRAINT check_role_name_format CHECK (name ~* '^[a-zA-Z][a-zA-Z0-9_]*$'),
  CONSTRAINT check_display_name_length CHECK (length(display_name) >= 2)
);

-- 角色表索引
CREATE INDEX idx_roles_name ON roles(name) WHERE is_active = true;
CREATE INDEX idx_roles_system ON roles(is_system) WHERE is_active = true;
CREATE INDEX idx_roles_priority ON roles(priority DESC) WHERE is_active = true;
```

### 3. 权限表 (permissions)

```sql
CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  resource VARCHAR(50) NOT NULL,  -- 资源类型: project, translation, user, system
  action VARCHAR(20) NOT NULL,    -- 操作: create, read, update, delete, manage
  scope VARCHAR(20) DEFAULT 'project',  -- 新增：权限范围 global/project/resource
  is_active BOOLEAN DEFAULT TRUE,  -- 新增：权限启用状态
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  -- 约束条件
  CONSTRAINT check_permission_name_format CHECK (name ~* '^[a-z][a-z_]*\.[a-z_]+$'),
  CONSTRAINT check_resource_valid CHECK (resource IN ('project', 'translation', 'user', 'system', 'config', 'provider')),
  CONSTRAINT check_action_valid CHECK (action IN ('create', 'read', 'update', 'delete', 'manage', 'approve', 'review')),
  CONSTRAINT check_scope_valid CHECK (scope IN ('global', 'project', 'resource'))
);

-- 权限表索引
CREATE INDEX idx_permissions_resource_action ON permissions(resource, action) WHERE is_active = true;
CREATE INDEX idx_permissions_name ON permissions(name) WHERE is_active = true;
CREATE INDEX idx_permissions_scope ON permissions(scope) WHERE is_active = true;
```

### 4. 角色权限关联表 (role_permissions)

```sql
CREATE TABLE role_permissions (
  role_id UUID NOT NULL,
  permission_id UUID NOT NULL,
  is_granted BOOLEAN DEFAULT TRUE,  -- 新增：权限授予状态（支持显式拒绝）
  conditions JSONB,  -- 新增：权限条件（如时间限制、IP限制等）
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- 角色权限关联表索引
CREATE INDEX idx_role_permissions_role ON role_permissions(role_id) WHERE is_granted = true;
CREATE INDEX idx_role_permissions_permission ON role_permissions(permission_id) WHERE is_granted = true;
```

### 5. 用户角色关联表 (user_roles)

```sql
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- 新增：主键ID
  user_id UUID NOT NULL,
  role_id UUID NOT NULL,
  project_id UUID NULL,  -- NULL表示全局角色，否则表示项目级角色
  granted_by UUID NOT NULL,
  granted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NULL,
  is_active BOOLEAN DEFAULT TRUE,  -- 新增：角色激活状态
  metadata JSONB,  -- 新增：角色元数据（如授权原因、特殊条件等）
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (granted_by) REFERENCES users(id),
  
  -- 唯一约束：同一用户在同一项目中不能有重复角色
  UNIQUE (user_id, role_id, project_id)
);

-- 用户角色关联表索引
CREATE INDEX idx_user_roles_user ON user_roles(user_id) 
  WHERE is_active = true AND (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP);
CREATE INDEX idx_user_roles_project ON user_roles(project_id) 
  WHERE is_active = true AND project_id IS NOT NULL;
CREATE INDEX idx_user_roles_expires ON user_roles(expires_at) 
  WHERE expires_at IS NOT NULL AND is_active = true;
CREATE INDEX idx_user_roles_user_project ON user_roles(user_id, project_id) 
  WHERE is_active = true;
```

### 6. 项目表 (projects)

```sql
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,  -- 新增：URL友好的项目标识
  description TEXT,
  owner_id UUID NOT NULL,
  primary_language_code VARCHAR(10) NOT NULL,
  settings JSONB DEFAULT '{}',  -- 项目配置信息（使用JSONB提高性能）
  status VARCHAR(20) DEFAULT 'active',  -- 新增：项目状态 active/archived/suspended
  visibility VARCHAR(20) DEFAULT 'private',  -- 新增：项目可见性 public/private/internal
  
  -- 统计字段（避免频繁统计查询）
  total_keys INTEGER DEFAULT 0,
  translated_keys INTEGER DEFAULT 0,
  languages_count INTEGER DEFAULT 0,
  members_count INTEGER DEFAULT 1,
  
  -- 时间戳
  last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,  -- 新增：最后活动时间
  archived_at TIMESTAMPTZ,  -- 新增：归档时间
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (owner_id) REFERENCES users(id),
  FOREIGN KEY (primary_language_code) REFERENCES languages(code),
  
  -- 约束条件
  CONSTRAINT check_project_name_length CHECK (length(name) >= 2 AND length(name) <= 100),
  CONSTRAINT check_project_slug_format CHECK (slug ~* '^[a-z0-9-]+$'),
  CONSTRAINT check_project_status CHECK (status IN ('active', 'archived', 'suspended')),
  CONSTRAINT check_project_visibility CHECK (visibility IN ('public', 'private', 'internal'))
);

-- 项目表索引优化
CREATE INDEX idx_projects_owner ON projects(owner_id) WHERE status = 'active';
CREATE INDEX idx_projects_slug ON projects(slug) WHERE status = 'active';
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_visibility ON projects(visibility) WHERE status = 'active';
CREATE INDEX idx_projects_activity ON projects(last_activity_at DESC) WHERE status = 'active';
CREATE INDEX idx_projects_created ON projects(created_at);

-- 全文搜索索引
CREATE INDEX idx_projects_search ON projects USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));
```

### 7. 语言表 (languages)

```sql
CREATE TABLE languages (
  code VARCHAR(10) PRIMARY KEY,  -- ISO 639-1/639-2 代码，如 'en', 'zh-CN', 'zh-Hans'
  name VARCHAR(100) NOT NULL,     -- 英文名称
  native_name VARCHAR(100) NOT NULL,  -- 本地名称
  direction VARCHAR(3) DEFAULT 'ltr',  -- 文字方向: ltr, rtl
  is_active BOOLEAN DEFAULT TRUE,
  is_rtl BOOLEAN DEFAULT FALSE,  -- 新增：RTL语言标识
  pluralization_rule VARCHAR(20),  -- 新增：复数规则
  sort_index INTEGER DEFAULT 0,
  metadata JSONB DEFAULT '{}',  -- 新增：语言元数据（如字体建议、输入法等）
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  -- 约束条件
  CONSTRAINT check_language_code_format CHECK (code ~* '^[a-z]{2,3}(-[A-Z]{2,4})?(-[a-z]{4})?$'),
  CONSTRAINT check_direction_valid CHECK (direction IN ('ltr', 'rtl'))
);

-- 语言表索引
CREATE INDEX idx_languages_active ON languages(is_active, sort_index);
CREATE INDEX idx_languages_direction ON languages(direction) WHERE is_active = true;
```

### 8. 项目语言关联表 (project_languages)

```sql
CREATE TABLE project_languages (
  project_id UUID NOT NULL,
  language_code VARCHAR(10) NOT NULL,
  is_enabled BOOLEAN DEFAULT TRUE,
  is_primary BOOLEAN DEFAULT FALSE,  -- 新增：是否为主要语言
  completion_percentage DECIMAL(5,2) DEFAULT 0.00,  -- 新增：翻译完成百分比
  sort_index INTEGER DEFAULT 0,
  settings JSONB DEFAULT '{}',  -- 新增：语言特定设置
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (project_id, language_code),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (language_code) REFERENCES languages(code),
  
  -- 约束条件
  CONSTRAINT check_completion_percentage CHECK (completion_percentage >= 0 AND completion_percentage <= 100)
);

-- 项目语言关联表索引
CREATE INDEX idx_project_languages_project ON project_languages(project_id) WHERE is_enabled = true;
CREATE INDEX idx_project_languages_completion ON project_languages(completion_percentage DESC) WHERE is_enabled = true;
```

### 9. 翻译条目表 (translation_entries)

```sql
CREATE TABLE translation_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL,
  entry_key VARCHAR(500) NOT NULL,  -- 重命名key字段避免保留字
  language_code VARCHAR(10) NOT NULL,
  source_text TEXT,
  target_text TEXT,
  status VARCHAR(20) DEFAULT 'pending',  -- pending, translating, completed, reviewing, approved, rejected
  translation_provider VARCHAR(50),     -- 翻译服务提供商
  provider_config_id UUID,       -- 使用的翻译接口配置ID
  is_ai_translated BOOLEAN DEFAULT FALSE,
  confidence_score DECIMAL(3,2),  -- 新增：翻译置信度（0.00-1.00）
  
  -- 人员分配
  translator_id UUID,
  reviewer_id UUID,
  assigned_at TIMESTAMPTZ,  -- 新增：分配时间
  
  -- 版本控制
  version INTEGER DEFAULT 1,
  parent_version_id UUID,  -- 新增：父版本ID（用于版本追踪）
  
  -- 内容特征
  character_count INTEGER DEFAULT 0,  -- 新增：字符数
  word_count INTEGER DEFAULT 0,       -- 新增：单词数
  is_plural BOOLEAN DEFAULT FALSE,    -- 新增：是否为复数形式
  context_info TEXT,                  -- 新增：翻译上下文信息
  
  -- 质量控制
  quality_score DECIMAL(3,2),  -- 新增：质量评分
  has_issues BOOLEAN DEFAULT FALSE,  -- 新增：是否有问题
  issues JSONB,  -- 新增：问题详情
  
  -- 时间戳
  translated_at TIMESTAMPTZ,    -- 新增：翻译完成时间
  reviewed_at TIMESTAMPTZ,      -- 新增：审核时间
  approved_at TIMESTAMPTZ,      -- 新增：批准时间
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(project_id, entry_key, language_code),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (language_code) REFERENCES languages(code),
  FOREIGN KEY (provider_config_id) REFERENCES user_translation_providers(id) ON DELETE SET NULL,
  FOREIGN KEY (translator_id) REFERENCES users(id),
  FOREIGN KEY (reviewer_id) REFERENCES users(id),
  FOREIGN KEY (parent_version_id) REFERENCES translation_entries(id),
  
  -- 约束条件
  CONSTRAINT check_status_valid CHECK (status IN ('pending', 'translating', 'completed', 'reviewing', 'approved', 'rejected')),
  CONSTRAINT check_confidence_score CHECK (confidence_score IS NULL OR (confidence_score >= 0 AND confidence_score <= 1)),
  CONSTRAINT check_quality_score CHECK (quality_score IS NULL OR (quality_score >= 0 AND quality_score <= 1)),
  CONSTRAINT check_character_count CHECK (character_count >= 0),
  CONSTRAINT check_word_count CHECK (word_count >= 0)
);

-- 翻译条目表关键索引
CREATE INDEX idx_translation_entries_project_status ON translation_entries(project_id, status);
CREATE INDEX idx_translation_entries_project_language ON translation_entries(project_id, language_code);
CREATE INDEX idx_translation_entries_key ON translation_entries(entry_key);
CREATE INDEX idx_translation_entries_translator ON translation_entries(translator_id) WHERE translator_id IS NOT NULL;
CREATE INDEX idx_translation_entries_reviewer ON translation_entries(reviewer_id) WHERE reviewer_id IS NOT NULL;
CREATE INDEX idx_translation_entries_status ON translation_entries(status) WHERE status != 'approved';
CREATE INDEX idx_translation_entries_ai ON translation_entries(is_ai_translated) WHERE is_ai_translated = true;
CREATE INDEX idx_translation_entries_updated ON translation_entries(updated_at DESC);

-- 全文搜索索引
CREATE INDEX idx_translation_entries_search ON translation_entries 
  USING gin(to_tsvector('english', entry_key || ' ' || COALESCE(source_text, '') || ' ' || COALESCE(target_text, '')));
```

### 10. 翻译历史表 (translation_history) - 分区表

```sql
-- 翻译历史表（按月分区，提高大数据量性能）
CREATE TABLE translation_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  translation_entry_id UUID NOT NULL,
  old_target_text TEXT,
  new_target_text TEXT,
  old_status VARCHAR(20),
  new_status VARCHAR(20),
  change_type VARCHAR(20) NOT NULL,  -- create, update, delete, status_change, bulk_import
  changed_by UUID NOT NULL,
  change_reason TEXT,
  change_details JSONB,  -- 新增：详细变更信息
  ip_address INET,  -- 新增：操作IP地址
  user_agent TEXT,  -- 新增：用户代理
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (translation_entry_id) REFERENCES translation_entries(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by) REFERENCES users(id),
  
  -- 约束条件
  CONSTRAINT check_change_type_valid CHECK (change_type IN ('create', 'update', 'delete', 'status_change', 'bulk_import'))
) PARTITION BY RANGE (created_at);

-- 创建分区表（过去6个月和未来6个月）
CREATE TABLE translation_history_202412 PARTITION OF translation_history
  FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');
CREATE TABLE translation_history_202501 PARTITION OF translation_history
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
CREATE TABLE translation_history_202502 PARTITION OF translation_history
  FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

-- 翻译历史表索引
CREATE INDEX idx_translation_history_entry ON translation_history(translation_entry_id, created_at DESC);
CREATE INDEX idx_translation_history_user ON translation_history(changed_by, created_at DESC);
CREATE INDEX idx_translation_history_type ON translation_history(change_type, created_at DESC);
CREATE INDEX idx_translation_history_created ON translation_history(created_at DESC);
```

### 11. 审计日志表 (audit_logs)

```sql
-- 系统审计日志表
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(50) NOT NULL,
  operation VARCHAR(10) NOT NULL,  -- INSERT, UPDATE, DELETE
  record_id TEXT NOT NULL,  -- 被操作记录的ID
  old_values JSONB,  -- 操作前的值
  new_values JSONB,  -- 操作后的值
  changed_fields TEXT[],  -- 变更的字段列表
  user_id UUID,
  session_id UUID,
  ip_address INET,
  user_agent TEXT,
  request_id UUID,  -- 请求追踪ID
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  
  -- 约束条件
  CONSTRAINT check_operation_valid CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
) PARTITION BY RANGE (created_at);

-- 审计日志分区表
CREATE TABLE audit_logs_202412 PARTITION OF audit_logs
  FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');
CREATE TABLE audit_logs_202501 PARTITION OF audit_logs
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

-- 审计日志索引
CREATE INDEX idx_audit_logs_table_operation ON audit_logs(table_name, operation, created_at DESC);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_logs_record ON audit_logs(table_name, record_id, created_at DESC);
CREATE INDEX idx_audit_logs_session ON audit_logs(session_id) WHERE session_id IS NOT NULL;
```

### 12. 用户会话表 (user_sessions)

```sql
-- 用户会话管理表
CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  token_hash CHAR(64) NOT NULL,  -- JWT Token hash (SHA256)
  refresh_token_hash CHAR(64),   -- Refresh Token hash
  device_id VARCHAR(100),
  device_name VARCHAR(100),
  device_type VARCHAR(20),  -- web, mobile, desktop, api
  ip_address INET,
  user_agent TEXT,
  location_info JSONB,  -- 地理位置信息
  is_active BOOLEAN DEFAULT TRUE,
  last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- 约束条件
  CONSTRAINT check_device_type_valid CHECK (device_type IN ('web', 'mobile', 'desktop', 'api'))
);

-- 会话表索引
CREATE UNIQUE INDEX idx_user_sessions_token ON user_sessions(token_hash);
CREATE UNIQUE INDEX idx_user_sessions_refresh ON user_sessions(refresh_token_hash) WHERE refresh_token_hash IS NOT NULL;
CREATE INDEX idx_user_sessions_user_active ON user_sessions(user_id, is_active, last_activity_at DESC);
CREATE INDEX idx_user_sessions_expires ON user_sessions(expires_at) WHERE is_active = true;
CREATE INDEX idx_user_sessions_device ON user_sessions(device_id) WHERE device_id IS NOT NULL;
```

### 13. 文件上传表 (file_uploads)

```sql
-- 文件上传管理表
CREATE TABLE file_uploads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  project_id UUID,
  original_filename VARCHAR(255) NOT NULL,
  stored_filename VARCHAR(255) NOT NULL,
  file_path TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  file_hash CHAR(64) NOT NULL,  -- SHA256 hash
  upload_type VARCHAR(20) NOT NULL,  -- import, export, avatar, attachment
  status VARCHAR(20) DEFAULT 'uploading',  -- uploading, completed, processing, failed
  metadata JSONB DEFAULT '{}',
  processed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  
  -- 约束条件
  CONSTRAINT check_file_size CHECK (file_size > 0 AND file_size <= 104857600),  -- 100MB limit
  CONSTRAINT check_upload_type_valid CHECK (upload_type IN ('import', 'export', 'avatar', 'attachment')),
  CONSTRAINT check_status_valid CHECK (status IN ('uploading', 'completed', 'processing', 'failed'))
);

-- 文件上传表索引
CREATE INDEX idx_file_uploads_user ON file_uploads(user_id, created_at DESC);
CREATE INDEX idx_file_uploads_project ON file_uploads(project_id, created_at DESC) WHERE project_id IS NOT NULL;
CREATE UNIQUE INDEX idx_file_uploads_hash ON file_uploads(file_hash);
CREATE INDEX idx_file_uploads_type_status ON file_uploads(upload_type, status);
CREATE INDEX idx_file_uploads_expires ON file_uploads(expires_at) WHERE expires_at IS NOT NULL;
```

### 14. 通知表 (notifications)

```sql
-- 用户通知表
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(20) NOT NULL,  -- info, warning, error, success
  category VARCHAR(30) NOT NULL,  -- translation, project, system, security
  priority VARCHAR(10) DEFAULT 'normal',  -- low, normal, high, urgent
  data JSONB DEFAULT '{}',  -- 相关数据
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,
  action_url TEXT,  -- 操作链接
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- 约束条件
  CONSTRAINT check_type_valid CHECK (type IN ('info', 'warning', 'error', 'success')),
  CONSTRAINT check_category_valid CHECK (category IN ('translation', 'project', 'system', 'security')),
  CONSTRAINT check_priority_valid CHECK (priority IN ('low', 'normal', 'high', 'urgent'))
);

-- 通知表索引
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_notifications_category ON notifications(category, created_at DESC);
CREATE INDEX idx_notifications_priority ON notifications(priority, created_at DESC) WHERE is_read = false;
CREATE INDEX idx_notifications_expires ON notifications(expires_at) WHERE expires_at IS NOT NULL;
```

### 15. 用户翻译接口配置表 (user_translation_providers)

```sql
CREATE TABLE user_translation_providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  provider_type VARCHAR(20) NOT NULL,  -- baidu, youdao, google, openai, deepl, custom
  display_name VARCHAR(100) NOT NULL,   -- 用户自定义的显示名称
  app_id TEXT,                  -- API App ID (百度、有道等需要)
  app_key_encrypted TEXT,       -- 加密的 API Key (敏感信息加密存储)
  api_url TEXT,                 -- 自定义翻译API的URL (仅custom类型使用)
  is_enabled BOOLEAN DEFAULT TRUE,
  is_default BOOLEAN DEFAULT FALSE,
  
  -- 使用统计
  usage_count INTEGER DEFAULT 0,       -- 使用次数
  total_characters INTEGER DEFAULT 0,  -- 总翻译字符数
  last_used_at TIMESTAMPTZ,            -- 最后使用时间
  
  -- 配置和限制
  settings JSONB DEFAULT '{}',         -- 其他配置参数
  rate_limit INTEGER,                  -- 速率限制 (每分钟请求数)
  monthly_quota INTEGER,               -- 月配额
  used_quota INTEGER DEFAULT 0,        -- 已使用配额
  quota_reset_at TIMESTAMPTZ,          -- 配额重置时间
  
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  
  -- 约束条件
  CONSTRAINT check_provider_type_valid CHECK (provider_type IN ('baidu', 'youdao', 'google', 'openai', 'deepl', 'custom')),
  CONSTRAINT check_rate_limit CHECK (rate_limit IS NULL OR rate_limit > 0),
  CONSTRAINT check_monthly_quota CHECK (monthly_quota IS NULL OR monthly_quota > 0),
  
  UNIQUE(user_id, provider_type, display_name)
);

-- 翻译接口配置表索引
CREATE INDEX idx_user_translation_providers_user ON user_translation_providers(user_id) WHERE is_enabled = true;
CREATE INDEX idx_user_translation_providers_default ON user_translation_providers(user_id, is_default) WHERE is_default = true;
CREATE INDEX idx_user_translation_providers_type ON user_translation_providers(provider_type) WHERE is_enabled = true;
CREATE INDEX idx_user_translation_providers_usage ON user_translation_providers(usage_count DESC, last_used_at DESC);
```

### 16. 系统配置表 (system_configs)

```sql
CREATE TABLE system_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_key VARCHAR(100) UNIQUE NOT NULL,  -- 重命名key字段避免保留字
  config_value TEXT,                         -- 配置值
  value_type VARCHAR(20) DEFAULT 'string',   -- 值类型: string, number, boolean, json, array
  category VARCHAR(30) NOT NULL,             -- 配置分类
  display_name VARCHAR(100) NOT NULL,        -- 显示名称
  description TEXT,                          -- 配置描述
  is_public BOOLEAN DEFAULT FALSE,           -- 是否公开 (前端可读取)
  is_editable BOOLEAN DEFAULT TRUE,          -- 是否可编辑
  is_encrypted BOOLEAN DEFAULT FALSE,        -- 是否加密存储
  default_value TEXT,                        -- 默认值
  validation_rule JSONB,                     -- 验证规则 (JSON格式)
  sort_order INTEGER DEFAULT 0,              -- 排序顺序
  
  -- 变更追踪
  created_by UUID,
  updated_by UUID,
  last_changed_at TIMESTAMPTZ,
  change_reason TEXT,                        -- 变更原因
  
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (updated_by) REFERENCES users(id),
  
  -- 约束条件
  CONSTRAINT check_value_type_valid CHECK (value_type IN ('string', 'number', 'boolean', 'json', 'array')),
  CONSTRAINT check_category_valid CHECK (category IN ('system', 'security', 'translation', 'notification', 'ui', 'api')),
  CONSTRAINT check_config_key_format CHECK (config_key ~* '^[a-z][a-z0-9_]*\.[a-z0-9_]+$')
);

-- 系统配置表索引
CREATE INDEX idx_system_configs_category ON system_configs(category, sort_order);
CREATE INDEX idx_system_configs_public ON system_configs(is_public) WHERE is_public = true;
CREATE INDEX idx_system_configs_editable ON system_configs(is_editable) WHERE is_editable = true;
CREATE INDEX idx_system_configs_key ON system_configs(config_key);
```

## 通用触发器函数

```sql
-- 自动更新 updated_at 字段的通用触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为所有有 updated_at 字段的表创建触发器
CREATE TRIGGER trigger_users_updated_at 
  BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_roles_updated_at 
  BEFORE UPDATE ON roles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_projects_updated_at 
  BEFORE UPDATE ON projects 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_languages_updated_at 
  BEFORE UPDATE ON languages 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_project_languages_updated_at 
  BEFORE UPDATE ON project_languages 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_translation_entries_updated_at 
  BEFORE UPDATE ON translation_entries 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_user_translation_providers_updated_at 
  BEFORE UPDATE ON user_translation_providers 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_system_configs_updated_at 
  BEFORE UPDATE ON system_configs 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## 初始数据

### 系统角色
```sql
INSERT INTO roles (name, display_name, description, is_system, priority) VALUES
('super_admin', '超级管理员', '拥有系统所有权限', true, 1000),
('project_owner', '项目所有者', '项目创建者，拥有项目所有权限', true, 900),
('project_manager', '项目管理员', '项目管理权限，可管理成员和设置', true, 800),
('translator', '翻译员', '翻译权限', true, 500),
('reviewer', '审核员', '审核翻译权限', true, 600),
('viewer', '查看者', '只读权限', true, 100);
```

### 系统权限
```sql
-- 项目权限
INSERT INTO permissions (name, display_name, description, resource, action, scope) VALUES
('project.create', '创建项目', '创建新项目', 'project', 'create', 'global'),
('project.read', '查看项目', '查看项目信息', 'project', 'read', 'project'),
('project.update', '编辑项目', '编辑项目信息', 'project', 'update', 'project'),
('project.delete', '删除项目', '删除项目', 'project', 'delete', 'project'),
('project.manage', '管理项目', '管理项目成员和权限', 'project', 'manage', 'project'),

-- 翻译权限
('translation.create', '创建翻译', '创建翻译条目', 'translation', 'create', 'project'),
('translation.read', '查看翻译', '查看翻译条目', 'translation', 'read', 'project'),
('translation.update', '编辑翻译', '编辑翻译条目', 'translation', 'update', 'project'),
('translation.delete', '删除翻译', '删除翻译条目', 'translation', 'delete', 'project'),
('translation.review', '审核翻译', '审核翻译条目', 'translation', 'review', 'project'),
('translation.approve', '批准翻译', '批准翻译条目', 'translation', 'approve', 'project'),

-- 用户权限
('user.read', '查看用户', '查看用户信息', 'user', 'read', 'global'),
('user.update', '编辑用户', '编辑用户信息', 'user', 'update', 'global'),
('user.delete', '删除用户', '删除用户', 'user', 'delete', 'global'),
('user.manage_roles', '管理用户角色', '分配和撤销用户角色', 'user', 'manage', 'global'),

-- 系统权限
('system.admin', '系统管理', '系统管理权限', 'system', 'manage', 'global'),
('system.backup', '数据备份', '数据备份权限', 'system', 'create', 'global'),
('system.restore', '数据恢复', '数据恢复权限', 'system', 'update', 'global'),

-- 配置权限
('config.read', '查看配置', '查看系统配置', 'config', 'read', 'global'),
('config.update', '修改配置', '修改系统配置', 'config', 'update', 'global'),
('config.create', '创建配置', '创建系统配置', 'config', 'create', 'global'),
('config.delete', '删除配置', '删除系统配置', 'config', 'delete', 'global'),

-- 翻译接口权限
('provider.create', '创建翻译接口', '创建翻译接口配置', 'provider', 'create', 'resource'),
('provider.read', '查看翻译接口', '查看翻译接口配置', 'provider', 'read', 'resource'),
('provider.update', '编辑翻译接口', '编辑翻译接口配置', 'provider', 'update', 'resource'),
('provider.delete', '删除翻译接口', '删除翻译接口配置', 'provider', 'delete', 'resource'),
('provider.use', '使用翻译接口', '使用翻译接口进行翻译', 'provider', 'read', 'resource');
```

### 语言数据
```sql
INSERT INTO languages (code, name, native_name, direction, is_rtl, sort_index) VALUES
('en', 'English', 'English', 'ltr', false, 1),
('zh-CN', 'Chinese (Simplified)', '简体中文', 'ltr', false, 2),
('zh-TW', 'Chinese (Traditional)', '繁體中文', 'ltr', false, 3),
('ja', 'Japanese', '日本語', 'ltr', false, 4),
('ko', 'Korean', '한국어', 'ltr', false, 5),
('fr', 'French', 'Français', 'ltr', false, 6),
('de', 'German', 'Deutsch', 'ltr', false, 7),
('es', 'Spanish', 'Español', 'ltr', false, 8),
('it', 'Italian', 'Italiano', 'ltr', false, 9),
('pt', 'Portuguese', 'Português', 'ltr', false, 10),
('ru', 'Russian', 'Русский', 'ltr', false, 11),
('ar', 'Arabic', 'العربية', 'rtl', true, 12),
('he', 'Hebrew', 'עברית', 'rtl', true, 13),
('hi', 'Hindi', 'हिन्दी', 'ltr', false, 14),
('th', 'Thai', 'ไทย', 'ltr', false, 15),
('vi', 'Vietnamese', 'Tiếng Việt', 'ltr', false, 16);
```

### 系统配置
```sql
INSERT INTO system_configs (config_key, config_value, value_type, category, display_name, description, is_public) VALUES
-- 系统配置
('system.site_title', 'TTPolyglot', 'string', 'system', '网站标题', '系统显示的标题', true),
('system.site_description', 'Multi-language translation management system', 'string', 'system', '网站描述', '系统描述信息', true),
('system.max_upload_size', '10485760', 'number', 'system', '最大上传文件大小', '单位：字节', false),
('system.session_timeout', '1440', 'number', 'system', '会话超时时间', '单位：分钟', false),

-- 安全配置
('security.password_min_length', '8', 'number', 'security', '密码最小长度', '用户密码最小长度要求', false),
('security.password_require_special', 'true', 'boolean', 'security', '密码需要特殊字符', '是否要求密码包含特殊字符', false),
('security.login_max_attempts', '5', 'number', 'security', '登录最大尝试次数', '账户锁定前的最大登录尝试次数', false),
('security.jwt_expire_hours', '24', 'number', 'security', 'JWT过期时间', '单位：小时', false),

-- 翻译配置
('translation.max_text_length', '5000', 'number', 'translation', '单次翻译最大字符数', '每次翻译请求的最大字符数限制', false),
('translation.auto_save_interval', '30', 'number', 'translation', '自动保存间隔', '单位：秒', true),
('translation.batch_size_limit', '100', 'number', 'translation', '批量翻译数量限制', '批量操作的最大条目数', false);
```

## 性能优化建议

### 分区管理
```sql
-- 创建自动分区管理函数
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

-- 定期清理旧分区
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
```

### 数据库连接优化
```sql
-- 连接池配置建议
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;
```

### 监控视图
```sql
-- 统计信息更新视图
CREATE OR REPLACE VIEW database_stats AS
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- 缓存命中率监控视图
CREATE OR REPLACE VIEW cache_hit_ratio AS
SELECT 
    schemaname,
    tablename,
    heap_blks_read,
    heap_blks_hit,
    CASE 
        WHEN heap_blks_read + heap_blks_hit > 0 
        THEN round((heap_blks_hit::float / (heap_blks_read + heap_blks_hit)) * 100, 2)
        ELSE 0 
    END as cache_hit_ratio_percent
FROM pg_statio_user_tables
WHERE heap_blks_read + heap_blks_hit > 0
ORDER BY cache_hit_ratio_percent ASC;
```
