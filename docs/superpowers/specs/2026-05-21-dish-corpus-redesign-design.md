---
title: TTPolyglot 重新立项 · 菜品垂类语料库
date: 2026-05-21
status: 已收敛 — brainstorm 全 6 节完成，待用户 review 后转入 writing-plans
mode: 推倒重做（discard existing i18n direction）
---

# TTPolyglot 重新立项设计 · 菜品垂类语料库

> 本文件是 brainstorm 完整产物，6 个 section 全部收敛。可作为 writing-plans 阶段输入。

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

## 5. 第 3 节 · 技术选型决定点

### 5.1 决策概览

| 决策 | 最终选择 | 理由速签 |
|---|---|---|
| 1. 后端语言 | **Python (FastAPI + Dramatiq)** | 产品 80% 工程在 NLP/LLM 管道，Python 是它的母语 |
| 2. 数据库 | **PostgreSQL 16 + pgvector + pg_trgm + unaccent** | 一个库覆盖结构化 + 全文 + 向量 + jsonb 全部需求 |
| 3. 搜索 | **Meilisearch ≥1.6（含 CJK 分词）** | PG 全文 CJK 配置太痛苦；Meilisearch 原生支持 |
| 4. 任务队列 | **Dramatiq + Redis** | Celery 太重，Temporal 太大，Dramatiq 刚刚好 |
| 5. LLM 网关 | **LiteLLM + 自写薄壳 LLMProviderPort** | 不重造多 provider 适配；自己加 CJK 路由 |
| 6. 编辑后台前端 | **React 18 + Vite + Ant Design 5** | 数据密集 admin UI 场景；CJK 一等公民 |
| 7. 仓库形态 | **新仓库 `tt-cuisine`，本仓归档** | 新栈与旧栈共用代码 < 5%，混在一起得不偿失 |
| 8. 基建（Auth / Cache / Storage / Proxy / Deploy / CI / Monitor） | Clerk + Redis + MinIO + Caddy + Docker Compose + GH Actions + Prometheus | 见 §5.9 |

### 5.2 决策 1 · 后端语言（Dart → Python，弃栈）

**Dart 服务端的硬伤**：

| 维度 | 实情 |
|---|---|
| CJK NLP 工具链 | jieba / pypinyin / opencc / fugashi / mecab 全是 Python；Dart 端 FFI 或 RPC 反复跨语言 |
| NER + Embedding 生态 | spaCy / sentence-transformers — Python 母语；Dart 无对等物 |
| LLM SDK | 官方 SDK 首发 Python，Dart 要么没有要么社区端口 |
| Serverpod 社区 | 小众；docs gap、招人难、debug 无援 |
| 唯一优势 | 复用 Flutter app — **但 Flutter 这次也弃栈（决策 6），优势消失** |

**Python 栈**：

```
┌──────────────────────────────────────────────────────────────┐
│                  Python 单语言后端                          │
│  ┌────────────────────┐       ┌────────────────────┐        │
│  │  Read Service      │       │  Write/Worker      │        │
│  │  FastAPI + Uvicorn │       │  Dramatiq actors   │        │
│  │  5-10k RPS/box     │       │  共用 Domain pkg   │        │
│  └────────────────────┘       └────────────────────┘        │
│             ▲                          ▲                    │
│             └──────────┬───────────────┘                    │
│              ┌─────────▼─────────┐                          │
│              │  Domain & Ports   │  pure python, no I/O     │
│              │   Pydantic v2     │                          │
│              └───────────────────┘                          │
└──────────────────────────────────────────────────────────────┘
```

**关键库**：FastAPI · Uvicorn · SQLAlchemy 2.0 (async) · Alembic · Dramatiq · jieba · pypinyin · opencc · fugashi · pecab · rapidfuzz · sentence-transformers (BAAI/bge-m3) · LiteLLM · pytest · mypy strict · ruff · Pydantic v2

**性能担忧的回应**：FastAPI + Uvicorn 在 4C 机器上 5-10k RPS 是日常水平；读路径峰值 day-1 < 50 RPS，M3 < 500 RPS。**慢 10 倍仍然过剩 20 倍**。

### 5.3 决策 2 · 数据库

PostgreSQL 16 + 扩展：

| 子决策 | 选择 |
|---|---|
| 引擎 | PostgreSQL 16 |
| 向量 | pgvector day-1 启用（Stage 4 消歧立刻就要） |
| 模糊匹配 | pg_trgm + unaccent |
| Schema 隔离 | `wiki_core` / `ingest` / `audit` 三 schema（同库不同 schema） |
| 迁移 | Alembic |
| 备份 | pg_dump nightly + WAL archive 到 S3 |

**day-1 不要做**：分片、读写分离、跨库 join、多租户 schema-per-tenant。

### 5.4 决策 3 · 搜索

**Meilisearch ≥1.6（含 CJK 分词）**

- 1.4+ 起原生 CJK 分词，自托管 Docker 一键起
- Rust 内核，极快
- API 友好

**用途分工**：
- Meilisearch：对外 `/search`（CJK 模糊、拼音、跨语言别名）
- PG 全文：内部 admin 查询 + 候选浮现

### 5.5 决策 4 · 任务队列

**Dramatiq + Redis day-1；Temporal 在 M3 重评估**

写路径 8 个 Stage 用 Dramatiq actors 表达：每个 Stage 是一个 actor，Stage 间通过 PG 状态字段流转。**day-1 严禁上 Temporal**——太诱人但太重。

### 5.6 决策 5 · LLM 网关

LiteLLM 做底层 100+ provider 适配；自写**薄壳** `LLMProviderPort`（约 500 行）加 CJK 路由：

```
┌─ LLMProviderPort（自写薄壳）──────────────────────┐
│ · 按任务类型路由（命名 / 描述 / 配料 / 消歧）        │
│ · prompt 模板版本管理 + a/b 测试                  │
│ · 计费打点 + 审计日志                             │
│ · 降级链（DeepSeek 失败 → Qwen → GPT-4o-mini）   │
│ · 数据驻留合规（境内任务不走境外 provider）         │
└────────────────────────┬─────────────────────────┘
                         │
            ┌────────────▼──────────────┐
            │       LiteLLM (库)         │
            │ DeepSeek/Qwen/Kimi/智谱    │
            │ GPT/Claude/Ollama 自部署   │
            └───────────────────────────┘
```

**不用 OpenRouter/Portkey 等托管服务**：CJK provider 在这些服务上支持参差、价格不透明、数据驻留合规不可控、质量基准必须我们自己做。

