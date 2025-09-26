-- 种子数据: 003 - 分配角色权限
-- 创建时间: 2024-12-26
-- 描述: 为各个角色分配相应的权限

-- 超级管理员 - 拥有所有权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'super_admin'
    ), id, true
FROM permissions;

-- 项目所有者 - 项目相关的所有权限 + 翻译权限 + 用户查看权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'project_owner'
    ), id, true
FROM permissions
WHERE
    name IN (
        'project.read',
        'project.update',
        'project.delete',
        'project.manage',
        'translation.create',
        'translation.read',
        'translation.update',
        'translation.delete',
        'translation.review',
        'translation.approve',
        'user.read',
        'provider.create',
        'provider.read',
        'provider.update',
        'provider.delete',
        'provider.use'
    );

-- 项目管理员 - 项目管理权限 + 翻译权限 + 用户查看权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'project_manager'
    ), id, true
FROM permissions
WHERE
    name IN (
        'project.read',
        'project.update',
        'project.manage',
        'translation.create',
        'translation.read',
        'translation.update',
        'translation.delete',
        'translation.review',
        'translation.approve',
        'user.read',
        'provider.read',
        'provider.use'
    );

-- 翻译员 - 翻译相关权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'translator'
    ), id, true
FROM permissions
WHERE
    name IN (
        'project.read',
        'translation.create',
        'translation.read',
        'translation.update',
        'user.read',
        'provider.read',
        'provider.use'
    );

-- 审核员 - 审核相关权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'reviewer'
    ), id, true
FROM permissions
WHERE
    name IN (
        'project.read',
        'translation.read',
        'translation.review',
        'translation.approve',
        'user.read',
        'provider.read'
    );

-- 查看者 - 只读权限
INSERT INTO
    role_permissions (
        role_id,
        permission_id,
        is_granted
    )
SELECT (
        SELECT id
        FROM roles
        WHERE
            name = 'viewer'
    ), id, true
FROM permissions
WHERE
    name IN (
        'project.read',
        'translation.read',
        'user.read',
        'provider.read'
    );