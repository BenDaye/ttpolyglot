# tt-cuisine M0 · 地基 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在新仓 `tt-cuisine` 跑通"Hello, DishConcept"最小端到端闭环——admin web 登录后创建一个含 5 语别名的 DishConcept，API `GET /api/v1/concepts/{slug}` 能取回 JSON，`docker compose up` 全栈跑通，CI 全绿。

**Architecture:** 单仓 monorepo（Python + React）；uv workspace 管理 Python 包；FastAPI 单进程 API；Vite + React + AntD admin web；PostgreSQL 16 + 三个扩展（pgvector/pg_trgm/unaccent）虽未在 M0 使用但 day-1 启用；六边形分层雏形（domain 包独立 + API 引用 domain）。

**Tech Stack:** Python 3.12 / uv / FastAPI / SQLAlchemy 2.0 async / Alembic / Pydantic v2 / ruff / mypy strict / pytest · React 18 / Vite / TypeScript strict / Ant Design 5 / TanStack Router / TanStack Query / Zustand / Clerk · PostgreSQL 16 / Docker Compose / GitHub Actions

**源 spec：** `/home/ben/projects/ttpolyglot/docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md` §7.2

---

## 前置条件（Prerequisites）

动手前必须就位：

1. **Clerk 账号 + app**：访问 https://clerk.com 注册，创建一个 development app。记下：
   - `CLERK_PUBLISHABLE_KEY`（前端用，pk_test_...）
   - `CLERK_SECRET_KEY`（后端用，sk_test_...）
   - `CLERK_JWKS_URL`（后端 JWT 验签用，通常 `https://<app>.clerk.accounts.dev/.well-known/jwks.json`）
2. **工具链**：
   - `uv >= 0.5.x`（Python 包管理 + workspace）：`curl -LsSf https://astral.sh/uv/install.sh | sh`
   - `Node.js >= 20`（推荐 `nvm install 20`）
   - `pnpm >= 9.x`（前端包管理）：`npm i -g pnpm`
   - `Docker + Docker Compose`（docker compose v2 plugin 内置即可）
   - `psql`（PostgreSQL client，验证用）
3. **新仓路径**：`/home/ben/projects/tt-cuisine`（旧仓兄弟目录）。Plan 全程使用此绝对路径。

---

## 文件结构（M0 完成时的目标）

```
/home/ben/projects/tt-cuisine/
├── .claude/
│   ├── settings.json
│   ├── hooks/
│   │   ├── python-format.sh
│   │   └── block-generated.sh
│   ├── agents/                            # M0 留空
│   ├── commands/                          # M0 留空
│   └── skills/                            # M0 留空
├── .github/
│   └── workflows/
│       └── ci.yml
├── .serena/                               # 从旧仓复制
├── apps/
│   ├── api/
│   │   ├── pyproject.toml
│   │   ├── src/tt_cuisine_api/
│   │   │   ├── __init__.py
│   │   │   ├── main.py
│   │   │   ├── config.py
│   │   │   ├── logging.py
│   │   │   ├── db.py
│   │   │   ├── auth.py
│   │   │   ├── models/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── base.py
│   │   │   │   └── concept.py
│   │   │   ├── repositories/
│   │   │   │   ├── __init__.py
│   │   │   │   └── concept.py
│   │   │   └── routers/
│   │   │       ├── __init__.py
│   │   │       ├── health.py
│   │   │       └── concepts.py
│   │   ├── tests/
│   │   │   ├── __init__.py
│   │   │   ├── conftest.py
│   │   │   ├── test_health.py
│   │   │   └── test_concepts.py
│   │   └── Dockerfile
│   └── admin-web/
│       ├── package.json
│       ├── tsconfig.json
│       ├── vite.config.ts
│       ├── playwright.config.ts
│       ├── index.html
│       ├── nginx.conf
│       ├── Dockerfile
│       ├── src/
│       │   ├── main.tsx
│       │   ├── styles.css
│       │   ├── routeTree.gen.ts           # auto-gen by TanStack
│       │   ├── routes/
│       │   │   ├── __root.tsx
│       │   │   ├── index.tsx
│       │   │   ├── concepts.new.tsx
│       │   │   └── concepts.$slug.tsx
│       │   ├── api/
│       │   │   ├── client.ts
│       │   │   └── concepts.ts
│       │   └── components/
│       │       └── ConceptForm.tsx
│       └── tests/
│           └── e2e/
│               └── create-concept.spec.ts
├── packages/
│   └── domain/
│       ├── pyproject.toml
│       ├── src/tt_cuisine_domain/
│       │   ├── __init__.py
│       │   ├── language.py
│       │   ├── status.py
│       │   ├── name.py
│       │   └── concept.py
│       └── tests/
│           ├── __init__.py
│           ├── test_language.py
│           ├── test_status.py
│           ├── test_name.py
│           └── test_concept.py
├── ops/
│   ├── compose/
│   │   ├── docker-compose.yml
│   │   ├── .env.example
│   │   └── postgres-init.sql
│   └── migrations/
│       ├── alembic.ini
│       ├── env.py
│       ├── script.py.mako
│       └── versions/
│           └── 0001_initial_schema.py
├── docs/
│   └── specs/
│       └── 2026-05-21-dish-corpus-redesign-design.md
├── .env.example
├── .gitignore
├── pyproject.toml                         # uv workspace root
├── Makefile
├── README.md
└── LICENSE
```

**单一职责约束**：
- `packages/domain` 纯 Pydantic v2 + Python stdlib，**零 I/O**，可单元测试
- `apps/api/src/tt_cuisine_api/models` SQLAlchemy ORM（与 domain Pydantic 解耦）
- `apps/api/src/tt_cuisine_api/repositories` 数据访问，**只依赖 ORM models 与 domain**
- `apps/api/src/tt_cuisine_api/routers` HTTP 层，**只依赖 repositories 与 domain**

---

## 任务总览（35 个任务，分 8 个 phase）

| Phase | Tasks | 主题 |
|---|---|---|
| 0 · 旧仓归档 | 1 | 本仓 ttpolyglot 打 tag + deprecation note |
| 1 · 新仓骨架 | 2-4 | 仓库初始化 + Claude 配置迁移 + spec 文档迁移 |
| 2 · 数据库基础 | 5-7 | Docker Compose PG + Alembic init + 第一个迁移 |
| 3 · Domain 层 | 8-12 | domain 包骨架 + 4 个 Pydantic 模型（TDD） |
| 4 · API 层 | 13-21 | FastAPI skeleton + JSON log + DB session + ORM + repo + 3 endpoints + Clerk auth |
| 5 · admin-web | 22-29 | Vite + React 骨架 + AntD + Router + Clerk + API client + 3 pages |
| 6 · 全栈 Compose + E2E | 30-33 | API Dockerfile + web Dockerfile + 完整 compose + Playwright E2E |
| 7 · CI | 34 | GitHub Actions workflow |
| 8 · 收尾 | 35 | README + 启动文档 |

**严禁出现（来自 spec §7.2.5）**：LLM 调用、TTPOS 接入（含 mock）、写路径管道、Meilisearch 索引接入、Ingredient/CookingMethod 实体、worker 进程、Redis、MinIO。

**Success criteria（M0 完成的硬证据）**：
- [ ] `cd /home/ben/projects/tt-cuisine && docker compose up` 后 admin web 能登录
- [ ] admin web 创建 "宫保鸡丁" 含 5 语别名（zh-CN/zh-HK/en-US/ja-JP/ko-KR）
- [ ] `curl http://localhost:8000/api/v1/concepts/gong-bao-ji-ding` 返回该 concept JSON
- [ ] CI 全绿（ruff + mypy + pytest + vitest + playwright）
- [ ] domain 包单元测试 + 1 个 Playwright E2E 测试通过

---

## Phase 0 · 旧仓归档

### Task 1: 本仓 ttpolyglot 打 deprecation tag + README note

**Files:**
- Modify: `/home/ben/projects/ttpolyglot/README.md` 顶部
- 新建 git tag: `v0.1.0-i18n-direction-archive`

- [ ] **Step 1: 在本仓 README.md 顶部插入 deprecation block**

打开 `/home/ben/projects/ttpolyglot/README.md`，在第 1 行（标题 `# TTPolyglot 🌍` 之前）插入以下内容并加一个分隔空行：

```markdown
> ⚠️ **本仓已归档**
>
> TTPolyglot 在 2026-05-21 完成方向转向：放弃通用 i18n 工具方向，
> 推倒重做为**菜品垂类多语言语料库**（新仓 `tt-cuisine`）。
>
> - 决策溯源与完整设计：[docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md](docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md)
> - M0 实施计划：[docs/superpowers/plans/2026-05-21-tt-cuisine-m0-foundation.md](docs/superpowers/plans/2026-05-21-tt-cuisine-m0-foundation.md)
> - 归档 tag：`v0.1.0-i18n-direction-archive`
>
> 本仓保留作历史档案与决策溯源；新开发请前往 `tt-cuisine`。

---

```

- [ ] **Step 2: 提交 deprecation note**

```bash
cd /home/ben/projects/ttpolyglot
git add README.md
git commit -m "docs: 顶部添加 deprecation note，指向新仓 tt-cuisine"
```

预期：1 file changed, 13 insertions(+).

- [ ] **Step 3: 打归档 tag**

```bash
cd /home/ben/projects/ttpolyglot
git tag -a v0.1.0-i18n-direction-archive -m "i18n 工具方向最后定格；自此推倒重做转向菜品垂类语料库 tt-cuisine"
git tag -l v0.1.0-i18n-direction-archive
```

预期：`v0.1.0-i18n-direction-archive` 输出。

- [ ] **Step 4: 验收**

确认：
- `head -20 /home/ben/projects/ttpolyglot/README.md` 显示 deprecation block
- `git tag -l 'v0.1.*'` 列出新 tag

**Acceptance**：本仓被打上归档 tag，README 顶部明确指向新仓位置。本仓状态对外部读者清晰。

---

## Phase 1 · 新仓骨架

### Task 2: 创建 tt-cuisine 仓库与顶层配置文件

**Files:**
- Create: `/home/ben/projects/tt-cuisine/` 目录
- Create: `pyproject.toml`（uv workspace root）
- Create: `.gitignore`
- Create: `LICENSE`（从旧仓复制）
- Create: `README.md`（最小版本，Task 35 完善）
- Create: `Makefile`
- Create: `.env.example`

- [ ] **Step 1: 创建目录与 git init**

```bash
mkdir -p /home/ben/projects/tt-cuisine
cd /home/ben/projects/tt-cuisine
git init -b main
```

预期：`Initialized empty Git repository in /home/ben/projects/tt-cuisine/.git/`。

- [ ] **Step 2: 复制 LICENSE**

```bash
cp /home/ben/projects/ttpolyglot/LICENSE /home/ben/projects/tt-cuisine/LICENSE
```

- [ ] **Step 3: 创建 `.gitignore`**

写入 `/home/ben/projects/tt-cuisine/.gitignore`：

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# uv / virtualenv
.venv/
venv/
ENV/
env/
.python-version

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.nox/
coverage.xml
*.cover

# Type checking
.mypy_cache/
.ruff_cache/
.pyright/

# Node
node_modules/
.pnp.*
.yarn/
pnpm-lock.yaml.bak

# Vite
dist/
dist-ssr/
*.local

# Playwright
playwright-report/
test-results/
playwright/.cache/

# Build outputs (frontend)
apps/admin-web/dist/

# Environment
.env
.env.local
.env.*.local
!.env.example

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Docker volumes (when bind-mounted)
ops/compose/data/

# Alembic auto-gen artifacts (we hand-write migrations)
# (intentionally NOT ignored — versions/ tracked)

# Logs
*.log
logs/
```

- [ ] **Step 4: 创建 `pyproject.toml`（uv workspace root）**

写入 `/home/ben/projects/tt-cuisine/pyproject.toml`：

```toml
[project]
name = "tt-cuisine"
version = "0.1.0"
description = "Multilingual structured dish corpus for the global cuisine industry"
readme = "README.md"
requires-python = ">=3.12"
license = { text = "Apache-2.0" }
authors = [{ name = "TTPolyglot Team" }]

[tool.uv.workspace]
members = ["apps/api", "packages/domain"]

[tool.uv]
dev-dependencies = [
    "ruff>=0.7.0",
    "mypy>=1.13.0",
    "pytest>=8.3.0",
    "pytest-asyncio>=0.24.0",
    "httpx>=0.27.0",
]

[tool.ruff]
line-length = 120
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "C4", "SIM", "RUF"]
ignore = ["E501"]  # line-too-long handled by formatter

[tool.ruff.format]
quote-style = "double"
indent-style = "space"

[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_unimported = true
no_implicit_optional = true
check_untyped_defs = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
plugins = ["pydantic.mypy"]

[[tool.mypy.overrides]]
module = ["alembic.*"]
ignore_missing_imports = true

[tool.pytest.ini_options]
testpaths = ["apps/api/tests", "packages/domain/tests"]
asyncio_mode = "auto"
addopts = "-v --tb=short"
```

- [ ] **Step 5: 创建 `Makefile`**

写入 `/home/ben/projects/tt-cuisine/Makefile`：

```makefile
.PHONY: help install fmt lint type test test-api test-domain api-dev web-dev web-install \
        compose-up compose-down compose-build db-migrate db-revision e2e clean

help:
	@echo "tt-cuisine development commands"
	@echo ""
	@echo "  install        Install all dependencies (Python + Node)"
	@echo "  fmt            Format Python (ruff format) + frontend (prettier)"
	@echo "  lint           Lint Python (ruff check) + frontend (eslint)"
	@echo "  type           Type-check Python (mypy) + frontend (tsc)"
	@echo "  test           Run all tests"
	@echo "  test-api       Run API tests only"
	@echo "  test-domain    Run domain tests only"
	@echo "  api-dev        Run API in dev mode (uvicorn --reload)"
	@echo "  web-dev        Run admin-web in dev mode (vite)"
	@echo "  web-install    Install admin-web deps"
	@echo "  compose-up     docker compose up (full stack)"
	@echo "  compose-down   docker compose down"
	@echo "  compose-build  docker compose build"
	@echo "  db-migrate     alembic upgrade head"
	@echo "  db-revision    alembic revision (manual; not autogen for M0)"
	@echo "  e2e            Run Playwright E2E"
	@echo "  clean          Remove build artifacts"

install:
	uv sync --all-packages
	cd apps/admin-web && pnpm install

fmt:
	uv run ruff format .
	cd apps/admin-web && pnpm format

lint:
	uv run ruff check .
	cd apps/admin-web && pnpm lint

type:
	uv run mypy apps/api packages/domain
	cd apps/admin-web && pnpm type-check

test: test-domain test-api
	cd apps/admin-web && pnpm test

test-api:
	uv run pytest apps/api/tests -v

test-domain:
	uv run pytest packages/domain/tests -v

api-dev:
	cd apps/api && uv run uvicorn tt_cuisine_api.main:app --reload --host 0.0.0.0 --port 8000

web-dev:
	cd apps/admin-web && pnpm dev

web-install:
	cd apps/admin-web && pnpm install

compose-up:
	cd ops/compose && docker compose up -d

compose-down:
	cd ops/compose && docker compose down

compose-build:
	cd ops/compose && docker compose build

db-migrate:
	cd ops/migrations && uv run alembic upgrade head

db-revision:
	cd ops/migrations && uv run alembic revision -m "$(MSG)"

e2e:
	cd apps/admin-web && pnpm exec playwright test

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	rm -rf apps/admin-web/dist apps/admin-web/node_modules/.vite
```

- [ ] **Step 6: 创建 `.env.example`**

写入 `/home/ben/projects/tt-cuisine/.env.example`：

```env
# PostgreSQL
POSTGRES_USER=ttcuisine
POSTGRES_PASSWORD=devpassword_change_in_prod
POSTGRES_DB=tt_cuisine
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# API
API_HOST=0.0.0.0
API_PORT=8000
API_LOG_LEVEL=INFO
DATABASE_URL=postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine

# Clerk (frontend)
VITE_CLERK_PUBLISHABLE_KEY=pk_test_REPLACE_ME

# Clerk (backend JWT verification)
CLERK_SECRET_KEY=sk_test_REPLACE_ME
CLERK_JWKS_URL=https://YOUR_APP.clerk.accounts.dev/.well-known/jwks.json
CLERK_ISSUER=https://YOUR_APP.clerk.accounts.dev

# CORS
API_CORS_ORIGINS=http://localhost:5173,http://localhost:8080

# Admin Web
VITE_API_BASE_URL=http://localhost:8000
```

- [ ] **Step 7: 创建最小 README**

写入 `/home/ben/projects/tt-cuisine/README.md`：

```markdown
# tt-cuisine

> 全球餐饮业的多语言结构化菜品知识资产。

**Status**: M0 development. Not production-ready.

**设计文档**: [docs/specs/2026-05-21-dish-corpus-redesign-design.md](docs/specs/2026-05-21-dish-corpus-redesign-design.md)

## 快速开始

```bash
make install
cp .env.example .env  # 然后填入 Clerk keys
make compose-up
make db-migrate
make api-dev   # 终端 1
make web-dev   # 终端 2
```

打开 http://localhost:5173。

详细文档参见 Task 35 的最终 README 章节（M0 完成后补全）。
```

- [ ] **Step 8: 创建空目录占位**

```bash
cd /home/ben/projects/tt-cuisine
mkdir -p apps/api/src/tt_cuisine_api apps/api/tests
mkdir -p apps/admin-web/src apps/admin-web/tests/e2e
mkdir -p packages/domain/src/tt_cuisine_domain packages/domain/tests
mkdir -p ops/compose ops/migrations/versions
mkdir -p docs/specs
mkdir -p .github/workflows
mkdir -p .claude/hooks .claude/agents .claude/commands .claude/skills
touch apps/api/src/tt_cuisine_api/__init__.py apps/api/tests/__init__.py
touch packages/domain/src/tt_cuisine_domain/__init__.py packages/domain/tests/__init__.py
```

- [ ] **Step 9: 首次提交**

```bash
cd /home/ben/projects/tt-cuisine
git add .
git commit -m "chore: tt-cuisine 新仓初始化 (workspace + LICENSE + Makefile + .gitignore)"
```

预期：约 10 个文件创建。

**Acceptance**：新仓 `tt-cuisine` 存在；`git log` 有 1 个 commit；`make help` 能列出所有命令（uv 暂未安装依赖，但 Makefile 静态可读）；目录骨架就位。

---

### Task 3: 迁移 .claude/ 配置 + 适配 Python 工具链

**Files:**
- Create: `/home/ben/projects/tt-cuisine/.claude/settings.json`
- Create: `/home/ben/projects/tt-cuisine/.claude/hooks/python-format.sh`
- Create: `/home/ben/projects/tt-cuisine/.claude/hooks/block-generated.sh`
- Copy: `/home/ben/projects/ttpolyglot/.serena/` → `/home/ben/projects/tt-cuisine/.serena/`

- [ ] **Step 1: 复制 Serena 配置（可选）**

```bash
if [ -d /home/ben/projects/ttpolyglot/.serena ]; then
  cp -r /home/ben/projects/ttpolyglot/.serena /home/ben/projects/tt-cuisine/
fi
```

如果 `.serena/` 不存在则跳过此步。

- [ ] **Step 2: 创建 `.claude/settings.json`**

写入 `/home/ben/projects/tt-cuisine/.claude/settings.json`：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/python-format.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/block-generated.sh"
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: 创建 `.claude/hooks/python-format.sh`**

写入 `/home/ben/projects/tt-cuisine/.claude/hooks/python-format.sh`：

```bash
#!/usr/bin/env bash
# Auto-format Python files edited by Claude using ruff.
# Reads JSON from stdin (Claude Code hook protocol), extracts file_path, runs ruff format.

set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  exit 0  # uv 未装时静默跳过，避免阻塞
fi

# Read hook payload from stdin
payload="$(cat)"
file_path="$(echo "$payload" | python3 -c 'import sys, json; data = json.load(sys.stdin); print(data.get("tool_input", {}).get("file_path", ""))' 2>/dev/null || true)"

if [ -z "$file_path" ]; then
  exit 0
fi

# Only format .py files
case "$file_path" in
  *.py)
    cd "$(dirname "$0")/../.."
    uv run ruff format "$file_path" 2>/dev/null || true
    uv run ruff check --fix "$file_path" 2>/dev/null || true
    ;;
esac

exit 0
```

```bash
chmod +x /home/ben/projects/tt-cuisine/.claude/hooks/python-format.sh
```

- [ ] **Step 4: 创建 `.claude/hooks/block-generated.sh`**

写入 `/home/ben/projects/tt-cuisine/.claude/hooks/block-generated.sh`：

```bash
#!/usr/bin/env bash
# Block edits to generated / dependency / lock files.
# Reads JSON from stdin (Claude Code hook protocol).

set -euo pipefail

payload="$(cat)"
file_path="$(echo "$payload" | python3 -c 'import sys, json; data = json.load(sys.stdin); print(data.get("tool_input", {}).get("file_path", ""))' 2>/dev/null || true)"

if [ -z "$file_path" ]; then
  exit 0
fi

# Patterns to block (regex-ish, simple glob)
case "$file_path" in
  *.pyc|*/__pycache__/*|*/.mypy_cache/*|*/.ruff_cache/*|*/.pytest_cache/*)
    echo "BLOCK: cannot edit cache/compiled file: $file_path" >&2
    exit 2  # exit code 2 = block
    ;;
  */node_modules/*|*/dist/*|*/build/*|*/.venv/*|*/venv/*)
    echo "BLOCK: cannot edit dependency/build directory: $file_path" >&2
    exit 2
    ;;
  */ops/migrations/versions/*.py)
    # Migration files are append-only after creation.
    # Allow Write (new file) but block Edit (modification).
    tool_name="$(echo "$payload" | python3 -c 'import sys, json; data = json.load(sys.stdin); print(data.get("tool_name", ""))' 2>/dev/null || true)"
    if [ "$tool_name" = "Edit" ]; then
      echo "BLOCK: existing alembic migration files are append-only. Create a new revision instead: $file_path" >&2
      exit 2
    fi
    ;;
  */uv.lock|*/pnpm-lock.yaml|*/package-lock.json|*/yarn.lock)
    echo "BLOCK: lock files are managed by their package manager: $file_path" >&2
    exit 2
    ;;
  */routeTree.gen.ts)
    echo "BLOCK: TanStack Router auto-generated file: $file_path" >&2
    exit 2
    ;;
