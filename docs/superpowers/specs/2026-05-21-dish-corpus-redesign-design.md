---
title: TTPolyglot 重新立项 · 菜品垂类语料库
date: 2026-05-21
status: 进行中 (WIP) — 已完成第 1-2 节；第 3-6 节待续
mode: 推倒重做（discard existing i18n direction）
---

# TTPolyglot 重新立项设计 · 菜品垂类语料库

> 本文件是 brainstorm 阶段性产物，**前两节已收敛、可作为下游设计依据**；剩余 4 节（技术选型 / 现有代码处置 / 里程碑 / 风险）待续。

---

## 0. Pivot 背景与产品定位

### 0.1 为什么推倒重做

原仓库（`packages/core` + `packages/parsers` + `apps/ttpolyglot`）的方向是 **通用 i18n 翻译协作平台**，对标 Lokalise/Crowdin/Tolgee。在 brainstorm 中评估后认定：

- 通用 i18n 工具品类已饱和，Lokalise 等十年沉淀，差异化空间窄
- 即便加上"CJK 原生"赌注，在短 i18n key 这种文本尺度上能差异化的空间有限
- 工具品类的护城河靠工程/UX/价格，**没有数据资产复利**

故放弃通用 i18n 方向，转向**纵向纵深 + 数据资产化**的新方向。

### 0.2 新方向的核心赌注

| 维度 | 选择 | 理由 |
|---|---|---|
| 赛道 | **垂直纵深 > 横向铺面** | 菜品垂类没有真正赢家，TTPOS 提供天然 distribution |
| 护城河 | **数据资产 > 工具品类** | 越做越深、护城河自带复利，3 年沉淀无法被 0 天追上 |
| 文化锚 | **CJK 原生** | 菜品多语本地化是 LLM 最难也最有价值的窄域之一 |
| 基建 | **TTPOS 是基础设施** | 不是兄弟品牌，是分发渠道 + 冷启动数据源 + 真实需求验证 |

### 0.3 三件独立产品的轮廓

新方向最终形态由 **三件互相独立、可单独发布、可单独 monetize** 的产品组成：

| 产品 | 角色 | 领域根 | 像什么 | 营收 |
|---|---|---|---|---|
| **A · 菜品维基** | 数据资产 | `DishConcept` | Wikidata for cuisine | API 调用 / 整库授权 |
| **B · 菜单本地化服务** | 交付服务 | `MenuLocalizationOrder` | 翻译公司 + Lokalise 合体（仅菜单） | 按单 / 按月 |
| **C · 菜品翻译引擎** | LLM / Agent | `Prompt` + `EvalCase` + `Provider` | DeepL 菜单版 | API tokens / 月费 / 私部署 |

**关键纪律**：三件之间**不互相依赖**，可独立 day-1 上线。它们之间的"可选连接"（A 喂 C、C 助 B、B 反馈 A）属于"如果有就更好"，**不能成为任一产品的前置依赖**。

---

## 1. 首战场 · A · 菜品维基

### 1.1 产品本质

**TTPolyglot A 是面向全球餐饮业的、多语言结构化的菜品知识资产**。每个 DishConcept 是一个"概念"而非某一家餐厅的某一道菜实例，附带：

- 多语言名称（含 canonical / 音译 / 直译 / 意译 / 外来词 / 错别字 / 别名 类型）
- 配料 / 烹饪方法 / 菜系（皆为受控实体而非自由文本标签）
- 过敏原 / 饮食限制 / 价位语域
- 文化注释 / 来源审计

对外形态：**只读 API + 整库/子集授权（B2B）**。

### 1.2 冷启动数据来源

| 维度 | 选择 |
|---|---|
| 数据源 | TTPOS 现有结构化菜品记录（已选） |
| 数据形态 | 结构化菜品行（dish-per-row，非 OCR / 非自由文本） |
| 可见度 | 跨餐厅全可见，平台所有者拥有数据使用权 |
| 接入复杂度 | ETL（不需 OCR / NER 重度处理） |

