-- 迁移: 004 - 更新用户表字段
-- 创建时间: 2024-12-26
-- 描述: 为用户表添加新字段，修改现有字段，添加索引和约束

-- 1. 添加新字段
ALTER TABLE users
ADD COLUMN IF NOT EXISTS profile_bio TEXT,
ADD COLUMN IF NOT EXISTS social_links JSONB DEFAULT '{}',
ADD COLUMN IF NOT EXISTS notification_preferences JSONB DEFAULT '{"email": true, "push": true, "sms": false}';

-- 2. 修改现有字段（如果需要）
-- 例如：将 phone 字段长度从 20 增加到 30
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(30);

-- 3. 添加新的约束条件
ALTER TABLE users
ADD CONSTRAINT IF NOT EXISTS check_profile_bio_length CHECK (length(profile_bio) <= 500);

-- 4. 添加新索引
CREATE INDEX IF NOT EXISTS idx_users_profile_bio ON users USING gin (
    to_tsvector ('english', profile_bio)
)
WHERE
    profile_bio IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_users_social_links ON users USING gin (social_links)
WHERE
    social_links != '{}';

-- 5. 更新现有数据（如果需要设置默认值）
UPDATE users 
SET notification_preferences = '{"email": true, "push": true, "sms": false}'::jsonb
WHERE notification_preferences IS NULL;

-- 6. 添加字段注释
COMMENT ON COLUMN users.profile_bio IS '用户个人简介';

COMMENT ON COLUMN users.social_links IS '用户社交媒体链接';

COMMENT ON COLUMN users.notification_preferences IS '用户通知偏好设置';