-- 迁移: 003 - 创建系统管理表
-- 创建时间: 2024-12-26
-- 描述: 创建系统配置、会话管理、文件上传、通知等表

-- 1. 系统配置表
CREATE TABLE system_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  config_key VARCHAR(100) UNIQUE NOT NULL,
  config_value TEXT,
  value_type VARCHAR(20) DEFAULT 'string',
  category VARCHAR(30) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  is_editable BOOLEAN DEFAULT TRUE,
  is_encrypted BOOLEAN DEFAULT FALSE,
  default_value TEXT,
  validation_rule JSONB,
  sort_order INTEGER DEFAULT 0,

-- 变更追踪
created_by UUID,
updated_by UUID,
last_changed_at TIMESTAMPTZ,
change_reason TEXT,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (created_by) REFERENCES users (id),
FOREIGN KEY (updated_by) REFERENCES users (id),

-- 约束条件
CONSTRAINT check_value_type_valid CHECK (value_type IN ('string', 'number', 'boolean', 'json', 'array')),
  CONSTRAINT check_category_valid CHECK (category IN ('system', 'security', 'translation', 'notification', 'ui', 'api')),
  CONSTRAINT check_config_key_format CHECK (config_key ~* '^[a-z][a-z0-9_]*\.[a-z0-9_]+$')
);

-- 系统配置表索引
CREATE INDEX idx_system_configs_category ON system_configs (category, sort_order);

CREATE INDEX idx_system_configs_public ON system_configs (is_public)
WHERE
    is_public = true;

CREATE INDEX idx_system_configs_editable ON system_configs (is_editable)
WHERE
    is_editable = true;

CREATE INDEX idx_system_configs_key ON system_configs (config_key);

-- 系统配置表触发器
CREATE TRIGGER trigger_system_configs_updated_at 
  BEFORE UPDATE ON system_configs 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 配置变更自动记录触发器
CREATE OR REPLACE FUNCTION track_config_changes()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_changed_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trigger_track_config_changes
  BEFORE UPDATE ON system_configs
  FOR EACH ROW EXECUTE FUNCTION track_config_changes();

-- 2. 用户会话表


CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  token_hash CHAR(64) NOT NULL,
  refresh_token_hash CHAR(64),
  device_id VARCHAR(100),
  device_name VARCHAR(100),
  device_type VARCHAR(20),
  ip_address INET,
  user_agent TEXT,
  location_info JSONB,
  is_active BOOLEAN DEFAULT TRUE,
  last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

-- 约束条件
CONSTRAINT check_device_type_valid CHECK (device_type IN ('web', 'mobile', 'desktop', 'api'))
);

-- 会话表索引
CREATE UNIQUE INDEX idx_user_sessions_token ON user_sessions (token_hash);

CREATE UNIQUE INDEX idx_user_sessions_refresh ON user_sessions (refresh_token_hash)
WHERE
    refresh_token_hash IS NOT NULL;

CREATE INDEX idx_user_sessions_user_active ON user_sessions (
    user_id,
    is_active,
    last_activity_at DESC
);

CREATE INDEX idx_user_sessions_expires ON user_sessions (expires_at)
WHERE
    is_active = true;

CREATE INDEX idx_user_sessions_device ON user_sessions (device_id)
WHERE
    device_id IS NOT NULL;

-- 3. 文件上传表


CREATE TABLE file_uploads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  project_id UUID,
  original_filename VARCHAR(255) NOT NULL,
  stored_filename VARCHAR(255) NOT NULL,
  file_path TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  file_hash CHAR(64) NOT NULL,
  upload_type VARCHAR(20) NOT NULL,
  status VARCHAR(20) DEFAULT 'uploading',
  metadata JSONB DEFAULT '{}',
  processed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,

-- 约束条件
CONSTRAINT check_file_size CHECK (file_size > 0 AND file_size <= 104857600),
  CONSTRAINT check_upload_type_valid CHECK (upload_type IN ('import', 'export', 'avatar', 'attachment')),
  CONSTRAINT check_status_valid CHECK (status IN ('uploading', 'completed', 'processing', 'failed'))
);

-- 文件上传表索引
CREATE INDEX idx_file_uploads_user ON file_uploads (user_id, created_at DESC);

CREATE INDEX idx_file_uploads_project ON file_uploads (project_id, created_at DESC)
WHERE
    project_id IS NOT NULL;

CREATE UNIQUE INDEX idx_file_uploads_hash ON file_uploads (file_hash);

CREATE INDEX idx_file_uploads_type_status ON file_uploads (upload_type, status);

CREATE INDEX idx_file_uploads_expires ON file_uploads (expires_at)
WHERE
    expires_at IS NOT NULL;

-- 4. 通知表


CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  type VARCHAR(20) NOT NULL,
  category VARCHAR(30) NOT NULL,
  priority VARCHAR(10) DEFAULT 'normal',
  data JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,
  action_url TEXT,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

-- 约束条件
CONSTRAINT check_type_valid CHECK (type IN ('info', 'warning', 'error', 'success')),
  CONSTRAINT check_category_valid CHECK (category IN ('translation', 'project', 'system', 'security')),
  CONSTRAINT check_priority_valid CHECK (priority IN ('low', 'normal', 'high', 'urgent'))
);

-- 通知表索引
CREATE INDEX idx_notifications_user_unread ON notifications (
    user_id,
    is_read,
    created_at DESC
);

CREATE INDEX idx_notifications_category ON notifications (category, created_at DESC);

CREATE INDEX idx_notifications_priority ON notifications (priority, created_at DESC)
WHERE
    is_read = false;

CREATE INDEX idx_notifications_expires ON notifications (expires_at)
WHERE
    expires_at IS NOT NULL;

-- 5. 审计日志表（分区表）


CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(50) NOT NULL,
  operation VARCHAR(10) NOT NULL,
  record_id TEXT NOT NULL,
  old_values JSONB,
  new_values JSONB,
  changed_fields TEXT[],
  user_id UUID,
  session_id UUID,
  ip_address INET,
  user_agent TEXT,
  request_id UUID,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (user_id) REFERENCES users(id),

-- 约束条件
CONSTRAINT check_operation_valid CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
) PARTITION BY RANGE (created_at);

-- 创建审计日志分区表
SELECT create_monthly_partitions ('audit_logs', 6);

-- 审计日志索引
CREATE INDEX idx_audit_logs_table_operation ON audit_logs (
    table_name,
    operation,
    created_at DESC
);

CREATE INDEX idx_audit_logs_user ON audit_logs (user_id, created_at DESC);

CREATE INDEX idx_audit_logs_record ON audit_logs (
    table_name,
    record_id,
    created_at DESC
);

CREATE INDEX idx_audit_logs_session ON audit_logs (session_id)
WHERE
    session_id IS NOT NULL;