**架构后果**：A 的产品主机**不是 Wiki 数据库本身**，而是 **TTPOS → 候选抽取 → 实体消歧 → 多语补全 → 编辑审核 → Wiki 发布** 这套管道。Wiki 数据库是这套管道的"沉淀池"，工程含量的 80% 在管道。

### 1.3 跨餐厅可见的金矿价值

- 同一道"宫保鸡丁" × 50 家餐厅 × 50 种写法 → 实体消歧/聚类是核心算法
- 出现频率、地理分布、价格分布 → 衍生数据资产（市场情报），可独立 monetize
- 餐厅菜单组合 → 反推菜系画像，反向给 TTPOS 提供餐饮洞察能力

---

## 2. 第 1 节决策清单（按最终目标钉死）

| 决策 | 选择 | 理由 |
|---|---|---|
| **A. Ingredient / CookingMethod 形态** | 实体（非自由文本） | C·LLM 引擎要靠它推理；B·菜单服务要靠它做过敏原/饮食筛选；配料库自身是 M3+ 可独立授权资产 |
| **B. 图片 / 营养 / 制作步骤的边界** | 过敏原 + 饮食标签 IN；营养信息通过 Ingredient 反向计算（可选层）；图片 + 食谱 OUT | 营养是 CJK 出海合规刚需；图片+食谱属另一物种 |
| **C. 地域变体** | 独立 DishConcept + `RelatedTo` 关系，不做"概念继承" | LLM 引擎要区分地域；菜单服务要按地理匹配；继承会让权限/查询/授权爆炸 |
| **D. URL slug** | 每个 DishConcept 一个 stable latin slug（基于 canonical 拼音/罗马字），创建时一次性生成、永不改 | API 友好、可分享、SEO |

---

## 3. 第 1 节 · 领域模型

### 3.1 总纲

A 的领域里有 **两个截然不同的世界**，必须在模型层分开：

- **Wiki 核心** — 净化的、规范化的、版本化的"菜品概念"知识资产
- **Ingest / Resolution** — 脏的、原始的、来自 TTPOS 的菜单观察 + 消歧管道

**把两者混在一张表里**是最常见也最致命的错误。它们的生命周期、读写模式、不变量、变化频率完全不一样。

### 3.2 两个有界上下文（Bounded Contexts）

```
┌──────────────────────────────┐        ┌──────────────────────────────┐
│   Ingest / Resolution        │        │        Wiki Core             │
│   （脏数据 + 消歧管道）      │ ─────► │     （净化的菜品知识）       │
│                              │        │                              │
│  · MenuSnapshot              │        │  · DishConcept ★ (root)      │
│  · RawMenuItem               │        │  · DishName                  │
│  · DishCandidate             │        │  · Description               │
│  · MergeProposal             │        │  · IngredientUsage           │
│                              │        │  · CookingMethod             │
│  写多读多 · TB 级 · 可重跑   │        │  · CuisineLineage            │
└──────────────────────────────┘        │  · AllergenTag / DietaryTag  │
        ▲                                │  · PriceTier · CulturalNote │
        │ 单向引用                       │  · Provenance · ConceptRevision
        │ Candidate.matchedConceptId ──► │                              │
                                         │  读多写少 · GB 级 · 不可篡   │
                                         └──────────────────────────────┘
```

**关键设计断言**：
- Wiki 完全不知道 RawMenuItem 存在
- Ingest 知道 DishConcept 存在（只为查"是否已有概念"）
- 唯一的物理连接是 **单向引用** `DishCandidate.matchedConceptId`
- 这允许 Wiki 独立部署、独立扩展、独立授权，不会被 Ingest 流量打死

### 3.3 Wiki 核心区 · 聚合详细

#### 聚合根：`DishConcept`