### 5.7 决策 6 · 编辑后台前端（Flutter Web → React，弃栈）

**Flutter Web 在数据密集 admin UI 上的硬伤**：

| 维度 | Flutter Web 实情 |
|---|---|
| 文本渲染 | canvas 渲染；CJK 字体回退坑多 |
| 复制粘贴 | 与浏览器原生 selection 差距大；编辑场景天天用 |
| SEO / a11y | 几乎裸跑 |
| 滚动 / 虚拟列表 | 长表格性能问题已知 |
| 表单 / 弹窗 / Diff 视图 | 生态贫瘠；要手写基础组件 |

**React 栈**：

| 子项 | 选择 | 理由 |
|---|---|---|
| UI 组件库 | Ant Design 5 (antd) | 阿里出品；CJK 一等公民；admin UI 完整度业内最高 |
| 全局状态 | Zustand | 比 Redux Toolkit 轻；hook 风格；TS 友好 |
| 服务端数据 | TanStack Query v5 | 缓存/失效/重试一等公民 |
| 路由 | TanStack Router | TS 全类型；data loaders 一等公民 |
| 表单 | React Hook Form + Zod | 性能好；schema 校验一等公民 |
| 表格 / 虚拟化 | TanStack Table + TanStack Virtual | 5k 候选 / 10k Concept 滚动顺滑 |
| Diff 视图 | react-diff-viewer-continued + monaco-editor | alias 跨语言对照、配料 / 工艺审核必备 |
| 编辑后台 i18n | react-i18next | 后台自身也要中英双语 |
| 构建 | Vite + TypeScript strict | — |
| 测试 | Vitest + Testing Library + Playwright | — |

### 5.8 决策 7 · 仓库形态（新仓 `tt-cuisine`，本仓归档）

**新仓布局**（Python + React + Docker Compose）：

```
tt-cuisine/
├── apps/
│   ├── api/                # FastAPI Read Service
│   ├── worker/             # Dramatiq Workers
│   └── admin-web/          # React 18 + Vite + Ant Design 5 编辑后台
├── packages/
│   ├── domain/             # 纯 Python 领域模型 (DishConcept, ...)
│   ├── ports/              # 端口接口定义 (Protocol/ABC)
│   ├── adapters/           # 适配器 (TTPOS / LiteLLM / PG / Meili / S3)
│   ├── pipeline/           # 写路径 8 stages
│   └── nlp/                # CJK 处理 (拼音 / 繁简 / 分词)
├── ops/
│   ├── compose/            # docker-compose.{dev,prod}.yml
│   ├── migrations/         # Alembic
│   └── helm/               # M3+ 自托管 chart 起步
├── docs/
│   └── specs/              # 新仓的设计文档
├── pyproject.toml          # uv / hatch
└── README.md
```

**本仓 `ttpolyglot` 的命运**：
- 不删除：留作 brainstorm 决策溯源 + Dart / Flutter 旧设计参考
- README 顶部加 deprecation note，指向 `tt-cuisine` 新仓
- 本设计文档 `docs/superpowers/specs/...` **继续在本仓**——它是 pivot 的历史记录
- 保留 git tag `v0.1.0-i18n-direction-archive` 标记 pivot 点

### 5.9 决策 8 · 其余基建

| 类别 | 选择 | 备注 |
|---|---|---|
| Reverse Proxy | Caddy | 自动 HTTPS，配置 5 行起步 |
| Cache | Redis（同实例兼任队列 backend） | day-1 单实例足够 |
| Object Storage | MinIO 自托管（S3 API 兼容） | day-1 简单；M2 切云 S3 透明 |
| 编辑后台 Auth | Clerk 起步；合规要求改 Authentik 自托管 | 5-20 编辑人员场景 |
| 公开 API Auth | 自建 API key + rate-limit + HMAC 签名 | 不用 Clerk |
| Deployment | Docker Compose day-1；Helm + K8s M3+ | 别在 day-1 上 K8s |
| CI | GitHub Actions | mypy / pytest / ruff / vitest / playwright |
| Monitoring | day-1 结构化 JSON log；M1 加 Prometheus + Grafana；M2 加 Sentry | APM 推到 M3 |
| 配置 | Pydantic Settings + `.env` + Vault（M2+） | 不要 yaml 字符串 |
| 文档 | mkdocs-material + 自动 OpenAPI 嵌入 | API 客户友好 |

### 5.10 综合后的技术栈快照

```
┌──────────────────────────────────────────────────────────────────┐
│                  tt-cuisine · 完整技术栈                          │
├──────────────────────────────────────────────────────────────────┤
│ 后端语言        │ Python 3.12 (strict typed, pydantic v2)         │
│ Web 框架        │ FastAPI + Uvicorn (ASGI)                        │
│ 任务队列        │ Dramatiq + Redis                                │
│ ORM / 迁移      │ SQLAlchemy 2.0 (async) + Alembic                │
│ 数据库          │ PostgreSQL 16 + pgvector + pg_trgm + unaccent   │
│ 搜索            │ Meilisearch 1.6+ (CJK 分词)                     │
│ Cache           │ Redis (与队列共用)                              │
│ 对象存储        │ MinIO (开发/M2) → AWS S3 / 阿里云 OSS (生产)    │
│ LLM 网关        │ LiteLLM + 自定 LLMProviderPort                  │
│ CJK NLP         │ jieba + pypinyin + opencc + fugashi + pecab     │
│ Embedding       │ sentence-transformers (BAAI/bge-m3)             │
│ 模糊匹配        │ rapidfuzz (Rust 内核 Python 绑定)               │
│ 测试            │ pytest + httpx + factory-boy + freezegun        │
│ 类型检查        │ mypy strict + Pydantic 边界                     │
│ Lint / Format   │ ruff (替代 flake8 + black + isort)              │
│ 前端框架        │ React 18 + Vite + TS strict                     │
│ 前端 UI lib     │ Ant Design 5                                    │
│ 前端状态        │ Zustand + TanStack Query                        │
│ 前端路由        │ TanStack Router                                 │
│ 前端表单 / 表格 │ React Hook Form + Zod / TanStack Table          │
│ 前端测试        │ Vitest + Testing Library + Playwright           │
│ 编辑后台 Auth   │ Clerk (起步) → Authentik (合规)                 │
│ 公开 API Auth   │ 自建 API key + HMAC                             │
│ 反向代理        │ Caddy                                           │
│ 部署            │ Docker Compose (day-1 → M2) → K8s + Helm (M3+) │
│ CI / CD         │ GitHub Actions                                  │
│ 监控            │ JSON log → Prometheus + Grafana → Sentry        │
│ 文档            │ mkdocs-material                                 │
│ 仓库            │ 新仓 tt-cuisine；本仓归档为 i18n-direction      │
└──────────────────────────────────────────────────────────────────┘
```

