# Flutter AI Engineering OS — How To Use
# الدليل الشامل لاستخدام نظام التشغيل الهندسي للذكاء الاصطناعي (V2)

> **For AI Agents:** This document provides deployment paths and integration instructions. In an initialized project, read `.agents/governance/AGENTS.md` for project governance and use `.agents/skills/` for native skill discovery. Do not require either path while maintaining this framework repository itself.

---

## Quick Start (English)

This framework is a **Modular AI Engineering OS (V2)** for Flutter. It enforces Clean Architecture, a Pluggable State Management Matrix, Progressive Disclosure, and Persona-driven execution.

**Deploy globally (one command):**
```powershell
.\tools\deploy.ps1
```
This syncs the `/core` OS Kernel and all 55 modular skills to your global AI agent paths.

**Initialize locally in a Flutter project:**
```powershell
.\tools\init-project.ps1
```
This sets up `.agents/context/` for project state and `.agents/skills/` for native workspace skill discovery inside your current project.

---

## نظرة عامة (Arabic Overview)

هذا الدليل هو مرجعك العملي لدمج **نظام التشغيل الهندسي V2 (AI Engineering OS)**. المهارات تُكتشف أصلاً من `.agents/skills/`، بينما تحفظ `.agents/context/` حالة المشروع وقراراته وسجلات التسليم. يحتوي كل Skill على تعليمات أساسية وموارد اختيارية تُقرأ عند الحاجة، ما يدعم الإفصاح التدريجي دون افتراض ذاكرة دائمة للوكيل.

---

## ⚡ 1. الميزة الجوهرية: نظام الشخصيات وتقليل استهلاك الذاكرة (Personas & Progressive Disclosure)

النظام لا يعتمد فقط على القواعد، بل يتبنى **شخصيات هندسية (Personas)**:
- **Technical Lead**: يستقبل الطلبات العامة ويوجهها.
- **Chief Product Officer**: لمرحلة تحليل المتطلبات (Discovery).
- **Principal Software Architect**: لتصميم المعمارية (Domain Modeling).
- **Staff Software Engineer**: لكتابة الكود والـ UI.
- **Principal QA & SecOps Engineer**: للمراجعة واكتشاف الثغرات.

كل مهارة في هذا النظام تمتلك `metadata.yaml` تحدد أي شخصية يجب على الوكيل تقمصها، وما هي المهارات الأخرى التي تعتمد عليها أو تتعارض معها.

---

## 🏛️ 2. الهيكل المعماري والقطاعات السبعة (The 7 Engineering Sectors)

يضم النظام **55 مهارة هندسية مستقلة (Self-Contained Skills)**:

1. 🏗️ **`core-architecture/` (9 مهارات):** معمارية النظافة، التنظيم بالميزات، حقن التبعيات، ومساحات العمل متعددة الحزم.
2. 🧠 **`state-management/` (4 مهارات):** Riverpod, Bloc, Cubit, GetX.
3. 🎨 **`ui-styling/` (9 مهارات):** هندسة الـ UI، التصميم المتجاوب، الحركات، وتجربة المستخدم (Micro-interactions).
4. 🌐 **`data-networking/` (7 مهارات):** REST APIs، تطور العقود، WebSockets، Firebase، وSupabase.
5. 🛡️ **`quality-testing-security/` (7 مهارات):** الاختبارات، الأمان، ومعالجة الأخطاء.
6. ⚡ **`performance-maintenance/` (8 مهارات):** الأداء، التشخيص، وإعادة الهيكلة.
7. 🚀 **`workflows-devops/` (11 مهارة):** التخطيط، CI/CD، مراجعة الكود، الترقيات، تقييم الوكيل، وبروتوكول Grill-Me.

> **ملاحظة:** تم إلغاء المجلدات العامة (`templates`, `checklists`). الآن، كل مهارة تحتوي على مجلدي `templates/` و `resources/` الخاصين بها فقط. عند تعديل حد توجيه أو قاعدة أو مُثبّت، استخدم `flutter-agent-evaluation` وحدّث سيناريوً واقعياً في `evaluation/routing-scenarios.yaml` ثم شغّل `python3 tools/validate_framework.py`.

---

## 🚀 3. طرق النشر والدمج في مشاريعك

### الطريقة الأولى: النشر العالمي (Global Deployment)
قم بتشغيل سكريبت النشر من موجه الأوامر PowerShell:
```powershell
.\tools\deploy.ps1
```
**ماذا يفعل؟** ينسخ مجلدات `/core` و `/skills` إلى مسارات الوكلاء العالمية (مثل `.gemini/config/skills` وغيرها).

### الطريقة الثانية: تهيئة كاملة لكل مشروع (Per-Project Full Init) — ⭐ الموصى بها

لكل مشروع Flutter جديد، شغّل هذا الأمر **من داخل مجلد المشروع**:
```powershell
.\path\to\flutter-skills\tools\init-project.ps1
```

**ماذا ينشئ داخل مشروعك؟**

```text
<your-flutter-project>/
├── .agents/                             ← الجذر الموحد لكل أصول الوكيل
│   ├── rules/                            ← قواعد Antigravity وعقد تشغيل المشروع
│   ├── skills/                           ← جميع المهارات الـ55 بصيغة Agent Skills الأصلية
│   ├── governance/                       ← AGENTS.md والشخصيات والتوجيه والحوكمة
│   ├── context/                          ← حالة المشروع والمعرفة وسجل الجلسات
│   │   ├── PROJECT_PROFILE.md            ← هويّة المشروع (عدّلها أولاً)
│   │   ├── KNOWLEDGE_INDEX.md            ← خريطة المعرفة
│   │   ├── CURRENT_STATE.md              ← الأدلة والافتراضات والأسئلة المفتوحة
│   │   ├── AGENTS_MEMORY.md              ← سجل الصحة والدروس المتكررة
│   │   └── SESSION_LOG.md                ← سجل الجلسات والتسليم
│   ├── tools/                            ← أدوات الفحص والتأكيد
│   └── framework-manifest.json           ← نسخة الإطار ومصدره وعدد المهارات
├── .cursorrules                          ← قواعد Cursor المتوافقة مع حالة المشروع
├── .windsurfrules                        ← قواعد Windsurf
└── .clinerules                           ← قواعد Roo/Cline
```

**الخطوات بعد التهيئة:**
1. اقرأ `.agents/governance/AGENTS.md` ثم افتح `.agents/context/PROJECT_PROFILE.md` وسجّل تفاصيل المشروع المؤكدة.
2. دع الوكيل يختار من `.agents/skills/` أقل مجموعة مهارات تغطي المهمة، مع الاستفادة من قواعد `.agents/rules/` المكتشفة أصلاً في Antigravity.
3. اطلب `flutter-grill-me` فقط عندما تؤثر المعلومات الناقصة في المعمارية أو الأمان أو البيانات أو الواجهات أو الاعتماديات أو سلوك المستخدم.
4. أعد تشغيل المهيئ بأمان عند الحاجة؛ لا تُستبدل ملفات السياق الموجودة إلا بخيار `-Force`، واستعمل `-MigrateLegacy` لترحيل مشروع قديم دون فقد بياناته.
5. ابدأ البناء والتحقق التدريجي.