esac

exit 0
```

```bash
chmod +x /home/ben/projects/tt-cuisine/.claude/hooks/block-generated.sh
```

- [ ] **Step 5: 提交 Claude 配置**

```bash
cd /home/ben/projects/tt-cuisine
git add .claude .serena 2>/dev/null || git add .claude
git commit -m "chore: 迁移 .claude/ 配置（hooks 适配 Python + Node 工具链）"
```

**Acceptance**：`.claude/settings.json` 和 2 个 hook 脚本到位且可执行；`bash -n .claude/hooks/python-format.sh` 与 `bash -n .claude/hooks/block-generated.sh` 语法无错。

---

### Task 4: 迁移 spec 文档到新仓

**Files:**
- Copy: `/home/ben/projects/ttpolyglot/docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md` → `/home/ben/projects/tt-cuisine/docs/specs/2026-05-21-dish-corpus-redesign-design.md`

- [ ] **Step 1: 复制 spec 文档**

```bash
cp /home/ben/projects/ttpolyglot/docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md \
   /home/ben/projects/tt-cuisine/docs/specs/2026-05-21-dish-corpus-redesign-design.md
```

- [ ] **Step 2: 在 spec 顶部添加迁移注记**

打开 `/home/ben/projects/tt-cuisine/docs/specs/2026-05-21-dish-corpus-redesign-design.md`，在 frontmatter 之后、`# TTPolyglot 重新立项设计 ...` 标题之前，插入：

```markdown
> **迁移记录**：本文档于 2026-05-21 从 [ttpolyglot 旧仓](https://github.com/.../ttpolyglot/tree/v0.1.0-i18n-direction-archive/docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md) 迁入。旧仓已归档；本文档以此处为权威版本。

```

- [ ] **Step 3: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add docs/specs/
git commit -m "docs: 迁入菜品垂类语料库设计文档 (brainstorm 全 6 节 + 附录)"
```

**Acceptance**：`/home/ben/projects/tt-cuisine/docs/specs/2026-05-21-dish-corpus-redesign-design.md` 存在；顶部有迁移注记。

---

## Phase 2 · 数据库基础

### Task 5: Docker Compose PostgreSQL + init 脚本

**Files:**
- Create: `/home/ben/projects/tt-cuisine/ops/compose/docker-compose.yml`
- Create: `/home/ben/projects/tt-cuisine/ops/compose/.env.example`
- Create: `/home/ben/projects/tt-cuisine/ops/compose/postgres-init.sql`

- [ ] **Step 1: 创建 PG init 脚本（启用扩展 + 创建 schema）**

写入 `/home/ben/projects/tt-cuisine/ops/compose/postgres-init.sql`：

```sql
-- 启用 M0/M1 需要的扩展
CREATE EXTENSION IF NOT EXISTS pgvector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;

-- 创建 schema（spec §4.2: wiki_core / ingest / audit）
CREATE SCHEMA IF NOT EXISTS wiki_core;
CREATE SCHEMA IF NOT EXISTS ingest;
CREATE SCHEMA IF NOT EXISTS audit;

-- 默认 search_path（让应用层无需每次写 schema 前缀）
ALTER DATABASE tt_cuisine SET search_path TO wiki_core, public;

-- 让默认连接角色对所有 schema 有权限（开发用；生产应细粒度）
GRANT ALL ON SCHEMA wiki_core TO ttcuisine;
GRANT ALL ON SCHEMA ingest TO ttcuisine;
GRANT ALL ON SCHEMA audit TO ttcuisine;
```

- [ ] **Step 2: 创建 compose .env.example**

写入 `/home/ben/projects/tt-cuisine/ops/compose/.env.example`：

```env
POSTGRES_USER=ttcuisine
POSTGRES_PASSWORD=devpassword_change_in_prod
POSTGRES_DB=tt_cuisine
POSTGRES_PORT=5432
```

- [ ] **Step 3: 创建 docker-compose.yml（M0 阶段只有 PG；API + admin-web 在 Task 32 加入）**

写入 `/home/ben/projects/tt-cuisine/ops/compose/docker-compose.yml`：

```yaml
name: tt-cuisine

services:
  postgres:
    image: pgvector/pgvector:pg16
    container_name: ttcuisine-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-ttcuisine}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-devpassword_change_in_prod}
      POSTGRES_DB: ${POSTGRES_DB:-tt_cuisine}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres-init.sql:/docker-entrypoint-initdb.d/01-init.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-ttcuisine} -d ${POSTGRES_DB:-tt_cuisine}"]
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  postgres-data:
    name: ttcuisine-postgres-data
```

- [ ] **Step 4: 验证 compose 起 PG**

```bash
cd /home/ben/projects/tt-cuisine/ops/compose
cp .env.example .env
docker compose up -d postgres
sleep 5
docker compose ps
```

预期：`ttcuisine-postgres` 状态 `running` 或 `healthy`。

- [ ] **Step 5: 验证扩展与 schema 已创建**

```bash
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "SELECT extname FROM pg_extension WHERE extname IN ('vector', 'pg_trgm', 'unaccent') ORDER BY extname;"
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "SELECT nspname FROM pg_namespace WHERE nspname IN ('wiki_core', 'ingest', 'audit') ORDER BY nspname;"
```

预期：
```
   extname
-----------
 pg_trgm
 unaccent
 vector
(3 rows)

  nspname
-----------
 audit
 ingest
 wiki_core
(3 rows)
```

如果不符合，删除 volume 重来：`docker compose down -v && docker compose up -d`。

- [ ] **Step 6: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add ops/compose/
git commit -m "feat(ops): Docker Compose PostgreSQL 16 + pgvector + 三 schema 初始化"
```

**Acceptance**：`docker compose up -d` 后 PG 容器健康；3 个扩展安装；3 个 schema 创建；可通过 `psql` 连接。

---

### Task 6: Alembic 初始化

**Files:**
- Create: `/home/ben/projects/tt-cuisine/ops/migrations/alembic.ini`
- Create: `/home/ben/projects/tt-cuisine/ops/migrations/env.py`
- Create: `/home/ben/projects/tt-cuisine/ops/migrations/script.py.mako`

- [ ] **Step 1: 在 apps/api 添加 alembic + 异步驱动依赖**

写入 `/home/ben/projects/tt-cuisine/apps/api/pyproject.toml`（Task 13 会补全这个文件，但 alembic 现在就需要）：

```toml
[project]
name = "tt-cuisine-api"
version = "0.1.0"
description = "tt-cuisine Read Service (FastAPI)"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.115.0",
    "uvicorn[standard]>=0.32.0",
    "sqlalchemy[asyncio]>=2.0.36",
    "asyncpg>=0.30.0",
    "alembic>=1.13.0",
    "pydantic>=2.9.0",
    "pydantic-settings>=2.6.0",
    "structlog>=24.4.0",
    "python-jose[cryptography]>=3.3.0",  # Clerk JWT verification
    "httpx>=0.27.0",                      # JWKS fetch
    "tt-cuisine-domain",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv.sources]
tt-cuisine-domain = { workspace = true }

[tool.hatch.build.targets.wheel]
packages = ["src/tt_cuisine_api"]
```

```bash
mkdir -p /home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api
touch /home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/__init__.py
```

同样为 domain 包占位（Task 8 完善）：

`/home/ben/projects/tt-cuisine/packages/domain/pyproject.toml`：

```toml
[project]
name = "tt-cuisine-domain"
version = "0.1.0"
description = "tt-cuisine Domain models (Pydantic v2, pure)"
requires-python = ">=3.12"
dependencies = [
    "pydantic>=2.9.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/tt_cuisine_domain"]
```

- [ ] **Step 2: 安装依赖（uv 第一次 sync）**

```bash
cd /home/ben/projects/tt-cuisine
uv sync --all-packages
```

预期：创建 `.venv/`、`uv.lock`，下载 fastapi/sqlalchemy/alembic 等。

- [ ] **Step 3: 创建 alembic.ini**

写入 `/home/ben/projects/tt-cuisine/ops/migrations/alembic.ini`：

```ini
[alembic]
script_location = .
prepend_sys_path = .
version_path_separator = os
sqlalchemy.url =

[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S
```

- [ ] **Step 4: 创建 alembic env.py（手写 schema，不依赖 ORM autogen）**

写入 `/home/ben/projects/tt-cuisine/ops/migrations/env.py`：

```python
"""Alembic environment for tt-cuisine.

M0 阶段手写迁移（不用 autogen），因此 env.py 不导入 ORM Metadata。
后续 Phase 引入 ORM 后再切到 autogen 模式。
"""

from __future__ import annotations

import os
import sys
from logging.config import fileConfig
from pathlib import Path

from alembic import context
from sqlalchemy import engine_from_config, pool

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# 从环境变量读取 DATABASE_URL；同步驱动用于 alembic
database_url = os.getenv("DATABASE_URL", "")
if not database_url:
    raise RuntimeError(
        "DATABASE_URL env var is required to run alembic. "
        "Example: postgresql://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
    )

# Alembic 用同步驱动；如果用户传的是异步 URL，转换一下
if database_url.startswith("postgresql+asyncpg://"):
    database_url = database_url.replace("postgresql+asyncpg://", "postgresql://", 1)

config.set_main_option("sqlalchemy.url", database_url)

target_metadata = None  # M0 手写迁移


def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        version_table_schema="wiki_core",
        include_schemas=True,
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            version_table_schema="wiki_core",
            include_schemas=True,
        )
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
```

- [ ] **Step 5: 创建 script.py.mako 模板**

写入 `/home/ben/projects/tt-cuisine/ops/migrations/script.py.mako`：

```mako
"""${message}

Revision ID: ${up_revision}
Revises: ${down_revision | comma,n}
Create Date: ${create_date}

"""
from __future__ import annotations

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
${imports if imports else ""}

revision: str = ${repr(up_revision)}
down_revision: Union[str, None] = ${repr(down_revision)}
branch_labels: Union[str, Sequence[str], None] = ${repr(branch_labels)}
depends_on: Union[str, Sequence[str], None] = ${repr(depends_on)}


def upgrade() -> None:
    ${upgrades if upgrades else "pass"}


def downgrade() -> None:
    ${downgrades if downgrades else "pass"}
```

- [ ] **Step 6: 验证 alembic 可启动**

```bash
cd /home/ben/projects/tt-cuisine
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
cd ops/migrations
uv run --project /home/ben/projects/tt-cuisine alembic current
```

预期：输出空（无迁移）或类似 `INFO  [alembic.runtime.migration] Context impl ...`。**不应报错**。