---

## 6. 第 4 节 · 现有代码处置清单

### 6.1 四个处置类别

| 标签 | 含义 | 动作 |
|---|---|---|
| 🟢 **救（Migrate）** | 概念 + 代码都可直接搬到新仓（翻译成 Python） | 列入新仓 day-0 种子清单 |
| 🟡 **借鉴（Reference）** | 代码丢，但**设计模式 / 决策依据**值得在新仓保留 | 在新仓相应处加注释引用 + 旧仓留 link |
| 🟠 **重做（Rebuild）** | 概念上需要，但旧实现完全错位，必须从零重写 | 旧文件**不复用**；新仓重新设计 |
| 🔴 **丢（Drop）** | 概念不需要、或与新方向冲突 | 旧仓归档时随之埋葬 |

**观察**：救的部分 < 5%。这是推倒重做的预期结果，非损失。

### 6.2 `packages/core` 逐文件审计

#### `lib/src/models/`

| 文件 | 处置 | 理由 |
|---|---|---|
| `language.dart` | 🟢 救 | `Language(code, name, nativeName, region)` 结构对菜品维基适用；翻译为 Pydantic |
| `user.dart` | 🟠 重做 | Clerk 接管 auth 后变 thin shadow model |
| `project.dart` | 🔴 丢 | i18n 项目概念，新产品无对应 |
| `translation_entry.dart` | 🔴 丢 | 对等物是 `DishName` + `Description`，结构差异巨大 |
| `workspace_config.dart` | 🔴 丢 | SaaS 单租户，无对应 |
| `export.dart` | 🔴 丢 | i18n 文件导出，无关 |

#### `lib/src/services/`

| 文件 | 处置 | 理由 |
|---|---|---|
| `project_service.dart` `translation_service.dart` `workspace_service.dart` `export_service.dart` `sync_service.dart` | 🔴 丢 | i18n 服务接口，全不适用 |
| `storage_service.dart` | 🟡 借鉴 | KV storage 端口抽象模式参考；新仓 `ObjectStoragePort` API 不同 |

#### `lib/src/enums/`

| 文件 | 处置 |
|---|---|
| `translation_status.dart` | 🟠 重做（→ `ConceptStatus`） |
| `translation_key.dart` | 🔴 丢 |
| `sync_status.dart` | 🔴 丢 |
| `user_role.dart` | 🟠 重做（角色集不同） |

#### `lib/src/utils/`

| 文件 | 处置 |
|---|---|
| `translation_utils.dart` `source_language_validator.dart` `data_migration_validator.dart` | 🔴 全丢（i18n 工具） |

#### 顶层

| 文件 | 处置 |
|---|---|
| `core.dart` | 🔴 丢（barrel export） |
| `pubspec.yaml` | 🔴 丢（Dart 生态） |

**`packages/core` 净保留**：1 个模型 (`Language`) + 2 个 enum 设计模式参考。

### 6.3 `packages/parsers` 逐文件审计

| 文件 | 处置 | 理由 |
|---|---|---|
| `parser_interface.dart` | 🟡 借鉴 | 双向接口模式 → 新仓 `MenuSourcePort` + `ExportPort` |
| `parser_factory.dart` | 🟡 借鉴 | factory 模式可在 `MenuSourcePort` 多适配器选择处复用 |
| `parser_result.dart` | 🟡 借鉴 | 带 errors/warnings 的结果类型设计 |
| `parsers/json_parser.dart` `yaml_parser.dart` `arb_parser.dart` `po_parser.dart` `properties_parser.dart` | 🔴 全丢 | i18n 格式，无关 |
| `parsers/csv_parser.dart` | 🟠 重做 | CSV 批量 dish 导入概念保留，针对 `Dish` 结构从零写 |
| `constants/file_formats.dart` | 🔴 丢 |
| `exceptions/parser_exception.dart` | 🟠 重做（异常分类思路保留） |
| `utils/encoding_utils.dart` | 🟢 救 | CJK 编码检测通用工具，Python 用 `chardet` 包装 |
| `utils/file_utils.dart` | 🟡 借鉴 | `pathlib` 重写更轻 |

**`packages/parsers` 净保留**：1 个工具 + 5 个模式参考；6 个具体 parser 全丢。

### 6.4 `apps/ttpolyglot` 逐目录审计

#### 顶层

| 文件 | 处置 |
|---|---|
| `main.dart` `lib/src/app.dart` `pubspec.yaml` | 🔴 全丢 |

#### `lib/src/core/`

| 目录 | 处置 | 借鉴价值 |
|---|---|---|
| `core/routing/` | 🟡 借鉴 | 命名路由表模式 → React TanStack Router 重写 |
| `core/theme/` | 🟡 借鉴 | Light/Dark 双主题 → Ant Design 5 自带 theme |
| `core/layout/` | 🟡 借鉴 | 响应式 layout → React hooks + Ant Design Layout 重写 |
| `core/services/*_impl.dart` | 🔴 丢 |
| `core/storage/` | 🟡 借鉴 | 平台抽象思路（admin IndexedDB 缓存层可参考） |
| `core/platform/` `core/utils/` `core/widgets/` | 🔴 丢 |

#### `lib/src/features/`

| Feature | 处置 | 借鉴价值 |
|---|---|---|
| `root/` | 🟠 重做 | shell 布局思路保留 |
| `sign_in/` `sign_up/` | 🔴 丢 | 走 Clerk |
| `dashboard/` | 🟡 借鉴 | 首页概念适用，内容完全不同 |
| `projects/` `project/` | 🔴 丢 | i18n 项目管理 |
| `translation/` | 🟡 借鉴 | 编辑器交互形态参考，数据模型不同 |
| `settings/` | 🟠 重做 |

**`apps/ttpolyglot` 净保留**：0 文件代码；约 5 个 UI 交互模式作为设计参考。

### 6.5 顶层与 Claude Code 配置