```
DishConcept ★
├─ id                  (UUID v7, time-ordered)
├─ slug                (stable latin, e.g. "gong-bao-ji-ding")
├─ canonicalName       (主语种, e.g. "宫保鸡丁")
├─ status              (draft | under_review | published | deprecated)
├─ versionRef          → 当前已发布的 ConceptRevision
├─ provenance          (创建者 / 最后审核者 / 时间)
│
├─ names: DishName[]
│   └─ {language, text, type, dialect?, region?, confidence, source}
│        type = canonical | transliteration | literal | descriptive
│             | loanword  | colloquial    | nickname | misspelling
│
├─ descriptions: Description[]
│   └─ {language, text, tone, length}
│
├─ ingredients: IngredientUsage[]
│   └─ {ingredient → Ingredient, role(主/配/调), optional}
│
├─ cookingMethods: CookingMethod[]   (受控词汇实体)
├─ cuisineLineage: CuisineLineage[]  (多对多, 川菜∧巴蜀文化)
├─ allergens:    AllergenTag[]       (受控, ISO/FDA 对标)
├─ dietaryTags:  DietaryTag[]        (素/清真/犹太洁食/无麸质…)
├─ priceTier:    enum                (low / mid / high / premium)
├─ culturalNotes: CulturalNote[]     (多语言文化背景注释)
├─ relatedTo:    RelatedConcept[]    (e.g. 地域变体的横向关系)
│
└─ revisions: ConceptRevision[]      (审核通过即新版本; 全量快照; 不可篡)
```

#### 关键周边实体（均为有自身价值的资产，非 enum）

- **`Ingredient`**：自身有多语言名 + 类别 + 过敏原 → 配料库本身是 M3+ 可独立授权资产
- **`CookingMethod`**：自身是概念实体（炒 / braise / sauté 的精确多语映射）
- **`CuisineRegion`**：DAG 而非 tree（川菜 → 中餐 ; 川菜 → 巴蜀）
- **`AllergenTag` / `DietaryTag`**：受控词汇，对标 ISO/FDA/EU 合规标准

### 3.4 Ingest 资源区 · 聚合详细

```
MenuSnapshot ★ (一次 TTPOS 拉取, 一家餐厅一份)
├─ restaurantId, takenAt, source
└─ rawItems: RawMenuItem[]

RawMenuItem
├─ originalText, originalLanguage
├─ priceText, priceAmount, currency
├─ categoryText (TTPOS 自己的分类)
├─ firstSeenAt, lastSeenAt, observationCount

DishCandidate (从 RawMenuItem 抽取出的候选)
├─ normalizedName
├─ extractionMethod  (rule | NER | LLM)
├─ confidence
├─ matchedConceptId? ──► DishConcept    (可空 = 尚未匹配)
├─ matchScore
└─ status (pending | linked | new_concept_proposed | rejected)

MergeProposal (算法提案: 把这堆 candidate 合到这个 concept)
├─ candidateIds[]
├─ targetConceptId   (existing 或 new)
├─ proposedBy        (algorithm name + version)
├─ score, evidence
└─ reviewerDecision  (approve | reject | split)
```

### 3.5 关键不变量（按重要性排序）

1. **DishConcept 一旦发布，`canonicalName` 不可改**。改名走 deprecate + redirect 流程，类同 Wikipedia 页面 move。否则 API 消费者地狱。
2. **DishName ↔ DishConcept 是多对一**。一个概念有多个名字；一个名字字面值在同一 `(language, region)` 下只能属于一个概念。歧义体现在 alias 上，不在概念上。
3. **Ingredient / CookingMethod 必须是实体而非 free-text**。昂贵但 long-term 正确。配料库本身在 M3+ 是独立可授权资产。
4. **CuisineRegion 是 DAG** 而非 tree。允许"川菜 → {中餐, 巴蜀文化}"双父亲。
5. **Provenance 必须可追溯到原始**。每个 DishConcept 都能回答"哪些 RawMenuItem 喂出了我？谁审的？什么时候？"这是数据资产授权时的法律和信任基石。
6. **Raw 区永不物理删除**。消歧算法迭代后要能回放历史。最多冷归档。

