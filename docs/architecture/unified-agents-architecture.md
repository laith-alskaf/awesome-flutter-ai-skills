# مقترح البنية الموحدة تحت `.agents/`

## القرار المعماري المقترح

اعتمد `.agents/` بوصفه **الجذر الوحيد** لكل ما يتعلق بتشغيل الوكيل داخل مشروع Flutter. هذا القرار يزيل الفرق المربك بين `.agent/` و`.agents/`، ويجعل المسارات الأصلية التي تتعرف إليها Antigravity (`.agents/skills/` و`.agents/rules/`) جزءاً من بنية واحدة متماسكة.[1] [2]

لا يعني ذلك أن Antigravity يقرأ تلقائياً كل ملف يوضع تحت `.agents/`. الاكتشاف الأصلي موثق للمهارات والقواعد فقط. لذلك يجب أن تحتوي القاعدة قصيرة المدى في `.agents/rules/` على مراجع صريحة إلى الحوكمة والحالة، وأن تُضبط من لوحة Antigravity بطريقة تفعيل تناسب الفريق. بهذه الطريقة تكون الملفات الأخرى منظمة تحت نفس الجذر من دون ادعاء أن المحرر يحمّلها تلقائياً.[2]

## البنية المستهدفة

```text
<flutter-project>/
├── .agents/
│   ├── rules/
│   │   ├── flutter-project-operating-contract.md
│   │   ├── flutter-project-files.md
│   │   └── flutter-ci-and-release.md
│   ├── skills/
│   │   ├── flutter-agent-memory/
│   │   ├── flutter-create-feature/
│   │   └── <one-direct-skill-folder-per-skill>/
│   ├── governance/
│   │   ├── AGENTS.md
│   │   ├── ROUTER_MANIFESTO.md
│   │   ├── PERSONAS.md
│   │   ├── GOVERNANCE.md
│   │   ├── PERFORMANCE_METRICS.md
│   │   ├── ROUTING_EVALUATION.md
│   │   └── resources/
│   ├── context/
│   │   ├── PROJECT_PROFILE.md
│   │   ├── CURRENT_STATE.md
│   │   ├── KNOWLEDGE_INDEX.md
│   │   ├── AGENTS_MEMORY.md
│   │   └── SESSION_LOG.md
│   ├── tools/
│   │   ├── verify_architecture.dart
│   │   └── audit_framework.dart
│   └── framework-manifest.json
├── .github/copilot-instructions.md
├── .cursorrules
├── .windsurfrules
├── .clinerules
├── .codex/instructions.md
├── pubspec.yaml
└── lib/, test/, integration_test/, CI
```

| المجلد | المسؤولية | آلية التحميل أو الاستعمال | قاعدة الانضباط |
|---|---|---|---|
| `.agents/rules/` | نقطة الدخول والقيود الدائمة أو المشروطة | Antigravity workspace rules | اجعل القاعدة قصيرة، موجهة، ولا تكرر محتوى الحوكمة أو المهارات. |
| `.agents/skills/` | الإجراءات المتخصصة | اكتشاف metadata ثم تفعيل `SKILL.md` عند الملاءمة | مهارة واحدة مباشرة في كل مجلد؛ لا تستخدم مجلدات قطاعات متداخلة داخل المسار المثبت. |
| `.agents/governance/` | السياسات المشتركة والراوتر والشخصيات | تشير إليها قواعد المشروع عند الحاجة | حوكمة لا ذاكرة تشغيلية؛ لا تعدلها لخدمة feature منفردة من دون قرار. |
| `.agents/context/` | حقائق المشروع وحالة العمل والتسليمات | تقرأها القاعدة أو skill الذاكرة عندما تكون موجودة وذات صلة | لا تسجل كل تعديل صغير؛ احتفظ فقط بالسياق الدائم أو متعدد المراحل. |
| `.agents/tools/` | أدوات تحقق مرتبطة بالإطار | تستدعى صراحة من skill أو قاعدة | لا تدّعِ نجاح اختبار لم يُنفّذ. |
| `.agents/framework-manifest.json` | تعريف النسخة والمصدر وحالة التثبيت | يقرأه المهيئ وأداة الترقية | يسجل commit أو tag المصدر، عدد المهارات، وقت التثبيت، وبنية المخطط. |

