# Rubber Ducky for GitHub Copilot CLI — Windows Installer
# Usage: irm https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "BandaruDheeraj/rubber-ducky"
$CopilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME ".copilot" }
$CacheDir = Join-Path $CopilotHome "marketplace-cache\rubber-ducky"

Write-Host "🦆 Rubber Ducky — Installer" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
Write-Host ""

# Check git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is required but not installed." -ForegroundColor Red
    exit 1
}

# Check copilot CLI
if (-not (Get-Command copilot -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  GitHub Copilot CLI not found in PATH." -ForegroundColor DarkYellow
    Write-Host "   Install it first: https://github.com/github/copilot-cli"
    Write-Host "   Continuing anyway..." -ForegroundColor DarkYellow
    Write-Host ""
}

# Clone or update
if (Test-Path $CacheDir) {
    Write-Host "📦 Updating existing cache..."
    Push-Location $CacheDir
    git pull --quiet 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   Cache update failed, re-cloning..."
        Pop-Location
        Remove-Item -Recurse -Force $CacheDir
        git clone --quiet "https://github.com/$Repo.git" $CacheDir
        if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
    } else {
        Pop-Location
    }
} else {
    Write-Host "📦 Cloning rubber-ducky..."
    $ParentDir = Split-Path $CacheDir -Parent
    if (-not (Test-Path $ParentDir)) { New-Item -ItemType Directory -Force -Path $ParentDir | Out-Null }
    git clone --quiet "https://github.com/$Repo.git" $CacheDir
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
}

# Copy skill (Windows doesn't have reliable symlinks without admin)
$SkillSrc = Join-Path $CacheDir "plugins\rubber-ducky\skills\rubber-duck-debugging"
$SkillDst = Join-Path $CopilotHome "skills\rubber-duck-debugging"

$SkillsDir = Join-Path $CopilotHome "skills"
if (-not (Test-Path $SkillsDir)) { New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null }

if (Test-Path $SkillDst) { Remove-Item -Recurse -Force $SkillDst }
Copy-Item -Recurse -Force $SkillSrc $SkillDst
Write-Host "✅ Skill installed: rubber-duck-debugging" -ForegroundColor Green

# Copy agent
$AgentSrc = Join-Path $CacheDir "plugins\rubber-ducky\agents\rubber-ducky.md"
$AgentDst = Join-Path $CopilotHome "agents\rubber-ducky.md"

$AgentsDir = Join-Path $CopilotHome "agents"
if (-not (Test-Path $AgentsDir)) { New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null }

if (Test-Path $AgentDst) { Remove-Item -Force $AgentDst }
Copy-Item -Force $AgentSrc $AgentDst
Write-Host "✅ Agent installed: rubber-ducky" -ForegroundColor Green

# Update custom instructions
$InstructionsFile = Join-Path $CopilotHome "copilot-instructions.md"
$Marker = "<!-- rubber-ducky-installed -->"

$NeedsUpdate = $true
if (Test-Path $InstructionsFile) {
    $Content = Get-Content $InstructionsFile -Raw
    if ($Content -match [regex]::Escape($Marker)) {
        $NeedsUpdate = $false
        Write-Host "ℹ️  Custom instructions already configured."
    }
}

if ($NeedsUpdate) {
    $Snippet = @"

$Marker
## Rubber Duck Debugging 🦆

You have the rubber-duck-debugging skill installed. BEFORE pushing any debug
fix, behavioral change, or patch, invoke this skill to walk through the fix
with the rubber duck.

The Iron Rule: No code gets pushed until you've explained it to the duck.

Available: rubber-duck-debugging (skill), rubber-ducky (agent)

"Fix this bug" → rubber-duck-debugging BEFORE pushing the fix.
"Debug this" → rubber-duck-debugging to explain the code line by line.
"Why is this failing?" → rubber-duck-debugging to find where explanation ≠ reality.
"@
    Add-Content -Path $InstructionsFile -Value $Snippet
    Write-Host "✅ Custom instructions updated: $InstructionsFile" -ForegroundColor Green
}

Write-Host ""
Write-Host "🦆 Rubber Ducky installed successfully!" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Skill: rubber-duck-debugging"
Write-Host "   Agent: rubber-ducky"
Write-Host ""
Write-Host "   Next steps:"
Write-Host "   1. Start a new Copilot CLI session: copilot"
Write-Host "   2. Verify: /skills list"
Write-Host "   3. Try: 'Use the /rubber-duck-debugging skill to review my fix'"
Write-Host ""
Write-Host "   To update: run this script again"
Write-Host "   To uninstall:"
Write-Host "     Remove-Item -Recurse $SkillDst"
Write-Host "     Remove-Item $AgentDst"
Write-Host "     Remove-Item -Recurse $CacheDir"
Write-Host "     and remove the rubber-ducky section from $InstructionsFile"