### 3.6 全流转例子 · "宫保鸡丁"

1. TTPOS 拉到 50 家餐厅菜单 → 50 个 `MenuSnapshot`
2. 写法分布：35 家"宫保鸡丁"｜10 家"宫爆鸡丁"（错别字）｜3 家"Kung Pao Chicken (Gong Bao Ji Ding)"｜2 家"宫保鸡丁(微辣)"
3. 抽取层产出 50 个 `RawMenuItem` → 派生 50 个 `DishCandidate`
4. 消歧算法（字符相似 + LLM 语义 + 配料 co-occurrence）→ 1 个 `MergeProposal`
5. 编辑审核 ✓ → 创建 `DishConcept` "宫保鸡丁"
6. Wiki 自动 / 半自动补全 `DishName[]`：
   - `(zh-CN, "宫保鸡丁", canonical)`
   - `(zh-CN, "宫爆鸡丁", misspelling, conf=0.95)`
   - `(en-US, "Kung Pao Chicken", transliteration-romanized)`
   - `(en-US, "Gong Bao Ji Ding", transliteration-pinyin)`
   - `(ja-JP, "鶏肉のカシューナッツ炒め(宮保鶏丁)", descriptive+transliteration)`
   - `(ko-KR, "궁보계정", transliteration)`
7. 关联 `Ingredient`：鸡丁(主) / 干辣椒 + 花椒 + 花生(配) / 醋 + 糖 + 酱油(调)
8. `CookingMethod`：炒（stir-fry，受控实体）
9. `CuisineLineage`：川菜（weight=1.0）
10. `AllergenTag`：花生
11. `PriceTier`：mid（基于 50 家价格分布）
12. `CulturalNote` (en-US)："Named after late Qing dynasty official Ding Baozhen…"

→ 50 家餐厅的菜单数据被压缩成 1 条高密度 DishConcept + 6+ 跨语言别名。**这就是语料库的价值密度**。

---

## 4. 第 2 节 · 架构骨架

### 4.1 系统上下文（Level 1）

```
                              ┌──────────────────┐
                              │  LLM Providers   │
                              │ DeepSeek │ Qwen  │
                              │  Kimi  │ 智谱     │
                              │   GPT  │ Claude  │
                              │   Ollama 自部署   │
                              └────────┬─────────┘
                                       │
   ┌──────────┐                        ▼                ┌──────────────┐
   │  TTPOS   │ ─── 菜单数据流 ──►  ┌──────────────┐   │ API 消费方    │
   │ (餐厅菜单)│                     │              │   │              │
   └──────────┘                     │ TTPolyglot   │   │ · 第三方        │
                                    │      A       │──►│ · 未来的 B     │
   ┌──────────┐                     │  菜品维基平台 │   │ · 未来的 C     │
   │ 编辑团队  │ ◄─── Web 后台 ───►│              │   │ · TTPOS 反查   │
   │ (审核者) │                     └──────┬───────┘   └──────────────┘
   └──────────┘                            │
                                ┌──────────▼──────────┐
                                │  Web/Object/CDN     │
                                │  授权/计费/审计      │
                                └─────────────────────┘
```

**对外身份只有 1 个**：TTPolyglot A 平台。LLM 与 TTPOS 是上游供给，第三方 / B / C 是下游消费。B 与 C 未来不是 A 的子模块，而是 A 的下游 API 消费方——**这个边界从 day-1 就要硬**。

### 4.2 内部架构（容器 / 进程级别）