| 文件 / 目录 | 处置 | 理由 |
|---|---|---|
| `CLAUDE.md` | 🟠 重做 | 新仓全新一份（Python / React / Docker Compose 约定） |
| `.claude/` | 🟢 救 | Hooks / subagents / skills 框架完整迁移 |
| `.claude/hooks/dart-format.sh` | 🟠 重做（→ `python-format.sh`，跑 ruff format） |
| `.claude/hooks/block-generated.sh` | 🟠 重做（阻止列表改 `*.pyc` / `__pycache__` / `alembic/versions/*.py` / `node_modules` / `dist/`） |
| `.claude/agents/getx-architecture-reviewer.md` `flutter-test-writer.md` | 🔴 丢 |
| `.claude/commands/fix-melos-scripts.md` | 🔴 丢 |
| `.claude/commands/new-package.md` | 🟠 重做（Python + JS 双模板） |
| `.serena/` | 🟢 救 |
| `.cursor/` | 🟢 救（视需要） |
| `LICENSE` | 🟢 救 |
| `.gitignore` | 🟠 重做（去 Dart 行，加 Python / Node / Docker） |
| `README.md` | 🟠 重做（本仓加 deprecation note；新仓另写） |
| `melos.yaml` `pubspec.yaml` `pubspec.lock` | 🔴 全丢 |

### 6.6 净保留物：新仓 day-0 种子清单

```
tt-cuisine/                            # 新仓
├── LICENSE                            # ← ttpolyglot/LICENSE 直接搬
├── .claude/                           # ← 选择性迁移
│   ├── settings.json                  # 框架保留，hooks 改 Python
│   ├── hooks/
│   │   ├── python-format.sh           # ← 改写自 dart-format.sh
│   │   └── block-generated.sh         # ← 改写，更新阻止列表
│   ├── agents/                        # ← 全部弃，按需新增
│   ├── commands/
│   │   └── new-package.md             # ← 重写为 Python/JS 双模板
│   └── skills/                        # ← 留空
├── .serena/                           # ← 迁移
├── packages/
│   ├── domain/
│   │   └── tt_cuisine/domain/
│   │       └── language.py            # ← 参考 ttpolyglot/.../language.dart
│   └── nlp/
│       └── tt_cuisine/nlp/
│           └── encoding.py            # ← 参考 ttpolyglot/.../encoding_utils.dart
└── docs/specs/                        # ← 本仓 docs/.../2026-05-21-...md 复制一份作为奠基
```

**实际原样复用**：`LICENSE` 1 个。**翻译/改写迁移**：5-8 个。**作为设计参考但不复制代码**：本设计文档。

### 6.7 本仓归档程序

```
1. 打 tag 标记 pivot 点
   git tag -a v0.1.0-i18n-direction-archive \
     -m "i18n 工具方向最后定格；自此推倒重做"

2. README.md 顶部加 deprecation note，指向 tt-cuisine 新仓
3. 一次 commit 记录归档
4. GitHub 上把本仓 visibility 改为 archived（或保留 public read-only）
5. 不删除分支 / 历史 / issues —— 它们是决策溯源的一部分
```

### 6.8 数字化总结

| 类别 | 文件数 |
|---|---|
| 🟢 救 | 5 |
| 🟡 借鉴 | 12 |
| 🟠 重做 | 9 |
| 🔴 丢 | 100+ |

**复用率约 5%**，与"推倒重做"判定一致。

**最有价值的非代码资产**：本设计文档 / `.claude/` 配置框架 / 端口适配器领域思维 / MCP 服务器选型。

---

## 7. 第 5 节 · 里程碑切片

### 7.1 总览

不按"季度"切，按**离散的产品形态**切。每个里程碑是一个**清晰可演示的产品状态**。时间估算是参考值（1 人 baseline；2 人减半；3+ 边际递减）。

```
M0  ────► M1  ────► M2  ────► M3  ────► (B/C 启动)
地基      贯通      规模      商业化
1-2 月    3-4 月    4-6 月    6-12 月

M0: "Hello, DishConcept"      — 能跑通最小闭环
M1: "100 道菜可 demo"          — 第一次有真实演示价值
M2: "1000 道菜 + 外部客户"     — 第一个 ARR
M3: "10000 道菜 + B 启动"      — 数据资产规模化 + 兄弟产品萌芽
```

| 里程碑 | 主线 deliverable | Success criteria | Exit criteria |
|---|---|---|---|
| **M0** 地基 | 单进程跑通 hello-DishConcept | admin 手工创建 1 个 concept；API 能查到 | 基础组件全跑通；CI green |
| **M1** 贯通 | 8-stage 写路径前 6 stage 跑通 | 100 道经典 CJK 菜入库；编辑可日常工作 | LLM 单 provider 跑通；编辑团队上手 |
| **M2** 规模 | TTPOS 真实接入 + 1000 concept + 商业化 | 1000 concept；1 个付费/试用客户；MRR ≥ ¥1k | pgvector 消歧；多 provider 降级链；计费稳定 |
| **M3** 商业化 | 数据资产规模化 + B 启动 + 自部署 | 10000 concept；MRR ≥ ¥50k；自托管首客；B MVP | B 最小闭环跑通；A 授权合同模板就绪 |

### 7.2 M0 · 地基（"Hello, DishConcept"）

**Deliverables**：
1. 仓库 scaffolding（uv workspace / Docker Compose / GitHub Actions / 本仓 deprecation note + tag）
2. 数据层（Alembic 迁移 wiki_core 最小表 concepts + dish_names；pgvector/pg_trgm/unaccent extensions）
3. Domain 层（DishConcept + DishName Pydantic 模型；Language enum）
4. Read Service（FastAPI skeleton；`GET /api/v1/concepts/{slug}`；OpenAPI）
5. Admin Web（React + Vite + AntD + TanStack Router；Clerk 登录；单页 list/create/view）
6. 部署（`docker compose up` 全栈跑通 + README）

**Success Criteria**：
- `docker compose up` 后 admin web 能登录
- admin web 创建 "宫保鸡丁" 含 5 语别名
- `curl /api/v1/concepts/gong-bao-ji-ding` 返回 JSON
- CI 全绿
- 设计文档迁移到新仓 `docs/specs/`

**Exit Criteria**：
- 上述全勾
- 至少 1 个真实编辑账号能登录
- domain 单元测试 + 1 个端到端集成测试
- 结构化 JSON log

**严禁出现**：LLM 调用、TTPOS 接入（含 mock）、写路径管道、Meilisearch 索引接入、Ingredient/CookingMethod 实体、worker 进程。

