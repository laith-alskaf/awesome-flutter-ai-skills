# الدليل الشامل لاستخدام إطار عمل مهارات Flutter (How to Use Flutter AI Agent Skills)

هذا الدليل هو مرجعك العملي الشامل لدمج واستخدام **إطار عمل مهارات Flutter 2026 (Flutter AI Agent Skill Framework)** مع وكيل الذكاء الاصطناعي (**Antigravity AI Agent**). 

تم تصميم هذا الإطار ليعمل كـ **"عقل هندسي منظم" (Structured Engineering Brain)** يضمن أن الذكاء الاصطناعي لا يكتب كوداً عشوائياً، بل يتبع أفضل ممارسات **Clean Architecture**، ومصفوفة إدارة الحالة المرنة (**Riverpod / Bloc / Cubit / GetX Pluggable Matrix**)، ومحرك **Impeller**، ومعايير جودة برمجيات المؤسسات عبر **7 قطاعات هندسية متكاملة (7 Core Engineering Sectors)**.

---

## ⚡ 1. الميزة الجوهرية: مصفوفة إدارة الحالة المرنة (Pluggable State Management Matrix)

الإطار مصمم ليكون **غير متحيز (State Management Agnostic)** في طبقات الـ Domain والـ Data. عندما تطلب من الذكاء الاصطناعي بناء ميزة أو شاشة أو مراجعة كود، يقوم الوكيل بالخطوات التالية:
1. **قراءة البوصلة (Router Manifesto):** يتفقد وثيقة `ROUTER_MANIFESTO.md` لتحديد المسار الفوري للمهارة المقابلة.
2. **الاكتشاف التلقائي:** يقرأ ملف `pubspec.yaml` أو توجيهك الصريح لمعرفة مكتبة إدارة الحالة المعتمدة (`Riverpod` أو `Bloc` أو `Cubit` أو `GetX`).
3. **اختيار القالب الصحيح:** يستخدم القالب البرمجي المناسب من بين 16 قالباً جاهزاً في مجلد `templates/`.

---

## 🏛️ 2. الهيكل المعماري والقطاعات السبعة (The 7 Engineering Sectors)

يضم الإطار **44 مهارة هندسية غير مكررة** مقسمة بصرامة على 7 قطاعات أساسية:

1. 🏗️ **`core-architecture/` (6 مهارات):** معمارية النظافة، حقن التبعيات، التنظيم بالميزات، مستودعات البيانات، التأسيس، والملاحة (`routing`).
2. 🧠 **`state-management/` (4 مهارات):** Riverpod 3.x، Bloc 9.x، Cubit، GetX 5.x.
3. 🎨 **`ui-styling/` (7 مهارات):** هندسة الـ UI، التصميم المتجاوب، الحركات، إمكانية الوصول، التوطين المتعدد، بناء الشاشات، وتحسينات منصات الويب والديسكتوب (`web-desktop`).
4. 🌐 **`data-networking/` (6 مهارات):** الاتصال بـ REST APIs، الاتصالات الفورية والحية (`websockets` لـ WebSockets/SSE/WebRTC/MQTT)، GraphQL، Firebase، Supabase، وقواعد البيانات المحلية.
5. 🛡️ **`quality-testing-security/` (7 مهارات):** اختبارات الوحدات، اختبارات الويدجت، الاختبارات الشاملة، الاختبارات البصرية Golden، توليد الاختبارات، الأمان، ومعالجة الأخطاء.
6. ⚡ **`performance-maintenance/` (8 مهارات):** قياس وتحسين الأداء، تقليل حجم التطبيق، التشخيص، منهجية وإصلاح البق، التسجيل، إعادة الهيكلة، المهام الخلفية (`background-processing`)، ومعالجة الوسائط والعتاد (`media-hardware`).
7. 🚀 **`workflows-devops/` (6 مهارات):** التخطيط للميزات، إنشاء الميزات، مراجعة الكود الشاملة، إدارة Git، خطوط CI/CD، وإصدار النشر.

---

## 🚀 3. طرق النشر والدمج في مشاريعك

### الطريقة الأولى: النشر العالمي المتعدد (Multi-Target Global Deployment) - ⭐ الموصى بها
قم بتشغيل سكريبت النشر الذكي بضغطة زر واحدة في موجه الأوامر PowerShell:
```powershell
.\deploy.ps1
```
* **ماذا يفعل؟** يقوم بالتنظيف الذاتي للمهارات القديمة وينسخ المهارات الـ 44 بآن واحد إلى 3 مسارات عالمية في نظامك:
  1. `C:\Users\Laith\.gemini\config\skills\`
  2. `C:\Users\Laith\.agents\skills\`
  3. `C:\Users\Laith\.gemini\antigravity\skills\`

### الطريقة الثانية: إعداد بيئة المشروع (Project Level Integration)
انسخ سياسات الإطار والبوصلة إلى جذر مشروع Flutter الخاص بك:
```powershell
Copy-Item .\AGENTS.md <your-flutter-project>\AGENTS.md
Copy-Item .\ROUTER_MANIFESTO.md <your-flutter-project>\ROUTER_MANIFESTO.md
```
