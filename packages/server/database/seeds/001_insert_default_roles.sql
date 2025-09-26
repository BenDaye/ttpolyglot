-- 种子数据: 001 - 插入默认角色
-- 创建时间: 2024-12-26
-- 描述: 插入系统默认角色

INSERT INTO
    roles (
        name,
        display_name,
        description,
        is_system,
        priority
    )
VALUES (
        'super_admin',
        '超级管理员',
        '拥有系统所有权限',
        true,
        1000
    ),
    (
        'project_owner',
        '项目所有者',
        '项目创建者，拥有项目所有权限',
        true,
        900
    ),
    (
        'project_manager',
        '项目管理员',
        '项目管理权限，可管理成员和设置',
        true,
        800
    ),
    (
        'translator',
        '翻译员',
        '翻译权限',
        true,
        500
    ),
    (
        'reviewer',
        '审核员',
        '审核翻译权限',
        true,
        600
    ),
    (
        'viewer',
        '查看者',
        '只读权限',
        true,
        100
    );