**决策点**：仓库可见性 / Alembic 迁移粒度 / Clerk vs 自建 Auth / AntD 主题色。

**团队**：1 人 6-8 周 / 2 人 3-4 周。

### 7.3 M1 · 贯通（"100 道菜可 demo"）

**Deliverables**：
1. 领域模型扩展（DishConcept 完整字段 + Ingredient/CookingMethod/CuisineRegion/AllergenTag 实体 + ConceptRevision）
2. 写路径管道 Stage 1-6（暂跳 7-8）：
   - Stage 1: TTPOS mock adapter（CSV/JSON 文件）
   - Stage 2-3: 规范化 + 候选抽取（规则 + jieba）
   - Stage 4: 消歧（字符 + 拼音相似；**不上 embedding**）
   - Stage 5: 编辑审核界面
   - Stage 6: LLM 单 provider (DeepSeek) 多语补全 + 描述生成
3. LLMProviderPort 起步（LiteLLM 集成；仅 DeepSeek；prompt 模板 v1；审计日志）
4. Worker 进程（Dramatiq + Redis；actor 表达 stage；PG 状态字段流转）
5. Admin Web 扩展（候选审核界面；DishConcept 编辑器；Revision 时间线）
6. Public API v1 alpha：5 个核心 endpoint
7. 数据：100 道 CJK 经典菜 + 100 ingredient + 20 cookingMethod

**Success Criteria**：
- 100 道菜入库，每道含中日韩英 4 语别名 + 配料 + 工艺 + 菜系 + 过敏原
- 编辑审核界面可日常工作（≥ 1 真实编辑能上手）
- 从 mock TTPOS → 候选 → 审核 → 发布 → API 查到 端到端跑通
- 5 个 endpoint + OpenAPI 文档
- 5 分钟 demo 视频

**Exit Criteria**：
- 100 道菜质量编辑评 ≥ 4/5
- LLM 多语补全人工修改率 ≤ 30%
- 编辑日均产能 ≥ 5 道菜
- TTPOS 真实接入协议谈妥

**严禁出现**：pgvector / 多 LLM provider / Temporal / 自托管 / 计费 / B/C 任何代码。

**决策点**：第一批菜系覆盖 / 数据质量基准 / TTPOS 接入时间窗 / 编辑团队招募策略。

**团队**：2 人 12-16 周 / 3 人 8-10 周。

### 7.4 M2 · 规模（"1000 道菜 + 外部客户"）

**Deliverables**：
1. 写路径管道 Stage 7-8 完整（终审 / 索引 / 缓存失效 / 事件广播；每 stage 可单独重跑）
2. 消歧升级（pgvector + sentence-transformers BAAI/bge-m3；多策略融合）
3. LLM 多 provider（DeepSeek + Qwen + Kimi + GPT-4o-mini；降级链 + 任务级路由；数据驻留合规；prompt 模板 v2 + a/b 测试）
4. TTPOS 真实接入（500 餐厅；合规审计日志）
5. Meilisearch 索引（CJK 分词；增量同步；跨语言别名搜索）
6. 计费 + API key（HMAC + rate limit + quota；Stripe + 国内方案；月度账单 + 用量看板）
7. Snapshot 导出（增量/全量/子集授权；对账机制）
8. 数据扩张：1000 concept / 500 ingredient / 50 cookingMethod / 100 cuisineRegion
9. 监控升级（Prometheus + Grafana + Sentry + 业务指标看板）

**Success Criteria**：
- 1000 高质量 DishConcept
- ≥ 1 外部 API 客户（试用或付费）
- MRR ≥ ¥1k
- TTPOS 真实数据流稳定 ≥ 4 周
- Read API 可用性 ≥ 99.5%

**Exit Criteria**：
- ≥ 3 inbound 商业咨询
- 数据资产授权合同模板就绪（法务过）
- 编辑日产能 ≥ 20 道菜（≥ 3 编辑）
- 单笔最大合同 ≥ ¥10k

**严禁出现**：B/C 任何代码 / K8s / 微服务拆分 / 自托管代码 / 移动 app。

**决策点**：计费货币 / 数据授权模式 / 合规重点国家 / 编辑团队拆不拆 / TTPOS 合作分成模型。

**团队**：4 人 16-20 周 / 5 人 12-16 周。

### 7.5 M3 · 商业化（"10000 道菜 + B 启动"）

**Deliverables**：
1. 数据规模：10000 DishConcept / 2000 ingredient / 100 cookingMethod / 5000 TTPOS 餐厅
2. 自托管能力（Helm chart 完整 + 私部署文档 + ≥ 1 大客户私部署成功）
3. 商业化深化（MRR ≥ ¥50k；≥ 3 付费客户；合规审计通过）
4. **B 产品 day-1**（新 service `tt-cuisine-menu-service`：订单系统 → 机翻初稿（调 A API） → 人审 → 交付；首批 5-10 餐厅订单；MVP demo）
5. **C 产品种子**（200 道菜 ground truth 评测集；当前 LLM 跑 baseline；商业可行性内部评估）
6. 平台演化评估（Temporal / 读写 DB 分离 / K8s 三选一或都不上）
7. 团队（编辑 5-10；后端 2 / 前端 1 / 商务 1 / 合规 1）

**Success Criteria**：
- 10000 DishConcept
- MRR ≥ ¥50k
- 自托管首批客户 ≥ 1
- B MVP 完整闭环可演
- C 评测集 + baseline 报告

**Exit Criteria**：
- 12 个月内 ARR 路径清晰（≥ ¥1M ARR 视为可融资/可独立运营）
- 团队月度流失 < 20%
- A 平台稳定性 ≥ 99.9%

**M3 之后**：进入持续运营，按季度 OKR / 商业目标管理。

### 7.6 跨里程碑红线（"什么时候要停下来回到设计"）

| 红线 | 信号 | 应对 |
|---|---|---|
| 领域模型撞墙 | M1 末发现 DishConcept 字段不够 | 停下扩展领域模型，不要 ad-hoc 加字段 |
| 消歧失败率 > 50% | M1 末编辑全要手动 | 重评估 Stage 4 算法栈；提前上 embedding |
| LLM 成本失控 | 单 concept 建库成本 > ¥10 | 重评估 provider 路由 + 缓存策略 |
| TTPOS 数据合规出问题 | M2 中发现菜单不能跨用 | 重评估冷启动策略 |
| 编辑团队招不到 | M1 中发现餐饮+多语审核人才稀缺 | 重评估"团队 vs 社区 vs LLM" |
| 客户不愿付钱 | M2 末 0 付费客户 | 重评估"数据资产 vs 服务"哪个先 monetize |
| 数据资产被复制 | M3 发现 API 被爬走整库 | 反爬 + 授权机制升级 |

