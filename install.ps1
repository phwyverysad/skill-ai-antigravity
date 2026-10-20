<#
.SYNOPSIS
    Antigravity Skills & MCP All-in-One Installer
.DESCRIPTION
    Installs and configures all Antigravity skills, plugins, MCP servers, and autonomous rules.
.EXAMPLE
    irm https://raw.githubusercontent.com/phwyverysad/skill-ai-antigravity/main/install.ps1 | iex
#>

[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Text)
    Write-Host "`n[+] $Text" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Text)
    Write-Host "    [OK] $Text" -ForegroundColor Green
}

function Write-Info {
    param([string]$Text)
    Write-Host "    [i]  $Text" -ForegroundColor Yellow
}

function Write-Warn {
    param([string]$Text)
    Write-Host "    [!]  $Text" -ForegroundColor Magenta
}

Write-Host @"
============================================================
   ANTIGRAVITY ALL-IN-ONE SKILLS & MCP INSTALLER
   Repo: https://github.com/phwyverysad/skill-ai-antigravity
============================================================
"@ -ForegroundColor Blue

# 1. Determine Source Directory (Remote vs Local)
$SourceDir = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($SourceDir) -or -not (Test-Path "$SourceDir\skills")) {
    Write-Step "Running from remote one-liner. Downloading repository archive..."
    $TempZip = Join-Path $env:TEMP "skill-ai-antigravity.zip"
    $TempExtract = Join-Path $env:TEMP "skill-ai-antigravity-main"
    $RepoZipUrl = "https://github.com/phwyverysad/skill-ai-antigravity/archive/refs/heads/main.zip"

    if (Test-Path $TempExtract) {
        Remove-Item -Path $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
    }

    Invoke-WebRequest -Uri $RepoZipUrl -OutFile $TempZip -UseBasicParsing
    Expand-Archive -Path $TempZip -DestinationPath $env:TEMP -Force
    $SourceDir = $TempExtract
    Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
    Write-Success "Downloaded and extracted to temporary directory: $SourceDir"
}

# 2. Prerequisites Check
Write-Step "Checking prerequisites (Python, uv, Git)..."

# Detect Python
$PythonExe = $null
$pythonCandidates = @(
    "C:\Python314\python.exe",
    "C:\Python313\python.exe",
    "C:\Python312\python.exe",
    "C:\Python311\python.exe"
)

foreach ($c in $pythonCandidates) {
    if (Test-Path $c) {
        $PythonExe = $c
        break
    }
}

if (-not $PythonExe) {
    $cmd = Get-Command "python.exe" -ErrorAction SilentlyContinue
    if ($cmd) {
        $PythonExe = $cmd.Source
    }
}

if (-not $PythonExe) {
    $cmd = Get-Command "py.exe" -ErrorAction SilentlyContinue
    if ($cmd) {
        $pyTarget = (& py -3 -c "import sys; print(sys.executable)" 2>$null)
        if ($pyTarget -and (Test-Path $pyTarget)) {
            $PythonExe = $pyTarget
        }
    }
}

if (-not $PythonExe) {
    throw "Python 3 is required but could not be located. Please install Python 3.10+ and re-run."
}
Write-Success "Found Python: $PythonExe"

# Detect or install uv
$uvCmd = Get-Command "uv.exe" -ErrorAction SilentlyContinue
$UvExe = if ($uvCmd) { $uvCmd.Source } else { $null }
if (-not $UvExe) {
    $localUv = "$HOME\.local\bin\uv.exe"
    if (Test-Path $localUv) {
        $UvExe = $localUv
    }
}

if (-not $UvExe) {
    Write-Info "Installing uv package manager via pip..."
    & $PythonExe -m pip install --quiet uv
    $uvCmd2 = Get-Command "uv.exe" -ErrorAction SilentlyContinue
    $UvExe = if ($uvCmd2) { $uvCmd2.Source } else { $null }
    if (-not $UvExe) {
        $UvExe = "$HOME\.local\bin\uv.exe"
    }
}
Write-Success "uv package manager ready: $(if ($UvExe) { $UvExe } else { 'python -m uv' })"

# 3. Setup Target Directories
Write-Step "Setting up Antigravity directories..."
$GeminiHome = Join-Path $HOME ".gemini"
$AntigravityHome = Join-Path $GeminiHome "antigravity"
$ConfigHome = Join-Path $GeminiHome "config"

$SkillsDest = Join-Path $AntigravityHome "skills"
$ConfigSkillsDest = Join-Path $ConfigHome "skills"
$PluginsDest = Join-Path $ConfigHome "plugins"
$McpDest = Join-Path $AntigravityHome "mcp"
$ScratchDest = Join-Path $AntigravityHome "scratch"

$dirs = @(
    $GeminiHome,
    $AntigravityHome,
    $ConfigHome,
    $SkillsDest,
    $ConfigSkillsDest,
    $PluginsDest,
    $McpDest,
    $ScratchDest
)

foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}
Write-Success "Directories initialized under $GeminiHome"

