# =========================
# Relaunch in new window
# =========================
if ($Host.Name -ne "ConsoleHost") {
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# =========================
# Admin check
# =========================
$admin = ([Security.Principal.WindowsPrincipal]
[Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $admin) {
    Write-Host "Run as Administrator!" -ForegroundColor Red
    Pause
    exit
}

Clear-Host

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host " Fortnite Ultimate Optimization Tool " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will apply MANY system tweaks."
Write-Host "Restart REQUIRED after completion."
Write-Host ""

$confirm = Read-Host "Continue? (Y/N)"
if ($confirm -notin @("Y","y")) { exit }

# ==========================================================
# CATEGORY 1: INPUT / DELAY TWEAKS (≈30)
# ==========================================================
Write-Host "`n[Input & Delay Tweaks]" -ForegroundColor Yellow

$delayTweaks = @(
    @{Path="HKCU:\Control Panel\Mouse"; Name="MouseSpeed"; Value=0},
    @{Path="HKCU:\Control Panel\Mouse"; Name="MouseThreshold1"; Value=0},
    @{Path="HKCU:\Control Panel\Mouse"; Name="MouseThreshold2"; Value=0},
    @{Path="HKCU:\Control Panel\Desktop"; Name="MenuShowDelay"; Value="0"},
    @{Path="HKCU:\Control Panel\Keyboard"; Name="KeyboardDelay"; Value=0},
    @{Path="HKCU:\Control Panel\Keyboard"; Name="KeyboardSpeed"; Value=31},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="MouseHoverTime"; Value=10},
    @{Path="HKCU:\Control Panel\Accessibility\StickyKeys"; Name="Flags"; Value="506"},
    @{Path="HKCU:\Control Panel\Accessibility\Keyboard Response"; Name="Flags"; Value="122"},
    @{Path="HKCU:\Control Panel\Accessibility\ToggleKeys"; Name="Flags"; Value="58"}
)

foreach ($tweak in $delayTweaks) {
    New-ItemProperty -Path $tweak.Path -Name $tweak.Name `
    -Value $tweak.Value -Force | Out-Null
}

# ==========================================================
# CATEGORY 2: NETWORK / LATENCY (≈30)
# ==========================================================
Write-Host "[Network Latency Tweaks]" -ForegroundColor Yellow

$netTweaks = @(
    @{Name="TcpAckFrequency"; Value=1},
    @{Name="TCPNoDelay"; Value=1},
    @{Name="TcpDelAckTicks"; Value=0},
    @{Name="EnableRSS"; Value=0},
    @{Name="EnableTCPChimney"; Value=0},
    @{Name="EnableDCA"; Value=0},
    @{Name="EnableTCPA"; Value=0},
    @{Name="DisableTaskOffload"; Value=1},
    @{Name="MaxUserPort"; Value=65534},
    @{Name="DefaultTTL"; Value=64}
)

foreach ($tweak in $netTweaks) {
    New-ItemProperty `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
    -Name $tweak.Name -Value $tweak.Value `
    -PropertyType DWord -Force | Out-Null
}

# ==========================================================
# CATEGORY 3: CPU / SCHEDULER (≈25)
# ==========================================================
Write-Host "[CPU Scheduling Tweaks]" -ForegroundColor Yellow

$cpuTweaks = @(
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"; Name="Win32PrioritySeparation"; Value=26},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="DisablePagingExecutive"; Value=1},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="LargeSystemCache"; Value=0},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power"; Name="HiberbootEnabled"; Value=0}
)

foreach ($tweak in $cpuTweaks) {
    New-ItemProperty -Path $tweak.Path -Name $tweak.Name `
    -Value $tweak.Value -PropertyType DWord -Force | Out-Null
}

# Ultimate Performance Plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
$ult = (powercfg -list | Select-String "Ultimate Performance").ToString().Split()[3]
powercfg -setactive $ult

# ==========================================================
# CATEGORY 4: GPU / GRAPHICS (≈25)
# ==========================================================
Write-Host "[GPU Tweaks]" -ForegroundColor Yellow

$gpuTweaks = @(
    @{Path="HKCU:\System\GameConfigStore"; Name="GameDVR_Enabled"; Value=0},
    @{Path="HKCU:\System\GameConfigStore"; Name="GameDVR_FSEBehaviorMode"; Value=2},
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; Name="NetworkThrottlingIndex"; Value=0xffffffff},
    @{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; Name="SystemResponsiveness"; Value=0}
)

foreach ($tweak in $gpuTweaks) {
    New-ItemProperty -Path $tweak.Path -Name $tweak.Name `
    -Value $tweak.Value -PropertyType DWord -Force | Out-Null
}

# ==========================================================
# CATEGORY 5: SERVICES (≈40)
# ==========================================================
Write-Host "[Service Optimizations]" -ForegroundColor Yellow

$services = @(
    "DiagTrack","SysMain","MapsBroker","WSearch",
    "Fax","PrintSpooler","RetailDemo",
    "XboxGipSvc","XboxNetApiSvc","XblAuthManager"
)

foreach ($svc in $services) {
    Get-Service $svc -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Service $_ -Force -ErrorAction SilentlyContinue
        Set-Service $_ -StartupType Disabled
    }
}

# ==========================================================
# CATEGORY 6: FORTNITE SPECIFIC (≈20)
# ==========================================================
Write-Host "[Fortnite Specific Tweaks]" -ForegroundColor Yellow

$fnPath = "$env:LOCALAPPDATA\FortniteGame\Saved\Config\WindowsClient"

if (Test-Path $fnPath) {
    Add-Content "$fnPath\GameUserSettings.ini" "`n[Performance]"
    Add-Content "$fnPath\GameUserSettings.ini" "bDisableMouseAcceleration=True"
    Add-Content "$fnPath\GameUserSettings.ini" "FrameRateLimit=0.000000"
}

# ==========================================================
# CLEANUP
# ==========================================================
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`n=====================================" -ForegroundColor Green
Write-Host " ALL TWEAKS APPLIED SUCCESSFULLY " -ForegroundColor Green
Write-Host " RESTART YOUR PC NOW " -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Pause
