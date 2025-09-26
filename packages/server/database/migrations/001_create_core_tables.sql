-- 迁移: 001 - 创建核心表（用户、角色、权限）
-- 创建时间: 2024-12-26
-- 描述: 创建用户认证和权限管理相关的核心表

-- 1. 用户表
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  email_encrypted TEXT,
  password_hash CHAR(60) NOT NULL,
  display_name VARCHAR(100),
  avatar_url TEXT,
  phone VARCHAR(20),
  timezone VARCHAR(50) DEFAULT 'UTC',
  locale VARCHAR(10) DEFAULT 'en-US',
  two_factor_enabled BOOLEAN DEFAULT FALSE,
  two_factor_secret TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  is_email_verified BOOLEAN DEFAULT FALSE,
  email_verified_at TIMESTAMPTZ,
  last_login_at TIMESTAMPTZ,
  last_login_ip INET,
  login_attempts INTEGER DEFAULT 0,
  locked_until TIMESTAMPTZ,
  password_changed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

-- 约束条件
CONSTRAINT check_username_length CHECK (length(username) >= 3),
  CONSTRAINT check_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  CONSTRAINT check_display_name_length CHECK (length(display_name) <= 100)
);

-- 用户表索引
CREATE INDEX idx_users_email ON users (email) WHERE is_active = true;

CREATE INDEX idx_users_username ON users (username)
WHERE
    is_active = true;

CREATE INDEX idx_users_last_login ON users (last_login_at DESC)
WHERE
    is_active = true;

CREATE INDEX idx_users_created_at ON users (created_at);

CREATE INDEX idx_users_active_verified ON users (is_active, is_email_verified);

-- 用户表触发器
CREATE TRIGGER trigger_users_updated_at 
  BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 2. 角色表
CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(50) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  is_system BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  priority INTEGER DEFAULT 0,
  permissions_cache JSONB,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

-- 约束条件
CONSTRAINT check_role_name_format CHECK (name ~* '^[a-zA-Z][a-zA-Z0-9_]*$'),
  CONSTRAINT check_display_name_length CHECK (length(display_name) >= 2)
);

-- 角色表索引
CREATE INDEX idx_roles_name ON roles (name) WHERE is_active = true;

CREATE INDEX idx_roles_system ON roles (is_system)
WHERE
    is_active = true;

CREATE INDEX idx_roles_priority ON roles (priority DESC)
WHERE
    is_active = true;

-- 角色表触发器
CREATE TRIGGER trigger_roles_updated_at 
  BEFORE UPDATE ON roles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 3. 权限表
CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  resource VARCHAR(50) NOT NULL,
  action VARCHAR(20) NOT NULL,
  scope VARCHAR(20) DEFAULT 'project',
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

-- 约束条件
CONSTRAINT check_permission_name_format CHECK (name ~* '^[a-z][a-z_]*\.[a-z_]+$'),
  CONSTRAINT check_resource_valid CHECK (resource IN ('project', 'translation', 'user', 'system', 'config', 'provider')),
  CONSTRAINT check_action_valid CHECK (action IN ('create', 'read', 'update', 'delete', 'manage', 'approve', 'review')),
  CONSTRAINT check_scope_valid CHECK (scope IN ('global', 'project', 'resource'))
);

-- 权限表索引
CREATE INDEX idx_permissions_resource_action ON permissions (resource, action)
WHERE
    is_active = true;

CREATE INDEX idx_permissions_name ON permissions (name)
WHERE
    is_active = true;

CREATE INDEX idx_permissions_scope ON permissions (scope)
WHERE
    is_active = true;

-- 4. 角色权限关联表
CREATE TABLE role_permissions (
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    is_granted BOOLEAN DEFAULT TRUE,
    conditions JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE
);

-- 角色权限关联表索引
CREATE INDEX idx_role_permissions_role ON role_permissions (role_id)
WHERE
    is_granted = true;

CREATE INDEX idx_role_permissions_permission ON role_permissions (permission_id)
WHERE
    is_granted = true;

-- 5. 语言表（在这里创建，因为项目表会引用它）
CREATE TABLE languages (
  code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  native_name VARCHAR(100) NOT NULL,
  direction VARCHAR(3) DEFAULT 'ltr',
  is_active BOOLEAN DEFAULT TRUE,
  is_rtl BOOLEAN DEFAULT FALSE,
  pluralization_rule VARCHAR(20),
  sort_index INTEGER DEFAULT 0,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

-- 约束条件
CONSTRAINT check_language_code_format CHECK (code ~* '^[a-z]{2,3}(-[A-Z]{2,4})?(-[a-z]{4})?$'),
  CONSTRAINT check_direction_valid CHECK (direction IN ('ltr', 'rtl'))
);

