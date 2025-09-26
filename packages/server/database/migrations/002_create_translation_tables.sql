-- 迁移: 002 - 创建翻译相关表
-- 创建时间: 2024-12-26
-- 描述: 创建翻译条目、项目语言关联、翻译接口配置等表

-- 1. 项目语言关联表


CREATE TABLE project_languages (
  project_id UUID NOT NULL,
  language_code VARCHAR(10) NOT NULL,
  is_enabled BOOLEAN DEFAULT TRUE,
  is_primary BOOLEAN DEFAULT FALSE,
  completion_percentage DECIMAL(5,2) DEFAULT 0.00,
  sort_index INTEGER DEFAULT 0,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (project_id, language_code),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (language_code) REFERENCES languages(code),

-- 约束条件
CONSTRAINT check_completion_percentage CHECK (completion_percentage >= 0 AND completion_percentage <= 100)
);

-- 项目语言关联表索引
CREATE INDEX idx_project_languages_project ON project_languages (project_id)
WHERE
    is_enabled = true;

CREATE INDEX idx_project_languages_completion ON project_languages (completion_percentage DESC)
WHERE
    is_enabled = true;

-- 项目语言关联表触发器
CREATE TRIGGER trigger_project_languages_updated_at 
  BEFORE UPDATE ON project_languages 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 2. 用户翻译接口配置表
CREATE TABLE user_translation_providers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  provider_type VARCHAR(20) NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  app_id TEXT,
  app_key_encrypted TEXT,
  api_url TEXT,
  is_enabled BOOLEAN DEFAULT TRUE,
  is_default BOOLEAN DEFAULT FALSE,

-- 使用统计
usage_count INTEGER DEFAULT 0,
total_characters INTEGER DEFAULT 0,
last_used_at TIMESTAMPTZ,

-- 配置和限制
settings JSONB DEFAULT '{}',
rate_limit INTEGER,
monthly_quota INTEGER,
used_quota INTEGER DEFAULT 0,
quota_reset_at TIMESTAMPTZ,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,

-- 约束条件

CONSTRAINT check_provider_type_valid CHECK (provider_type IN ('baidu', 'youdao', 'google', 'openai', 'deepl', 'custom')),
  CONSTRAINT check_rate_limit CHECK (rate_limit IS NULL OR rate_limit > 0),
  CONSTRAINT check_monthly_quota CHECK (monthly_quota IS NULL OR monthly_quota > 0),
  
  UNIQUE(user_id, provider_type, display_name)
);

-- 翻译接口配置表索引
CREATE INDEX idx_user_translation_providers_user ON user_translation_providers (user_id)
WHERE
    is_enabled = true;

CREATE INDEX idx_user_translation_providers_default ON user_translation_providers (user_id, is_default)
WHERE
    is_default = true;

CREATE INDEX idx_user_translation_providers_type ON user_translation_providers (provider_type)
WHERE
    is_enabled = true;

CREATE INDEX idx_user_translation_providers_usage ON user_translation_providers (
    usage_count DESC,
    last_used_at DESC
);

-- 翻译接口配置表触发器
CREATE TRIGGER trigger_user_translation_providers_updated_at 
  BEFORE UPDATE ON user_translation_providers 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 3. 翻译条目表
CREATE TABLE translation_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL,
  entry_key VARCHAR(500) NOT NULL,
  language_code VARCHAR(10) NOT NULL,
  source_text TEXT,
  target_text TEXT,
  status VARCHAR(20) DEFAULT 'pending',
  translation_provider VARCHAR(50),
  provider_config_id UUID,
  is_ai_translated BOOLEAN DEFAULT FALSE,
  confidence_score DECIMAL(3,2),

-- 人员分配
translator_id UUID, reviewer_id UUID, assigned_at TIMESTAMPTZ,

-- 版本控制
version INTEGER DEFAULT 1, parent_version_id UUID,

-- 内容特征
character_count INTEGER DEFAULT 0,
word_count INTEGER DEFAULT 0,
is_plural BOOLEAN DEFAULT FALSE,
context_info TEXT,

-- 质量控制
quality_score DECIMAL(3, 2),
has_issues BOOLEAN DEFAULT FALSE,
issues JSONB,

-- 时间戳
translated_at TIMESTAMPTZ,
reviewed_at TIMESTAMPTZ,
approved_at TIMESTAMPTZ,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
UNIQUE (
    project_id,
    entry_key,
    language_code
),
FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE,
FOREIGN KEY (language_code) REFERENCES languages (code),
FOREIGN KEY (provider_config_id) REFERENCES user_translation_providers (id) ON DELETE SET NULL,
FOREIGN KEY (translator_id) REFERENCES users (id),
FOREIGN KEY (reviewer_id) REFERENCES users (id),
FOREIGN KEY (parent_version_id) REFERENCES translation_entries (id),