```
┌────────────────────────────────────────────────────────────────────────┐
│                       TTPolyglot A · 平台内部                          │
│                                                                        │
│   ┌──────────────────────┐         ┌──────────────────────┐           │
│   │   Read Service       │         │  Write/Worker Service │           │
│   │   ─────────────      │         │  ──────────────────   │           │
│   │ · Public API (v1)    │         │ · TTPOS 拉取 Job      │           │
│   │ · 编辑后台 BFF       │ ◄─────► │ · 抽取 + NER + 消歧   │           │
│   │ · 缓存 (Read-mostly) │         │ · LLM Orchestration   │           │
│   │ · 计费打点           │         │ · 审核工作流后端       │           │
│   └──────────┬───────────┘         └──────────┬───────────┘           │
│              │                                 │                       │
│              ▼                                 ▼                       │
│   ┌────────────────────────────────────────────────────────┐         │
│   │            PostgreSQL · 主库 (jsonb 友好)              │         │
│   │   ┌────────────────────┐   ┌────────────────────┐    │         │
│   │   │ Wiki Core Schema   │   │ Ingest Schema      │    │         │
│   │   │ · concepts         │   │ · menu_snapshots   │    │         │
│   │   │ · dish_names       │   │ · raw_menu_items   │    │         │
│   │   │ · ingredients      │   │ · dish_candidates  │    │         │
│   │   │ · revisions (不变) │   │ · merge_proposals  │    │         │
│   │   │ 读多写少 · GB 级    │   │ 写多 · TB 增长     │    │         │
│   │   └────────────────────┘   └────────────────────┘    │         │
│   │   (同一物理库, 不同 schema, 不同访问角色)              │         │
│   └────────────────────────────────────────────────────────┘         │
│                                                                        │
│   ┌──────────────────┐    ┌──────────────────┐   ┌────────────────┐ │
│   │  Search Index    │    │  Job Queue        │   │ Object Storage │ │
│   │ Meilisearch      │    │ PG LISTEN/NOTIFY  │   │ S3-compatible  │ │
│   │ (多语种 + typo)  │    │ → Redis Stream    │   │ (raw exports,  │ │
│   │ (alias 全文)     │    │ (M2+ 升级)        │   │  snapshots)    │ │
│   └──────────────────┘    └──────────────────┘   └────────────────┘ │
└────────────────────────────────────────────────────────────────────────┘
```

**取舍说明**：

- **拆 service / 不拆库**：读路径需 SLA / 缓存 / horizontal scale；写路径是突发批量管道，节奏完全不同——从 day-1 就分开避免后期撕扯。但单机 PG 在 day-1 完全 hold 住，过早拆库 = 早死。**用 schema 而非 database 隔离**，未来再分。
- **PG 选型理由**：jsonb 兼容性强（schema 演化容忍）、`pg_trgm` + `unaccent` 模糊匹配、`tsvector` 全文、`pgvector` 后期向量相似度——一个库覆盖 day-1 到 M2 所有需求。

### 4.3 写路径管道（核心引擎，工程含量的 80%）