- [ ] **Step 7: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add ops/migrations/alembic.ini ops/migrations/env.py ops/migrations/script.py.mako
git add apps/api/pyproject.toml packages/domain/pyproject.toml
git add apps/api/src/tt_cuisine_api/__init__.py
git add uv.lock 2>/dev/null || true
git commit -m "feat(ops): Alembic 初始化（手写迁移模式，schema-aware）"
```

**Acceptance**：`alembic current` 不报错；`env.py` 强制要求 `DATABASE_URL`；`version_table_schema=wiki_core` 让 alembic 元表落在正确 schema。

---

### Task 7: 第一个迁移——concepts + dish_names 表

**Files:**
- Create: `/home/ben/projects/tt-cuisine/ops/migrations/versions/0001_initial_schema.py`

- [ ] **Step 1: 生成迁移 stub**

```bash
cd /home/ben/projects/tt-cuisine/ops/migrations
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run --project /home/ben/projects/tt-cuisine alembic revision -m "initial_schema"
```

预期：在 `versions/` 下生成一个 `<hash>_initial_schema.py` 文件。**重命名为 `0001_initial_schema.py`** 并把 revision id 字段改成 `0001`：

```bash
cd versions
mv *_initial_schema.py 0001_initial_schema.py
```

- [ ] **Step 2: 编辑迁移内容，写入 schema**

把 `0001_initial_schema.py` 全文替换为：

```python
"""initial_schema

Revision ID: 0001
Revises:
Create Date: 2026-05-21 00:00:00.000000

"""
from __future__ import annotations

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # concepts (wiki_core.concepts)
    op.create_table(
        "concepts",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column("slug", sa.String(length=200), nullable=False, unique=True),
        sa.Column("canonical_name", sa.String(length=500), nullable=False),
        sa.Column("status", sa.String(length=32), nullable=False, server_default="draft"),
        sa.Column("created_at", sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("created_by", sa.String(length=200), nullable=True),
        sa.Column("updated_by", sa.String(length=200), nullable=True),
        schema="wiki_core",
    )
    op.create_index(
        "ix_concepts_canonical_name",
        "concepts",
        ["canonical_name"],
        schema="wiki_core",
    )
    op.create_index(
        "ix_concepts_status",
        "concepts",
        ["status"],
        schema="wiki_core",
    )

    # dish_names (wiki_core.dish_names)
    op.create_table(
        "dish_names",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "concept_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("wiki_core.concepts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("language", sa.String(length=16), nullable=False),  # IETF BCP 47: zh-CN, ja-JP...
        sa.Column("text", sa.String(length=500), nullable=False),
        sa.Column("type", sa.String(length=32), nullable=False),
        # canonical | transliteration | literal | descriptive | loanword | colloquial | nickname | misspelling
        sa.Column("dialect", sa.String(length=64), nullable=True),
        sa.Column("region", sa.String(length=64), nullable=True),
        sa.Column("confidence", sa.Numeric(precision=4, scale=3), nullable=False, server_default="1.000"),
        sa.Column("source", sa.String(length=200), nullable=True),
        sa.Column("created_at", sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text("now()")),
        schema="wiki_core",
    )
    op.create_index(
        "ix_dish_names_concept_id",
        "dish_names",
        ["concept_id"],
        schema="wiki_core",
    )
    op.create_index(
        "ix_dish_names_text",
        "dish_names",
        ["text"],
        schema="wiki_core",
    )
    op.create_index(
        "ix_dish_names_language_text",
        "dish_names",
        ["language", "text"],
        schema="wiki_core",
    )
    # 同 (language, region) 下相同 text 必须属于同一个 concept（不变量 §3.5.2）
    # 实现为唯一约束（NULL region 视为独立分组）
    op.create_unique_constraint(
        "uq_dish_names_lang_region_text",
        "dish_names",
        ["language", "region", "text"],
        schema="wiki_core",
    )


def downgrade() -> None:
    op.drop_constraint("uq_dish_names_lang_region_text", "dish_names", schema="wiki_core", type_="unique")
    op.drop_index("ix_dish_names_language_text", table_name="dish_names", schema="wiki_core")
    op.drop_index("ix_dish_names_text", table_name="dish_names", schema="wiki_core")
    op.drop_index("ix_dish_names_concept_id", table_name="dish_names", schema="wiki_core")
    op.drop_table("dish_names", schema="wiki_core")
    op.drop_index("ix_concepts_status", table_name="concepts", schema="wiki_core")
    op.drop_index("ix_concepts_canonical_name", table_name="concepts", schema="wiki_core")
    op.drop_table("concepts", schema="wiki_core")
```

- [ ] **Step 3: 运行迁移**

```bash
cd /home/ben/projects/tt-cuisine/ops/migrations
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run --project /home/ben/projects/tt-cuisine alembic upgrade head
```

预期：输出包含 `Running upgrade  -> 0001, initial_schema`。

- [ ] **Step 4: 验证表已创建**

```bash
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "\dt wiki_core.*"
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "\d wiki_core.concepts"
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "\d wiki_core.dish_names"
```

预期：列出 `concepts`、`dish_names` 两张表，以及 `alembic_version`（在 `wiki_core` schema 下）。

- [ ] **Step 5: 验证 downgrade 可逆**

```bash
cd /home/ben/projects/tt-cuisine/ops/migrations
uv run --project /home/ben/projects/tt-cuisine alembic downgrade base
uv run --project /home/ben/projects/tt-cuisine alembic upgrade head
```

预期：两次操作都无错；表先消失再重建。

- [ ] **Step 6: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add ops/migrations/versions/0001_initial_schema.py
git commit -m "feat(db): 0001 initial schema (concepts + dish_names) in wiki_core"
```

**Acceptance**：迁移 `0001` 可 upgrade + downgrade；表落在 `wiki_core` schema；`(language, region, text)` 唯一约束就位。

---

## Phase 3 · Domain 层（纯 Pydantic v2，TDD）

### Task 8: domain 包骨架完善 + 单元测试基础设施

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/packages/domain/pyproject.toml`（确认 hatch 配置）
- Create: `/home/ben/projects/tt-cuisine/packages/domain/tests/conftest.py`

- [ ] **Step 1: 确认 domain 包 src 布局**

```bash
ls /home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/
# 应该已有 __init__.py（Task 2 创建）
```

如果 `__init__.py` 不存在则创建空文件。

- [ ] **Step 2: 创建 tests/conftest.py（M0 暂无 fixtures，留 placeholder）**

写入 `/home/ben/projects/tt-cuisine/packages/domain/tests/conftest.py`：

```python
"""Shared fixtures for domain unit tests.

M0 阶段无共享 fixture；保留此文件便于后续 milestones 扩展。
"""

from __future__ import annotations
```

- [ ] **Step 3: 验证 pytest 能发现空测试集**

```bash
cd /home/ben/projects/tt-cuisine
uv run pytest packages/domain/tests -v
```

预期：`no tests ran in 0.0Xs` 或类似（**不报错**）。

- [ ] **Step 4: 提交**

```bash
git add packages/domain/
git commit -m "chore(domain): 包骨架就位（conftest placeholder）"
```

**Acceptance**：`uv run pytest packages/domain/tests` 不报错；包结构 src layout 完整。

---

### Task 9: Language enum（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/language.py`
- Create: `/home/ben/projects/tt-cuisine/packages/domain/tests/test_language.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/packages/domain/tests/test_language.py`：

```python
"""Tests for Language enum."""

from __future__ import annotations

import pytest

from tt_cuisine_domain.language import Language


def test_zh_cn_code() -> None:
    assert Language.ZH_CN.code == "zh-CN"


def test_ja_jp_code() -> None:
    assert Language.JA_JP.code == "ja-JP"


def test_from_code_valid() -> None:
    assert Language.from_code("zh-CN") is Language.ZH_CN
    assert Language.from_code("en-US") is Language.EN_US
    assert Language.from_code("ko-KR") is Language.KO_KR


def test_from_code_case_insensitive() -> None:
    assert Language.from_code("ZH-CN") is Language.ZH_CN
    assert Language.from_code("zh-cn") is Language.ZH_CN


def test_from_code_invalid_raises() -> None:
    with pytest.raises(ValueError, match="Unknown language code"):
        Language.from_code("xx-XX")


def test_native_name() -> None:
    assert Language.ZH_CN.native_name == "简体中文"
    assert Language.JA_JP.native_name == "日本語"
    assert Language.KO_KR.native_name == "한국어"
    assert Language.EN_US.native_name == "English (US)"


def test_all_languages_cover_m0_set() -> None:
    """M0 success criteria: 创建宫保鸡丁含 5 语别名 (zh-CN/zh-HK/en-US/ja-JP/ko-KR)."""
    codes = {lang.code for lang in Language}
    required = {"zh-CN", "zh-HK", "en-US", "ja-JP", "ko-KR"}
    assert required.issubset(codes), f"Missing M0 required languages: {required - codes}"
```

- [ ] **Step 2: 跑测试确认失败**

```bash
cd /home/ben/projects/tt-cuisine
uv run pytest packages/domain/tests/test_language.py -v
```

预期：`ImportError: No module named 'tt_cuisine_domain.language'` 或类似失败。

- [ ] **Step 3: 实现 Language enum**

写入 `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/language.py`：

```python
"""Language enum (IETF BCP 47 codes).

M0 覆盖 CJK 原生赌注下的核心 5 语：zh-CN / zh-HK / ja-JP / ko-KR / en-US。
扩展到越泰马来等放到 M2+（spec §9.1 待 sizing）。
"""

from __future__ import annotations

from enum import Enum


class Language(str, Enum):
    """BCP 47 language tag enum."""

    ZH_CN = "zh-CN"
    ZH_HK = "zh-HK"
    ZH_TW = "zh-TW"
    JA_JP = "ja-JP"
    KO_KR = "ko-KR"
    EN_US = "en-US"
    EN_GB = "en-GB"

    @property
    def code(self) -> str:
        """Return the BCP 47 code (same as value)."""
        return self.value

    @property
    def native_name(self) -> str:
        """Native-script display name."""
        return _NATIVE_NAMES[self]

    @classmethod
    def from_code(cls, code: str) -> "Language":
        """Look up Language by BCP 47 code (case-insensitive)."""
        normalized = _normalize_code(code)
        for lang in cls:
            if lang.value == normalized:
                return lang
        raise ValueError(f"Unknown language code: {code!r}")


def _normalize_code(code: str) -> str:
    """zh-cn → zh-CN ; en-US → en-US ; ZH-cn → zh-CN."""
    if "-" not in code:
        return code.lower()
    primary, _, region = code.partition("-")
    return f"{primary.lower()}-{region.upper()}"


_NATIVE_NAMES: dict[Language, str] = {
    Language.ZH_CN: "简体中文",
    Language.ZH_HK: "繁體中文（香港）",
    Language.ZH_TW: "繁體中文（台灣）",
    Language.JA_JP: "日本語",
    Language.KO_KR: "한국어",
    Language.EN_US: "English (US)",
    Language.EN_GB: "English (UK)",
}
```

- [ ] **Step 4: 跑测试确认通过**

```bash
cd /home/ben/projects/tt-cuisine
uv run pytest packages/domain/tests/test_language.py -v
```

预期：7 passed。

- [ ] **Step 5: mypy + ruff 检查**

```bash
cd /home/ben/projects/tt-cuisine
uv run mypy packages/domain
uv run ruff check packages/domain
```

预期：两个命令都 Success / no issues。

- [ ] **Step 6: 提交**

```bash
git add packages/domain/src/tt_cuisine_domain/language.py packages/domain/tests/test_language.py
git commit -m "feat(domain): Language enum (BCP 47, 7 codes, M0 CJK 5 + en-GB extras)"
```

**Acceptance**：7 tests pass；mypy strict 通过；ruff 通过。

---

### Task 10: ConceptStatus 和 DishNameType enum（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/status.py`
- Create: `/home/ben/projects/tt-cuisine/packages/domain/tests/test_status.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/packages/domain/tests/test_status.py`：

```python
"""Tests for ConceptStatus and DishNameType enums."""

from __future__ import annotations

import pytest

from tt_cuisine_domain.status import ConceptStatus, DishNameType


def test_concept_status_values() -> None:
    assert ConceptStatus.DRAFT.value == "draft"
    assert ConceptStatus.UNDER_REVIEW.value == "under_review"
    assert ConceptStatus.PUBLISHED.value == "published"
    assert ConceptStatus.DEPRECATED.value == "deprecated"


def test_concept_status_count() -> None:
    """M0 spec §3.3 固定 4 个状态。"""
    assert len(list(ConceptStatus)) == 4


def test_dish_name_type_values() -> None:
    expected = {
        "canonical",
        "transliteration",
        "literal",
        "descriptive",
        "loanword",
        "colloquial",
        "nickname",
        "misspelling",
    }
    assert {t.value for t in DishNameType} == expected


def test_dish_name_type_canonical_is_unique_per_concept_lang() -> None:
    """canonical 类型是 spec §3.3 的特殊类型；语义在 DishConcept 校验里强制。"""
    assert DishNameType.CANONICAL.value == "canonical"


def test_status_string_equivalence() -> None:
    """因为继承 str，可以直接比较字符串。"""
    assert ConceptStatus.PUBLISHED == "published"


def test_unknown_status_raises() -> None:
    with pytest.raises(ValueError):
        ConceptStatus("invalid")
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest packages/domain/tests/test_status.py -v
```

预期：`ImportError` 失败。

- [ ] **Step 3: 实现 enums**

写入 `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/status.py`：

```python
"""ConceptStatus and DishNameType enums.

来源: spec §3.3。
M0 全部固定；M1+ 不应扩展状态机本身（spec §4.9.6：审核流走事件 sourcing 不走状态机）。
"""

from __future__ import annotations

from enum import Enum


class ConceptStatus(str, Enum):
    """DishConcept 生命周期状态。"""

    DRAFT = "draft"
    UNDER_REVIEW = "under_review"
    PUBLISHED = "published"
    DEPRECATED = "deprecated"


class DishNameType(str, Enum):
    """DishName 的类型分类（spec §3.3）。

    canonical       - 规范名（同语言下每个 concept 唯一）
    transliteration - 音译（拼音/罗马字/한글 表音）
    literal         - 直译（按字面）
    descriptive     - 描述性（解释做法/外观）
    loanword        - 外来词（如日语的 外来語 / 韩语的 외래어）
    colloquial      - 俗称/口语
    nickname        - 别名
    misspelling     - 错别字/常见误写（带置信度）
    """

    CANONICAL = "canonical"
    TRANSLITERATION = "transliteration"
    LITERAL = "literal"
    DESCRIPTIVE = "descriptive"
    LOANWORD = "loanword"
    COLLOQUIAL = "colloquial"
    NICKNAME = "nickname"
    MISSPELLING = "misspelling"
```

- [ ] **Step 4: 跑测试**

```bash
uv run pytest packages/domain/tests/test_status.py -v
uv run mypy packages/domain
uv run ruff check packages/domain
```

预期：6 passed；mypy/ruff 无错。

- [ ] **Step 5: 提交**

```bash
git add packages/domain/src/tt_cuisine_domain/status.py packages/domain/tests/test_status.py
git commit -m "feat(domain): ConceptStatus (4 states) + DishNameType (8 types) enums"
```

**Acceptance**：6 tests pass；状态枚举锁定（M1+ 不可扩展状态机）。

---

### Task 11: DishName Pydantic 模型（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/name.py`
- Create: `/home/ben/projects/tt-cuisine/packages/domain/tests/test_name.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/packages/domain/tests/test_name.py`：

```python
"""Tests for DishName Pydantic model."""

from __future__ import annotations

import pytest
from pydantic import ValidationError

from tt_cuisine_domain.language import Language
from tt_cuisine_domain.name import DishName
from tt_cuisine_domain.status import DishNameType


def test_dish_name_canonical_zh_cn() -> None:
    name = DishName(
        language=Language.ZH_CN,
        text="宫保鸡丁",
        type=DishNameType.CANONICAL,
    )
    assert name.language is Language.ZH_CN
    assert name.text == "宫保鸡丁"
    assert name.type is DishNameType.CANONICAL
    assert name.confidence == 1.0
    assert name.dialect is None
    assert name.region is None
    assert name.source is None


def test_dish_name_misspelling_with_confidence() -> None:
    name = DishName(
        language=Language.ZH_CN,
        text="宫爆鸡丁",
        type=DishNameType.MISSPELLING,
        confidence=0.95,
    )
    assert name.confidence == 0.95


def test_dish_name_with_dialect_and_region() -> None:
    name = DishName(
        language=Language.EN_US,
        text="豆腐脑",
        type=DishNameType.TRANSLITERATION,
        dialect="northern",
        region="SF Chinatown",
    )
    assert name.dialect == "northern"
    assert name.region == "SF Chinatown"


def test_dish_name_text_cannot_be_empty() -> None:
    with pytest.raises(ValidationError):
        DishName(language=Language.ZH_CN, text="", type=DishNameType.CANONICAL)


def test_dish_name_text_strips_whitespace() -> None:
    name = DishName(
        language=Language.ZH_CN,
        text="  宫保鸡丁  ",
        type=DishNameType.CANONICAL,
    )
    assert name.text == "宫保鸡丁"


def test_dish_name_confidence_out_of_range_rejected() -> None:
    with pytest.raises(ValidationError):
        DishName(
            language=Language.ZH_CN,
            text="test",
            type=DishNameType.CANONICAL,
            confidence=1.5,
        )
    with pytest.raises(ValidationError):
        DishName(
            language=Language.ZH_CN,
            text="test",
            type=DishNameType.CANONICAL,
            confidence=-0.1,
        )


def test_dish_name_serializes_to_json() -> None:
    name = DishName(
        language=Language.JA_JP,
        text="宮保鶏丁",
        type=DishNameType.TRANSLITERATION,
        source="DeepSeek",
    )
    data = name.model_dump(mode="json")
    assert data["language"] == "ja-JP"
    assert data["text"] == "宮保鶏丁"
    assert data["type"] == "transliteration"
    assert data["source"] == "DeepSeek"


def test_dish_name_round_trip() -> None:
    """JSON round-trip preserves semantic equality."""
    original = DishName(
        language=Language.KO_KR,
        text="궁보계정",
        type=DishNameType.TRANSLITERATION,
        confidence=0.9,
    )
    payload = original.model_dump(mode="json")
    restored = DishName.model_validate(payload)
    assert restored == original
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest packages/domain/tests/test_name.py -v
```

预期：`ImportError`。

- [ ] **Step 3: 实现 DishName**

写入 `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/name.py`：

```python
"""DishName Pydantic v2 model.

每个 DishConcept 关联多个 DishName。一个 DishName 是 (language, region) 限定下的具体名字。
spec §3.3 / §3.5.2: 同一 (language, region) 下相同 text 必须属于同一个 concept。
"""

from __future__ import annotations

from pydantic import BaseModel, ConfigDict, Field, field_validator

from tt_cuisine_domain.language import Language
from tt_cuisine_domain.status import DishNameType


class DishName(BaseModel):
    """A localized name for a DishConcept."""

    model_config = ConfigDict(
        frozen=False,
        use_enum_values=False,
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    language: Language
    text: str = Field(..., min_length=1, max_length=500)
    type: DishNameType
    dialect: str | None = Field(default=None, max_length=64)
    region: str | None = Field(default=None, max_length=64)
    confidence: float = Field(default=1.0, ge=0.0, le=1.0)
    source: str | None = Field(default=None, max_length=200)

    @field_validator("text", mode="after")
    @classmethod
    def _text_not_blank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("text must not be blank")
        return value
```

- [ ] **Step 4: 跑测试**

```bash
uv run pytest packages/domain/tests/test_name.py -v
uv run mypy packages/domain
uv run ruff check packages/domain
```

预期：8 passed；mypy/ruff 无错。

- [ ] **Step 5: 提交**

```bash
git add packages/domain/src/tt_cuisine_domain/name.py packages/domain/tests/test_name.py
git commit -m "feat(domain): DishName Pydantic 模型（含 confidence + dialect + region）"
```

**Acceptance**：8 tests pass；text 自动 strip + 非空校验；confidence [0,1] 校验；序列化用 BCP 47 字符串而非 enum 名。

---

### Task 12: DishConcept Pydantic 模型（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/concept.py`
- Create: `/home/ben/projects/tt-cuisine/packages/domain/tests/test_concept.py`
- Modify: `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/__init__.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/packages/domain/tests/test_concept.py`：

```python
"""Tests for DishConcept Pydantic model."""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from pydantic import ValidationError

from tt_cuisine_domain.concept import DishConcept
from tt_cuisine_domain.language import Language
from tt_cuisine_domain.name import DishName
from tt_cuisine_domain.status import ConceptStatus, DishNameType


def _name(lang: Language, text: str, t: DishNameType = DishNameType.CANONICAL) -> DishName:
    return DishName(language=lang, text=text, type=t)


def test_dish_concept_minimal() -> None:
    concept = DishConcept(
        id=uuid4(),
        slug="gong-bao-ji-ding",
        canonical_name="宫保鸡丁",
        status=ConceptStatus.DRAFT,
        names=[_name(Language.ZH_CN, "宫保鸡丁")],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    assert concept.slug == "gong-bao-ji-ding"
    assert concept.status is ConceptStatus.DRAFT
    assert len(concept.names) == 1


def test_dish_concept_five_languages_m0_demo() -> None:
    """M0 success criteria：宫保鸡丁含 5 语别名 (zh-CN/zh-HK/en-US/ja-JP/ko-KR)。"""
    concept = DishConcept(
        id=uuid4(),
        slug="gong-bao-ji-ding",
        canonical_name="宫保鸡丁",
        status=ConceptStatus.PUBLISHED,
        names=[
            _name(Language.ZH_CN, "宫保鸡丁"),
            _name(Language.ZH_HK, "宮保雞丁"),
            _name(Language.EN_US, "Kung Pao Chicken", DishNameType.TRANSLITERATION),
            _name(Language.JA_JP, "宮保鶏丁", DishNameType.TRANSLITERATION),
            _name(Language.KO_KR, "궁보계정", DishNameType.TRANSLITERATION),
        ],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    assert len(concept.names) == 5
    assert {n.language for n in concept.names} == {
        Language.ZH_CN,
        Language.ZH_HK,
        Language.EN_US,
        Language.JA_JP,
        Language.KO_KR,
    }


def test_dish_concept_slug_lowercase_kebab_required() -> None:
    """slug 形如 latin-lowercase-with-hyphens（spec §2-D）。"""
    with pytest.raises(ValidationError):
        DishConcept(
            id=uuid4(),
            slug="Gong Bao",  # 含空格 + 大写
            canonical_name="宫保鸡丁",
            status=ConceptStatus.DRAFT,
            names=[_name(Language.ZH_CN, "宫保鸡丁")],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
        )


def test_dish_concept_slug_underscore_rejected() -> None:
    with pytest.raises(ValidationError):
        DishConcept(
            id=uuid4(),
            slug="gong_bao",
            canonical_name="宫保鸡丁",
            status=ConceptStatus.DRAFT,
            names=[_name(Language.ZH_CN, "宫保鸡丁")],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
        )


def test_dish_concept_requires_at_least_one_name() -> None:
    """无别名的 DishConcept 没有意义。"""
    with pytest.raises(ValidationError):
        DishConcept(
            id=uuid4(),
            slug="empty",
            canonical_name="空",
            status=ConceptStatus.DRAFT,
            names=[],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
        )


def test_dish_concept_canonical_name_required() -> None:
    with pytest.raises(ValidationError):
        DishConcept(
            id=uuid4(),
            slug="x",
            canonical_name="",
            status=ConceptStatus.DRAFT,
            names=[_name(Language.ZH_CN, "宫保鸡丁")],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
        )


def test_dish_concept_serializes_uuid_as_string() -> None:
    concept_id = UUID("550e8400-e29b-41d4-a716-446655440000")
    concept = DishConcept(
        id=concept_id,
        slug="x",
        canonical_name="宫保鸡丁",
        status=ConceptStatus.DRAFT,
        names=[_name(Language.ZH_CN, "宫保鸡丁")],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    data = concept.model_dump(mode="json")
    assert data["id"] == "550e8400-e29b-41d4-a716-446655440000"
    assert data["status"] == "draft"


def test_dish_concept_round_trip() -> None:
    original = DishConcept(
        id=uuid4(),
        slug="gong-bao-ji-ding",
        canonical_name="宫保鸡丁",
        status=ConceptStatus.PUBLISHED,
        names=[
            _name(Language.ZH_CN, "宫保鸡丁"),
            _name(Language.EN_US, "Kung Pao Chicken", DishNameType.TRANSLITERATION),
        ],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    payload = original.model_dump(mode="json")
    restored = DishConcept.model_validate(payload)
    assert restored == original


def test_dish_concept_languages_property() -> None:
    """便利属性：返回所有出现过的语言集合。"""
    concept = DishConcept(
        id=uuid4(),
        slug="x",
        canonical_name="宫保鸡丁",
        status=ConceptStatus.PUBLISHED,
        names=[
            _name(Language.ZH_CN, "宫保鸡丁"),
            _name(Language.EN_US, "Kung Pao Chicken", DishNameType.TRANSLITERATION),
            _name(Language.JA_JP, "宮保鶏丁", DishNameType.TRANSLITERATION),
        ],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    assert concept.languages == {Language.ZH_CN, Language.EN_US, Language.JA_JP}
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest packages/domain/tests/test_concept.py -v
```

预期：`ImportError`。

- [ ] **Step 3: 实现 DishConcept**

写入 `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/concept.py`：

```python
"""DishConcept Pydantic v2 model — aggregate root for the Wiki Core context.

来源：spec §3.3。M0 极简版：仅 names。
M1+ 扩展：descriptions / ingredients / cookingMethods / cuisineLineage / allergens / dietaryTags
/ priceTier / culturalNotes / relatedTo / revisions（这些 M0 严禁出现）。
"""

from __future__ import annotations

import re
from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, field_validator

from tt_cuisine_domain.language import Language
from tt_cuisine_domain.name import DishName
from tt_cuisine_domain.status import ConceptStatus

_SLUG_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


class DishConcept(BaseModel):
    """A canonical dish concept — Wiki Core aggregate root."""

    model_config = ConfigDict(
        frozen=False,
        use_enum_values=False,
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    id: UUID
    slug: str = Field(..., min_length=1, max_length=200)
    canonical_name: str = Field(..., min_length=1, max_length=500)
    status: ConceptStatus
    names: list[DishName] = Field(..., min_length=1)
    created_at: datetime
    updated_at: datetime
    created_by: str | None = Field(default=None, max_length=200)
    updated_by: str | None = Field(default=None, max_length=200)

    @field_validator("slug", mode="after")
    @classmethod
    def _validate_slug(cls, value: str) -> str:
        """Slug 必须是 latin-lowercase-kebab-case（spec §2-D）。"""
        if not _SLUG_PATTERN.match(value):
            raise ValueError(
                f"slug must be lowercase-kebab-case (a-z, 0-9, hyphens), got: {value!r}"
            )
        return value

    @property
    def languages(self) -> set[Language]:
        """All languages this concept has at least one DishName in."""
        return {n.language for n in self.names}
```

- [ ] **Step 4: 完善 domain 包的 __init__.py 公开 API**

写入 `/home/ben/projects/tt-cuisine/packages/domain/src/tt_cuisine_domain/__init__.py`：

```python
"""tt-cuisine domain models (Pydantic v2, pure, no I/O)."""

from __future__ import annotations

from tt_cuisine_domain.concept import DishConcept
from tt_cuisine_domain.language import Language
from tt_cuisine_domain.name import DishName
from tt_cuisine_domain.status import ConceptStatus, DishNameType

__all__ = [
    "ConceptStatus",
    "DishConcept",
    "DishName",
    "DishNameType",
    "Language",
]
```

- [ ] **Step 5: 跑测试 + mypy + ruff**

```bash
cd /home/ben/projects/tt-cuisine
uv run pytest packages/domain/tests -v
uv run mypy packages/domain
uv run ruff check packages/domain
```

预期：
- pytest：所有 domain 测试 pass（test_language + test_status + test_name + test_concept 合计约 30 个测试）
- mypy 无错
- ruff 无错

- [ ] **Step 6: 提交**

```bash
git add packages/domain/src/tt_cuisine_domain/concept.py
git add packages/domain/src/tt_cuisine_domain/__init__.py
git add packages/domain/tests/test_concept.py
git commit -m "feat(domain): DishConcept Pydantic 聚合根（M0 极简版 + slug 校验 + languages 属性）"
```

**Acceptance**：DishConcept 模型可代表 "宫保鸡丁含 5 语别名"（M0 demo 数据形态）；slug 校验严格；至少 1 个 name 强制；JSON round-trip 等价。所有 domain 测试通过。

---

## Phase 4 · API 层（FastAPI + SQLAlchemy 2.0 async）

### Task 13: API 包骨架 + Pydantic Settings + main.py

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/api/pyproject.toml`（已在 Task 6 创建，确认即可）
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/config.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/conftest.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_main.py`

- [ ] **Step 1: 创建 config.py（Pydantic Settings）**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/config.py`：

```python
"""Application configuration (Pydantic Settings)."""

from __future__ import annotations

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """tt-cuisine API runtime settings, loaded from env + .env file."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    api_host: str = Field(default="0.0.0.0")
    api_port: int = Field(default=8000)
    api_log_level: str = Field(default="INFO")
    api_cors_origins: str = Field(default="http://localhost:5173")
    database_url: str = Field(
        default="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
    )

    # Clerk
    clerk_secret_key: str = Field(default="")
    clerk_jwks_url: str = Field(default="")
    clerk_issuer: str = Field(default="")

    @property
    def cors_origins_list(self) -> list[str]:
        return [origin.strip() for origin in self.api_cors_origins.split(",") if origin.strip()]


def get_settings() -> Settings:
    """FastAPI dependency-friendly settings provider (memoized via lru_cache 可后加)."""
    return Settings()
```

- [ ] **Step 2: 创建最小 main.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py`：

```python
"""tt-cuisine API entry point."""

from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from tt_cuisine_api.config import get_settings


def create_app() -> FastAPI:
    """Application factory (enables test isolation)."""
    settings = get_settings()
    app = FastAPI(
        title="tt-cuisine API",
        version="0.1.0",
        description="Read service for the multilingual dish concept corpus",
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    return app


app = create_app()
```

- [ ] **Step 3: 创建 tests/conftest.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/conftest.py`：

```python
"""Shared fixtures for API tests."""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from tt_cuisine_api.main import create_app


@pytest.fixture
def client() -> TestClient:
    """A TestClient wrapping a fresh app instance."""
    app = create_app()
    return TestClient(app)
```

- [ ] **Step 4: 写一个 main 加载测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_main.py`：

```python
"""Smoke test for app bootstrap."""

from __future__ import annotations

from fastapi.testclient import TestClient


def test_openapi_schema_available(client: TestClient) -> None:
    """OpenAPI schema endpoint exists out of the box."""
    response = client.get("/openapi.json")
    assert response.status_code == 200
    data = response.json()
    assert data["info"]["title"] == "tt-cuisine API"
    assert data["info"]["version"] == "0.1.0"
```

- [ ] **Step 5: 跑测试**

```bash
cd /home/ben/projects/tt-cuisine
uv sync --all-packages
uv run pytest apps/api/tests/test_main.py -v
```

预期：1 passed。

- [ ] **Step 6: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 7: 提交**

```bash
git add apps/api/
git commit -m "feat(api): FastAPI skeleton + Pydantic Settings + smoke test"
```

**Acceptance**：API app 能加载；OpenAPI schema 可访问；CORS 中间件就位。

---

### Task 14: 结构化 JSON 日志（structlog）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/logging.py`
- Modify: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_logging.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_logging.py`：

```python
"""Tests for structured logging configuration."""

from __future__ import annotations

import json
import logging
from io import StringIO

import structlog


def test_logger_emits_json() -> None:
    """structlog must emit JSON-compatible records when configured."""
    from tt_cuisine_api.logging import configure_logging

    buf = StringIO()
    configure_logging(level="INFO", stream=buf)

    log = structlog.get_logger("test")
    log.info("hello", key="value", number=42)

    output = buf.getvalue().strip()
    assert output, "logger emitted nothing"

    parsed = json.loads(output)
    assert parsed["event"] == "hello"
    assert parsed["key"] == "value"
    assert parsed["number"] == 42
    assert parsed["level"] == "info"
    assert "timestamp" in parsed


def test_logger_level_filter(capsys: object) -> None:
    """DEBUG logs should be suppressed when level is INFO."""
    from tt_cuisine_api.logging import configure_logging

    buf = StringIO()
    configure_logging(level="INFO", stream=buf)

    log = structlog.get_logger("test")
    log.debug("debug-message")
    log.info("info-message")

    output = buf.getvalue()
    assert "info-message" in output
    assert "debug-message" not in output
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest apps/api/tests/test_logging.py -v
```

预期：`ImportError`。

- [ ] **Step 3: 实现 logging.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/logging.py`：

```python
"""Structured JSON logging via structlog.

Spec §7.2 Exit Criteria: "结构化 JSON log，不是 print"。
"""

from __future__ import annotations

import logging
import sys
from typing import TextIO

import structlog


def configure_logging(level: str = "INFO", stream: TextIO | None = None) -> None:
    """Configure structlog + stdlib logging to emit JSON to a target stream.

    Args:
        level: minimum log level (DEBUG / INFO / WARNING / ERROR).
        stream: target stream, defaults to sys.stdout (production) or test buffer.
    """
    target = stream or sys.stdout
    log_level = getattr(logging, level.upper(), logging.INFO)

    # Reset root logger handlers so multiple test calls don't accumulate
    root = logging.getLogger()
    for h in list(root.handlers):
        root.removeHandler(h)

    handler = logging.StreamHandler(target)
    handler.setFormatter(logging.Formatter("%(message)s"))
    root.addHandler(handler)
    root.setLevel(log_level)

    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            structlog.processors.JSONRenderer(),
        ],
        wrapper_class=structlog.make_filtering_bound_logger(log_level),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(file=target),
        cache_logger_on_first_use=True,
    )
```

- [ ] **Step 4: 在 main.py 启用 logging**

把 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py` 替换为：

```python
"""tt-cuisine API entry point."""

from __future__ import annotations

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from tt_cuisine_api.config import get_settings
from tt_cuisine_api.logging import configure_logging


def create_app() -> FastAPI:
    """Application factory (enables test isolation)."""
    settings = get_settings()
    configure_logging(level=settings.api_log_level)

    log = structlog.get_logger(__name__)
    log.info("app.startup", version="0.1.0")

    app = FastAPI(
        title="tt-cuisine API",
        version="0.1.0",
        description="Read service for the multilingual dish concept corpus",
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    return app


app = create_app()
```

- [ ] **Step 5: 跑测试**

```bash
uv run pytest apps/api/tests -v
uv run mypy apps/api
uv run ruff check apps/api
```

预期：3 passed（1 main + 2 logging）；mypy/ruff 无错。

- [ ] **Step 6: 手动验证 uvicorn 起来时 emit JSON**

```bash
cd /home/ben/projects/tt-cuisine/apps/api
uv run --project /home/ben/projects/tt-cuisine uvicorn tt_cuisine_api.main:app --host 0.0.0.0 --port 8000 &
sleep 2
curl -s http://localhost:8000/openapi.json | head -c 100
kill %1
```

预期：终端能看到 JSON 形态的 `{"event": "app.startup", "version": "0.1.0", "level": "info", "timestamp": "..."}`。

- [ ] **Step 7: 提交**

```bash
git add apps/api/src/tt_cuisine_api/logging.py apps/api/src/tt_cuisine_api/main.py apps/api/tests/test_logging.py
git commit -m "feat(api): structlog JSON logging + 启动日志"
```

**Acceptance**：logger emit JSON 行（含 timestamp + level + event + custom fields）；2 个 logging 测试通过；uvicorn 启动可见 `app.startup` JSON 日志。

---

### Task 15: SQLAlchemy 2.0 async session + DB 模块

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/db.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_db.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_db.py`：

```python
"""Tests for DB session factory.

依赖：本地 PostgreSQL 跑起来 (Task 5 docker compose up)；DATABASE_URL 指向它。
"""

from __future__ import annotations

import os

import pytest
from sqlalchemy import text


@pytest.mark.asyncio
async def test_db_session_can_connect() -> None:
    """sanity: session works against real PG."""
    from tt_cuisine_api.db import get_engine, get_sessionmaker

    if not os.getenv("DATABASE_URL"):
        pytest.skip("DATABASE_URL not set; skipping live PG test")

    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    async with sessionmaker() as session:
        result = await session.execute(text("SELECT 1 AS one"))
        row = result.first()
        assert row is not None
        assert row.one == 1

    await engine.dispose()


@pytest.mark.asyncio
async def test_db_session_can_access_wiki_core_schema() -> None:
    """search_path 含 wiki_core (postgres-init.sql)。"""
    from tt_cuisine_api.db import get_engine, get_sessionmaker

    if not os.getenv("DATABASE_URL"):
        pytest.skip("DATABASE_URL not set; skipping live PG test")

    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    async with sessionmaker() as session:
        result = await session.execute(
            text("SELECT count(*) AS n FROM wiki_core.concepts")
        )
        row = result.first()
        assert row is not None  # 表存在即可，数量为 0 也 OK
    await engine.dispose()
```

- [ ] **Step 2: 跑测试确认失败**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_db.py -v
```

预期：`ImportError`。

- [ ] **Step 3: 实现 db.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/db.py`：

```python
"""Async SQLAlchemy engine + session factory.

Pattern: 单例 engine（应用生命周期），sessionmaker per request via FastAPI Depends.
"""

from __future__ import annotations

from collections.abc import AsyncGenerator
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from tt_cuisine_api.config import Settings, get_settings

_engine: AsyncEngine | None = None
_sessionmaker: async_sessionmaker[AsyncSession] | None = None


def get_engine(settings: Settings | None = None) -> AsyncEngine:
    """Return (and lazily create) the single async engine."""
    global _engine
    if _engine is None:
        s = settings or get_settings()
        _engine = create_async_engine(
            s.database_url,
            echo=False,
            pool_pre_ping=True,
        )
    return _engine


def get_sessionmaker(engine: AsyncEngine | None = None) -> async_sessionmaker[AsyncSession]:
    """Return (and lazily create) the session factory."""
    global _sessionmaker
    if _sessionmaker is None:
        eng = engine or get_engine()
        _sessionmaker = async_sessionmaker(
            bind=eng,
            expire_on_commit=False,
            class_=AsyncSession,
        )
    return _sessionmaker


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    """FastAPI dependency: yield a session per request, auto-commit on success."""
    sessionmaker = get_sessionmaker()
    async with sessionmaker() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise


SessionDep = Annotated[AsyncSession, Depends(get_session)]
```

- [ ] **Step 4: 跑测试**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_db.py -v
```

预期：2 passed（前提 PG 跑起来且 0001 迁移已执行）。

- [ ] **Step 5: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 6: 提交**

```bash
git add apps/api/src/tt_cuisine_api/db.py apps/api/tests/test_db.py
git commit -m "feat(api): SQLAlchemy 2.0 async engine + session factory + FastAPI dep"
```

**Acceptance**：能连上 PG；能 `SELECT count(*) FROM wiki_core.concepts`；`SessionDep` 可作为路由参数注入。

---

### Task 16: SQLAlchemy ORM models（Concept + DishName）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/__init__.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/base.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/concept.py`

- [ ] **Step 1: 创建 Base declarative class**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/base.py`：

```python
"""Declarative Base for SQLAlchemy ORM models."""

from __future__ import annotations

from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """Base class for all ORM models."""
```

- [ ] **Step 2: 创建 ORM models**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/concept.py`：

```python
"""ORM models for Concept and DishName (wiki_core schema).

跟 0001_initial_schema.py 完全对齐。任何 schema 变化都要先写迁移再改 ORM。
"""

from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from uuid import UUID

from sqlalchemy import TIMESTAMP, ForeignKey, Numeric, String, UniqueConstraint, func
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from tt_cuisine_api.models.base import Base


class ConceptORM(Base):
    __tablename__ = "concepts"
    __table_args__ = {"schema": "wiki_core"}

    id: Mapped[UUID] = mapped_column(PG_UUID(as_uuid=True), primary_key=True)
    slug: Mapped[str] = mapped_column(String(200), unique=True, nullable=False, index=True)
    canonical_name: Mapped[str] = mapped_column(String(500), nullable=False, index=True)
    status: Mapped[str] = mapped_column(String(32), nullable=False, server_default="draft", index=True)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )
    created_by: Mapped[str | None] = mapped_column(String(200), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(200), nullable=True)

    names: Mapped[list["DishNameORM"]] = relationship(
        "DishNameORM",
        back_populates="concept",
        cascade="all, delete-orphan",
        lazy="selectin",  # eager load by default for /api/v1/concepts/{slug}
    )


class DishNameORM(Base):
    __tablename__ = "dish_names"
    __table_args__ = (
        UniqueConstraint("language", "region", "text", name="uq_dish_names_lang_region_text"),
        {"schema": "wiki_core"},
    )

    id: Mapped[UUID] = mapped_column(PG_UUID(as_uuid=True), primary_key=True)
    concept_id: Mapped[UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("wiki_core.concepts.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    language: Mapped[str] = mapped_column(String(16), nullable=False)
    text: Mapped[str] = mapped_column(String(500), nullable=False, index=True)
    type: Mapped[str] = mapped_column(String(32), nullable=False)
    dialect: Mapped[str | None] = mapped_column(String(64), nullable=True)
    region: Mapped[str | None] = mapped_column(String(64), nullable=True)
    confidence: Mapped[Decimal] = mapped_column(
        Numeric(precision=4, scale=3), nullable=False, server_default="1.000"
    )
    source: Mapped[str | None] = mapped_column(String(200), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

    concept: Mapped[ConceptORM] = relationship("ConceptORM", back_populates="names")
```

- [ ] **Step 3: 创建 models/__init__.py 公开 API**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/models/__init__.py`：

```python
"""SQLAlchemy ORM models for wiki_core schema."""

from __future__ import annotations

from tt_cuisine_api.models.base import Base
from tt_cuisine_api.models.concept import ConceptORM, DishNameORM

__all__ = ["Base", "ConceptORM", "DishNameORM"]
```

- [ ] **Step 4: 验证 ORM 可导入且与 schema 对齐（手动 sanity）**

```bash
cd /home/ben/projects/tt-cuisine
uv run python -c "
from tt_cuisine_api.models import ConceptORM, DishNameORM, Base
print('Concept:', [c.name for c in ConceptORM.__table__.columns])
print('DishName:', [c.name for c in DishNameORM.__table__.columns])
print('Concept schema:', ConceptORM.__table__.schema)
"
```

预期输出列出列名，schema 是 `wiki_core`。

- [ ] **Step 5: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 6: 提交**

```bash
git add apps/api/src/tt_cuisine_api/models/
git commit -m "feat(api): SQLAlchemy ORM (ConceptORM + DishNameORM, eager load names)"
```

**Acceptance**：ORM 类与 0001 迁移完全对齐；relationships 双向；DishName 默认 selectin 加载（M0 query 友好，避免 N+1）。

---

### Task 17: Concept repository（async, read + create）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/repositories/__init__.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/repositories/concept.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_repository_concept.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_repository_concept.py`：

```python
"""Tests for ConceptRepository (live PG, cleaned after each test)."""

from __future__ import annotations

import os
from collections.abc import AsyncGenerator
from datetime import UTC, datetime
from uuid import uuid4

import pytest
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from tt_cuisine_domain import (
    ConceptStatus,
    DishConcept,
    DishName,
    DishNameType,
    Language,
)


@pytest.fixture(autouse=True)
def skip_without_db() -> None:
    if not os.getenv("DATABASE_URL"):
        pytest.skip("DATABASE_URL not set")


@pytest.fixture
async def session() -> AsyncGenerator[AsyncSession, None]:
    from tt_cuisine_api.db import get_engine, get_sessionmaker

    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    async with sessionmaker() as s:
        yield s


@pytest.fixture(autouse=True)
async def cleanup_db() -> AsyncGenerator[None, None]:
    """Wipe concepts table after each test using a fresh session (avoids
    being affected by tests that leave the primary session in a failed state)."""
    yield
    from tt_cuisine_api.db import get_engine, get_sessionmaker

    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    async with sessionmaker() as cleanup_session:
        await cleanup_session.execute(text("TRUNCATE wiki_core.concepts CASCADE"))
        await cleanup_session.commit()


def _make_concept(slug: str = "gong-bao-ji-ding") -> DishConcept:
    return DishConcept(
        id=uuid4(),
        slug=slug,
        canonical_name="宫保鸡丁",
        status=ConceptStatus.PUBLISHED,
        names=[
            DishName(language=Language.ZH_CN, text="宫保鸡丁", type=DishNameType.CANONICAL),
            DishName(language=Language.EN_US, text="Kung Pao Chicken", type=DishNameType.TRANSLITERATION),
        ],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )


@pytest.mark.asyncio
async def test_create_then_get_by_slug(session: AsyncSession) -> None:
    from tt_cuisine_api.repositories.concept import ConceptRepository

    repo = ConceptRepository(session)
    original = _make_concept()
    saved = await repo.create(original)
    assert saved.slug == original.slug
    assert len(saved.names) == 2

    fetched = await repo.get_by_slug("gong-bao-ji-ding")
    assert fetched is not None
    assert fetched.canonical_name == "宫保鸡丁"
    assert {n.language for n in fetched.names} == {Language.ZH_CN, Language.EN_US}


@pytest.mark.asyncio
async def test_get_by_slug_not_found(session: AsyncSession) -> None:
    from tt_cuisine_api.repositories.concept import ConceptRepository

    repo = ConceptRepository(session)
    result = await repo.get_by_slug("does-not-exist")
    assert result is None


@pytest.mark.asyncio
async def test_list_all_paginated(session: AsyncSession) -> None:
    from tt_cuisine_api.repositories.concept import ConceptRepository

    repo = ConceptRepository(session)
    for i in range(3):
        await repo.create(_make_concept(slug=f"dish-{i}"))

    result = await repo.list_all(limit=10, offset=0)
    assert len(result) == 3

    result_paginated = await repo.list_all(limit=2, offset=0)
    assert len(result_paginated) == 2


@pytest.mark.asyncio
async def test_create_duplicate_slug_rejected(session: AsyncSession) -> None:
    from tt_cuisine_api.repositories.concept import ConceptRepository

    repo = ConceptRepository(session)
    await repo.create(_make_concept(slug="duplicate"))
    with pytest.raises(Exception):  # IntegrityError, but kept generic for portability
        await repo.create(_make_concept(slug="duplicate"))
```

- [ ] **Step 2: 跑测试确认失败**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_repository_concept.py -v
```

预期：`ImportError` 失败。

- [ ] **Step 3: 创建 repositories/__init__.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/repositories/__init__.py`：

```python
"""Repositories: async data access for ORM <-> domain conversion."""

from __future__ import annotations

from tt_cuisine_api.repositories.concept import ConceptRepository

__all__ = ["ConceptRepository"]
```

- [ ] **Step 4: 实现 ConceptRepository**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/repositories/concept.py`：

```python
"""ConceptRepository: async CRUD-lite over ConceptORM + DishNameORM.

ORM ↔ Domain 双向转换在 _to_domain / _to_orm 集中处理。
"""

from __future__ import annotations

from datetime import UTC, datetime
from decimal import Decimal
from uuid import uuid4

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from tt_cuisine_api.models import ConceptORM, DishNameORM
from tt_cuisine_domain import (
    ConceptStatus,
    DishConcept,
    DishName,
    DishNameType,
    Language,
)


class ConceptRepository:
    """Async repository for DishConcept aggregates."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_by_slug(self, slug: str) -> DishConcept | None:
        """Return the concept identified by slug, or None."""
        stmt = select(ConceptORM).where(ConceptORM.slug == slug)
        result = await self._session.execute(stmt)
        orm = result.scalar_one_or_none()
        if orm is None:
            return None
        return self._to_domain(orm)

    async def list_all(self, *, limit: int = 50, offset: int = 0) -> list[DishConcept]:
        """List concepts ordered by created_at DESC."""
        stmt = (
            select(ConceptORM)
            .order_by(ConceptORM.created_at.desc())
            .limit(limit)
            .offset(offset)
        )
        result = await self._session.execute(stmt)
        orms = result.scalars().all()
        return [self._to_domain(o) for o in orms]

    async def create(self, concept: DishConcept) -> DishConcept:
        """Insert a new concept aggregate (including its names). Flush + return saved version."""
        orm = self._to_orm(concept)
        self._session.add(orm)
        await self._session.flush()
        # Re-fetch to get server defaults (timestamps) realized
        await self._session.refresh(orm, attribute_names=["names", "created_at", "updated_at"])
        return self._to_domain(orm)

    # ----- ORM <-> Domain conversion -----

    @staticmethod
    def _to_domain(orm: ConceptORM) -> DishConcept:
        return DishConcept(
            id=orm.id,
            slug=orm.slug,
            canonical_name=orm.canonical_name,
            status=ConceptStatus(orm.status),
            names=[
                DishName(
                    language=Language.from_code(n.language),
                    text=n.text,
                    type=DishNameType(n.type),
                    dialect=n.dialect,
                    region=n.region,
                    confidence=float(n.confidence),
                    source=n.source,
                )
                for n in orm.names
            ],
            created_at=orm.created_at,
            updated_at=orm.updated_at,
            created_by=orm.created_by,
            updated_by=orm.updated_by,
        )

    @staticmethod
    def _to_orm(concept: DishConcept) -> ConceptORM:
        now = datetime.now(UTC)
        orm = ConceptORM(
            id=concept.id,
            slug=concept.slug,
            canonical_name=concept.canonical_name,
            status=concept.status.value,
            created_at=concept.created_at or now,
            updated_at=concept.updated_at or now,
            created_by=concept.created_by,
            updated_by=concept.updated_by,
        )
        orm.names = [
            DishNameORM(
                id=uuid4(),
                concept_id=concept.id,
                language=n.language.value,
                text=n.text,
                type=n.type.value,
                dialect=n.dialect,
                region=n.region,
                confidence=Decimal(str(n.confidence)),
                source=n.source,
            )
            for n in concept.names
        ]
        return orm
```

- [ ] **Step 5: 跑测试**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_repository_concept.py -v
```

预期：4 passed。

- [ ] **Step 6: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 7: 提交**

```bash
git add apps/api/src/tt_cuisine_api/repositories/ apps/api/tests/test_repository_concept.py
git commit -m "feat(api): ConceptRepository (async, get_by_slug + list + create + ORM↔domain)"
```

**Acceptance**：4 repository 测试通过；ORM↔Domain 转换正确；重复 slug 触发 DB 约束错误。

---

### Task 18: GET /api/v1/health endpoint（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/__init__.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/health.py`
- Modify: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_health.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_health.py`：

```python
"""Tests for /api/v1/health."""

from __future__ import annotations

from fastapi.testclient import TestClient


def test_health_returns_200(client: TestClient) -> None:
    response = client.get("/api/v1/health")
    assert response.status_code == 200


def test_health_payload(client: TestClient) -> None:
    response = client.get("/api/v1/health")
    payload = response.json()
    assert payload["status"] == "ok"
    assert payload["version"] == "0.1.0"
    assert "timestamp" in payload
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest apps/api/tests/test_health.py -v
```

预期：`404 != 200`。

- [ ] **Step 3: 创建 routers/__init__.py**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/__init__.py`：

```python
"""HTTP routers for tt-cuisine API."""

from __future__ import annotations
```

- [ ] **Step 4: 实现 health router**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/health.py`：

```python
"""Health check endpoint."""

from __future__ import annotations

from datetime import UTC, datetime

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1", tags=["health"])


class HealthResponse(BaseModel):
    status: str
    version: str
    timestamp: datetime


@router.get("/health", response_model=HealthResponse)
async def health() -> HealthResponse:
    """Liveness probe — does NOT check DB. M1+ 加 /readiness 区分。"""
    return HealthResponse(
        status="ok",
        version="0.1.0",
        timestamp=datetime.now(UTC),
    )
```

- [ ] **Step 5: 在 main.py 挂载 router**

修改 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py` 的 `create_app` 函数，在 `app.add_middleware(...)` 之后、`return app` 之前，加入：

```python
    from tt_cuisine_api.routers import health as health_router

    app.include_router(health_router.router)
```

完整 main.py 应为：

```python
"""tt-cuisine API entry point."""

from __future__ import annotations

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from tt_cuisine_api.config import get_settings
from tt_cuisine_api.logging import configure_logging
from tt_cuisine_api.routers import health as health_router


def create_app() -> FastAPI:
    """Application factory (enables test isolation)."""
    settings = get_settings()
    configure_logging(level=settings.api_log_level)

    log = structlog.get_logger(__name__)
    log.info("app.startup", version="0.1.0")

    app = FastAPI(
        title="tt-cuisine API",
        version="0.1.0",
        description="Read service for the multilingual dish concept corpus",
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    app.include_router(health_router.router)
    return app


app = create_app()
```

- [ ] **Step 6: 跑测试**

```bash
uv run pytest apps/api/tests/test_health.py -v
uv run mypy apps/api
uv run ruff check apps/api
```

预期：2 passed；mypy/ruff 无错。

- [ ] **Step 7: 提交**

```bash
git add apps/api/src/tt_cuisine_api/routers/ apps/api/src/tt_cuisine_api/main.py apps/api/tests/test_health.py
git commit -m "feat(api): GET /api/v1/health endpoint"
```

**Acceptance**：`curl http://localhost:8000/api/v1/health` 返回 `{"status":"ok","version":"0.1.0","timestamp":"..."}`；2 测试通过。

---

### Task 19: GET /api/v1/concepts/{slug} endpoint（TDD）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/concepts.py`
- Modify: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py`
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_concepts.py`

- [ ] **Step 1: 写失败测试**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_concepts.py`：

```python
"""Tests for /api/v1/concepts endpoints."""

from __future__ import annotations

import os
from datetime import UTC, datetime
from uuid import uuid4

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import text

from tt_cuisine_domain import (
    ConceptStatus,
    DishConcept,
    DishName,
    DishNameType,
    Language,
)


@pytest.fixture(autouse=True)
def skip_without_db() -> None:
    if not os.getenv("DATABASE_URL"):
        pytest.skip("DATABASE_URL not set")


@pytest.fixture(autouse=True)
async def cleanup_db() -> None:
    """Wipe concepts after each test."""
    from tt_cuisine_api.db import get_engine, get_sessionmaker

    yield
    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    async with sessionmaker() as session:
        await session.execute(text("TRUNCATE wiki_core.concepts CASCADE"))
        await session.commit()


async def _seed_concept(slug: str = "gong-bao-ji-ding") -> None:
    from tt_cuisine_api.db import get_engine, get_sessionmaker
    from tt_cuisine_api.repositories.concept import ConceptRepository

    engine = get_engine()
    sessionmaker = get_sessionmaker(engine)
    concept = DishConcept(
        id=uuid4(),
        slug=slug,
        canonical_name="宫保鸡丁",
        status=ConceptStatus.PUBLISHED,
        names=[
            DishName(language=Language.ZH_CN, text="宫保鸡丁", type=DishNameType.CANONICAL),
            DishName(language=Language.EN_US, text="Kung Pao Chicken", type=DishNameType.TRANSLITERATION),
        ],
        created_at=datetime.now(UTC),
        updated_at=datetime.now(UTC),
    )
    async with sessionmaker() as session:
        repo = ConceptRepository(session)
        await repo.create(concept)
        await session.commit()


def test_get_concept_by_slug_404_when_missing(client: TestClient) -> None:
    response = client.get("/api/v1/concepts/does-not-exist")
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_get_concept_by_slug_200_when_exists(client: TestClient) -> None:
    await _seed_concept()
    response = client.get("/api/v1/concepts/gong-bao-ji-ding")
    assert response.status_code == 200
    payload = response.json()
    assert payload["slug"] == "gong-bao-ji-ding"
    assert payload["canonical_name"] == "宫保鸡丁"
    assert payload["status"] == "published"
    assert len(payload["names"]) == 2
    languages = {n["language"] for n in payload["names"]}
    assert languages == {"zh-CN", "en-US"}


def test_list_concepts_empty(client: TestClient) -> None:
    response = client.get("/api/v1/concepts")
    assert response.status_code == 200
    assert response.json() == []


@pytest.mark.asyncio
async def test_list_concepts_with_items(client: TestClient) -> None:
    await _seed_concept(slug="dish-a")
    await _seed_concept(slug="dish-b")
    response = client.get("/api/v1/concepts")
    assert response.status_code == 200
    items = response.json()
    assert len(items) == 2
    slugs = {item["slug"] for item in items}
    assert slugs == {"dish-a", "dish-b"}
```

- [ ] **Step 2: 跑测试确认失败**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_concepts.py -v
```

预期：`404`，因为路由未挂。

- [ ] **Step 3: 实现 concepts router**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/concepts.py`：

```python
"""DishConcept endpoints."""

from __future__ import annotations

from fastapi import APIRouter, HTTPException, Query, status

from tt_cuisine_api.db import SessionDep
from tt_cuisine_api.repositories.concept import ConceptRepository
from tt_cuisine_domain import DishConcept

router = APIRouter(prefix="/api/v1/concepts", tags=["concepts"])


@router.get("", response_model=list[DishConcept])
async def list_concepts(
    session: SessionDep,
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
) -> list[DishConcept]:
    """List concepts, newest first."""
    repo = ConceptRepository(session)
    return await repo.list_all(limit=limit, offset=offset)


@router.get("/{slug}", response_model=DishConcept)
async def get_concept(slug: str, session: SessionDep) -> DishConcept:
    """Fetch a single concept by slug."""
    repo = ConceptRepository(session)
    concept = await repo.get_by_slug(slug)
    if concept is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No concept found with slug: {slug!r}",
        )
    return concept
