# Antigravity AI Skills and MCP All-In-One Pack

Comprehensive backup and automated installer for the **Antigravity App**. Bundles all currently active **Skills**, **Plugins**, **MCP Servers**, and **Agent Directives** with a single-command installation setup for Windows environments.

---

## One-Click Installation

Open **PowerShell** and run the following command:

```powershell
irm https://raw.githubusercontent.com/phwyverysad/skill-ai-antigravity/main/install.ps1 | iex
```

> **Note:** If restricted by PowerShell Execution Policy, run:
> ```powershell
> powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/phwyverysad/skill-ai-antigravity/main/install.ps1 | iex"
> ```

---

### Manual Installation (Clone Repository)

```powershell
git clone https://github.com/phwyverysad/skill-ai-antigravity.git
cd skill-ai-antigravity
.\install.ps1
```
*(Or double-click `install.bat` in File Explorer)*

---

## Safe Merge and Automated Backup

The installer provides safety mechanisms:
- Dynamically resolves user directories (`%USERPROFILE%`) and local Python installations without hardcoded system paths.
- If existing configuration files are found (`mcp_config.json`, `config.json`, `skills.json`, `GEMINI.md`), timestamped backups (`.bak_<timestamp>`) are automatically preserved before merging settings. Existing personal configurations remain intact.

---

## Included Components

### 1. AI Skills and Plugins
- **Superpowers Plugin**:
  - `brainstorming` - Explore intent and design architectures before implementation
  - `test-driven-development` - TDD methodology and test-first verification
  - `subagent-driven-development` - Dispatch and coordinate parallel specialized subagents
  - `executing-plans` and `writing-plans` - Structured implementation workflows
  - `systematic-debugging` - Evidence-based defect isolation and resolution
  - `using-superpowers`, `writing-skills`, `verification-before-completion`, and more
- **Caveman Suite (14+ Skills)**:
  - `cavecrew`, `caveman`, `caveman-commit`, `caveman-compress`, `caveman-discover`
  - `investigate-first`, `lean-build`, `safe-refactor`, `surgical-patch`, `verify-and-stop`, `migration`
- **Official Plugins**:
  - `chrome-devtools-plugin` - Web inspection, performance auditing, a11y, LCP, and memory leak analysis
  - `firebase` - Cloud Firestore, Firebase App Hosting, Authentication, and Security Rules authoring
  - `gdocs`, `gdrive`, `gsheets`, `gslides` - Google Workspace integrations

---

### 2. MCP Servers (Model Context Protocol)
- **Roblox Studio MCP (`Roblox_Studio`)**:
  - `roblox_studio_bridge.py` automatically discovers and links to the newest `StudioMCP.exe` binary
  - Full schema set of 29 tool definitions (Game Tree traversal, Luau execution, screen capture, console streaming, asset management)
- **SketchUp MCP (`sketchup`)**:
  - Full `sketchup-mcp` package (Python MCP Server + Ruby bridge extension `su_mcp.rb`)
  - Supports Ruby evaluation, component manipulation, and joinery generation
- **Windows Automation MCP (`windows-mcp` / `windows_mcp`)**:
  - Installed via `uv tool` or CLI
  - Desktop control tools: window inspection, screenshot capture, mouse, keyboard, PowerShell execution, and UI Tree scraping
- **Chrome DevTools MCP (`chrome_devtools`)**:
  - Complete browser automation schema collection across 31 endpoints (clicks, navigation, snapshots, network requests, trace profiling)

---

### 3. Agent Rules and Directives
- **`GEMINI.md` (Full Autonomous Execution Mode)**:
  - Universal autonomous directive: Authorizes proactive file modifications, script execution, diagnostics, and build validations without conversational round-trips.

---

## Repository Structure

```text
skill-ai-antigravity/
|-- install.ps1                   # All-in-one PowerShell installer
|-- install.bat                   # Batch wrapper for Windows
|-- README.md                     # Documentation
|-- config/
|   |-- GEMINI.md                 # Global autonomous agent directives
|   |-- mcp_config.template.json  # MCP server configuration template
|   |-- skills.template.json      # Skills path registration template
|   |-- plugins.template.json     # Plugin registration template
|   `-- import_manifest.json      # Plugin import manifest
|-- mcp/
|   |-- Roblox_Studio/            # Bridge script and 29 tool schemas
|   |-- sketchup/                 # SketchUp MCP source and tool schemas
|   |-- windows-mcp/              # Windows desktop automation schemas
|   `-- chrome_devtools/          # Chrome DevTools schemas
|-- plugins/
|   |-- superpowers/              # Superpowers plugin and skill repository
|   |-- chrome-devtools-plugin/   # Official DevTools plugin
|   |-- firebase/                 # Official Firebase plugin
|   |-- gdocs/                    # Google Docs plugin
|   |-- gdrive/                   # Google Drive plugin
|   |-- gsheets/                  # Google Sheets plugin
|   `-- gslides/                  # Google Slides plugin
`-- skills/
    `-- caveman/                  # Caveman suite and skills
```

---

## Post-Installation Verification

After running the installer:
1. Restart the **Antigravity App**.
2. Verify that skills such as `brainstorming`, `caveman`, and `firebase` are active in the agent session.
3. Confirm MCP tool registrations under the agent's available tool list.

---

## License
Curated and structured for Antigravity application backups. Subordinate packages (Caveman, Superpowers, SketchUp MCP) retain their respective original upstream licenses.
