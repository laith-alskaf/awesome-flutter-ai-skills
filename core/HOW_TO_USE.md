# Flutter AI Engineering OS — How To Use
# الدليل الشامل لاستخدام نظام التشغيل الهندسي للذكاء الاصطناعي (V2)

> **For AI Agents:** This document provides deployment paths and integration instructions. Read `.agent/core/AGENTS.md` for policy rules and `.agent/PERSONAS.md` for role adoption.

---

## Quick Start (English)

This framework is a **Modular AI Engineering OS (V2)** for Flutter. It enforces Clean Architecture, a Pluggable State Management Matrix, Progressive Disclosure, and Persona-driven execution.

**Deploy globally (one command):**
```powershell
.\tools\deploy.ps1
```
This syncs the `/core` OS Kernel and all 51 modular skills to your global AI agent paths.

**Initialize locally in a Flutter project:**
```powershell
.\tools\init-project.ps1
```
This sets up the `.agent/` isolated workspace inside your current project.

---

## نظرة عامة (Arabic Overview)

هذا الدليل هو مرجعك العملي لدمج **نظام التشغيل الهندسي V2 (AI Engineering OS)**.
تمت إعادة هيكلة هذا النظام بالكامل ليكون **Modular**، بحيث تحتوي كل مهارة على القوالب والموارد الخاصة بها، مما يمنع استهلاك الذاكرة (Token Bloat) ويضمن استجابة دقيقة من وكيل الذكاء الاصطناعي بناءً على 5 شخصيات قيادية (Personas).

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

يضم النظام **51 مهارة هندسية مستقلة (Self-Contained Skills)**:

1. 🏗️ **`core-architecture/` (8 مهارات):** معمارية النظافة، التنظيم بالميزات، وحقن التبعيات.
2. 🧠 **`state-management/` (4 مهارات):** Riverpod, Bloc, Cubit, GetX.
3. 🎨 **`ui-styling/` (9 مهارات):** هندسة الـ UI، التصميم المتجاوب، الحركات، وتجربة المستخدم (Micro-interactions).
4. 🌐 **`data-networking/` (6 مهارات):** REST APIs, WebSockets, Firebase, Supabase.
5. 🛡️ **`quality-testing-security/` (7 مهارات):** الاختبارات، الأمان، ومعالجة الأخطاء.
6. ⚡ **`performance-maintenance/` (8 مهارات):** الأداء، التشخيص، وإعادة الهيكلة.
7. 🚀 **`workflows-devops/` (9 مهارات):** التخطيط، CI/CD، مراجعة الكود، وبروتوكول Grill-Me.

> **ملاحظة:** تم إلغاء المجلدات العامة (`templates`, `checklists`). الآن، كل مهارة تحتوي على مجلدي `templates/` و `resources/` الخاصين بها فقط!

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
├── .agent/
│   ├── core/                            ← نواة النظام (AGENTS.md, PERSONAS.md, إلخ)
│   ├── skills/                          ← جميع الـ 51 مهارة بنظام الوحدات (Modular)
│   ├── tools/                           ← أدوات الفحص والتأكيد
│   ├── PROJECT_PROFILE.md               ← هويّة المشروع (عدّلها أولاً!)
│   ├── KNOWLEDGE_INDEX.md               ← خريطة الـ skills الكاملة
│   ├── CURRENT_STATE.md                 ← متتبع الثقة والحالة
│   ├── AGENTS_MEMORY.md                 ← سجل صحة المشروع
│   └── SESSION_LOG.md                   ← سجل الجلسات
├── .cursorrules                         ← قواعد Cursor (موجّهة إلى .agent/core/AGENTS.md)
├── .windsurfrules                       ← قواعد Windsurf
└── .clinerules                          ← قواعد Roo/Cline
```

**الخطوات بعد التهيئة:**
1. افتح `.agent/PROJECT_PROFILE.md` واملأ تفاصيل مشروعك.
2. تأكد من قراءة الوكيل لملف `.agent/core/PERSONAS.md`.
3. اطلب من الـ AI Agent تفعيل `flutter-grill-me` لقفل المتطلبات.
4. ابدأ البناء!