# Function to safely backup existing files
function Backup-FileSafely {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
        $bakPath = "${FilePath}.bak_${timestamp}"
        Copy-Item -Path $FilePath -Destination $bakPath -Force
        Write-Info "Created backup: $bakPath"
    }
}

# 4. Deploy Skills & Plugins
Write-Step "Deploying Caveman skills..."
$CavemanSrc = Join-Path $SourceDir "skills\caveman"
$CavemanDest = Join-Path $SkillsDest "caveman"

if (Test-Path $CavemanSrc) {
    if (Test-Path $CavemanDest) {
        Remove-Item -Path $CavemanDest -Recurse -Force -ErrorAction SilentlyContinue
    }
    Copy-Item -Path $CavemanSrc -Destination $CavemanDest -Recurse -Force
    Write-Success "Caveman base installed at $CavemanDest"

    # Link/Junction sub-skills
    $subskills = Get-ChildItem -Path "$CavemanDest\skills" -Directory -ErrorAction SilentlyContinue
    foreach ($sk in $subskills) {
        $target1 = Join-Path $SkillsDest $sk.Name
        $target2 = Join-Path $ConfigSkillsDest $sk.Name

        foreach ($t in @($target1, $target2)) {
            if (Test-Path $t) {
                Remove-Item -Path $t -Force -Recurse -ErrorAction SilentlyContinue
            }
            try {
                New-Item -ItemType Junction -Path $t -Target $sk.FullName -Force | Out-Null
            } catch {
                Copy-Item -Path $sk.FullName -Destination $t -Recurse -Force
            }
        }
    }
    Write-Success "Symlinked $(($subskills | Measure-Object).Count) Caveman sub-skills into skills folders"
}