## قاعدة Antigravity الأساسية

ينشئ المهيئ الملف `.agents/rules/flutter-project-operating-contract.md`. يجب أن يكون هذا الملف نقطة الدخول الوحيدة عالية المستوى، وأن يوجه الوكيل إلى الملفات الأخرى بدلاً من تحميلها أو تكرارها كلها. تقترح القاعدة النص التالي، مع الحفاظ عليه مختصراً:

```markdown
# Flutter project operating contract

For non-trivial work, inspect `pubspec.yaml`, the affected feature, relevant tests and CI.
When available and relevant, read:
- @/.agents/context/PROJECT_PROFILE.md
- @/.agents/context/CURRENT_STATE.md
- @/.agents/governance/AGENTS.md
- @/.agents/governance/ROUTER_MANIFESTO.md

Use the smallest relevant skill set from `.agents/skills/`. Preserve the state-management and architecture established by the affected feature. Ask focused questions only when an answer could change architecture, security, data, external contracts, dependencies, or user-visible behavior. For a reversible low-risk change, state the assumption, make the smallest safe change, and validate it.

Record decisions, evidence, validation, and next action in `.agents/context/CURRENT_STATE.md` only for material or multi-phase work.
```

اضبط هذه القاعدة كـ **Always On** إذا كان الفريق يريد حوكمة موحدة في كل مهمة، أو **Model Decision** إذا كانت غالبية الاستخدامات استكشافية وخفيفة. لا تستخدم قاعدة ضخمة Always On؛ Antigravity يفرق بين القواعد الدائمة والمهارات التخصصية، ولكل Rule حد حجم معلن.[2]

## تسلسل الأولويات

| الأولوية | مصدر الحقيقة | لماذا |
|---|---|---|
| 1 | طلب المستخدم والقيود المباشرة | يحدد الهدف الفعلي ولا يجوز استبداله بسياسة عامة. |
| 2 | `pubspec.yaml`، الكود المتأثر، الاختبارات، CI | تمثل الواقع التقني الحالي للمشروع. |
| 3 | `.agents/context/PROJECT_PROFILE.md` | يثبت قرارات المشروع المعتمدة عندما لا تناقض الكود. |
| 4 | `.agents/context/CURRENT_STATE.md` | يربط العمل المستمر وقراراته وتحققه. |
| 5 | `.agents/governance/AGENTS.md` و`ROUTER_MANIFESTO.md` | يحدد طريقة القرار والاختيار بين المهارات. |
| 6 | `.agents/skills/*` | يحدد الإجراء المتخصص بعد التعرف على نوع المهمة. |
| 7 | ملفات محولات المحررات في الجذر | توصل العقد للمحررات الأخرى ولا تكون مصدراً مستقلاً متعارضاً. |

## عقد التوافق مع Antigravity

Antigravity يكتشف المهارات في `<workspace>/.agents/skills/<skill-folder>/` والقواعد في `<workspace>/.agents/rules/`، بينما `.agent/*` مسار توافق خلفي وليس أساس البنية الجديدة.[1] [2] لذلك يعتمد النموذج الموحد على ما هو أصلي للمحرر بدلاً من الاحتفاظ بمجلد ثانٍ لحقائق المشروع.

لا تُنسخ قواعد صيانة مستودع المهارات نفسه إلى تطبيق Flutter. يحتاج التطبيق قواعد تشغيل مختلفة تشير إلى سياقه وحوكمته. تحتفظ قواعد Cursor وCopilot وCline وWindsurf وCodex بأسمائها المتوقعة، لكنها لا تكرر السياسة؛ تشير ببساطة إلى `.agents/` وبنفس ترتيب الأولوية أعلاه.

## خطة الترحيل الآمن