### 7.7 时间线与资金需求（参考）

| 阶段 | 1 人 baseline | 团队 | 资金需求 |
|---|---|---|---|
| M0 | 6-8 周 | 1-2 人 | ¥0-50k |
| M1 | 12-16 周 | 2-3 人 | ¥100-300k |
| M2 | 16-20 周 | 4-5 人 | ¥500k-1M |
| M3 | 24-48 周 | 8-12 人 | ¥2-5M |

**单人/小团队 bootstrap 路径**估算。融资加速可压一半，但 M0/M1 是**领域知识积累期**，没人能用钱买掉。

---

## 8. 第 6 节 · 风险与反模式

### 8.1 风险全景

按"影响 × 概率"分类。右上角的**高影响 + 高概率**才是 day-1 就要动手的；其余是 day-1 写进 contingency plan。

```
        高影响
          │
          │  · TTPOS 商业失败拖累冷启动     · 数据被竞品复制
          │  · 编辑团队招不到                · LLM 成本失控
          │  · 客户不愿为数据资产付费       · 消歧失败率 > 50%
          │
          │─────────────────────────────────────────
          │
          │  · 单点 LLM provider 故障       · CJK 原生赌注被时代推翻
          │  · 元风险: 沉没成本诱惑         · 三件产品独立性假设崩塌
          │
        低影响 ────────────────────────────► 高概率
```

### 8.2 算法 / 技术风险

#### 8.2.1 消歧失败率太高

- **描述**：Stage 4 "50 种'宫保鸡丁'写法合并为 1 个 concept" 是 NLP 30 年未完全解决的问题；CJK 更难（无空格分词 + 方言 + 错别字 + 拼音变体）
- **触发信号**：M1 末编辑日均产能 < 3 道；MergeProposal 自动通过率 < 60%
- **缓解**：day-1 多策略融合（字符 + 拼音 + 配料 co-occurrence + 餐厅菜系 prior）；每策略打置信度分；算法版本号 + 重跑能力 day-1 就有
- **应急**：提前到 M1 引入 embedding；把低置信度 candidate 主动推编辑；极端情况改"算法初筛 + 全人工二审"

#### 8.2.2 LLM 幻觉 / 错配料 / 编造别名

- **描述**：LLM 自信地编造不存在的小语种译名 / 虚构配料 / 虚构典故；CJK 小语种（越南语、泰语）幻觉率更高
- **触发信号**：编辑修改 LLM 输出字符比例 > 50%；事后发现已发布数据是 LLM 编造
- **缓解**：LLM 输出永远带 `source/model/version/confidence` provenance；publish 必须经编辑明确 approve；小语种走"严格 ground"模式（要求参考来源 + 母语者二审）；prompt 强制"不确定请说 unknown"
- **应急**：M2 启动时 200 道 ground truth 评测集；发现编造数据立即 deprecate + 修订 + 通知下游 API 客户

#### 8.2.3 Embedding 在 CJK 上质量参差

- **描述**：BAAI/bge-m3 是 SOTA 之一但在菜品短文本垂类上不一定有用；同义不同字距离可能比同字异义还远
- **触发信号**：M2 引入 embedding 后消歧 F1 不升反降
- **缓解**：embedding 是多策略融合的一项不是替代品；M2 启动跑评测集对比有/无 embedding 的 baseline；备选 OpenAI text-embedding-3-large 或自训练（M3+）
- **应急**：不上 embedding；靠字符 + 拼音 + 配料启发式撑到 M3

#### 8.2.4 数据规模超出 PG 处理能力

- **描述**：sizing 基于均匀分布假设；热点 concept（如"宫保鸡丁" 5000 个 raw items）可能出问题
- **触发信号**：read API p99 > 500ms；某 concept 查询 > 1s
- **缓解**：raw 表按 conceptId 分区 schema 留余地（PG declarative partitioning）
- **应急**：读写分离 + replica；极端情况 Citus 分片（M3+）

### 8.3 数据 / 合规风险

#### 8.3.1 TTPOS 数据使用权法律灰色

- **描述**：合约说"平台拥有数据"，但菜单可能含商业秘密（独家菜 / 定价策略）；中国 PIPL / 日本不正竞争防止法 / 欧盟 GDPR 各有约束
- **触发信号**：M2 餐厅起诉/投诉；出海合规咨询拦下
- **缓解**：day-1 把数据使用权写进 TTPOS 餐厅合约；全链路 audit trail；day-1 区分**事实数据**（菜名/配料/工艺：可商用）和**衍生数据**（价格分布/流行度：另列条款）；私域数据（VIP 备注/内部成本）永远不进 A
- **应急**：法务模板 day-1 准备；真出问题 deprecate 涉及 concept + 公开声明数据来源

#### 8.3.2 跨国数据驻留（GDPR / PIPL）

- **描述**：M2 出海日韩美时，海外客户访问意味着区域数据驻留；中国境内数据走境外 LLM 违法
- **触发信号**：海外客户合规检查；中国客户合规清单
- **缓解**：LLMProviderPort 的"数据驻留合规检查" day-1 有 placeholder；文档化 provider 区域数据中心；架构留余地（区域 read replica）
- **应急**：按客户 IP 路由 provider（缓冲，不是合规方案）；真合规要重设部署拓扑

#### 8.3.3 用户隐私（菜单含手写注释 / 特殊客户标记）

- **描述**：POS 菜单可能混入"VIP 客户备注""不要香菜（客户 A）"
- **触发信号**：发现 raw item 含 "Mr.王不吃辣" 这类文本
- **缓解**：Stage 2 day-1 就有敏感字段过滤（PII 正则 + LLM 兜底）；含 PII 直接打标记不进 Stage 3+
- **应急**：历史数据漏过 → 回溯过滤 + 通知 TTPOS

### 8.4 商业 / 市场风险

#### 8.4.1 数据资产授权市场太小 / 不存在