-- 语言表索引
CREATE INDEX idx_languages_active ON languages (is_active, sort_index);

CREATE INDEX idx_languages_direction ON languages (direction)
WHERE
    is_active = true;

-- 语言表触发器
CREATE TRIGGER trigger_languages_updated_at 
  BEFORE UPDATE ON languages 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 6. 项目表
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  owner_id UUID NOT NULL,
  primary_language_code VARCHAR(10) NOT NULL,
  settings JSONB DEFAULT '{}',
  status VARCHAR(20) DEFAULT 'active',
  visibility VARCHAR(20) DEFAULT 'private',

-- 统计字段
total_keys INTEGER DEFAULT 0,
translated_keys INTEGER DEFAULT 0,
languages_count INTEGER DEFAULT 0,
members_count INTEGER DEFAULT 1,

-- 时间戳
last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
archived_at TIMESTAMPTZ,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (owner_id) REFERENCES users (id),
FOREIGN KEY (primary_language_code) REFERENCES languages (code),

-- 约束条件
CONSTRAINT check_project_name_length CHECK (length(name) >= 2 AND length(name) <= 100),
  CONSTRAINT check_project_slug_format CHECK (slug ~* '^[a-z0-9-]+$'),
  CONSTRAINT check_project_status CHECK (status IN ('active', 'archived', 'suspended')),
  CONSTRAINT check_project_visibility CHECK (visibility IN ('public', 'private', 'internal'))
);

-- 项目表索引
CREATE INDEX idx_projects_owner ON projects (owner_id)
WHERE
    status = 'active';

CREATE INDEX idx_projects_slug ON projects (slug)
WHERE
    status = 'active';

CREATE INDEX idx_projects_status ON projects (status);

CREATE INDEX idx_projects_visibility ON projects (visibility)
WHERE
    status = 'active';

CREATE INDEX idx_projects_activity ON projects (last_activity_at DESC)
WHERE
    status = 'active';

CREATE INDEX idx_projects_created ON projects (created_at);

-- 全文搜索索引
CREATE INDEX idx_projects_search ON projects USING gin (
    to_tsvector (
        'english',
        name || ' ' || COALESCE(description, '')
    )
);

-- 项目表触发器
CREATE TRIGGER trigger_projects_updated_at 
  BEFORE UPDATE ON projects 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 自动生成 slug 的触发器
CREATE OR REPLACE FUNCTION generate_project_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        NEW.slug = lower(regexp_replace(NEW.name, '[^a-zA-Z0-9]+', '-', 'g'));
        NEW.slug = trim(both '-' from NEW.slug);
        
        -- 确保 slug 唯一性
        WHILE EXISTS (SELECT 1 FROM projects WHERE slug = NEW.slug AND id != NEW.id) LOOP
            NEW.slug = NEW.slug || '-' || substr(NEW.id::text, 1, 8);
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trigger_generate_project_slug
  BEFORE INSERT OR UPDATE OF name, slug ON projects
  FOR EACH ROW EXECUTE FUNCTION generate_project_slug();

-- 7. 用户角色关联表（需要在项目表创建后）


CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  role_id UUID NOT NULL,
  project_id UUID NULL,
  granted_by UUID NOT NULL,
  granted_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMPTZ NULL,
  is_active BOOLEAN DEFAULT TRUE,
  metadata JSONB,
  
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (granted_by) REFERENCES users(id),

-- 唯一约束：同一用户在同一项目中不能有重复角色
UNIQUE (user_id, role_id, project_id) );

-- 用户角色关联表索引
CREATE INDEX idx_user_roles_user ON user_roles (user_id)
WHERE
    is_active = true
    AND (
        expires_at IS NULL
        OR expires_at > CURRENT_TIMESTAMP
    );

CREATE INDEX idx_user_roles_project ON user_roles (project_id)
WHERE
    is_active = true
    AND project_id IS NOT NULL;

CREATE INDEX idx_user_roles_expires ON user_roles (expires_at)
WHERE
    expires_at IS NOT NULL
    AND is_active = true;

CREATE INDEX idx_user_roles_user_project ON user_roles (user_id, project_id)
WHERE
    is_active = true;