-- 约束条件
CONSTRAINT check_status_valid CHECK (status IN ('pending', 'translating', 'completed', 'reviewing', 'approved', 'rejected')),
  CONSTRAINT check_confidence_score CHECK (confidence_score IS NULL OR (confidence_score >= 0 AND confidence_score <= 1)),
  CONSTRAINT check_quality_score CHECK (quality_score IS NULL OR (quality_score >= 0 AND quality_score <= 1)),
  CONSTRAINT check_character_count CHECK (character_count >= 0),
  CONSTRAINT check_word_count CHECK (word_count >= 0)
);

-- 翻译条目表关键索引
CREATE INDEX idx_translation_entries_project_status ON translation_entries (project_id, status);

CREATE INDEX idx_translation_entries_project_language ON translation_entries (project_id, language_code);

CREATE INDEX idx_translation_entries_key ON translation_entries (entry_key);

CREATE INDEX idx_translation_entries_translator ON translation_entries (translator_id)
WHERE
    translator_id IS NOT NULL;

CREATE INDEX idx_translation_entries_reviewer ON translation_entries (reviewer_id)
WHERE
    reviewer_id IS NOT NULL;

CREATE INDEX idx_translation_entries_status ON translation_entries (status)
WHERE
    status != 'approved';

CREATE INDEX idx_translation_entries_ai ON translation_entries (is_ai_translated)
WHERE
    is_ai_translated = true;

CREATE INDEX idx_translation_entries_updated ON translation_entries (updated_at DESC);

-- 全文搜索索引
CREATE INDEX idx_translation_entries_search ON translation_entries USING gin (
    to_tsvector (
        'english',
        entry_key || ' ' || COALESCE(source_text, '') || ' ' || COALESCE(target_text, '')
    )
);

-- 翻译条目表触发器
CREATE TRIGGER trigger_translation_entries_updated_at 
  BEFORE UPDATE ON translation_entries 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 自动计算字符数和单词数的触发器
CREATE OR REPLACE FUNCTION calculate_text_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- 计算目标文本的字符数和单词数
    IF NEW.target_text IS NOT NULL THEN
        NEW.character_count = length(NEW.target_text);
        NEW.word_count = array_length(string_to_array(trim(NEW.target_text), ' '), 1);
    END IF;
    
    -- 设置翻译完成时间
    IF OLD.status != 'completed' AND NEW.status = 'completed' THEN
        NEW.translated_at = CURRENT_TIMESTAMP;
    END IF;
    
    -- 设置审核时间
    IF OLD.status != 'reviewing' AND NEW.status = 'reviewing' THEN
        NEW.reviewed_at = CURRENT_TIMESTAMP;
    END IF;
    
    -- 设置批准时间
    IF OLD.status != 'approved' AND NEW.status = 'approved' THEN
        NEW.approved_at = CURRENT_TIMESTAMP;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trigger_calculate_text_stats
  BEFORE INSERT OR UPDATE ON translation_entries
  FOR EACH ROW EXECUTE FUNCTION calculate_text_stats();

-- 4. 翻译历史表（分区表）


CREATE TABLE translation_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  translation_entry_id UUID NOT NULL,
  old_target_text TEXT,
  new_target_text TEXT,
  old_status VARCHAR(20),
  new_status VARCHAR(20),
  change_type VARCHAR(20) NOT NULL,
  changed_by UUID NOT NULL,
  change_reason TEXT,
  change_details JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (translation_entry_id) REFERENCES translation_entries(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by) REFERENCES users(id),

-- 约束条件
CONSTRAINT check_change_type_valid CHECK (change_type IN ('create', 'update', 'delete', 'status_change', 'bulk_import'))
) PARTITION BY RANGE (created_at);

-- 创建当前和未来几个月的分区
SELECT create_monthly_partitions ('translation_history', 6);

-- 翻译历史表索引
CREATE INDEX idx_translation_history_entry ON translation_history (
    translation_entry_id,
    created_at DESC
);

CREATE INDEX idx_translation_history_user ON translation_history (changed_by, created_at DESC);

CREATE INDEX idx_translation_history_type ON translation_history (change_type, created_at DESC);

CREATE INDEX idx_translation_history_created ON translation_history (created_at DESC);