```

- [ ] **Step 4: 挂载 concepts router**

修改 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/main.py` 的 import 与 `create_app`：

```python
from tt_cuisine_api.routers import concepts as concepts_router
from tt_cuisine_api.routers import health as health_router
```

在 `app.include_router(health_router.router)` 之后加：

```python
    app.include_router(concepts_router.router)
```

- [ ] **Step 5: 跑测试**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_concepts.py -v
```

预期：4 passed。

- [ ] **Step 6: 手动 curl 验证**

```bash
cd /home/ben/projects/tt-cuisine
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run --project /home/ben/projects/tt-cuisine uvicorn tt_cuisine_api.main:app --host 0.0.0.0 --port 8000 &
sleep 2
curl -s http://localhost:8000/api/v1/concepts | head
curl -s -w "\n%{http_code}\n" http://localhost:8000/api/v1/concepts/does-not-exist
kill %1
```

预期：第一个 curl 返回 `[]`；第二个返回 `{"detail":"No concept found with slug: 'does-not-exist'"}` + HTTP 404。

- [ ] **Step 7: 提交**

```bash
git add apps/api/src/tt_cuisine_api/routers/concepts.py apps/api/src/tt_cuisine_api/main.py apps/api/tests/test_concepts.py
git commit -m "feat(api): GET /api/v1/concepts + /api/v1/concepts/{slug}"
```

**Acceptance**：4 concepts 测试通过；GET by slug 返回 200/404；list 返回数组带 limit/offset。

---

### Task 20: POST /api/v1/concepts endpoint（TDD）

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/concepts.py`
- Modify: `/home/ben/projects/tt-cuisine/apps/api/tests/test_concepts.py`

