# 🚀 Antigravity AI Skills & MCP All-In-One Pack

ชุดสำรองข้อมูลและตัวติดตั้งอัตโนมัติ (All-In-One) สำหรับ **Antigravity App** รวมทุก **Skills**, **Plugins**, **MCP Servers**, และ **Agent Directives** ที่ใช้งานอยู่ทั้งหมด พร้อมคำสั่งติดตั้งบรรทัดเดียวจบ รองรับการรันบน Windows ทุกเครื่องโดยอัตโนมัติ

---

## ⚡ คำสั่งติดตั้ง All-In-One (1-Click Install)

เปิด **PowerShell** แล้วคัดลอกคำสั่งด้านล่างไปวาง จากนั้นกด `Enter`:

```powershell
irm https://raw.githubusercontent.com/phwyverysad/skill-ai-antigravity/main/install.ps1 | iex
```

> **หมายเหตุ:** หากติดนโยบาย Execution Policy สามารถรันคำสั่งนี้แทนได้:
> ```powershell
> powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/phwyverysad/skill-ai-antigravity/main/install.ps1 | iex"
> ```

---

### 📦 หรือติดตั้งแบบ Manual (Clone Repository)

```powershell
git clone https://github.com/phwyverysad/skill-ai-antigravity.git
cd skill-ai-antigravity
.\install.ps1
```
*(หรือดับเบิ้ลคลิกที่ไฟล์ `install.bat` บนเครื่อง)*

---

## 🛡️ ระบบ Safe Merge & Auto Backup

ตัวติดตั้งมาพร้อมระบบความปลอดภัย:
- ตรวจจับโฟลเดอร์ผู้ใช้ (`%USERPROFILE%`) และเวอร์ชัน Python ในเครื่องให้อัตโนมัติ (ไม่ผูกติดกับ Username เครื่องเดิม)
- หากมีไฟล์ Config เดิมอยู่แล้ว (`mcp_config.json`, `config.json`, `skills.json`, `GEMINI.md`) ระบบจะทำการสำรองข้อมูลเดิมเป็น `.bak_<timestamp>` ไว้เสมอ ข้อมูลที่มีอยู่เดิมจะไม่สูญหาย

---

## 🧩 สิ่งที่รวมอยู่ในชุดนี้ (Included Components)

### 1. 🧠 AI Skills & Plugins
- **Superpowers Plugin**:
  - `brainstorming` - สำรวจความต้องการ ออกแบบก่อนลงมือเขียนโค้ด
  - `test-driven-development` - แนวคิด TDD เขียนเทสต์ก่อนโค้ดจริง
  - `subagent-driven-development` - สั่งงาน Subagent แยกส่วนแบบขนาน
  - `executing-plans` & `writing-plans` - วางแผนและดำเนินงานตามสเต็ป
  - `systematic-debugging` - วินิจฉัยข้อผิดพลาดอย่างเป็นระบบ
  - `using-superpowers`, `writing-skills`, `verification-before-completion`, ฯลฯ
- **Caveman Suite (14+ Skills)**:
  - `cavecrew`, `caveman`, `caveman-commit`, `caveman-compress`, `caveman-discover`
  - `investigate-first`, `lean-build`, `safe-refactor`, `surgical-patch`, `verify-and-stop`, `migration`
- **Official Plugins**:
  - `chrome-devtools-plugin` (การดีบักและออดิทหน้าเว็บ / a11y / lcp / memory leak)
  - `firebase` (Firestore, App Hosting, Auth, Rules)
  - `gdocs`, `gdrive`, `gsheets`, `gslides` (Google Workspace integration)

---

### 2. 🔌 MCP Servers (Model Context Protocol)
- **Roblox Studio MCP (`Roblox_Studio`)**:
  - บริดจ์สคริปต์ `roblox_studio_bridge.py` ค้นหา `StudioMCP.exe` เวอร์ชันล่าสุดในเครื่องให้อัตโนมัติ
  - สคีมาเครื่องมือครบชุด 29 คำสั่ง (ค้นหา game tree, รัน Luau, จับภาพหน้าจอ, ดึง console output, จัดการ asset)
