# Flutter AI Agent Skill Framework — How To Use
# الدليل الشامل لاستخدام إطار عمل مهارات Flutter

> **For AI Agents:** This document provides deployment paths, skill counts, and integration instructions. Read `.ai/KNOWLEDGE_INDEX.md` for skill routing and `.ai/CURRENT_STATE.md` for session context.

---

## Quick Start (English)

This framework is a **49-skill AI Engineering OS** for Flutter. It enforces Clean Architecture, a Pluggable State Management Matrix (Riverpod / Bloc / Cubit / GetX), and zero-hallucination code generation via the Grill-Me Anti-Hallucination Protocol.

**Deploy globally (one command):**
```powershell
.\deploy.ps1
```
This syncs all 49 skills to **6 global AI agent paths** on your system (see Section 3 below).

**Add framework rules to your Flutter project:**
```powershell
Copy-Item .\AGENTS.md <your-flutter-project>\AGENTS.md
Copy-Item .\ROUTER_MANIFESTO.md <your-flutter-project>\ROUTER_MANIFESTO.md
```

---

## نظرة عامة (Arabic Overview)

هذا الدليل هو مرجعك العملي الشامل لدمج واستخدام **إطار عمل مهارات Flutter 2026 (Flutter AI Agent Skill Framework)** مع وكيل الذكاء الاصطناعي (**Antigravity AI Agent**).

تم تصميم هذا الإطار ليعمل كـ **"عقل هندسي منظم" (Structured Engineering Brain)** يضمن أن الذكاء الاصطناعي لا يكتب كوداً عشوائياً، بل يتبع أفضل ممارسات **Clean Architecture**، ومصفوفة إدارة الحالة المرنة (**Riverpod / Bloc / Cubit / GetX Pluggable Matrix**)، ومحرك **Impeller**، ومعايير جودة برمجيات المؤسسات عبر **7 قطاعات هندسية متكاملة**.

---

## ⚡ 1. الميزة الجوهرية: مصفوفة إدارة الحالة المرنة (Pluggable State Management Matrix)

الإطار مصمم ليكون **غير متحيز (State Management Agnostic)** في طبقات الـ Domain والـ Data. عندما تطلب من الذكاء الاصطناعي بناء ميزة أو شاشة أو مراجعة كود، يقوم الوكيل بالخطوات التالية:
1. **قراءة البوصلة (Router Manifesto):** يتفقد وثيقة `ROUTER_MANIFESTO.md` لتحديد المسار الفوري للمهارة المقابلة.
2. **الاكتشاف التلقائي:** يقرأ ملف `pubspec.yaml` أو توجيهك الصريح لمعرفة مكتبة إدارة الحالة المعتمدة.
3. **اختيار القالب الصحيح:** يستخدم القالب البرمجي المناسب من بين 21 قالباً جاهزاً في مجلد `templates/`.

---

## 🏛️ 2. الهيكل المعماري والقطاعات السبعة (The 7 Engineering Sectors — 49 Skills)

يضم الإطار **49 مهارة هندسية غير مكررة** مقسمة بصرامة على 7 قطاعات أساسية:

1. 🏗️ **`core-architecture/` (8 مهارات):** معمارية النظافة، التنظيم بالميزات، حقن التبعيات، نمذجة المجال، مستودعات البيانات، التأسيس، اكتشاف المنتج، والملاحة (`routing`).
2. 🧠 **`state-management/` (4 مهارات):** Riverpod 3.x، Bloc 9.x، Cubit، GetX 5.x.
3. 🎨 **`ui-styling/` (7 مهارات):** هندسة الـ UI، التصميم المتجاوب، الحركات، إمكانية الوصول، التوطين المتعدد، بناء الشاشات، وتحسينات منصات الويب والديسكتوب.
4. 🌐 **`data-networking/` (6 مهارات):** REST APIs (Dio)، WebSockets/SSE، GraphQL، Firebase، Supabase، وقواعد البيانات المحلية.
5. 🛡️ **`quality-testing-security/` (7 مهارات):** اختبارات الوحدات، الويدجت، الشاملة، البصرية Golden، توليد الاختبارات، الأمان، ومعالجة الأخطاء.
6. ⚡ **`performance-maintenance/` (8 مهارات):** الأداء، حجم التطبيق، التشخيص، إصلاح البق، التسجيل، إعادة الهيكلة، المهام الخلفية، ومعالجة الوسائط والعتاد.
7. 🚀 **`workflows-devops/` (9 مهارات):** ذاكرة الوكيل، CI/CD، مراجعة الكود، إنشاء الميزات، التخطيط للميزات، Git، بروتوكول Grill-Me، جاهزية الإنتاج، والإصدار.