- [ ] **Step 1: 追加失败测试到 test_concepts.py**

在 `test_concepts.py` 末尾追加：

```python
def test_create_concept_201(client: TestClient) -> None:
    payload = {
        "slug": "gong-bao-ji-ding",
        "canonical_name": "宫保鸡丁",
        "status": "draft",
        "names": [
            {"language": "zh-CN", "text": "宫保鸡丁", "type": "canonical"},
            {"language": "zh-HK", "text": "宮保雞丁", "type": "canonical"},
            {"language": "en-US", "text": "Kung Pao Chicken", "type": "transliteration"},
            {"language": "ja-JP", "text": "宮保鶏丁", "type": "transliteration"},
            {"language": "ko-KR", "text": "궁보계정", "type": "transliteration"},
        ],
    }
    response = client.post("/api/v1/concepts", json=payload)
    assert response.status_code == 201, response.text
    body = response.json()
    assert body["slug"] == "gong-bao-ji-ding"
    assert len(body["names"]) == 5
    assert body["status"] == "draft"
    assert "id" in body
    assert "created_at" in body


def test_create_concept_invalid_slug_422(client: TestClient) -> None:
    payload = {
        "slug": "Bad Slug",
        "canonical_name": "宫保鸡丁",
        "status": "draft",
        "names": [{"language": "zh-CN", "text": "宫保鸡丁", "type": "canonical"}],
    }
    response = client.post("/api/v1/concepts", json=payload)
    assert response.status_code == 422


def test_create_concept_no_names_422(client: TestClient) -> None:
    payload = {
        "slug": "x",
        "canonical_name": "X",
        "status": "draft",
        "names": [],
    }
    response = client.post("/api/v1/concepts", json=payload)
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_create_concept_duplicate_slug_409(client: TestClient) -> None:
    await _seed_concept(slug="dup")
    payload = {
        "slug": "dup",
        "canonical_name": "X",
        "status": "draft",
        "names": [{"language": "zh-CN", "text": "X", "type": "canonical"}],
    }
    response = client.post("/api/v1/concepts", json=payload)
    assert response.status_code == 409
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest apps/api/tests/test_concepts.py -v
```

预期：4 个新测试失败（method not allowed / etc）。

- [ ] **Step 3: 实现 POST endpoint**

替换 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/concepts.py` 的全部内容为：

```python
"""DishConcept endpoints."""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Query, status
from pydantic import BaseModel, Field
from sqlalchemy.exc import IntegrityError

from tt_cuisine_api.db import SessionDep
from tt_cuisine_api.repositories.concept import ConceptRepository
from tt_cuisine_domain import (
    ConceptStatus,
    DishConcept,
    DishName,
    DishNameType,
    Language,
)

router = APIRouter(prefix="/api/v1/concepts", tags=["concepts"])


class DishNameCreate(BaseModel):
    language: str = Field(..., description="BCP 47 code, e.g. zh-CN")
    text: str
    type: str
    dialect: str | None = None
    region: str | None = None
    confidence: float = 1.0
    source: str | None = None


class DishConceptCreate(BaseModel):
    slug: str
    canonical_name: str
    status: str = "draft"
    names: list[DishNameCreate] = Field(..., min_length=1)


@router.get("", response_model=list[DishConcept])
async def list_concepts(
    session: SessionDep,
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
) -> list[DishConcept]:
    """List concepts, newest first."""
    repo = ConceptRepository(session)
    return await repo.list_all(limit=limit, offset=offset)


@router.get("/{slug}", response_model=DishConcept)
async def get_concept(slug: str, session: SessionDep) -> DishConcept:
    """Fetch a single concept by slug."""
    repo = ConceptRepository(session)
    concept = await repo.get_by_slug(slug)
    if concept is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No concept found with slug: {slug!r}",
        )
    return concept


@router.post("", response_model=DishConcept, status_code=status.HTTP_201_CREATED)
async def create_concept(payload: DishConceptCreate, session: SessionDep) -> DishConcept:
    """Create a new DishConcept aggregate."""
    try:
        concept = DishConcept(
            id=uuid4(),
            slug=payload.slug,
            canonical_name=payload.canonical_name,
            status=ConceptStatus(payload.status),
            names=[
                DishName(
                    language=Language.from_code(n.language),
                    text=n.text,
                    type=DishNameType(n.type),
                    dialect=n.dialect,
                    region=n.region,
                    confidence=n.confidence,
                    source=n.source,
                )
                for n in payload.names
            ],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
        )
    except ValueError as exc:  # 含 pydantic.ValidationError 与 Language.from_code/Enum 的 ValueError
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=str(exc),
        ) from exc

    repo = ConceptRepository(session)
    try:
        saved = await repo.create(concept)
    except IntegrityError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Concept with slug {payload.slug!r} already exists",
        ) from exc

    return saved
```

- [ ] **Step 4: 跑测试**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests/test_concepts.py -v
```

预期：所有 8 个 concepts 测试 pass。

- [ ] **Step 5: 手动 curl 验证 M0 demo 数据**

```bash
cd /home/ben/projects/tt-cuisine
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "TRUNCATE wiki_core.concepts CASCADE"

uv run --project /home/ben/projects/tt-cuisine uvicorn tt_cuisine_api.main:app --host 0.0.0.0 --port 8000 &
sleep 2

curl -s -X POST http://localhost:8000/api/v1/concepts \
  -H 'Content-Type: application/json' \
  -d '{
    "slug": "gong-bao-ji-ding",
    "canonical_name": "宫保鸡丁",
    "status": "published",
    "names": [
      {"language": "zh-CN", "text": "宫保鸡丁", "type": "canonical"},
      {"language": "zh-HK", "text": "宮保雞丁", "type": "canonical"},
      {"language": "en-US", "text": "Kung Pao Chicken", "type": "transliteration"},
      {"language": "ja-JP", "text": "宮保鶏丁", "type": "transliteration"},
      {"language": "ko-KR", "text": "궁보계정", "type": "transliteration"}
    ]
  }' | python3 -m json.tool

echo "---"
curl -s http://localhost:8000/api/v1/concepts/gong-bao-ji-ding | python3 -m json.tool

kill %1
```

预期：POST 返回 201 + 含 5 个 names 的 JSON；GET 返回同一 concept。

- [ ] **Step 6: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 7: 提交**

```bash
git add apps/api/src/tt_cuisine_api/routers/concepts.py apps/api/tests/test_concepts.py
git commit -m "feat(api): POST /api/v1/concepts (201/409/422 status codes)"
```

**Acceptance**：8 concepts 测试通过；curl 创建宫保鸡丁含 5 语别名成功；重复 slug 返回 409；坏 slug 返回 422。**M0 第一个 success criterion (curl 返回 JSON) 达成。**

---

### Task 21: Clerk JWT 验证中间件

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/auth.py`
- Modify: `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/routers/concepts.py`（保护 POST）
- Create: `/home/ben/projects/tt-cuisine/apps/api/tests/test_auth.py`

- [ ] **Step 1: 写失败测试（auth 模块自身的单元测试，不依赖真 Clerk）**

写入 `/home/ben/projects/tt-cuisine/apps/api/tests/test_auth.py`：

```python
"""Tests for Clerk JWT verification.

注意：M0 不集成真 Clerk JWKS——仅用本地生成的 HS256 测试密钥模拟验证逻辑。
真 Clerk integration 由 frontend 在 admin web 端完成，后端验签延后到 M1（要接 RS256 + JWKS rotate）。
M0 提供"未验签时的 anonymous user"模式，让 admin-web 走 Clerk 登录、API 信任 frontend forward header。
"""

from __future__ import annotations

import pytest

from tt_cuisine_api.auth import AuthenticatedUser, get_current_user_optional


@pytest.mark.asyncio
async def test_anonymous_when_no_header() -> None:
    user = await get_current_user_optional(authorization=None)
    assert isinstance(user, AuthenticatedUser)
    assert user.is_anonymous
    assert user.user_id == "anonymous"


@pytest.mark.asyncio
async def test_user_when_header_present_dev_mode() -> None:
    """M0 dev mode: 直接把 Authorization Bearer <user_id> 作为 user_id（无验签）。"""
    user = await get_current_user_optional(authorization="Bearer user_abc123")
    assert not user.is_anonymous
    assert user.user_id == "user_abc123"


@pytest.mark.asyncio
async def test_malformed_authorization_returns_anonymous() -> None:
    user = await get_current_user_optional(authorization="Garbage")
    assert user.is_anonymous