| المرحلة | تغيير المهيئ | حماية البيانات | شرط القبول |
|---|---|---|---|
| 0. الإصدار التحضيري | أضف دعم قراءة `.agents/context/` بالتوازي مع `.agent/` عند وجود مشروع قديم. | لا تنقل ولا تحذف تلقائياً. | يستطيع الوكيل العمل مع الهيكلين ويعطي الأفضلية للهيكل الموحد إذا كان مكتملًا. |
| 1. الإصدار الموحد الجديد | اكتب كل التثبيتات الجديدة إلى `.agents/` فقط، وأنشئ القواعد والـ manifest. | استعمل `-Force` فقط للكتابة فوق ملف managed صراحة. | مشروع جديد يحتوي `.agents/skills` و`.agents/rules` و`.agents/context` و`.agents/governance`. |
| 2. ترحيل المشروع القديم | أضف `-MigrateLegacy` ينقل `.agent/` إلى `.agents/` عبر نسخ مرئي ثم تحقق ثم إعادة تسمية النسخة القديمة إلى `.agent.backup-<date>`. | لا حذف تلقائي؛ توقف عند التعارضات واطلب قراراً. | لا يضيع أي ملف، ويشير كل adapter إلى المسارات الجديدة. |
| 3. توحيد التوثيق والعقود | حدّث كل skills والقوالب والـ README والمدقق وCI. | يظل دعم القراءة للقديم في فترة معلنة فقط. | لا تظهر مراجع كتابة إلى `.agent/` في مشروع جديد، والمدقق يرفضها. |
| 4. إيقاف التوافق الخلفي | بعد فترة انتشار وإصدار رئيسي، اجعل `.agent/` مدعوماً للقراءة فقط ثم أزل الدعم وفق سياسة deprecation. | يظل `-MigrateLegacy` متاحاً لإصدار واحد على الأقل. | CI يثبت التثبيت الجديد والانتقال من نسخة قديمة. |

## تغييرات المهيئ المطلوبة

1. استبدل `$agentDir = Join-Path $ProjectPath ".agent"` بالجذر `$agentsDir = Join-Path $ProjectPath ".agents"` وحدد داخله `rules`, `skills`, `governance`, `context`, و`tools`.
2. انسخ `core/` إلى `.agents/governance/` و`tools/` إلى `.agents/tools/`، وأنشئ state files في `.agents/context/`.
3. أنشئ قاعدة مشروع Antigravity في `.agents/rules/`، مع تذكير المستخدم بضبط تفعيلها في واجهة Antigravity عند الحاجة.
4. أنشئ `framework-manifest.json` بعد تحقق ناجح، واحفظ إصدار الإطار وcommit المصدر والمسارات وعدد المهارات.
5. غيّر adapters في الجذر لتشير إلى `.agents/context` و`.agents/governance` و`.agents/tools` فقط.
6. لا تستخدم `-Force` على state أو adapters المخصصة في إعادة التشغيل؛ فرق بين ملف **managed** يملكه المهيئ وملف **user-owned** يملكه الفريق.
7. أضف `-MigrateLegacy` و`-DryRun` و`-Force` بعقود منفصلة وواضحة.

## اختبارات القبول

| الاختبار | ما يثبت |
|---|---|
| تثبيت مشروع جديد على Windows | مسار المهارات مباشر، القاعدة موجودة، الحوكمة والسياق والأدوات داخل `.agents/` فقط. |
| إعادة تشغيل بدون `-Force` | لا تتغير ملفات `context/` ولا adapters المعدلة من الفريق. |
| `-MigrateLegacy -DryRun` | يعرض خريطة النقل والتعارضات بلا كتابة. |
| `-MigrateLegacy` | ينشئ النسخة الجديدة والنسخة الاحتياطية من `.agent/` ويحدّث الروابط. |
| مدقق المستودع | يمنع مراجع `.agent/` في عقد التثبيت الجديد ويسمح بها حصراً ضمن مهاجر التوافق والوثائق الانتقالية. |
| اختبار Antigravity حي | يظهر rule المشروع و55 skill في الجذر الصحيح؛ يوثق نوع التفعيل والبيئة والنتيجة. |

## القرار المطلوب قبل التنفيذ

هذه الخطة توصي باعتماد `.agents/` حصراً للتثبيتات الجديدة، مع ترحيل غير مدمر للمشاريع القديمة. لا أنصح بحذف `.agent/` فوراً من المشاريع القائمة أو بتغيير `main` دفعة واحدة. بعد اعتمادك، تبدأ التنفيذ على فرع مستقل في مرحلتين: أولاً بنية التثبيت الجديد واختبارات CI، ثم أداة ترحيل legacy والوثائق النهائية.

## المراجع

[1]: [Antigravity Agent Skills](https://antigravity.google/docs/skills)
[2]: [Antigravity Rules and Workflows](https://antigravity.google/docs/rules-workflows)