Write-Step "Deploying Plugins (Superpowers, Chrome DevTools, Firebase, Google Workspace)..."
$PluginList = @("superpowers", "chrome-devtools-plugin", "firebase", "gdocs", "gdrive", "gsheets", "gslides")
foreach ($p in $PluginList) {
    $pSrc = Join-Path $SourceDir "plugins\$p"
    $pDest = Join-Path $PluginsDest $p
    if (Test-Path $pSrc) {
        if (Test-Path $pDest) {
            Remove-Item -Path $pDest -Recurse -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -Path $pSrc -Destination $pDest -Recurse -Force
        Write-Success "Installed plugin: $p"
    }
}

# 5. Deploy MCP Servers & Schemas
Write-Step "Deploying MCP Schemas and Bridge Scripts..."

# Copy MCP Schemas
$mcpSrc = Join-Path $SourceDir "mcp"
$mcpFolders = @("Roblox_Studio", "sketchup", "windows-mcp", "windows_mcp", "chrome_devtools")
foreach ($m in $mcpFolders) {
    $schemaSrc = Join-Path $mcpSrc "$m\schemas"
    $schemaDest = Join-Path $McpDest $m
    if (Test-Path $schemaSrc) {
        if (-not (Test-Path $schemaDest)) {
            New-Item -ItemType Directory -Path $schemaDest -Force | Out-Null
        }
        Copy-Item -Path "$schemaSrc\*" -Destination $schemaDest -Recurse -Force
        Write-Success "Installed schemas for MCP: $m"
    }
}

# Copy Roblox Studio Bridge
$robloxBridgeSrc = Join-Path $SourceDir "mcp\Roblox_Studio\roblox_studio_bridge.py"
$robloxBridgeDest = Join-Path $GeminiHome "roblox_studio_bridge.py"
if (Test-Path $robloxBridgeSrc) {
    Copy-Item -Path $robloxBridgeSrc -Destination $robloxBridgeDest -Force
    Write-Success "Installed Roblox Studio Bridge: $robloxBridgeDest"
}

# Install SketchUp MCP
Write-Step "Setting up SketchUp MCP python package..."
$sketchupSrc = Join-Path $SourceDir "mcp\sketchup\sketchup-mcp"
$sketchupDest = Join-Path $ScratchDest "sketchup-mcp"
if (Test-Path $sketchupSrc) {
    if (-not (Test-Path $sketchupDest)) {
        Copy-Item -Path $sketchupSrc -Destination $sketchupDest -Recurse -Force
    }
    Write-Info "Installing sketchup-mcp dependencies..."
    & $PythonExe -m pip install -e $sketchupDest --quiet
    Write-Success "sketchup-mcp package installed in Python"
}

# Install Windows MCP
Write-Step "Setting up Windows MCP..."
$WindowsMcpExe = "$HOME\.local\bin\windows-mcp.exe"
if (-not (Test-Path $WindowsMcpExe)) {
    Write-Info "Installing windows-mcp CLI tool..."
    try {
        if ($UvExe -and (Test-Path $UvExe)) {
            & $UvExe tool install windows-mcp
        } else {
            & $PythonExe -m pip install windows-mcp
        }
    } catch {
        Write-Warn "Could not auto-install windows-mcp via uv tool; attempting pip..."
        & $PythonExe -m pip install windows-mcp
    }
}

if (-not (Test-Path $WindowsMcpExe)) {
    $findMcpCmd = Get-Command "windows-mcp.exe" -ErrorAction SilentlyContinue
    $findMcp = if ($findMcpCmd) { $findMcpCmd.Source } else { $null }
    if ($findMcp) {
        $WindowsMcpExe = $findMcp
    }
}
Write-Success "Windows MCP executable: $WindowsMcpExe"

# 6. Configure MCP, Skills & Directives (Safe Merge)
Write-Step "Configuring Antigravity settings..."

# Directives (GEMINI.md)
$geminiMdSrc = Join-Path $SourceDir "config\GEMINI.md"
$geminiMdDest = Join-Path $ConfigHome "GEMINI.md"
if (Test-Path $geminiMdSrc) {
    Backup-FileSafely $geminiMdDest
    Copy-Item -Path $geminiMdSrc -Destination $geminiMdDest -Force
    Write-Success "Updated Global Directives: $geminiMdDest"
}

# skills.json
$skillsJsonPath = Join-Path $ConfigHome "skills.json"
Backup-FileSafely $skillsJsonPath
$skillsData = @{
    entries = @(
        @{ path = ($SkillsDest -replace "\\", "/") },
        @{ path = ("$SkillsDest/caveman/skills" -replace "\\", "/") }
    )
}
$skillsData | ConvertTo-Json -Depth 5 | Set-Content -Path $skillsJsonPath -Encoding utf8
Write-Success "Configured skills paths in $skillsJsonPath"

# import_manifest.json
$importManifestPath = Join-Path $ConfigHome "import_manifest.json"
$importManifestSrc = Join-Path $SourceDir "config\import_manifest.json"
if (Test-Path $importManifestSrc) {
    Copy-Item -Path $importManifestSrc -Destination $importManifestPath -Force
    Write-Success "Updated $importManifestPath"
}

# mcp_config.json
$mcpConfigDest = Join-Path $AntigravityHome "mcp_config.json"
$mcpConfigAlt = Join-Path $ConfigHome "mcp_config.json"
Backup-FileSafely $mcpConfigDest

$mcpConfigObj = @{
    mcpServers = @{
        "Roblox_Studio" = @{
            command = $PythonExe
            args = @($robloxBridgeDest)
        }
        "sketchup" = @{
            command = $PythonExe
            args = @("-m", "sketchup_mcp.server")
        }
        "windows-mcp" = @{
            command = $WindowsMcpExe
            args = @("serve", "--no-control")
        }
        "windows_mcp" = @{
            command = $WindowsMcpExe
            args = @("serve", "--no-control")
        }
    }
}

$mcpJsonContent = $mcpConfigObj | ConvertTo-Json -Depth 6
Set-Content -Path $mcpConfigDest -Value $mcpJsonContent -Encoding utf8
Set-Content -Path $mcpConfigAlt -Value $mcpJsonContent -Encoding utf8
Write-Success "Configured MCP servers in $mcpConfigDest and $mcpConfigAlt"

# config.json Safe Merge (Plugins & Settings)
$configJsonPath = Join-Path $ConfigHome "config.json"
$existingConfig = @{}
if (Test-Path $configJsonPath) {
    Backup-FileSafely $configJsonPath
    try {
        $existingConfig = Get-Content -Raw $configJsonPath | ConvertFrom-Json -AsHashtable
    } catch {
        $existingConfig = @{}
    }
}

if (-not $existingConfig.ContainsKey("plugins")) {
    $existingConfig["plugins"] = @{}
}

$existingConfig["plugins"]["chrome-devtools-plugin"] = @{
    installedFrom = @{
        id = "antigravity-plugins-official/plugin/chrome-devtools-plugin"
        marketplace = "antigravity-plugins-official"
        version = "1.10.1"
    }
}
$existingConfig["plugins"]["firebase"] = @{
    installedFrom = @{
        id = "antigravity-plugins-official/plugin/firebase"
        marketplace = "antigravity-plugins-official"
        version = "1.0.3"
    }
}

if (-not $existingConfig.ContainsKey("userSettings")) {
    $existingConfig["userSettings"] = @{}
}

$existingConfig["userSettings"]["enablePersonalCustomizations"] = $true

$existingConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $configJsonPath -Encoding utf8
Write-Success "Updated plugins configuration in $configJsonPath"

Write-Host @"

============================================================
   ALL-IN-ONE INSTALLATION COMPLETE!
============================================================

Installed Components:
  [v] Caveman (14+ Skills: cavecrew, investigate-first, lean-build, etc.)
  [v] Superpowers Plugin & Skills (brainstorming, tdd, executing-plans, etc.)
  [v] Official Plugins (Chrome DevTools, Firebase, GDocs, GDrive, GSheets, GSlides)
  [v] Roblox Studio MCP Bridge (Auto-detect StudioMCP.exe)
  [v] SketchUp MCP Server & Tool Schemas
  [v] Windows MCP Automation Server & Schemas
  [v] Global Autonomous Agent Directives (GEMINI.md)

Next Step:
  Restart your Antigravity App to load all newly installed skills and MCP servers!
============================================================
"@ -ForegroundColor Green