- **SketchUp MCP (`sketchup`)**:
  - แพ็กเกจ `sketchup-mcp` (Python Server + Ruby Bridge `su_mcp.rb`)
  - รองรับการประเมินโค้ด Ruby, จัดการ Component, สร้างเดือยไม้ (joinery)
- **Windows Automation MCP (`windows-mcp` / `windows_mcp`)**:
  - ติดตั้งผ่าน `uv tool install windows-mcp` หรือ CLI
  - คำสั่งควบคุมหน้าต่าง, จับภาพหน้าจอ, เลื่อนเมาส์, รัน PowerShell, ตรวจจับ UI Tree
- **Chrome DevTools MCP (`chrome_devtools`)**:
  - สคีมาควบคุมเบราว์เซอร์ 31 รายการ (คลิก, พิมพ์ข้อความ, ถ่ายภาพ, ตรวจสอบ Network, ประเมินประสิทธิภาพ)

---

### 3. ⚙️ Agent Rules & Directives
- **`GEMINI.md` (Full Autonomous Execution Mode)**:
  - คำสั่ง Directive สากลสำหรับเปิดโหมด Autonomous: ทำงาน แก้ไขไฟล์ และทดสอบได้โดยไม่ต้องหยุดถามคอนเฟิร์มขั้นตอนที่ไม่จำเป็น

---

## 📁 โครงสร้างโปรเจกต์ (Repository Structure)

```text
skill-ai-antigravity/
├── install.ps1                   # สคริปต์ติดตั้ง All-in-One (PowerShell)
├── install.bat                   # ดับเบิ้ลคลิกสำหรับติดตั้งบน Windows
├── README.md                     # คู่มือและเอกสารการใช้งาน
├── config/
│   ├── GEMINI.md                 # Global Autonomous Directives
│   ├── mcp_config.template.json  # เทมเพลตตั้งค่า MCP Servers
│   ├── skills.template.json      # เทมเพลตลงทะเบียน Path Skills
│   ├── plugins.template.json     # เทมเพลต Plugin ของระบบ
│   └── import_manifest.json      # Manifest นำเข้า Plugin
├── mcp/
│   ├── Roblox_Studio/            # สคริปต์บริดจ์และ Schema 29 คำสั่ง
│   ├── sketchup/                 # ซอร์สโค้ด SketchUp MCP และ Schema
│   ├── windows-mcp/              # Schema เครื่องมือ Windows Automation
│   └── chrome_devtools/          # Schema เครื่องมือ DevTools
├── plugins/
│   ├── superpowers/              # ซอร์สโค้ด Superpowers ทั้งหมด
│   ├── chrome-devtools-plugin/   # Plugin DevTools ทางการ
│   ├── firebase/                 # Plugin Firebase ทางการ
│   ├── gdocs/                    # Plugin Google Docs
│   ├── gdrive/                   # Plugin Google Drive
│   ├── gsheets/                  # Plugin Google Sheets
│   └── gslides/                  # Plugin Google Slides
└── skills/
    └── caveman/                  # ซอร์สโค้ด Caveman และซับสกิลทั้งหมด
```

---

## 🔍 การตรวจสอบหลังการติดตั้ง (Verification)

เมื่อรันตัวติดตั้งเสร็จแล้ว:
1. ปิดและเปิด **Antigravity App** ใหม่อีกครั้ง
2. ตรวจสอบว่าในแชท AI มีการโหลด Skills เช่น `brainstorming`, `caveman`, `firebase`
3. เรียกดูรายการ MCP Servers ว่าพร้อมใช้งานหรือไม่

---

## 📄 License
รวบรวมและจัดทำขึ้นเพื่อการใช้งานและสำรองข้อมูลสำหรับ Antigravity โดยซอร์สโค้ดของแต่ละโปรเจกต์ (Caveman, Superpowers, SketchUp MCP) ยังคงเป็นไปตามสัญญาอนุญาต (License) ของผู้พัฒนาดั้งเดิม