- **描述**：垂类数据授权市场是个未经验证的假设——餐厅老板觉得菜名是公共知识；外卖平台自己有数据；AI 公司用 GPT-4 直翻就行
- **触发信号**：M2 末 0 付费客户；销售周期 < 3 个 inbound
- **缓解**：day-1 就有 5 个潜在客户访谈（外卖平台 / 酒店集团 / 餐饮 SaaS / AI 公司 / 留学旅游）——问痛点不问要不要买；M0 末有"客户画像 doc"；M1 末就要 outbound
- **应急**：切首战场到 B（菜单本地化服务）——有明确买家（出海餐厅）；A 降级为 B 的内部资产

#### 8.4.2 客户不愿为"看似公共信息"付费

- **描述**：Wikipedia 是免费的，凭什么你收费？
- **触发信号**：客户说"这数据网上都能爬到"
- **缓解**：价值主张是"高质量 + 跨语言一致 + 可商用授权 + 实时增量 + SLA"，不是"数据"；与 Wikipedia 差异：Wiki CC BY-SA 不可商用，你的授权商用 friendly；day-1 有"Wikipedia 比对"营销材料
- **应急**：Freemium——小流量免费，大流量 + 商用 + SLA 收费

#### 8.4.3 竞品（Google / OpenAI 突然免费）

- **描述**：M3 时 Google Translate 升级菜单 mode 或 OpenAI / 字节 / 阿里推免费餐饮多语 API
- **触发信号**：媒体新闻；竞品官网更新
- **缓解**：护城河是数据质量 + 编辑团队 + provenance，不是技术；带审核签名的数据可作法律证据；垂类纵深（"豆腐脑在旧金山华人区叫什么"通用模型不知道）
- **应急**：公开发布技术评测；输了的话转向"垂直得更深"（只做 CJK + 出海中餐）

#### 8.4.4 TTPOS 商业失败拖累冷启动

- **描述**：A 假设 TTPOS day-1 500 餐厅 → M2 5000；如果 TTPOS traction 不行飞轮启动不了
- **触发信号**：M1 中段 TTPOS 实际签约 < 计划 50%
- **缓解**：day-1 不 100% 依赖 TTPOS；M1 中段就有 plan B（手工录入 + 外购菜品数据 + 公开数据爬取）；与 TTPOS 商务月度 sync
- **应急**：cold start 策略调整：原"TTPOS 100%" → "TTPOS 30% + 手工 50% + 公开 20%"

### 8.5 团队 / 运营风险

#### 8.5.1 餐饮 + 多语审核人才稀缺

- **描述**：需要"懂川菜 + 会日语审核"这种交叉人才；不是普通翻译，不是普通厨师
- **触发信号**：M1 招 1 全职编辑 3 月招不到；候选人不知"宫保鸡丁有花生"
- **缓解**：day-1 把编辑当 product user 设计；招募策略（餐饮专科 + 留学生 + 海外华人 + 退休大厨）；LLM 辅助降低门槛
- **应急**：分工细化（餐饮专家审菜名+配料 / 翻译专家审多语 / 两班接力）；极端情况外部协作（Wiki 模式 + 报酬）

#### 8.5.2 编辑培训成本高

- **描述**：新编辑 2-4 周培训才能独立审核；M2 加 5 编辑培训占 1 全职
- **触发信号**：M2 中段新编辑日产能 < 老编辑 50%
- **缓解**：day-1 有"入职手册"；admin UI in-context help / 常见错误 hint；mentor 配对
- **应急**：工作流拆分（新编辑只做易任务 / 难任务留资深）

#### 8.5.3 单人 / 小团队跨技术栈过度

- **描述**：M1 一个人兼 Python + React + DevOps + 编辑管理 + 商务/合规，每件都拖延
- **触发信号**：M0 末未交付；M1 中段连续 2 周无进展
- **缓解**：M1 启动前必须招到第 2 人，否则不启动 M1；M0 success criteria 之一是"≥ 2 常驻成员"；商务/合规可外包咨询
- **应急**：M1 时间线 ×1.5；功能砍 50%；坚持质量不降

### 8.6 数据被复制 / 流出风险

#### 8.6.1 爬虫盗取整库

- **触发信号**：API 单 IP 调用量异常；GitHub 出现别人发布的 cuisine multilang dataset
- **缓解**：API 层 day-1 rate limit + IP 黑名单 + 异常检测；**数据指纹**（publish 时主动注入无害但唯一的标记）；API 协议禁止重发布
- **应急**：法务发函 + 增量加密分发；已被拿走整库 infeasible 完全追回，诉讼 + 后续加强保护

#### 8.6.2 内部员工导出

- **触发信号**：员工离职前 30 天 DB 查询量异常
- **缓解**：admin 角色权限细粒度（编辑只看自己审过的）；DB 读副本不下发给开发；操作 audit log
- **应急**：劳动合同含保密 + 离职审计

#### 8.6.3 API 客户 dump 整库

- **触发信号**：单客户单月调用 > 全库容量；订阅取消后无续费
- **缓解**：snapshot 导出端点 quota + 单独定价（远高于按调用）；协议层禁止重发布；停付后必须删除已下载（合同 + 审计权）
- **应急**：法律手段 + 改产品策略（subscription only 不卖 dump）

### 8.7 元风险（about 推倒重做 本身）

#### 8.7.1 "推倒重做"的代价被低估

- **描述**：判断是"现有代码 95% 报废"，但实际跑会发现 brainstorm 没看见的隐性资产（debug 经验 / 已知坑 / 客户验证）
- **触发信号**：M0 实际花了 12 周而不是 6-8 周
- **缓解**：时间估算 ×1.5；M0 启动 4 周后做"现实对比"，差 30% 就降 scope
- **应急**：砍 M0 deliverables（Admin Web 1 页而非 3；API 1 endpoint 而非 2）

#### 8.7.2 三件产品独立性假设崩塌

- **描述**：跑下去发现 B 需要 A 的特定数据结构；C 需要 A 的内部 candidate 数据；独立性变成一厢情愿
- **触发信号**：M3 启动 B 时发现"必须先在 A 加非 A 自己需要的字段"
- **缓解**：架构纪律 §4.9.4——API v1 上线后 2 年不破坏；day-1 把 A 的 public schema 和 internal schema 分清楚，B/C 只能依赖 public
- **应急**：B/C 自己建独立的"领域适配层"，从 A 的 public API 拉数据后内部转换

#### 8.7.3 CJK 原生赌注被时代推翻

- **描述**：M2 时 Claude 5 / GPT-5 在 CJK 上反超国内模型；"CJK 原生"作为差异化失效
- **触发信号**：评测集上 GPT-5 比国内模型高 ≥ 5%
- **缓解**：赌注不止"模型"还有"数据 + 工程 + 团队"；LLMProviderPort 设计天然支持快速切换 provider
- **应急**：投资定位转向"垂类数据资产 + 工程化餐饮翻译流程"，不再强调"CJK LLM"