```
   ┌─ Stage 1 ─────────────────────────┐
   │ TTPOS 增量拉取 (cron / webhook)    │
   │ → MenuSnapshot (按餐厅, 按时间)    │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 2 ─────────────────────────┐
   │ 规范化 / 噪声清除                  │
   │ · 去价格前后缀 ("特价"/"招牌")     │
   │ · unicode 标准化                  │
   │ · 语言检测                         │
   │ → RawMenuItem (持久化, append)     │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 3 ─────────────────────────┐
   │ 候选抽取 · 多策略                  │
   │ · 规则 (正则 + 词表)               │
   │ · NER 模型 (CJK food NER)         │
   │ · LLM 兜底 (难以解析的 item)       │
   │ → DishCandidate (含置信度 + 策略)  │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 4 ─────────────────────────┐
   │ 消歧 / 实体解析 (最关键!)          │
   │ · 字符相似 (Levenshtein, pg_trgm)  │
   │ · 拼音相似 (汉语拼音/罗马字)        │
   │ · 语义相似 (embedding cos)         │
   │ · 配料 co-occurrence              │
   │ · 餐厅菜系 prior                   │
   │ ──► 输出 MergeProposal             │
   │     · 链接到现有 DishConcept       │
   │     · 或提议新建                   │
   │     · 或要求人工裁决               │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 5 ─────────────────────────┐
   │ 编辑审核 (Web 后台)                │
   │ · approve → link                  │
   │ · reject  → 标记 outlier          │
   │ · split   → 拆分多 proposal       │
   │ · merge   → 多 concept 合并        │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 6 ─────────────────────────┐
   │ 多语补全 (LLM 编排)                │
   │ · 别名生成 (受控: 音译/直译/意译)  │
   │ · 描述生成 (按 tone)               │
   │ · 配料推理 (回链 Ingredient 库)    │
   │ · 工艺推理 (回链 CookingMethod)    │
   │ → DishConcept DRAFT Revision      │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 7 ─────────────────────────┐
   │ 终审 (Web 后台)                    │
   │ · 编辑校对 LLM 产出                │
   │ · 配料/工艺/菜系 confirm          │
   │ · publish → PUBLISHED Revision    │
   │   (不可篡, 形成版本史)             │
   └──────────────┬────────────────────┘
                  ▼
   ┌─ Stage 8 ─────────────────────────┐
   │ 索引 + 缓存失效 + 事件广播         │
   │ · Meilisearch 增量索引            │
   │ · Read cache invalidation         │
   │ · ConceptPublished 事件 → 下游     │
   │   (未来 B/C 订阅)                  │
   └────────────────────────────────────┘
```

**纪律**：Stage 4 的消歧策略**必须可插拔**（端口）。day-1 用 `pg_trgm` + 拼音相似就够；M1 接入 embedding；M2 可能引入小模型。**算法越好，编辑工作量越小**。

### 4.4 端口与适配器（六边形）

```
                ┌────────────────────────────────────┐
                │           Application Layer        │
                │  · ConceptReviewUseCase            │
                │  · CandidateResolveUseCase         │
                │  · MultilangEnrichUseCase          │
                │  · PublishConceptUseCase           │
                └───────────────┬────────────────────┘
                                │
                ┌───────────────▼────────────────────┐
                │          Domain Layer              │
                │  · DishConcept (聚合根)            │
                │  · Ingredient · CookingMethod      │
                │  · DishCandidate · MergeProposal   │
                │  (纯, 无外部依赖, 可单元测试)      │
                └───────────────┬────────────────────┘
                                │
        ┌───────────────────────┼───────────────────────────┐
        │                       │                           │
   Ports (接口)         Ports (接口)                Ports (接口)
   ┌────────────┐      ┌────────────┐      ┌──────────────────┐
   │ MenuSource │      │ LLM        │      │ ConceptRepository │
   │  Port      │      │ Provider   │      │ IngestRepository  │
   │            │      │  Port      │      │ SearchIndex       │
   │            │      │            │      │ NotificationPort  │
   │            │      │            │      │ BillingPort (M2+) │
   └─────┬──────┘      └─────┬──────┘      └────────┬─────────┘
         │                   │                       │
         ▼                   ▼                       ▼
   Adapters (实现)     Adapters             Adapters
   ┌────────────┐      ┌────────────┐      ┌──────────────┐
   │ TTPOS API  │      │ DeepSeek   │      │ Postgres     │
   │ CSV import │      │ Qwen       │      │ Meilisearch  │
   │ OCR (B 用) │      │ Kimi       │      │ S3 / MinIO   │
   │ 手工录入   │      │ GPT-4o     │      │ 钉钉 / 飞书  │
   │            │      │ Claude     │      │ Stripe (M2+) │
   │            │      │ Ollama 自托│      │              │
   └────────────┘      └────────────┘      └──────────────┘
```