---

## 🚀 3. طرق النشر والدمج في مشاريعك

### الطريقة الأولى: النشر العالمي المتعدد (Multi-Target Global Deployment) - ⭐ الموصى بها
قم بتشغيل سكريبت النشر الذكي بضغطة زر واحدة في موجه الأوامر PowerShell:
```powershell
.\deploy.ps1
```
**ماذا يفعل؟** يقوم بالتنظيف الذاتي للمهارات القديمة وينسخ المهارات الـ 49 بآن واحد إلى **6 مسارات عالمية** في نظامك:
  1. `C:\Users\Laith\.gemini\config\skills\`
  2. `C:\Users\Laith\.gemini\antigravity\skills\`
  3. `C:\Users\Laith\.agents\skills\`
  4. `C:\Users\Laith\AppData\Roaming\Cursor\User\globalStorage\skills\`
  5. `C:\Users\Laith\AppData\Roaming\Windsurf\User\globalStorage\skills\`
  6. `C:\Users\Laith\.codex\skills\`

### الطريقة الثانية: إعداد بيئة المشروع (Project Level Integration)
انسخ سياسات الإطار والبوصلة إلى جذر مشروع Flutter الخاص بك:
```powershell
Copy-Item .\AGENTS.md <your-flutter-project>\AGENTS.md
Copy-Item .\ROUTER_MANIFESTO.md <your-flutter-project>\ROUTER_MANIFESTO.md
```

### الطريقة الثالثة: تهيئة كاملة لكل مشروع (Per-Project Full Init) — ⭐ الجديدة الموصى بها

لكل مشروع Flutter جديد تريد تفعيل الإطار فيه كاملاً، شغّل هذا الأمر الواحد **من داخل مجلد المشروع مباشرةً**:

```powershell
# الطريقة الأسرع — من داخل مشروع Flutter:
.\path\to\flutter-skills\init-project.ps1

# أو بتحديد المسار صراحةً:
.\path\to\flutter-skills\init-project.ps1 -ProjectPath "D:\Projects\my_app"
```

**ماذا ينشئ داخل مشروعك؟**

```
<your-flutter-project>/
├── .agent/
│   ├── AGENTS.md                        ← سياسات الحوكمة وسياسة المكتبات
│   ├── ROUTER_MANIFESTO.md              ← بوصلة توجيه الـ agents
│   ├── PROJECT_PROFILE.md               ← هويّة المشروع (عدّلها أولاً!)
│   ├── KNOWLEDGE_INDEX.md               ← خريطة الـ skills الكاملة
│   ├── CURRENT_STATE.md                 ← متتبع الثقة والحالة
│   ├── AGENTS_MEMORY.md                 ← سجل صحة المشروع
│   ├── SESSION_LOG.md                   ← سجل الجلسات
│   ├── skills/                          ← جميع الـ 49 skills محلياً
│   ├── templates/                       ← جميع الـ 21 template
│   ├── checklists/                      ← جميع الـ 7 checklists
│   ├── decisions/                       ← جميع الـ 12 ADRs
│   ├── anti-patterns/                   ← جميع الـ 5 anti-patterns
│   └── scripts/                         ← verify_architecture.dart
├── .cursorrules                         ← قواعد Cursor (موجّهة إلى .agent/)
├── .windsurfrules                       ← قواعد Windsurf (موجّهة إلى .agent/)
├── .clinerules                          ← قواعد Roo/Cline (موجّهة إلى .agent/)
├── .codex/instructions.md               ← قواعد OpenAI Codex (موجّهة إلى .agent/)
└── .github/copilot-instructions.md      ← قواعد GitHub Copilot (موجّهة إلى .agent/)
```

**الخطوات بعد التهيئة:**
1. افتح `.agent/PROJECT_PROFILE.md` واملأ تفاصيل مشروعك (StateManagement، Database، إلخ)
2. ارفع `confidence score` في `.agent/CURRENT_STATE.md` بعد ملء البيانات
3. اطلب من الـ AI Agent تفعيل `flutter-grill-me` لقفل المتطلبات
4. ابدأ البناء!