```

- [ ] **Step 2: 跑测试确认失败**

```bash
uv run pytest apps/api/tests/test_auth.py -v
```

预期：`ImportError`。

- [ ] **Step 3: 实现 auth.py（M0 dev 模式）**

写入 `/home/ben/projects/tt-cuisine/apps/api/src/tt_cuisine_api/auth.py`：

```python
"""Authentication / authorization.

**M0 范围**：
- 不实际验签 Clerk RS256 JWT（M1 任务）
- 提供 "dev mode trust header" 模式：admin-web 已经走 Clerk 登录，把 Clerk user_id forward 给后端
- 后端在 M0 暂时信任 Authorization Bearer <user_id> 这个语义（仅本地开发 + 内部 admin 环境）
- M1 切到真 JWKS 验签（python-jose + httpx fetch JWKS）

不在 M0 引入真 JWT 验签的理由：
1. M0 spec §7.2.4 Exit Criteria 仅要求"至少 1 个真实编辑账号能登录"——登录由 admin-web Clerk 处理
2. 真 JWKS 验签 + cache + rotate 是 M1 工程量，超出 M0 scope
3. 本地开发环境无生产风险
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Annotated

from fastapi import Depends, Header


@dataclass(frozen=True)
class AuthenticatedUser:
    """The minimal user identity carried by the API request context."""

    user_id: str

    @property
    def is_anonymous(self) -> bool:
        return self.user_id == "anonymous"


async def get_current_user_optional(
    authorization: Annotated[str | None, Header(alias="Authorization")] = None,
) -> AuthenticatedUser:
    """M0 dev-mode user resolution.

    Returns AuthenticatedUser(user_id='anonymous') if header absent / malformed.
    Returns AuthenticatedUser(user_id=<token>) if header is 'Bearer <token>'.

    Note: M1 will replace this with real Clerk JWT verification (RS256 + JWKS).
    """
    if not authorization:
        return AuthenticatedUser(user_id="anonymous")

    parts = authorization.split()
    if len(parts) != 2 or parts[0].lower() != "bearer":
        return AuthenticatedUser(user_id="anonymous")

    token = parts[1]
    if not token:
        return AuthenticatedUser(user_id="anonymous")

    return AuthenticatedUser(user_id=token)


async def get_current_user_required(
    user: Annotated[AuthenticatedUser, Depends(get_current_user_optional)],
) -> AuthenticatedUser:
    """Variant that rejects anonymous (used to protect write endpoints).

    M0 行为：anonymous 返回 401。
    M1 行为：JWT 验签失败返回 401（含详细 reason）。
    """
    from fastapi import HTTPException, status

    if user.is_anonymous:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user


CurrentUser = Annotated[AuthenticatedUser, Depends(get_current_user_required)]
OptionalUser = Annotated[AuthenticatedUser, Depends(get_current_user_optional)]
```

- [ ] **Step 4: 保护 POST endpoint（GET 仍 public）**

修改 `concepts.py`，在 `create_concept` 函数签名加入 `user: CurrentUser`，并用 user.user_id 填充 `created_by`：

```python
from tt_cuisine_api.auth import CurrentUser, OptionalUser
```

并把 `create_concept` 替换为：

```python
@router.post("", response_model=DishConcept, status_code=status.HTTP_201_CREATED)
async def create_concept(
    payload: DishConceptCreate,
    session: SessionDep,
    user: CurrentUser,
) -> DishConcept:
    """Create a new DishConcept aggregate (auth required)."""
    try:
        concept = DishConcept(
            id=uuid4(),
            slug=payload.slug,
            canonical_name=payload.canonical_name,
            status=ConceptStatus(payload.status),
            names=[
                DishName(
                    language=Language.from_code(n.language),
                    text=n.text,
                    type=DishNameType(n.type),
                    dialect=n.dialect,
                    region=n.region,
                    confidence=n.confidence,
                    source=n.source,
                )
                for n in payload.names
            ],
            created_at=datetime.now(UTC),
            updated_at=datetime.now(UTC),
            created_by=user.user_id,
            updated_by=user.user_id,
        )
    except (ValueError, Exception) as exc:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=str(exc),
        ) from exc

    repo = ConceptRepository(session)
    try:
        saved = await repo.create(concept)
    except IntegrityError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Concept with slug {payload.slug!r} already exists",
        ) from exc

    return saved
```

- [ ] **Step 5: 更新 test_concepts.py 的 POST 测试加上 auth header**

修改 `apps/api/tests/test_concepts.py` 的所有 POST 测试，在 `client.post(...)` 调用中加 header：

替换：

```python
response = client.post("/api/v1/concepts", json=payload)
```

为：

```python
response = client.post(
    "/api/v1/concepts",
    json=payload,
    headers={"Authorization": "Bearer user_test_editor"},
)
```

并新增一个测试验证未带 token → 401：

```python
def test_create_concept_requires_auth_401(client: TestClient) -> None:
    payload = {
        "slug": "x",
        "canonical_name": "X",
        "status": "draft",
        "names": [{"language": "zh-CN", "text": "X", "type": "canonical"}],
    }
    response = client.post("/api/v1/concepts", json=payload)  # no auth header
    assert response.status_code == 401
```

- [ ] **Step 6: 跑全部测试**

```bash
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run pytest apps/api/tests -v
```

预期：所有测试通过（health + main + db + repo + concepts + auth），约 18+ 项。

- [ ] **Step 7: mypy + ruff**

```bash
uv run mypy apps/api
uv run ruff check apps/api
```

预期：无错。

- [ ] **Step 8: 提交**

```bash
git add apps/api/src/tt_cuisine_api/auth.py apps/api/src/tt_cuisine_api/routers/concepts.py apps/api/tests/test_auth.py apps/api/tests/test_concepts.py
git commit -m "feat(api): Clerk auth M0 dev mode (Bearer pass-through) + protect POST"
```

**Acceptance**：POST 无 Authorization → 401；POST 带 `Bearer <user_id>` → 201 且 `created_by` 落到 DB；所有 API 测试通过；M0 auth 边界清晰（M1 切真 JWKS 验签的位置已留好）。

---

## Phase 5 · admin-web（React + Vite + AntD + TanStack）

### Task 22: admin-web Vite + React 18 + TS skeleton

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/package.json`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/tsconfig.json`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/tsconfig.node.json`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/vite.config.ts`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/index.html`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/styles.css`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/.gitignore`

- [ ] **Step 1: 创建 package.json**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/package.json`：

```json
{
  "name": "tt-cuisine-admin-web",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview --host 0.0.0.0 --port 8080",
    "type-check": "tsc -b --noEmit",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "format": "prettier --write 'src/**/*.{ts,tsx,css,json}'",
    "test": "vitest run",
    "test:watch": "vitest",
    "e2e": "playwright test"
  },
  "dependencies": {
    "@clerk/clerk-react": "^5.18.0",
    "@tanstack/react-query": "^5.59.0",
    "@tanstack/react-router": "^1.78.0",
    "antd": "^5.21.0",
    "axios": "^1.7.7",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "zustand": "^5.0.0"
  },
  "devDependencies": {
    "@playwright/test": "^1.48.0",
    "@tanstack/router-vite-plugin": "^1.78.0",
    "@testing-library/react": "^16.0.0",
    "@types/node": "^22.7.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@typescript-eslint/eslint-plugin": "^8.8.0",
    "@typescript-eslint/parser": "^8.8.0",
    "@vitejs/plugin-react": "^4.3.0",
    "eslint": "^9.12.0",
    "eslint-plugin-react-hooks": "^5.0.0",
    "eslint-plugin-react-refresh": "^0.4.0",
    "jsdom": "^25.0.0",
    "prettier": "^3.3.0",
    "typescript": "^5.6.0",
    "vite": "^5.4.0",
    "vitest": "^2.1.0"
  }
}
```

- [ ] **Step 2: 创建 tsconfig.json**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/tsconfig.json`：

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src", "tests"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

- [ ] **Step 3: 创建 tsconfig.node.json**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/tsconfig.node.json`：

```json
{
  "compilerOptions": {
    "composite": true,
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["vite.config.ts", "playwright.config.ts"]
}
```

- [ ] **Step 4: 创建 vite.config.ts**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/vite.config.ts`：

```typescript
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { TanStackRouterVite } from "@tanstack/router-vite-plugin";
import path from "node:path";

export default defineConfig({
  plugins: [TanStackRouterVite(), react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  server: {
    host: "0.0.0.0",
    port: 5173,
    proxy: {
      "/api": {
        target: "http://localhost:8000",
        changeOrigin: true,
      },
    },
  },
  test: {
    globals: true,
    environment: "jsdom",
  },
});
```

- [ ] **Step 5: 创建 index.html**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/index.html`：

```html
<!doctype html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>tt-cuisine · 菜品维基管理后台</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

- [ ] **Step 6: 创建 src/styles.css（最小重置）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/styles.css`：

```css
* {
  box-sizing: border-box;
}

html,
body,
#root {
  margin: 0;
  padding: 0;
  height: 100%;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC",
    "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Arial,
    "Noto Sans CJK SC", sans-serif;
}
```

- [ ] **Step 7: 创建最小 main.tsx**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`：

```tsx
import React from "react";
import ReactDOM from "react-dom/client";
import "./styles.css";
import { App } from "./App";

const root = document.getElementById("root");
if (!root) {
  throw new Error("Root element not found");
}

ReactDOM.createRoot(root).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
```

- [ ] **Step 8: 创建最小 App.tsx**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`：

```tsx
export function App() {
  return (
    <main style={{ padding: "2rem", fontFamily: "system-ui" }}>
      <h1>tt-cuisine · admin-web (M0 bootstrap)</h1>
      <p>Vite + React 18 + TypeScript skeleton 已就位。</p>
    </main>
  );
}
```

- [ ] **Step 9: 创建 admin-web 局部 .gitignore**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/.gitignore`：

```gitignore
node_modules/
dist/
.vite/
playwright-report/
test-results/
```

- [ ] **Step 10: 安装依赖**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm install
```

预期：装好所有 deps。如有 peer warnings 可忽略。

- [ ] **Step 11: 启动 dev server 手动验证**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm dev &
sleep 5
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5173
kill %1
```

预期：HTTP 200。

- [ ] **Step 12: 类型检查 + lint**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm type-check
```

预期：通过。

- [ ] **Step 13: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/package.json apps/admin-web/tsconfig.json apps/admin-web/tsconfig.node.json
git add apps/admin-web/vite.config.ts apps/admin-web/index.html
git add apps/admin-web/src/ apps/admin-web/.gitignore
git add apps/admin-web/pnpm-lock.yaml 2>/dev/null || true
git commit -m "feat(web): Vite + React 18 + TS skeleton（admin-web）"
```

**Acceptance**：`pnpm dev` 起来；浏览器访问 `http://localhost:5173` 看到 "tt-cuisine · admin-web (M0 bootstrap)"；type-check 通过。

---

### Task 23: AntD 5 + ConfigProvider + 主题

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/theme.ts`

- [ ] **Step 1: 创建 theme 配置**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/theme.ts`：

```typescript
import type { ThemeConfig } from "antd";

export const lightTheme: ThemeConfig = {
  token: {
    colorPrimary: "#c14d35", // 砖红色 — 餐饮品牌色（M0 暂用此色，M3 品牌确认后调整）
    borderRadius: 6,
    fontFamily:
      '-apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Arial, "Noto Sans CJK SC", sans-serif',
  },
};
```

- [ ] **Step 2: 用 ConfigProvider 包裹 App**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`：

```tsx
import { ConfigProvider, App as AntApp, Layout, Typography } from "antd";
import zhCN from "antd/locale/zh_CN";
import { lightTheme } from "./theme";

const { Header, Content } = Layout;
const { Title } = Typography;

export function App() {
  return (
    <ConfigProvider theme={lightTheme} locale={zhCN}>
      <AntApp>
        <Layout style={{ minHeight: "100vh" }}>
          <Header style={{ display: "flex", alignItems: "center" }}>
            <Title level={4} style={{ color: "#fff", margin: 0 }}>
              tt-cuisine · 菜品维基管理后台
            </Title>
          </Header>
          <Content style={{ padding: "24px" }}>
            <p>AntD 5 ConfigProvider + 中文 locale 已就位。</p>
          </Content>
        </Layout>
      </AntApp>
    </ConfigProvider>
  );
}
```

- [ ] **Step 3: 验证 dev 中 AntD 主题应用**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm dev &
sleep 5
curl -s http://localhost:5173 | grep -o "tt-cuisine" | head -1
kill %1
```

预期：能 grep 到字符串（说明 SPA 主入口 OK）。**重点是人肉打开浏览器看到 AntD Header（砖红色背景 + 白字标题）**。

- [ ] **Step 4: type-check**

```bash
pnpm type-check
```

预期：通过。

- [ ] **Step 5: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/App.tsx apps/admin-web/src/theme.ts
git commit -m "feat(web): AntD 5 ConfigProvider + 中文 locale + 临时品牌色"
```

**Acceptance**：AntD Layout + Header 渲染；中文 locale 启用（如 DatePicker 等组件 OK）；theme.ts 可被后续 fine-tune。

---

### Task 24: TanStack Router 配置 + 文件式路由

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/__root.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/index.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.new.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.$slug.tsx`

- [ ] **Step 1: 创建 __root 路由**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/__root.tsx`：

```tsx
import { createRootRoute, Outlet, Link } from "@tanstack/react-router";
import { ConfigProvider, App as AntApp, Layout, Typography, Menu } from "antd";
import zhCN from "antd/locale/zh_CN";
import { lightTheme } from "../theme";

const { Header, Content } = Layout;
const { Title } = Typography;

export const Route = createRootRoute({
  component: () => (
    <ConfigProvider theme={lightTheme} locale={zhCN}>
      <AntApp>
        <Layout style={{ minHeight: "100vh" }}>
          <Header
            style={{
              display: "flex",
              alignItems: "center",
              gap: 24,
              padding: "0 24px",
            }}
          >
            <Title level={4} style={{ color: "#fff", margin: 0 }}>
              tt-cuisine
            </Title>
            <Menu
              theme="dark"
              mode="horizontal"
              selectable={false}
              style={{ flex: 1, minWidth: 0 }}
              items={[
                {
                  key: "list",
                  label: <Link to="/">菜品列表</Link>,
                },
                {
                  key: "new",
                  label: <Link to="/concepts/new">新建菜品</Link>,
                },
              ]}
            />
          </Header>
          <Content style={{ padding: "24px" }}>
            <Outlet />
          </Content>
        </Layout>
      </AntApp>
    </ConfigProvider>
  ),
});
```

- [ ] **Step 2: 创建 index (list) 路由 placeholder**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/index.tsx`：

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  component: () => <div>菜品列表（Task 27 实现）</div>,
});
```

- [ ] **Step 3: 创建 new 路由 placeholder**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.new.tsx`：

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/concepts/new")({
  component: () => <div>新建菜品（Task 28 实现）</div>,
});
```

- [ ] **Step 4: 创建 $slug 路由 placeholder**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.$slug.tsx`：

```tsx
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/concepts/$slug")({
  component: () => {
    const { slug } = Route.useParams();
    return <div>菜品详情：{slug}（Task 29 实现）</div>;
  },
});
```

- [ ] **Step 5: 替换 App.tsx 用 Router**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/App.tsx`：

```tsx
import { RouterProvider, createRouter } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";

const router = createRouter({ routeTree });

declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router;
  }
}

export function App() {
  return <RouterProvider router={router} />;
}
```

- [ ] **Step 6: 启动 dev，确认 routeTree.gen.ts 自动生成**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm dev &
sleep 8
ls src/routeTree.gen.ts && echo "routeTree.gen.ts generated"
kill %1
```

预期：`src/routeTree.gen.ts` 已存在（TanStack Router 插件自动生成）。

- [ ] **Step 7: 手动浏览器验证（人肉一次）**

打开 http://localhost:5173/，点击导航看 / → /concepts/new → /concepts/some-slug 跳转可工作。

- [ ] **Step 8: type-check**

```bash
pnpm type-check
```

预期：通过。

- [ ] **Step 9: 提交（routeTree.gen.ts 已被 .gitignore 阻止编辑、但需要被 commit 才能 build）**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/App.tsx apps/admin-web/src/routes/
# routeTree.gen.ts 通常生成，需要决定是否 commit。M0 选择 commit（避免 CI 装包后还要生成）
git add -f apps/admin-web/src/routeTree.gen.ts
git commit -m "feat(web): TanStack Router 文件式路由（__root + index + concepts/{new,$slug} placeholders）"
```

**Acceptance**：访问 `/`、`/concepts/new`、`/concepts/some-slug` 全部 OK 渲染；Header Menu 可点击切换路由；type-check 通过。

---

### Task 25: Clerk 登录 + ProtectedRoute

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/.env.example`
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/__root.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/auth/ClerkRouterProvider.tsx`

- [ ] **Step 1: 创建 admin-web .env.example**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/.env.example`：

```env
VITE_CLERK_PUBLISHABLE_KEY=pk_test_REPLACE_ME
VITE_API_BASE_URL=http://localhost:8000
```

- [ ] **Step 2: 让开发者 copy + 填 Clerk key**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
cp .env.example .env
# 编辑 .env，填入 pk_test_xxxxx
```

提示：从 Clerk Dashboard → API Keys 复制 Publishable Key。

- [ ] **Step 3: 创建 ClerkRouterProvider wrapper**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/auth/ClerkRouterProvider.tsx`：

```tsx
import { ClerkProvider } from "@clerk/clerk-react";
import { ReactNode } from "react";

const PUBLISHABLE_KEY = import.meta.env.VITE_CLERK_PUBLISHABLE_KEY;

if (!PUBLISHABLE_KEY) {
  throw new Error(
    "Missing VITE_CLERK_PUBLISHABLE_KEY. " +
      "Copy apps/admin-web/.env.example to .env and fill in Clerk pk_test_*",
  );
}

export function ClerkRouterProvider({ children }: { children: ReactNode }) {
  return <ClerkProvider publishableKey={PUBLISHABLE_KEY}>{children}</ClerkProvider>;
}
```

- [ ] **Step 4: main.tsx 包裹 ClerkRouterProvider**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`：

```tsx
import React from "react";
import ReactDOM from "react-dom/client";
import "./styles.css";
import { App } from "./App";
import { ClerkRouterProvider } from "./auth/ClerkRouterProvider";

const root = document.getElementById("root");
if (!root) {
  throw new Error("Root element not found");
}

ReactDOM.createRoot(root).render(
  <React.StrictMode>
    <ClerkRouterProvider>
      <App />
    </ClerkRouterProvider>
  </React.StrictMode>,
);
```

- [ ] **Step 5: 在 __root.tsx 添加 SignedIn / SignedOut + UserButton**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/__root.tsx`：

```tsx
import { createRootRoute, Outlet, Link } from "@tanstack/react-router";
import { ConfigProvider, App as AntApp, Layout, Typography, Menu, Space } from "antd";
import zhCN from "antd/locale/zh_CN";
import { SignedIn, SignedOut, SignInButton, UserButton } from "@clerk/clerk-react";
import { lightTheme } from "../theme";

const { Header, Content } = Layout;
const { Title } = Typography;

export const Route = createRootRoute({
  component: () => (
    <ConfigProvider theme={lightTheme} locale={zhCN}>
      <AntApp>
        <Layout style={{ minHeight: "100vh" }}>
          <Header
            style={{
              display: "flex",
              alignItems: "center",
              gap: 24,
              padding: "0 24px",
            }}
          >
            <Title level={4} style={{ color: "#fff", margin: 0, whiteSpace: "nowrap" }}>
              tt-cuisine
            </Title>
            <Menu
              theme="dark"
              mode="horizontal"
              selectable={false}
              style={{ flex: 1, minWidth: 0 }}
              items={[
                { key: "list", label: <Link to="/">菜品列表</Link> },
                { key: "new", label: <Link to="/concepts/new">新建菜品</Link> },
              ]}
            />
            <Space>
              <SignedOut>
                <SignInButton mode="modal" />
              </SignedOut>
              <SignedIn>
                <UserButton afterSignOutUrl="/" />
              </SignedIn>
            </Space>
          </Header>
          <Content style={{ padding: "24px" }}>
            <SignedIn>
              <Outlet />
            </SignedIn>
            <SignedOut>
              <div style={{ textAlign: "center", padding: "4rem" }}>
                <Typography.Title level={3}>请先登录</Typography.Title>
                <Typography.Paragraph>
                  tt-cuisine 编辑后台需要登录后访问。点击右上角 "Sign in"。
                </Typography.Paragraph>
              </div>
            </SignedOut>
          </Content>
        </Layout>
      </AntApp>
    </ConfigProvider>
  ),
});
```

- [ ] **Step 6: 启动验证**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm dev
```

打开 http://localhost:5173 ：
- 应看到 "请先登录" 页面
- 点 Header 右上角 "Sign in" 弹出 Clerk modal
- 用 Clerk Dashboard 创建一个测试用户（email + password）登录
- 登录后应看到原路由内容 + Header 右上角 UserButton

⛔ **如果 401 / Clerk 报错**，确认 `.env` 中 `VITE_CLERK_PUBLISHABLE_KEY` 正确。

- [ ] **Step 7: type-check**

```bash
pnpm type-check
```

预期：通过。

- [ ] **Step 8: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/.env.example apps/admin-web/src/main.tsx
git add apps/admin-web/src/routes/__root.tsx apps/admin-web/src/auth/
git commit -m "feat(web): Clerk 登录 + SignedIn/SignedOut 路由保护"
```

**Acceptance**：未登录看到提示页 + Sign in 按钮；点击弹出 Clerk modal；登录后看到 UserButton + 原路由内容；**M0 success criterion 2（admin web 能登录）达成**。

---

### Task 26: API client（axios + Clerk token + TanStack Query）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/client.ts`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/concepts.ts`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/types.ts`
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`（加 QueryClientProvider）

- [ ] **Step 1: 创建 API 类型（与后端 Pydantic 对齐）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/types.ts`：

```typescript
// API 响应 / 请求类型，与 apps/api 的 Pydantic 模型对齐。
// 任何后端 schema 变化都要先更新这里再消费。

export type LanguageCode =
  | "zh-CN"
  | "zh-HK"
  | "zh-TW"
  | "ja-JP"
  | "ko-KR"
  | "en-US"
  | "en-GB";

export type DishNameType =
  | "canonical"
  | "transliteration"
  | "literal"
  | "descriptive"
  | "loanword"
  | "colloquial"
  | "nickname"
  | "misspelling";

export type ConceptStatus = "draft" | "under_review" | "published" | "deprecated";

export interface DishName {
  language: LanguageCode;
  text: string;
  type: DishNameType;
  dialect?: string | null;
  region?: string | null;
  confidence: number;
  source?: string | null;
}

export interface DishConcept {
  id: string;
  slug: string;
  canonical_name: string;
  status: ConceptStatus;
  names: DishName[];
  created_at: string;
  updated_at: string;
  created_by?: string | null;
  updated_by?: string | null;
}

export interface DishConceptCreate {
  slug: string;
  canonical_name: string;
  status: ConceptStatus;
  names: Array<Omit<DishName, "confidence"> & { confidence?: number }>;
}
```

- [ ] **Step 2: 创建 axios client（带 Clerk token 注入）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/client.ts`：

```typescript
import axios, { AxiosInstance } from "axios";

const BASE_URL = import.meta.env.VITE_API_BASE_URL || "http://localhost:8000";

/**
 * 创建一个 axios 实例，绑定一个 token getter。
 *
 * M0 dev mode: token = Clerk user_id（被后端信任为 Bearer subject）。
 * M1 切真 JWT: token = await getToken() (returns RS256 signed JWT)。
 */
export function createApiClient(getToken: () => Promise<string | null>): AxiosInstance {
  const client = axios.create({
    baseURL: BASE_URL,
    timeout: 10_000,
    headers: { "Content-Type": "application/json" },
  });

  client.interceptors.request.use(async (config) => {
    const token = await getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  return client;
}
```

- [ ] **Step 3: 创建 concepts API 函数**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/concepts.ts`：

```typescript
import type { AxiosInstance } from "axios";
import type { DishConcept, DishConceptCreate } from "./types";

export async function listConcepts(
  client: AxiosInstance,
  params: { limit?: number; offset?: number } = {},
): Promise<DishConcept[]> {
  const { data } = await client.get<DishConcept[]>("/api/v1/concepts", { params });
  return data;
}

export async function getConceptBySlug(
  client: AxiosInstance,
  slug: string,
): Promise<DishConcept> {
  const { data } = await client.get<DishConcept>(`/api/v1/concepts/${slug}`);
  return data;
}

export async function createConcept(
  client: AxiosInstance,
  payload: DishConceptCreate,
): Promise<DishConcept> {
  const { data } = await client.post<DishConcept>("/api/v1/concepts", payload);
  return data;
}
```

- [ ] **Step 4: 创建 useApiClient hook（绑定 Clerk + axios）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/api/useApiClient.ts`：

```typescript
import { useAuth } from "@clerk/clerk-react";
import { useMemo } from "react";
import { createApiClient } from "./client";

/**
 * useApiClient
 *
 * Returns an axios instance with a Clerk-aware token injector.
 * M0: 把 Clerk userId 作为 Bearer token（后端 dev mode 信任）。
 * M1: 切到 getToken()（返回真 JWT）。
 */
export function useApiClient() {
  const { userId, isSignedIn } = useAuth();

  return useMemo(() => {
    return createApiClient(async () => {
      // M0: userId 作为 token（后端在 auth.py 信任）
      if (isSignedIn && userId) {
        return userId;
      }
      return null;
    });
  }, [userId, isSignedIn]);
}
```

- [ ] **Step 5: main.tsx 加 QueryClientProvider**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/main.tsx`：

```tsx
import React from "react";
import ReactDOM from "react-dom/client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import "./styles.css";
import { App } from "./App";
import { ClerkRouterProvider } from "./auth/ClerkRouterProvider";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

const root = document.getElementById("root");
if (!root) {
  throw new Error("Root element not found");
}

ReactDOM.createRoot(root).render(
  <React.StrictMode>
    <ClerkRouterProvider>
      <QueryClientProvider client={queryClient}>
        <App />
      </QueryClientProvider>
    </ClerkRouterProvider>
  </React.StrictMode>,
);
```

- [ ] **Step 6: type-check**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm type-check
```

预期：通过。

- [ ] **Step 7: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/api/ apps/admin-web/src/main.tsx
git commit -m "feat(web): API client (axios + Clerk Bearer) + TanStack Query Provider"
```

**Acceptance**：API 类型定义与后端 Pydantic 对齐；useApiClient hook 返回带 token 的 axios；QueryClient 在 root 注入。

---

### Task 27: 菜品列表页（List page）

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/index.tsx`

- [ ] **Step 1: 实现 List page**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/index.tsx`：

```tsx
import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { Table, Tag, Typography, Alert, Spin, Empty, Button, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useApiClient } from "../api/useApiClient";
import { listConcepts } from "../api/concepts";
import type { DishConcept, ConceptStatus } from "../api/types";

const { Title } = Typography;

const STATUS_COLOR: Record<ConceptStatus, string> = {
  draft: "default",
  under_review: "processing",
  published: "success",
  deprecated: "error",
};

function ListPage() {
  const client = useApiClient();
  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: ["concepts"],
    queryFn: () => listConcepts(client, { limit: 50, offset: 0 }),
  });

  const columns: ColumnsType<DishConcept> = [
    {
      title: "Slug",
      dataIndex: "slug",
      key: "slug",
      render: (slug: string) => (
        <Link to="/concepts/$slug" params={{ slug }} style={{ fontFamily: "monospace" }}>
          {slug}
        </Link>
      ),
    },
    {
      title: "规范名",
      dataIndex: "canonical_name",
      key: "canonical_name",
    },
    {
      title: "状态",
      dataIndex: "status",
      key: "status",
      render: (status: ConceptStatus) => <Tag color={STATUS_COLOR[status]}>{status}</Tag>,
    },
    {
      title: "别名数",
      key: "name_count",
      render: (_, record) => record.names.length,
    },
    {
      title: "创建时间",
      dataIndex: "created_at",
      key: "created_at",
      render: (ts: string) => new Date(ts).toLocaleString("zh-CN"),
    },
  ];

  if (isLoading) {
    return (
      <div style={{ textAlign: "center", padding: "4rem" }}>
        <Spin size="large" />
      </div>
    );
  }

  if (isError) {
    return (
      <Alert
        type="error"
        message="加载菜品列表失败"
        description={(error as Error).message}
        action={<Button onClick={() => refetch()}>重试</Button>}
      />
    );
  }

  return (
    <Space direction="vertical" size="middle" style={{ width: "100%" }}>
      <Space style={{ justifyContent: "space-between", width: "100%" }}>
        <Title level={3} style={{ margin: 0 }}>
          菜品列表
        </Title>
        <Link to="/concepts/new">
          <Button type="primary">新建菜品</Button>
        </Link>
      </Space>
      {data && data.length === 0 ? (
        <Empty description="还没有菜品 — 点击 '新建菜品' 创建第一个" />
      ) : (
        <Table
          rowKey="id"
          columns={columns}
          dataSource={data}
          pagination={false}
        />
      )}
    </Space>
  );
}

export const Route = createFileRoute("/")({
  component: ListPage,
});
```

- [ ] **Step 2: 启动验证**

```bash
# 终端 1: API
cd /home/ben/projects/tt-cuisine
export DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine"
uv run --project /home/ben/projects/tt-cuisine uvicorn tt_cuisine_api.main:app --host 0.0.0.0 --port 8000

# 终端 2: web
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm dev
```

浏览器访问 `http://localhost:5173/`：
- 登录后看到 Empty 提示（"还没有菜品 — 点击 '新建菜品' 创建第一个"）
- 上方有 "新建菜品" 按钮（Task 28 实现交互）

- [ ] **Step 3: type-check**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm type-check
```

预期：通过。

- [ ] **Step 4: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/routes/index.tsx
git commit -m "feat(web): 菜品列表页（TanStack Query + AntD Table + 状态 tag）"
```

**Acceptance**：登录后访问 `/` 显示 Empty + 新建按钮；如果 DB 已有数据则显示 AntD Table；slug 可点击跳转（详情页待 Task 29 实现）。

---

### Task 28: 新建菜品页（Create form）

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.new.tsx`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/src/components/DishNameFields.tsx`

- [ ] **Step 1: 创建 DishNameFields（受 AntD Form.List 控制的多语言别名区）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/src/components/DishNameFields.tsx`：

```tsx
import { Form, Input, Select, Button, Space, InputNumber } from "antd";
import { MinusCircleOutlined, PlusOutlined } from "@ant-design/icons";
import type { DishNameType, LanguageCode } from "../api/types";

const LANGUAGE_OPTIONS: { value: LanguageCode; label: string }[] = [
  { value: "zh-CN", label: "简体中文 (zh-CN)" },
  { value: "zh-HK", label: "繁體中文（香港）(zh-HK)" },
  { value: "zh-TW", label: "繁體中文（台灣）(zh-TW)" },
  { value: "ja-JP", label: "日本語 (ja-JP)" },
  { value: "ko-KR", label: "한국어 (ko-KR)" },
  { value: "en-US", label: "English (US)" },
  { value: "en-GB", label: "English (UK)" },
];

const TYPE_OPTIONS: { value: DishNameType; label: string }[] = [
  { value: "canonical", label: "canonical（规范）" },
  { value: "transliteration", label: "transliteration（音译）" },
  { value: "literal", label: "literal（直译）" },
  { value: "descriptive", label: "descriptive（描述性）" },
  { value: "loanword", label: "loanword（外来词）" },
  { value: "colloquial", label: "colloquial（俗称）" },
  { value: "nickname", label: "nickname（别名）" },
  { value: "misspelling", label: "misspelling（错别字）" },
];

export function DishNameFields() {
  return (
    <Form.List
      name="names"
      rules={[
        {
          validator: async (_, names) => {
            if (!names || names.length < 1) {
              return Promise.reject(new Error("至少需要 1 个别名"));
            }
          },
        },
      ]}
    >
      {(fields, { add, remove }, { errors }) => (
        <>
          {fields.map((field) => (
            <Space
              key={field.key}
              align="baseline"
              style={{ display: "flex", marginBottom: 8 }}
              wrap
            >
              <Form.Item
                {...field}
                name={[field.name, "language"]}
                rules={[{ required: true, message: "选择语言" }]}
                style={{ marginBottom: 0, minWidth: 200 }}
              >
                <Select placeholder="语言" options={LANGUAGE_OPTIONS} />
              </Form.Item>
              <Form.Item
                {...field}
                name={[field.name, "text"]}
                rules={[{ required: true, message: "填写别名文本" }]}
                style={{ marginBottom: 0, minWidth: 200 }}
              >
                <Input placeholder="别名文本" />
              </Form.Item>
              <Form.Item
                {...field}
                name={[field.name, "type"]}
                rules={[{ required: true, message: "选择类型" }]}
                style={{ marginBottom: 0, minWidth: 200 }}
              >
                <Select placeholder="类型" options={TYPE_OPTIONS} />
              </Form.Item>
              <Form.Item
                {...field}
                name={[field.name, "confidence"]}
                style={{ marginBottom: 0 }}
              >
                <InputNumber
                  placeholder="置信度"
                  min={0}
                  max={1}
                  step={0.05}
                  style={{ width: 100 }}
                />
              </Form.Item>
              <MinusCircleOutlined onClick={() => remove(field.name)} />
            </Space>
          ))}
          <Form.Item>
            <Button
              type="dashed"
              onClick={() => add({ confidence: 1.0 })}
              icon={<PlusOutlined />}
              style={{ width: "60%" }}
            >
              添加别名
            </Button>
            <Form.ErrorList errors={errors} />
          </Form.Item>
        </>
      )}
    </Form.List>
  );
}
```

- [ ] **Step 2: 实现 Create page**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.new.tsx`：

```tsx
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Form, Input, Button, Select, Typography, Space, App as AntApp } from "antd";
import { useApiClient } from "../api/useApiClient";
import { createConcept } from "../api/concepts";
import { DishNameFields } from "../components/DishNameFields";
import type { ConceptStatus, DishConceptCreate } from "../api/types";

const { Title } = Typography;

const STATUS_OPTIONS: { value: ConceptStatus; label: string }[] = [
  { value: "draft", label: "draft（草稿）" },
  { value: "under_review", label: "under_review（待审）" },
  { value: "published", label: "published（已发布）" },
  { value: "deprecated", label: "deprecated（已弃用）" },
];

function NewConceptPage() {
  const client = useApiClient();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const { message } = AntApp.useApp();
  const [form] = Form.useForm<DishConceptCreate>();

  const mutation = useMutation({
    mutationFn: (payload: DishConceptCreate) => createConcept(client, payload),
    onSuccess: (data) => {
      message.success(`已创建：${data.canonical_name}`);
      queryClient.invalidateQueries({ queryKey: ["concepts"] });
      navigate({ to: "/concepts/$slug", params: { slug: data.slug } });
    },
    onError: (error: Error & { response?: { data?: { detail?: string }; status?: number } }) => {
      const detail = error.response?.data?.detail || error.message;
      const status = error.response?.status;
      if (status === 409) {
        message.error(`slug 已存在：${detail}`);
      } else if (status === 422) {
        message.error(`数据校验失败：${detail}`);
      } else if (status === 401) {
        message.error(`未登录或登录已过期`);
      } else {
        message.error(`创建失败：${detail}`);
      }
    },
  });

  return (
    <Space direction="vertical" size="middle" style={{ width: "100%", maxWidth: 900 }}>
      <Title level={3}>新建菜品</Title>
      <Form
        form={form}
        layout="vertical"
        onFinish={(values) => mutation.mutate(values)}
        initialValues={{
          status: "draft",
          names: [{ language: "zh-CN", text: "", type: "canonical", confidence: 1.0 }],
        }}
      >
        <Form.Item
          label="Slug（latin-lowercase-kebab，如 gong-bao-ji-ding）"
          name="slug"
          rules={[
            { required: true, message: "请填写 slug" },
            {
              pattern: /^[a-z0-9]+(?:-[a-z0-9]+)*$/,
              message: "slug 必须是 latin-lowercase-kebab-case（仅 a-z、0-9 与连字符）",
            },
          ]}
        >
          <Input placeholder="e.g. gong-bao-ji-ding" />
        </Form.Item>

        <Form.Item
          label="规范名（主语种）"
          name="canonical_name"
          rules={[{ required: true, message: "请填写规范名" }]}
        >
          <Input placeholder="e.g. 宫保鸡丁" />
        </Form.Item>

        <Form.Item
          label="状态"
          name="status"
          rules={[{ required: true }]}
        >
          <Select options={STATUS_OPTIONS} />
        </Form.Item>

        <Title level={5}>多语言别名（至少 1 个）</Title>
        <DishNameFields />

        <Form.Item>
          <Button type="primary" htmlType="submit" loading={mutation.isPending}>
            创建
          </Button>
        </Form.Item>
      </Form>
    </Space>
  );
}

export const Route = createFileRoute("/concepts/new")({
  component: NewConceptPage,
});
```

- [ ] **Step 3: 手动验证 M0 demo 数据**

启动 API + web，登录后访问 `/concepts/new`：
- 填表：
  - slug: `gong-bao-ji-ding`
  - canonical_name: `宫保鸡丁`
  - status: `published`
  - names（点 "添加别名" 至 5 条）：
    - `zh-CN / 宫保鸡丁 / canonical / 1.0`
    - `zh-HK / 宮保雞丁 / canonical / 1.0`
    - `en-US / Kung Pao Chicken / transliteration / 1.0`
    - `ja-JP / 宮保鶏丁 / transliteration / 1.0`
    - `ko-KR / 궁보계정 / transliteration / 1.0`
- 点 "创建"
- 应跳到 `/concepts/gong-bao-ji-ding` 并显示成功 message

如果 DB 已有同 slug，应看到红色 `slug 已存在` 提示。

- [ ] **Step 4: type-check**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm type-check
```

预期：通过。

- [ ] **Step 5: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/routes/concepts.new.tsx apps/admin-web/src/components/
git commit -m "feat(web): 新建菜品页（含多语言别名 Form.List + 错误处理）"
```

**Acceptance**：在 admin web 完整走通 "登录 → 新建 → 5 语别名 → 创建"；后端 DB 出现一条 `gong-bao-ji-ding` 记录；**M0 success criterion 2（创建宫保鸡丁含 5 语别名）达成**。

---

### Task 29: 菜品详情页（View by slug）

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.$slug.tsx`

- [ ] **Step 1: 实现详情页**

替换 `/home/ben/projects/tt-cuisine/apps/admin-web/src/routes/concepts.$slug.tsx`：

```tsx
import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import {
  Descriptions,
  Typography,
  Tag,
  Table,
  Alert,
  Spin,
  Space,
  Button,
  Result,
} from "antd";
import type { ColumnsType } from "antd/es/table";
import { useApiClient } from "../api/useApiClient";
import { getConceptBySlug } from "../api/concepts";
import type { DishName, ConceptStatus } from "../api/types";

const { Title } = Typography;

const STATUS_COLOR: Record<ConceptStatus, string> = {
  draft: "default",
  under_review: "processing",
  published: "success",
  deprecated: "error",
};

function ConceptDetailPage() {
  const { slug } = Route.useParams();
  const client = useApiClient();

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ["concept", slug],
    queryFn: () => getConceptBySlug(client, slug),
    retry: (failureCount, err) => {
      const status = (err as { response?: { status?: number } }).response?.status;
      if (status === 404) return false;
      return failureCount < 1;
    },
  });

  if (isLoading) {
    return (
      <div style={{ textAlign: "center", padding: "4rem" }}>
        <Spin size="large" />
      </div>
    );
  }

  if (isError) {
    const status = (error as { response?: { status?: number } }).response?.status;
    if (status === 404) {
      return (
        <Result
          status="404"
          title="404"
          subTitle={`没有找到 slug 为 "${slug}" 的菜品`}
          extra={
            <Link to="/">
              <Button type="primary">返回列表</Button>
            </Link>
          }
        />
      );
    }
    return (
      <Alert
        type="error"
        message="加载失败"
        description={(error as Error).message}
      />
    );
  }

  if (!data) {
    return null;
  }

  const nameColumns: ColumnsType<DishName> = [
    { title: "语言", dataIndex: "language", key: "language", width: 100 },
    { title: "文本", dataIndex: "text", key: "text" },
    { title: "类型", dataIndex: "type", key: "type", width: 160 },
    {
      title: "方言",
      dataIndex: "dialect",
      key: "dialect",
      width: 100,
      render: (v?: string | null) => v || "—",
    },
    {
      title: "地区",
      dataIndex: "region",
      key: "region",
      width: 100,
      render: (v?: string | null) => v || "—",
    },
    {
      title: "置信度",
      dataIndex: "confidence",
      key: "confidence",
      width: 90,
      render: (v: number) => v.toFixed(2),
    },
    {
      title: "来源",
      dataIndex: "source",
      key: "source",
      render: (v?: string | null) => v || "—",
    },
  ];

  return (
    <Space direction="vertical" size="middle" style={{ width: "100%" }}>
      <Space style={{ justifyContent: "space-between", width: "100%" }}>
        <Title level={3} style={{ margin: 0 }}>
          {data.canonical_name}
        </Title>
        <Link to="/">
          <Button>返回列表</Button>
        </Link>
      </Space>
      <Descriptions bordered column={2} size="small">
        <Descriptions.Item label="Slug">
          <code>{data.slug}</code>
        </Descriptions.Item>
        <Descriptions.Item label="ID">
          <code style={{ fontSize: 12 }}>{data.id}</code>
        </Descriptions.Item>
        <Descriptions.Item label="规范名">{data.canonical_name}</Descriptions.Item>
        <Descriptions.Item label="状态">
          <Tag color={STATUS_COLOR[data.status]}>{data.status}</Tag>
        </Descriptions.Item>
        <Descriptions.Item label="创建时间">
          {new Date(data.created_at).toLocaleString("zh-CN")}
        </Descriptions.Item>
        <Descriptions.Item label="更新时间">
          {new Date(data.updated_at).toLocaleString("zh-CN")}
        </Descriptions.Item>
        <Descriptions.Item label="创建者">{data.created_by || "—"}</Descriptions.Item>
        <Descriptions.Item label="更新者">{data.updated_by || "—"}</Descriptions.Item>
      </Descriptions>
      <Title level={4}>多语言别名（{data.names.length}）</Title>
      <Table
        rowKey={(r) => `${r.language}-${r.text}-${r.region ?? ""}`}
        columns={nameColumns}
        dataSource={data.names}
        pagination={false}
      />
    </Space>
  );
}

export const Route = createFileRoute("/concepts/$slug")({
  component: ConceptDetailPage,
});
```

- [ ] **Step 2: 手动验证 M0 完整路径**

确保 API + web 都跑起来，登录后：
1. 访问 `/`（列表，看到刚创建的 `gong-bao-ji-ding`）
2. 点击 slug 链接 → 跳 `/concepts/gong-bao-ji-ding`
3. 看到 Descriptions（ID/Slug/规范名/状态/时间）+ 多语言别名 Table（5 行）
4. 访问 `/concepts/not-exist` → 看到 404 Result + 返回列表按钮

同时 curl 验证 M0 success criterion 3:

```bash
curl -s http://localhost:8000/api/v1/concepts/gong-bao-ji-ding | python3 -m json.tool
```

预期：完整 JSON 含 5 个 names。

- [ ] **Step 3: type-check**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm type-check
```

预期：通过。

- [ ] **Step 4: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/src/routes/concepts.$slug.tsx
git commit -m "feat(web): 菜品详情页（Descriptions + 别名 Table + 404 处理）"
```

**Acceptance**：详情页正确渲染所有字段；404 用 AntD Result 优雅显示；**M0 success criterion 3（curl 返回 JSON）达成**——前端端到端流转完整。

---

## Phase 6 · Docker Compose 全栈 + Playwright E2E

### Task 30: API Dockerfile

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/api/Dockerfile`
- Create: `/home/ben/projects/tt-cuisine/apps/api/.dockerignore`

- [ ] **Step 1: 创建 API Dockerfile（multi-stage，uv-based）**

写入 `/home/ben/projects/tt-cuisine/apps/api/Dockerfile`：

```dockerfile
# syntax=docker/dockerfile:1.7

# ----- Builder stage -----
FROM python:3.12-slim AS builder

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.5 /uv /uvx /bin/

WORKDIR /app

# Copy workspace root files first for better cache
COPY pyproject.toml uv.lock /app/
COPY packages/domain /app/packages/domain
COPY apps/api/pyproject.toml /app/apps/api/pyproject.toml

# Pre-install deps (no source yet)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --package tt-cuisine-api

# Now copy api source
COPY apps/api /app/apps/api

# Install api itself (editable not needed in container)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --package tt-cuisine-api

# ----- Runtime stage -----
FROM python:3.12-slim AS runtime

# OS deps for asyncpg (libpq) — usually not needed since asyncpg ships its own,
# but keep ca-certificates for HTTPS calls to Clerk JWKS
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the resolved venv from builder
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Copy app source (needed because we import tt_cuisine_api.main)
COPY apps/api/src /app/apps/api/src
COPY packages/domain/src /app/packages/domain/src

# Non-root user
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

EXPOSE 8000

CMD ["uvicorn", "tt_cuisine_api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

- [ ] **Step 2: 创建 .dockerignore**

写入 `/home/ben/projects/tt-cuisine/apps/api/.dockerignore`：

```
__pycache__
*.pyc
*.pyo
.pytest_cache
.mypy_cache
.ruff_cache
.venv
venv
tests
```

- [ ] **Step 3: 本地 build 验证**

```bash
cd /home/ben/projects/tt-cuisine
docker build -f apps/api/Dockerfile -t tt-cuisine-api:m0 .
```

预期：build 成功，输出 `tt-cuisine-api:m0` image。

- [ ] **Step 4: smoke test container**

```bash
docker network create tt-cuisine-test 2>/dev/null || true
docker run --rm -d --name api-smoke \
  --network host \
  -e DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine" \
  -e API_CORS_ORIGINS="http://localhost:5173" \
  -e API_LOG_LEVEL=INFO \
  tt-cuisine-api:m0
sleep 3
curl -s -w "\n%{http_code}\n" http://localhost:8000/api/v1/health
docker stop api-smoke
```

预期：`200`；JSON 含 `"status":"ok"`。

- [ ] **Step 5: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/api/Dockerfile apps/api/.dockerignore
git commit -m "feat(ops): API Dockerfile (uv multi-stage, non-root, python:3.12-slim)"
```

**Acceptance**：image build < 200MB（多数为 python:3.12-slim 基础）；container 启动后 health endpoint 可用；非 root user 运行。

---

### Task 31: admin-web Dockerfile + nginx serve

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/Dockerfile`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/nginx.conf`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/.dockerignore`

- [ ] **Step 1: 创建 nginx.conf**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/nginx.conf`：

```nginx
server {
    listen 8080;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    # SPA fallback
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets aggressively (Vite hashes filenames)
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Health check
    location = /healthz {
        access_log off;
        return 200 "ok\n";
    }

    # Proxy API to backend service (in docker compose, host = `api`)
    location /api/ {
        proxy_pass http://api:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- [ ] **Step 2: 创建 Dockerfile（multi-stage：node build → nginx serve）**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/Dockerfile`：

```dockerfile
# syntax=docker/dockerfile:1.7

# ----- Builder stage -----
FROM node:20-alpine AS builder

RUN corepack enable && corepack prepare pnpm@9 --activate

WORKDIR /app

COPY apps/admin-web/package.json apps/admin-web/pnpm-lock.yaml* /app/
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile

COPY apps/admin-web /app/

# Vite env vars need to be set at build time
ARG VITE_CLERK_PUBLISHABLE_KEY
ARG VITE_API_BASE_URL=""
ENV VITE_CLERK_PUBLISHABLE_KEY=${VITE_CLERK_PUBLISHABLE_KEY}
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN pnpm build

# ----- Runtime stage: nginx serves dist/ -----
FROM nginx:1.27-alpine AS runtime

COPY --from=builder /app/dist /usr/share/nginx/html
COPY apps/admin-web/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
```

- [ ] **Step 3: 创建 .dockerignore**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/.dockerignore`：

```
node_modules
dist
.vite
playwright-report
test-results
tests/e2e
```

- [ ] **Step 4: 本地 build 验证**

```bash
cd /home/ben/projects/tt-cuisine
docker build \
  --build-arg VITE_CLERK_PUBLISHABLE_KEY="pk_test_DUMMY" \
  --build-arg VITE_API_BASE_URL="" \
  -f apps/admin-web/Dockerfile \
  -t tt-cuisine-web:m0 .
```

预期：build 成功。

- [ ] **Step 5: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/Dockerfile apps/admin-web/.dockerignore apps/admin-web/nginx.conf
git commit -m "feat(ops): admin-web Dockerfile (Vite build → nginx serve + API proxy)"
```

**Acceptance**：image build 成功；nginx 内嵌 SPA fallback + /api 反向代理到 `api:8000`（compose 内部 hostname）。

---

### Task 32: docker-compose.yml 完整版（PG + API + web）

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/ops/compose/docker-compose.yml`
- Create: `/home/ben/projects/tt-cuisine/ops/compose/Makefile.fragment.md`（说明用，不实际 include）

- [ ] **Step 1: 完整 compose**

替换 `/home/ben/projects/tt-cuisine/ops/compose/docker-compose.yml`：

```yaml
name: tt-cuisine

services:
  postgres:
    image: pgvector/pgvector:pg16
    container_name: ttcuisine-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-ttcuisine}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-devpassword_change_in_prod}
      POSTGRES_DB: ${POSTGRES_DB:-tt_cuisine}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres-init.sql:/docker-entrypoint-initdb.d/01-init.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-ttcuisine} -d ${POSTGRES_DB:-tt_cuisine}"]
      interval: 5s
      timeout: 5s
      retries: 10

  migrations:
    image: tt-cuisine-api:m0
    container_name: ttcuisine-migrations
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      DATABASE_URL: postgresql+asyncpg://${POSTGRES_USER:-ttcuisine}:${POSTGRES_PASSWORD:-devpassword_change_in_prod}@postgres:5432/${POSTGRES_DB:-tt_cuisine}
    working_dir: /app/ops/migrations
    volumes:
      - ../migrations:/app/ops/migrations:ro
    command: ["alembic", "upgrade", "head"]
    # 一次性运行；compose up 时自动跑 + exit
    restart: "no"

  api:
    image: tt-cuisine-api:m0
    container_name: ttcuisine-api
    depends_on:
      postgres:
        condition: service_healthy
      migrations:
        condition: service_completed_successfully
    environment:
      DATABASE_URL: postgresql+asyncpg://${POSTGRES_USER:-ttcuisine}:${POSTGRES_PASSWORD:-devpassword_change_in_prod}@postgres:5432/${POSTGRES_DB:-tt_cuisine}
      API_HOST: 0.0.0.0
      API_PORT: 8000
      API_LOG_LEVEL: ${API_LOG_LEVEL:-INFO}
      API_CORS_ORIGINS: "http://localhost:5173,http://localhost:8080"
      CLERK_SECRET_KEY: ${CLERK_SECRET_KEY:-}
      CLERK_JWKS_URL: ${CLERK_JWKS_URL:-}
      CLERK_ISSUER: ${CLERK_ISSUER:-}
    ports:
      - "${API_PORT:-8000}:8000"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/api/v1/health').read()"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 10s

  web:
    image: tt-cuisine-web:m0
    container_name: ttcuisine-web
    depends_on:
      api:
        condition: service_healthy
    ports:
      - "${WEB_PORT:-8080}:8080"
    restart: unless-stopped

volumes:
  postgres-data:
    name: ttcuisine-postgres-data
```

- [ ] **Step 2: 更新 .env.example**

替换 `/home/ben/projects/tt-cuisine/ops/compose/.env.example`：

```env
POSTGRES_USER=ttcuisine
POSTGRES_PASSWORD=devpassword_change_in_prod
POSTGRES_DB=tt_cuisine
POSTGRES_PORT=5432
API_PORT=8000
WEB_PORT=8080
API_LOG_LEVEL=INFO

# Clerk
CLERK_SECRET_KEY=sk_test_REPLACE_ME
CLERK_JWKS_URL=https://YOUR_APP.clerk.accounts.dev/.well-known/jwks.json
CLERK_ISSUER=https://YOUR_APP.clerk.accounts.dev
```

- [ ] **Step 3: 修复 migrations service 的体积挂载（确保 alembic.ini 与 versions 都可见）**

migrations service 现在挂的是 `../migrations`（ops/migrations），但 API image 里没有 alembic.ini 与 versions/。换个 strategy：让 API image 包含 alembic 资产。

修改 `apps/api/Dockerfile` 的 runtime stage（在 `COPY apps/api/src ...` 之后追加）：

```dockerfile
# Migrations (for the dedicated `migrations` compose service)
COPY ops/migrations /app/ops/migrations
```

重新 build：

```bash
cd /home/ben/projects/tt-cuisine
docker build -f apps/api/Dockerfile -t tt-cuisine-api:m0 .
```

并把 compose 的 migrations service 的 volumes 段**删除**（不再需要外挂），workdir 保留：

```yaml
  migrations:
    image: tt-cuisine-api:m0
    container_name: ttcuisine-migrations
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      DATABASE_URL: postgresql+asyncpg://${POSTGRES_USER:-ttcuisine}:${POSTGRES_PASSWORD:-devpassword_change_in_prod}@postgres:5432/${POSTGRES_DB:-tt_cuisine}
    working_dir: /app/ops/migrations
    command: ["alembic", "upgrade", "head"]
    restart: "no"
```

- [ ] **Step 4: 全栈起动验证**

```bash
cd /home/ben/projects/tt-cuisine
docker build -f apps/api/Dockerfile -t tt-cuisine-api:m0 .
docker build \
  --build-arg VITE_CLERK_PUBLISHABLE_KEY="$(grep VITE_CLERK_PUBLISHABLE_KEY apps/admin-web/.env | cut -d= -f2)" \
  --build-arg VITE_API_BASE_URL="" \
  -f apps/admin-web/Dockerfile \
  -t tt-cuisine-web:m0 .

cd ops/compose
docker compose down -v  # 清旧数据
docker compose up -d
sleep 15
docker compose ps
docker compose logs migrations | tail -20
curl -s http://localhost:8000/api/v1/health
echo ""
curl -s -o /dev/null -w "web: %{http_code}\n" http://localhost:8080/
```

预期：
- `migrations` 完成（State: Exited 0；logs 含 `Running upgrade -> 0001`）
- `api` healthy
- `web` running
- health endpoint 返回 ok
- web 返回 200

- [ ] **Step 5: 手动验证端到端**

打开 http://localhost:8080 → Clerk 登录 → 进入 admin web → 列表 / 新建 / 查看 完整跑通。

⛔ 若 web 调 API 失败（CORS / proxy 错误），看 nginx 是否能解析 `api:8000`。可以 `docker compose exec web sh -c "wget -qO- http://api:8000/api/v1/health"` 验证容器间网络。

- [ ] **Step 6: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add ops/compose/docker-compose.yml ops/compose/.env.example apps/api/Dockerfile
git commit -m "feat(ops): 完整 docker compose (PG + migrations + API + web) 全栈起动"
```

**Acceptance**：`docker compose up -d` 后 4 个 service 协调启动（migrations 跑完才起 API，API healthy 才起 web）；浏览器 http://localhost:8080 完整功能跑通；**M0 success criterion 1（docker compose up 后 admin web 能登录）达成**。

---

### Task 33: Playwright E2E（创建+查看完整路径）

**Files:**
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/playwright.config.ts`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/tests/e2e/create-concept.spec.ts`
- Create: `/home/ben/projects/tt-cuisine/apps/admin-web/tests/e2e/.env.test.example`

- [ ] **Step 1: 创建 playwright.config.ts**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/playwright.config.ts`：

```typescript
import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  timeout: 30_000,
  expect: { timeout: 5_000 },
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: process.env.CI ? "github" : "list",
  use: {
    baseURL: process.env.E2E_BASE_URL || "http://localhost:8080",
    trace: "on-first-retry",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],
});
```

- [ ] **Step 2: 安装 Playwright browser**

```bash
cd /home/ben/projects/tt-cuisine/apps/admin-web
pnpm exec playwright install chromium
```

- [ ] **Step 3: 创建 E2E 测试**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/tests/e2e/create-concept.spec.ts`：

```typescript
import { test, expect } from "@playwright/test";

/**
 * M0 端到端 happy path：
 * - 假设 docker compose 已起，PG 已清空 (TRUNCATE wiki_core.concepts CASCADE)
 * - 使用 Clerk 测试用户登录
 * - 创建宫保鸡丁含 5 语别名
 * - 跳到详情页验证全部别名
 * - List 页应能看到这条
 *
 * 要求环境变量:
 *   E2E_BASE_URL          (default http://localhost:8080)
 *   E2E_CLERK_EMAIL       Clerk 测试用户邮箱
 *   E2E_CLERK_PASSWORD    Clerk 测试用户密码
 */

const EMAIL = process.env.E2E_CLERK_EMAIL || "";
const PASSWORD = process.env.E2E_CLERK_PASSWORD || "";

test.skip(!EMAIL || !PASSWORD, "E2E_CLERK_EMAIL/PASSWORD env vars are required");

test("登录 → 创建宫保鸡丁含5语 → 详情页验证", async ({ page }) => {
  await page.goto("/");

  // 1. 登录
  await expect(page.getByRole("heading", { name: /请先登录/ })).toBeVisible();
  await page.getByRole("button", { name: /Sign in/i }).click();

  // Clerk modal 中填邮箱密码
  await page.getByLabel(/email/i).fill(EMAIL);
  await page.getByRole("button", { name: /continue/i }).click();
  await page.getByLabel(/password/i).fill(PASSWORD);
  await page.getByRole("button", { name: /continue/i }).click();

  // 等待 Clerk modal 关闭，导航出现菜品列表
  await expect(page.getByRole("heading", { name: "菜品列表" })).toBeVisible({ timeout: 15_000 });

  // 2. 进入新建页
  await page.getByRole("link", { name: "新建菜品" }).first().click();
  await expect(page.getByRole("heading", { name: "新建菜品" })).toBeVisible();

  // 3. 填写 slug + 规范名
  await page.getByLabel(/Slug/).fill("gong-bao-ji-ding");
  await page.getByLabel(/规范名/).fill("宫保鸡丁");

  // 状态选择 published
  await page.getByLabel(/状态/).click();
  await page.getByRole("option", { name: /published/ }).click();

  // 4. 填写 5 个别名（默认有 1 个空行）
  const dishes = [
    { lang: "zh-CN", text: "宫保鸡丁", type: "canonical" },
    { lang: "zh-HK", text: "宮保雞丁", type: "canonical" },
    { lang: "en-US", text: "Kung Pao Chicken", type: "transliteration" },
    { lang: "ja-JP", text: "宮保鶏丁", type: "transliteration" },
    { lang: "ko-KR", text: "궁보계정", type: "transliteration" },
  ];

  for (let i = 0; i < dishes.length; i++) {
    if (i > 0) {
      await page.getByRole("button", { name: /添加别名/ }).click();
    }
    const row = page.locator(".ant-space").nth(i + 1); // 跳过 header row
    await row.locator(".ant-select").nth(0).click();
    await page.getByRole("option", { name: new RegExp(dishes[i].lang) }).click();
    await row.locator("input.ant-input").fill(dishes[i].text);
    await row.locator(".ant-select").nth(1).click();
    await page.getByRole("option", { name: new RegExp(dishes[i].type) }).click();
  }

  // 5. 提交
  await page.getByRole("button", { name: "创建" }).click();

  // 6. 跳转到详情页
  await expect(page).toHaveURL(/\/concepts\/gong-bao-ji-ding$/);
  await expect(page.getByRole("heading", { name: "宫保鸡丁" })).toBeVisible();

  // 7. 验证 5 个别名都在详情 Table
  for (const dish of dishes) {
    await expect(page.getByText(dish.text)).toBeVisible();
  }

  // 8. 返回列表，看到新创建的
  await page.getByRole("button", { name: "返回列表" }).click();
  await expect(page.getByRole("link", { name: "gong-bao-ji-ding" })).toBeVisible();
});
```

- [ ] **Step 4: 创建 E2E 环境变量示例**

写入 `/home/ben/projects/tt-cuisine/apps/admin-web/tests/e2e/.env.test.example`：

```env
E2E_BASE_URL=http://localhost:8080
E2E_CLERK_EMAIL=test+m0@example.com
E2E_CLERK_PASSWORD=YOUR_TEST_PASSWORD
```

并指导：开发者在 Clerk Dashboard 手动创建一个测试用户 `test+m0@example.com`，记录密码，然后：

```bash
cp tests/e2e/.env.test.example tests/e2e/.env.test
# 编辑 .env.test 填入真实测试用户邮箱/密码
```

- [ ] **Step 5: 跑 E2E**

```bash
cd /home/ben/projects/tt-cuisine

# 清空 DB
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "TRUNCATE wiki_core.concepts CASCADE"

# 跑 E2E
cd apps/admin-web
set -a; source tests/e2e/.env.test; set +a
pnpm exec playwright test
```

预期：1 test passed。如果失败，playwright 会生成 `test-results/` 含 screenshot + video，可用作诊断。

- [ ] **Step 6: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add apps/admin-web/playwright.config.ts apps/admin-web/tests/e2e/
git commit -m "test(web): Playwright E2E (login + 5-language dish create + detail verify)"
```

**Acceptance**：E2E test 通过；test-results/ 可作为失败时的诊断证据；**M0 Exit criterion（1 个 Playwright E2E 通过）达成**。

---

## Phase 7 · CI

### Task 34: GitHub Actions workflow

**Files:**
- Create: `/home/ben/projects/tt-cuisine/.github/workflows/ci.yml`

- [ ] **Step 1: 创建 CI workflow**

写入 `/home/ben/projects/tt-cuisine/.github/workflows/ci.yml`：

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  python:
    name: Python (ruff + mypy + pytest)
    runs-on: ubuntu-latest

    services:
      postgres:
        image: pgvector/pgvector:pg16
        env:
          POSTGRES_USER: ttcuisine
          POSTGRES_PASSWORD: devpassword_change_in_prod
          POSTGRES_DB: tt_cuisine
        ports:
          - 5432:5432
        options: >-
          --health-cmd "pg_isready -U ttcuisine -d tt_cuisine"
          --health-interval 5s
          --health-timeout 5s
          --health-retries 10

    env:
      DATABASE_URL: postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine

    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v3
        with:
          version: "0.5.x"
          enable-cache: true

      - name: Set up Python
        run: uv python install 3.12

      - name: Install dependencies
        run: uv sync --all-packages

      - name: Initialize PG (extensions + schemas)
        run: |
          psql "$DATABASE_URL_SYNC" -f ops/compose/postgres-init.sql
        env:
          DATABASE_URL_SYNC: postgresql://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine
          PGPASSWORD: devpassword_change_in_prod

      - name: Run alembic upgrade
        working-directory: ops/migrations
        run: uv run --project ${{ github.workspace }} alembic upgrade head

      - name: Ruff format check
        run: uv run ruff format --check .

      - name: Ruff lint
        run: uv run ruff check .

      - name: Mypy
        run: uv run mypy apps/api packages/domain

      - name: Pytest (domain + api)
        run: uv run pytest apps/api/tests packages/domain/tests -v

  web:
    name: Web (eslint + tsc + vitest + build)
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: pnpm/action-setup@v4
        with:
          version: 9

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm
          cache-dependency-path: apps/admin-web/pnpm-lock.yaml

      - name: Install web deps
        working-directory: apps/admin-web
        run: pnpm install --frozen-lockfile

      - name: Type-check
        working-directory: apps/admin-web
        run: pnpm type-check

      - name: Vitest
        working-directory: apps/admin-web
        run: pnpm test
        if: false  # M0 no unit tests for web; reserved for M1

      - name: Build
        working-directory: apps/admin-web
        env:
          VITE_CLERK_PUBLISHABLE_KEY: pk_test_DUMMY_FOR_BUILD_CHECK
        run: pnpm build

  docker:
    name: Docker images build
    runs-on: ubuntu-latest
    needs: [python, web]
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build API image
        uses: docker/build-push-action@v6
        with:
          context: .
          file: apps/api/Dockerfile
          push: false
          tags: tt-cuisine-api:ci
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build web image
        uses: docker/build-push-action@v6
        with:
          context: .
          file: apps/admin-web/Dockerfile
          push: false
          tags: tt-cuisine-web:ci
          build-args: |
            VITE_CLERK_PUBLISHABLE_KEY=pk_test_DUMMY
            VITE_API_BASE_URL=
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**说明**：
- E2E（Playwright）暂不在 CI 跑，因为需要真 Clerk 测试账号 + 完整 docker compose stack。M1 加 e2e job（要么 mock Clerk，要么用 Clerk test mode）。
- vitest job 暂禁用（`if: false`）——M0 admin-web 无前端单测；M1 加。

- [ ] **Step 2: 本地预跑 CI 步骤（确认在 push 前不会红）**

```bash
cd /home/ben/projects/tt-cuisine

# Python
uv run ruff format --check .
uv run ruff check .
uv run mypy apps/api packages/domain
DATABASE_URL="postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine" \
  uv run pytest apps/api/tests packages/domain/tests -v

# Web
cd apps/admin-web
pnpm type-check
VITE_CLERK_PUBLISHABLE_KEY=pk_test_DUMMY pnpm build
```

预期：每一步都 pass。**M0 success criterion 4（CI 全绿）的本地预演**。

- [ ] **Step 3: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add .github/workflows/ci.yml
git commit -m "ci: GitHub Actions (ruff + mypy + pytest + web build + docker images)"
```

**Acceptance**：CI workflow 文件就绪；本地预跑全部步骤 pass；推到 GitHub 后能跑（实际验证留给 push 后）。

---

## Phase 8 · 收尾

### Task 35: 完整 README + 启动文档

**Files:**
- Modify: `/home/ben/projects/tt-cuisine/README.md`
- Create: `/home/ben/projects/tt-cuisine/docs/getting-started.md`

- [ ] **Step 1: 替换 README.md 为完整版**

替换 `/home/ben/projects/tt-cuisine/README.md`：

```markdown
# tt-cuisine

> 全球餐饮业的多语言结构化菜品知识资产。
>
> **Status**: M0 development. Not production-ready.

## 这是什么

tt-cuisine 是一个面向全球餐饮业的、多语言结构化的菜品知识资产平台。
长期愿景是三件互相独立的产品：

- **A · 菜品维基**（first battlefield）— 结构化 DishConcept 知识库，对外提供 read-only API + 整库授权
- **B · 菜单本地化服务**（M3+）— 餐厅菜单的"机翻初稿 + 人审 + 交付"工作流
- **C · 菜品翻译引擎**（M3+）— 菜单语料微调的 LLM/Agent

完整设计文档与决策溯源：[`docs/specs/2026-05-21-dish-corpus-redesign-design.md`](docs/specs/2026-05-21-dish-corpus-redesign-design.md)。

## 当前状态 · M0 地基

M0 实现"Hello, DishConcept"最小端到端闭环：
- ✅ admin web 登录后可创建一个含 5 语别名的 DishConcept
- ✅ Public API `GET /api/v1/concepts/{slug}` 返回该 concept JSON
- ✅ `docker compose up` 全栈跑通
- ✅ CI 全绿（ruff + mypy + pytest + tsc + image build）

M0 完成判据见实施计划：[`docs/superpowers/plans/...`](.)（本仓首版）。

## 技术栈

| 层 | 技术 |
|---|---|
| 后端语言 | Python 3.12 (strict typed) |
| Web 框架 | FastAPI + Uvicorn (ASGI) |
| 任务队列 | Dramatiq + Redis（M1+） |
| ORM / 迁移 | SQLAlchemy 2.0 (async) + Alembic |
| 数据库 | PostgreSQL 16 + pgvector + pg_trgm + unaccent |
| 搜索 | Meilisearch（M1+） |
| LLM 网关 | LiteLLM（M1+） |
| 前端 | React 18 + Vite + TypeScript + Ant Design 5 + TanStack Router/Query + Zustand |
| Auth | Clerk |
| 部署 | Docker Compose (M0-M2) → K8s + Helm (M3+) |
| CI | GitHub Actions |

## 仓库结构

```
tt-cuisine/
├── apps/
│   ├── api/         FastAPI Read Service
│   └── admin-web/   React admin (Vite + AntD)
├── packages/
│   └── domain/      Pydantic 领域模型（纯，无 I/O）
├── ops/
│   ├── compose/     Docker Compose + PG init
│   └── migrations/  Alembic
├── docs/
│   └── specs/       设计文档
└── .github/
    └── workflows/   CI
```

## 快速开始

详细步骤见 [`docs/getting-started.md`](docs/getting-started.md)。最简版：

```bash
# 1. 装依赖
make install

# 2. 配置环境变量
cp .env.example .env
cp ops/compose/.env.example ops/compose/.env
cp apps/admin-web/.env.example apps/admin-web/.env
# 编辑这三个 .env，填入 Clerk pk_test_/sk_test_ 等

# 3. 起基础设施（PG）
cd ops/compose && docker compose up -d postgres
cd ../..

# 4. 跑迁移
make db-migrate

# 5. 开发模式（双终端）
make api-dev      # 终端 1: API @ :8000
make web-dev      # 终端 2: web @ :5173

# 浏览器: http://localhost:5173
```

或一键全栈（生产形态）：

```bash
make compose-build  # build 两个 Docker images
make compose-up     # 起 4 个 service
# 浏览器: http://localhost:8080
```

## 开发命令

| 命令 | 作用 |
|---|---|
| `make install` | 装所有依赖（Python uv + Node pnpm） |
| `make fmt` | 格式化（ruff format + prettier） |
| `make lint` | lint（ruff check + eslint） |
| `make type` | 类型检查（mypy + tsc） |
| `make test` | 跑所有测试 |
| `make test-api` / `make test-domain` | 跑指定 suite |
| `make api-dev` / `make web-dev` | dev mode |
| `make db-migrate` | 跑 alembic upgrade head |
| `make e2e` | 跑 Playwright E2E |
| `make compose-up` / `compose-down` / `compose-build` | docker compose 操作 |

## 贡献

M0 阶段是单人/小团队驱动；M1+ 招编辑团队。

代码风格：
- Python: `ruff` (format + check) + `mypy strict`
- TS: `eslint` + `tsc strict` + Prettier
- Commit message: 中文 + conventional prefixes（`feat:` / `fix:` / `chore:` / `docs:` / `test:` / `ci:` / `refactor:`）

## License

Apache License 2.0 — 见 [LICENSE](LICENSE)。
```

- [ ] **Step 2: 创建详细 getting-started 文档**

写入 `/home/ben/projects/tt-cuisine/docs/getting-started.md`：

```markdown
# Getting Started · tt-cuisine M0

本文档假设你是从零开始 onboard 这个项目的新成员。

## 前置条件

1. **工具链**
   - `uv >= 0.5` ([install](https://github.com/astral-sh/uv))
   - `Node.js >= 20`（推荐 nvm）
   - `pnpm >= 9`（`npm i -g pnpm`）
   - Docker + Docker Compose v2
   - PostgreSQL client (`psql`)，用于偶尔的手动检查

2. **Clerk 账号**
   - 访问 https://clerk.com 注册
   - 创建一个 development app
   - 记下：
     - `Publishable Key` (pk_test_*) → 给前端
     - `Secret Key` (sk_test_*) → 给后端（M1 用，M0 可以填占位）
     - `JWKS URL` → 通常 `https://YOUR_APP.clerk.accounts.dev/.well-known/jwks.json`
   - 创建一个测试用户（用真实 email + password），用于登录测试

## 安装

```bash
git clone <repo-url> tt-cuisine
cd tt-cuisine
make install
```

## 配置环境变量

复制 3 份 .env 模板并填值：

```bash
cp .env.example .env
cp ops/compose/.env.example ops/compose/.env
cp apps/admin-web/.env.example apps/admin-web/.env
```

**关键变量**：

| 文件 | 变量 | 说明 |
|---|---|---|
| `.env` | `DATABASE_URL` | `postgresql+asyncpg://ttcuisine:devpassword_change_in_prod@localhost:5432/tt_cuisine` |
| `ops/compose/.env` | `POSTGRES_PASSWORD` | 生产请改！dev 可用默认 |
| `apps/admin-web/.env` | `VITE_CLERK_PUBLISHABLE_KEY` | 你的 Clerk pk_test_* |

## 启动开发环境

### 模式 A：本地原生跑（推荐 dev）

```bash
# 1. 启动 PG (Docker)
make compose-up   # 仅 PG service 起来；或 `docker compose up -d postgres`

# 2. 跑 DB 迁移
make db-migrate

# 3. 双终端：
make api-dev      # 终端 1
make web-dev      # 终端 2
```

浏览器访问 http://localhost:5173 → 登录 → 创建 → 查看。

### 模式 B：全栈 Docker

```bash
make compose-build  # 先 build 两个 image
make compose-up     # 起所有 service（PG + migrations + API + web）
```

浏览器访问 http://localhost:8080。

## 验证 M0 success criteria

| 标准 | 验证命令/动作 |
|---|---|
| docker compose up 后 admin web 能登录 | 模式 B 跑起来，浏览器 http://localhost:8080，登录成功 |
| admin web 创建宫保鸡丁含 5 语别名 | 登录后在 admin 走表单流程 |
| `curl /api/v1/concepts/gong-bao-ji-ding` 返回 JSON | `curl -s http://localhost:8000/api/v1/concepts/gong-bao-ji-ding \| python3 -m json.tool` |
| CI 全绿 | push 到 GitHub 看 Actions tab |
| domain + Playwright E2E 通过 | `make test-domain && make e2e` |

## 故障排查

### `docker compose up` 后 migrations service 失败

看日志：

```bash
docker compose logs migrations
```

常见原因：DATABASE_URL 不对（host 应该是 `postgres` 不是 `localhost`），或者 postgres-init.sql 中 schema 未建好。删 volume 重来：

```bash
docker compose down -v
docker compose up -d
```

### admin web 登录后 list 拉不到数据 / 401

- F12 看 network：Authorization header 是否带 `Bearer <user_id>`？
- 后端 logs：`docker compose logs api -f`
- `.env` 中 Clerk pk 是否正确？
- 后端 `.env` 中 `API_CORS_ORIGINS` 是否包含前端来源？

### Playwright E2E 失败

```bash
cd apps/admin-web
pnpm exec playwright show-report
```

会展示 screenshot/video，看 step 失败位置。

### "Failed to connect to PostgreSQL" 类错误

```bash
docker exec ttcuisine-postgres pg_isready -U ttcuisine
# 应该返回 "accepting connections"

docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "\dt wiki_core.*"
# 应该列出 concepts + dish_names
```

如果表不存在，重跑迁移：

```bash
make db-migrate
```

## 后续 milestones

- M1：写路径管道（TTPOS mock 接入 → 抽取 → 消歧 → 编辑审核 → LLM 多语补全 → 100 道菜 demo）
- M2：pgvector 消歧 + 多 LLM provider + 真 TTPOS + 计费 + 1000 道菜 + 第一个客户
- M3：10000 道菜 + 自托管 + B 启动

详细规划见 [`docs/specs/2026-05-21-dish-corpus-redesign-design.md`](specs/2026-05-21-dish-corpus-redesign-design.md) §7。
```

- [ ] **Step 3: 验证两个 markdown 文件无渲染错（人肉看一遍）**

```bash
cd /home/ben/projects/tt-cuisine
wc -l README.md docs/getting-started.md
head README.md
head docs/getting-started.md
```

- [ ] **Step 4: 提交**

```bash
cd /home/ben/projects/tt-cuisine
git add README.md docs/getting-started.md
git commit -m "docs: 完整 README + getting-started 上手文档"
```

**Acceptance**：新成员仅凭这两份文档能从 0 跑通 M0；M0 success criteria 验证步骤明确。

---

## 整体收尾与 M0 完工验证

### 最终 Acceptance Walkthrough（在所有任务完成后跑一遍）

按顺序跑下面 8 步，全部通过即 M0 完工：

```bash
# 1. 从干净状态启动
cd /home/ben/projects/tt-cuisine
docker compose -f ops/compose/docker-compose.yml down -v

# 2. 全栈起来
make compose-build
make compose-up
sleep 20
docker compose -f ops/compose/docker-compose.yml ps

# 3. 验证 4 个 service 状态
#    postgres / migrations(Exited 0) / api(healthy) / web(running)

# 4. API health
curl -s http://localhost:8000/api/v1/health | python3 -m json.tool
# 期望：{"status": "ok", "version": "0.1.0", "timestamp": "..."}

# 5. 浏览器登录 → admin web
#    打开 http://localhost:8080
#    用 Clerk 测试账号登录
#    创建宫保鸡丁含 5 语别名（按 Task 28 步骤）

# 6. curl 验证创建成功
curl -s http://localhost:8000/api/v1/concepts/gong-bao-ji-ding | python3 -m json.tool
# 期望：返回 DishConcept JSON，names 数组长度 5

# 7. 跑 Playwright E2E（需要 DB 清空）
docker exec ttcuisine-postgres psql -U ttcuisine -d tt_cuisine -c "TRUNCATE wiki_core.concepts CASCADE"
cd apps/admin-web
set -a; source tests/e2e/.env.test; set +a
pnpm exec playwright test
# 期望：1 passed

# 8. CI 验证（push 后看 Actions tab）
git push origin main  # 触发 CI
# 期望：python / web / docker 三 job 全绿
```

**全 8 步通过 = M0 完成。** 可以进入 M1 规划。

---

## Plan 完结

本 plan 35 个 task 全部就绪。

执行选项见下方 Execution Handoff。