**LLM Provider Port 是 CJK 原生赌注的硬体现**——它不是普通的"调一个 OpenAI 接口"，而是一套**路由协议**：按任务类型（命名 / 描述 / 配料推理 / 消歧验证）、价格、质量等级、合规要求（数据驻留）路由到不同 Provider。**day-1 就要做对**，否则后期改超痛。

### 4.5 读路径与 API 契约

```
GET  /api/v1/concepts/{idOrSlug}              → 当前发布版 DishConcept 全量
GET  /api/v1/concepts/{idOrSlug}@v{n}         → 指定历史版本
GET  /api/v1/concepts?canonical={text}        → 精确匹配规范名
GET  /api/v1/concepts?alias={text}&lang={lc}  → 别名查询 (任意语言)
GET  /api/v1/search?q={text}&lang={lc}&fuzzy  → 模糊全文 (Meilisearch)
GET  /api/v1/concepts?filter=...              → 复合筛选 (配料/菜系/过敏)
GET  /api/v1/ingredients/{idOrSlug}
GET  /api/v1/cuisines/{idOrSlug}/concepts
GET  /api/v1/exports/snapshot?since={ts}      → 增量授权拉取 (B/C 友好)
```

**契约纪律**：
- 所有响应带 `version` 和 `etag`，下游可缓存
- 查询参数支持 `lang=zh-CN,ja-JP` 多语返回（不分别请求）
- **不暴露内部 UUID 作为唯一 URL key**，强制用 slug → SEO + 理解性

### 4.6 部署形态

**SaaS-first（day-1 推荐）**：
- 单一云租户，A 平台运营方 = 数据 owner（与 TTPOS 跨餐厅授权一致）
- API 按 quota 计费（M2+ 上线计费）

**自托管选项（M3+ 加上）**：
- 大客户买"整库 snapshot 授权 + Docker Compose / Helm Chart 自部署"
- **只读快照，不双向同步** → 避免数据反流污染主库

**day-1 不支持自托管的理由**：数据全靠 TTPOS 反哺，自托管副本无数据源，做了用不上。

### 4.7 给 B 和 C 留的接入点（硬边界）

```
A 的 Public API + Snapshot Export     ◄── B 调用 (按订单查菜品概念)
                                       ◄── C 调用 (训练 + 评测)

A 内部的 ConceptPublished 事件流      ──► B 订阅 (新增菜品时主动通知)
                                       ──► C 订阅 (增量训练数据)

A 的 Anonymized Raw Items Export       ──► C 拿真实菜单文本做训练
```

**硬纪律**：
- B 和 C **不直接读 A 的 DB**，只通过 API 和事件流
- A 的内部 schema 演化与 B / C 解耦
- 三件产品可各自独立部署、独立计费、独立 PR / CI ——只共享 A 这个"原料供应商"

### 4.8 现实 sizing（day-1 单机足够）

| 资源 | day-1 (500 餐厅) | M1 (5k 餐厅) | M3 (50k 餐厅) |
|---|---|---|---|
| RawMenuItem | 25k 行 | 250k | 2.5M |
| DishConcept | 2–5k | ~10k | ~50k |
| 主库存储 | < 500 MB | < 5 GB | < 50 GB |
| 索引存储 | < 100 MB | < 1 GB | < 10 GB |
| LLM 一次建库成本 | 1–5 万 ¥ | 增量 ≤ 5k ¥/月 | 增量 ≤ 5 万 ¥/月 |
| 部署 | 1 台 4C8G | 1 台 8C16G + 1 worker | 读副本 + worker fleet |

**day-1 完全单机**。day-1 严禁引入 Kafka / K8s / 微服务 / 读写分离 / 分片。

### 4.9 架构纪律（给未来的自己/后人）