#### 8.7.4 沉没成本的诱惑

- **描述**：最危险的元风险。M2 末 0 付费客户但已投 1 年 50 万——直觉是"再做半年市场就开了"——可能 90% 错
- **触发信号**：M2 exit criteria 全部不达，但正在"调整 sizing 重定义 M2 exit"
- **缓解**：exit criteria 在 M0 末就钉死，不允许 M2 中段修订；独立顾问每季度评一次产品 status
- **应急**：砍 50% + 转 B（菜单服务）作为首战场重启；或彻底关闭

### 8.8 反模式清单

**开发节奏类**：

1. **过早抽象**：数据 < 100 时纠结 schema 完美性。100 例才能感受到 schema 边界。M1 之前允许"不完美"标签字段
2. **过早扩展**：M0 想 K8s / 微服务 / 多 provider。day-1 单机；M2 之前不拆 service；M3 之前不上 K8s。每次想优化先问"M2 之前真的需要吗？"
3. **过早自动化**：工作流没跑过手工就先建自动审批。让编辑手工跑 100 工单后自动化优先级会重排
4. **追求技术完美而非业务进展**：Stage 4 算法死磕 3 月导致 M1 延期半年。F1 70→85% 的边际价值通常低于"M1 提早 2 月上线"

**产品决策类**：

5. **过度信赖 LLM**：LLM 输出直接发布到 Wiki。LLM 是 candidate 生成器不是 publisher；publish 必须有人
6. **忽略地区差异**：把所有 CJK 当一个市场。日本愿为高质量本地化溢价；中国愿为便宜大量付费；韩国愿为美容/健康付费
7. **混淆 A/B/C 边界**：A 代码里偷写 B 逻辑（"反正都是同一项目"）。边界 day-1 不硬，M3 无法独立交付 B

**团队 / 运营类**：

8. **忽视编辑团队的工程化**：把编辑当成本而非 product user。编辑用得不爽 → 产能下降 → 数据质量下降 → 整个产品塌方。**编辑 UI 应投入与公开 API UI 相同工程量**
9. **不留 audit trail**：消歧决策 / LLM 调用 / 合并操作没记录。M3 大客户合规审计无法回答"这条数据来自哪里？谁审的？什么时候？"——失去合同
10. **过度依赖单一 LLM provider**：M1 单 provider 但**架构准备好多 provider**（LiteLLM 已统一）；M2 立即接第二个

### 8.9 风险监控机制

```
每日 (admin web dashboard):
  · concept 增长曲线
  · 编辑日产能（按编辑）
  · MergeProposal 自动通过率
  · LLM 调用量 + 成本
  · API 错误率 + p99

每周 (创始人 review):
  · 上述指标 vs 目标
  · TTPOS 接入进展
  · 客户 outbound 进展 (M1+)
  · 编辑团队反馈

每月 (内部 retrospective):
  · 红线检查 (§7.6)
  · 风险表 (§8.2-8.7) 逐项 review
  · 反模式清单 (§8.8) 自查
  · M0-M3 exit criteria 进展

每季度 (独立顾问 review):
  · 商业进展是否符合假设
  · 是否触发"切首战场"或"关闭项目"红线
  · CJK 赌注是否仍然成立
```

### 8.10 这次 brainstorm 没覆盖的"已知未知"

为完整性记录——下次设计时要补：

1. 国际化部署细节（M3 跨区域拓扑、数据驻留、CDN、合规分区）
2. OpenAPI 客户 SDK 策略（Python / JS / Go / Java 各出官方 SDK？）
3. API 安全细节（OAuth flow / scoped key / API key rotation）
4. 数据库灾备（region failover / PITR / RPO/RTO 目标）
5. C 产品具体形态（SaaS API / fine-tuned model license / agent 框架）
6. B 产品人审流程详细（付费确认 / 争议仲裁 / SLA 承诺）
7. TTPolyglot 公司本身（股权 / 融资 / 团队薪酬结构）

day-1 写这些只是 yak shaving。

---

## 9. Brainstorm 收尾

本设计文档 6 个 section 全部收敛，可作为 writing-plans 阶段输入。

**核心判断回顾**：

- **产品**：从通用 i18n 工具 → 菜品垂类多语言语料库
- **首战场**：A · 菜品维基（三件独立产品之一）
- **冷启动**：TTPOS 结构化菜单数据反哺
- **技术栈**：Python (FastAPI + Dramatiq) + React (Vite + AntD) + PostgreSQL + Meilisearch + Redis + LiteLLM
- **仓库**：新仓 `tt-cuisine`，本仓 `ttpolyglot` 归档
- **里程碑**：M0 地基 → M1 贯通（100 道菜可 demo） → M2 规模（1000 道菜 + 外部客户） → M3 商业化（10000 道菜 + B 启动）
- **复用率**：现有代码 ≈ 5%（推倒重做的预期结果）

**写下来不等于做下来**。下一步是把 M0 这一段切成可执行的 implementation plan（task 拆解 + 顺序 + 检查点）。这是 writing-plans skill 的工作，不是 brainstorming 的工作。

### 9.1 待 sizing 的产品参数（不改变设计，只影响 sizing）

- **首批菜系覆盖范围**（中餐 only vs CJK 混合 vs 多元）—— 取决于 TTPOS 客户菜系分布
- **目标语种范围**（中日韩英 only vs 含越泰马来 vs 全球）—— 取决于 TTPOS 客户出海方向
- **私有部署支持时间窗**（M2 vs M3 vs 永不）—— 取决于商业客户结构

这些 sizing 参数**不改变本文已定的领域模型与架构骨架**，只影响里程碑 sizing 和团队 sizing。在 M0 启动前再回头钉，不必现在决。

### 9.2 文档读者指引

- **如果你要做 M0 实施**：跳到 §7.2，配合 §3（领域模型）+ §4（架构骨架）+ §5（技术栈）
- **如果你要评估投入产出**：读 §0（产品定位）+ §7.7（资金需求）+ §8（风险）
- **如果你要质疑这次 pivot 是否对**：读 §0.1（为何推倒）+ 附录（决策溯源）
- **如果你要给团队 onboarding**：读 §0-§2，让人理解产品脸面；再读 §4.9（架构纪律）和 §8.8（反模式）作为日常红线

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