1. **写路径管道的每一 Stage 都要可单独重跑**（idempotent + content-addressable input）。算法迭代必然要回放历史，day-1 就要保证此属性。
2. **Ingest 和 Wiki 之间唯一物理引用是 `DishCandidate.matchedConceptId`**。任何想从 Wiki 反查"我是哪些 raw 喂出来的"的需求，都通过 Provenance 字段而非反向外键。
3. **LLM 调用必须经过 Provider Port**。不允许任何 use case 直接调 OpenAI / DeepSeek SDK。Provider Port 自带重试、降级、计费打点、prompt 模板版本管理、审计日志。
4. **API 版本 v1 上线后承诺 2 年不破坏**。B 和 C 是下游消费者，破坏 API 意味着内部产品互卡。
5. **PostgreSQL 是真理之源，Meilisearch 是缓存**。任何只在 Meilisearch 里的数据视为"会丢"。所有 ETL 在 PG 跑完再增量到搜索。
6. **审核工作流不在领域层做状态机**——而是**事件 sourcing**（每个 review action 是 immutable event，最终态由 reducer 计算）。理由：消歧是不断回溯纠错的工作，一个 concept 可能被审 3 次才定稿，传统状态机表达不动。

---

## 5. 未决事项 / 下一步

### 5.1 待续节次

- **第 3 节 · 技术选型决定点**：Dart / Serverpod 继续 vs 换栈（Python / Node / Go）、DB（PG 已基本定）、Search（Meilisearch vs Typesense vs OpenSearch）、Queue（PG LISTEN/NOTIFY → Redis Stream → NATS 演进）、LLM gateway（自建 vs LiteLLM）、编辑后台前端（Flutter Web vs Vue / React）
- **第 4 节 · 现有代码处置清单**：精确到文件级的"救 / 丢 / 重做"判定
- **第 5 节 · 里程碑切片**：M0 → M3 每个里程碑的 success criteria
- **第 6 节 · 风险与反模式**：消歧失败 / LLM 幻觉 / TTPOS 合规 / 数据资产授权法律 / 编辑团队招募

### 5.2 待 sizing 的产品参数

- **首批菜系覆盖范围**（中餐 only vs CJK 混合 vs 多元）—— 取决于 TTPOS 客户菜系分布
- **目标语种范围**（中日韩英 only vs 含越泰马来 vs 全球）—— 取决于 TTPOS 客户出海方向
- **私有部署支持时间窗**（M2 vs M3 vs 永不）—— 取决于商业客户结构

这些 sizing 参数**不会改变本文已定的领域模型与架构骨架**，只会影响里程碑 sizing 和团队 sizing。

---

## 附录 · 决策溯源

本设计来自一次 brainstorm 会话，关键决策路径：

1. 用户要求"框架思维梳理项目" → 探索现状（CJK Dart 翻译协作平台）
2. 用户要求"推倒重做" → 抛弃现有方向，重新思考产品
3. 数据真理之源问题 → 选"git 与平台本就不是同一物种"（产物 vs 资源）
4. 产品脸面 → 选"翻译者/PM 是主体"（Web 平台为脸）
5. 产品赌注 → 选"CJK 原生"
6. 翻译边界 → 用户进一步推倒，转向"做语料库 + 深挖菜品垂类"
7. 语料库角色 → 选"三件独立产品（A 维基 / B 服务 / C 引擎），不被长线目标拖累"
8. 首战场 → 选 A · 菜品维基
9. 冷启动来源 → 选 TTPOS 餐厅菜单反哺
10. TTPOS 数据形态 → 结构化菜品记录（最理想场景）
11. 跨餐厅可见度 → 全可见，平台拥有数据权
12. 第 1 节 4 个决策按最终目标钉死（Ingredient 实体化 / 营养信息策略 / 地域变体平行 / slug 必备）

每一步选择都是 brainstorming skill 的 "ask clarifying questions" 阶段产物，已确认无遗漏。
