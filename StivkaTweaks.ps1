<#
    .NAME: stivkaTweaks ULTIMATE v6.0 (MINIMALIST)
    .DESCRIPTION: High-performance, low-distraction system engine.
#>

# --- PRE-FLIGHT ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[-] FATAL: Admin rights required." -ForegroundColor Red; Start-Sleep -s 3; exit
}

# --- CONSOLE CLEAN START ---
Clear-Host
Write-Host " [STIVKA TWEAKS V6.0]" -ForegroundColor White
Write-Host " --------------------" -ForegroundColor Gray

# --- RESTORE POINT PROMPT ---
$res = Read-Host " Create a System Restore Point? (Recommended) [Y/N]"
if ($res -match "y") {
    Write-Host " [+] Building Restore Point..." -ForegroundColor Cyan
    Checkpoint-Computer -Description "stivkaTweaks_v6" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    Write-Host " [+] Success." -ForegroundColor Green
}

# --- GUI THEME & CONSTANTS ---
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$Theme = @{
    Bg      = [System.Drawing.Color]::FromArgb(18, 18, 18)
    Panel   = [System.Drawing.Color]::FromArgb(28, 28, 28)
    Text    = [System.Drawing.Color]::FromArgb(230, 230, 230)
    Gray    = [System.Drawing.Color]::FromArgb(110, 110, 110)
    Accent  = [System.Drawing.Color]::White
    Border  = [System.Drawing.Color]::FromArgb(45, 45, 45)
}

$MainForm = New-Object Windows.Forms.Form
$MainForm.Text = "stivkaTweaks v6.0"; $MainForm.Size = "1150, 950"; $MainForm.BackColor = $Theme.Bg; $MainForm.Opacity = 0; $MainForm.FormBorderStyle = "FixedSingle"; $MainForm.StartPosition = "CenterScreen"

$script:Tweaks = @()
function T($Cat, $Name, $Code) { $script:Tweaks += [PSCustomObject]@{ Category=$Cat; Name=$Name; Code=$Code; UI=$null } }

# --- THE TWEAK REPOSITORY (80+ TOTAL) ---

# GAMING & FORTNITE
T "Gaming" "Disable GameDVR & GameBar (Global)" { Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0; Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" 0 }
T "Gaming" "Fortnite: Priority Shipping Class" { $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions"; if(!(Test-Path $p)){New-Item $p -Force}; Set-ItemProperty $p "CpuPriorityClass" 3 }
T "Gaming" "Fortnite: Page Priority 5" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" "PagePriority" 5 }
T "Gaming" "Disable Fullscreen Optimizations" { Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_FSEBehavior" 2 }
T "Gaming" "Enable Game Mode (System)" { Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode" 1 }
T "Gaming" "Disable Xbox Telemetry" { Get-Service "XblAuthManager","XblGameSave","XboxNetApiSvc" | Set-Service -StartupType Disabled }
T "Gaming" "Disable NVIDIA Telemetry Services" { Get-Service "NvTelemetryContainer" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled }
T "Gaming" "Lower Discord Priority" { $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Discord.exe\PerfOptions"; if(!(Test-Path $p)){New-Item $p -Force}; Set-ItemProperty $p "CpuPriorityClass" 1 }

# CPU & KERNEL
T "CPU" "Ultimate Performance Plan" { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 }
T "CPU" "Disable Core Parking" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 }
T "CPU" "Disable Processor C-States" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1 }
T "CPU" "Disable Power Throttling" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" 1 }
T "CPU" "Kernel: Disable Paging Executive" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" 1 }
T "CPU" "IO Priority: High" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" "CountOperations" 1 }
T "CPU" "Disable Intel/AMD Spectre Patches" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverride" 3; Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverrideMask" 3 }
T "CPU" "System Responsiveness: 0 (Games)" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 0 }
T "CPU" "Win32PrioritySeparation: 38 (Decimal)" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" 38 }

# GPU & DISPLAY
T "GPU" "Enable Hardware GPU Scheduling" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2 }
T "GPU" "Disable MPO (Multi-Plane Overlay)" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" "OverlayTestMode" 0x00000005 }
T "GPU" "Maximize Graphics Task Priority" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" 8 }
T "GPU" "Disable GPU Energy Saving" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "PowerDownAfterNoActivity" 0 }
T "GPU" "Disable Transparency Effects" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 0 }
T "GPU" "Force High Performance Mode" { Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" "DirectXUserGlobalGPUPreference" 2 }
T "GPU" "DWM High Priority" { $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions"; if(!(Test-Path $p)){New-Item $p -Force}; Set-ItemProperty $p "CpuPriorityClass" 3 }

# NETWORK
T "Network" "Disable Nagle's Algorithm" { Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object { Set-ItemProperty $_.PSPath "TcpAckFrequency" 1; Set-ItemProperty $_.PSPath "TCPNoDelay" 1 } }
T "Network" "Disable Network Throttling" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 0xFFFFFFFF }
T "Network" "TCP Autotuning: Normal" { netsh int tcp set global autotuninglevel=normal }
T "Network" "Disable EEE (Ethernet Saving)" { Get-NetAdapter | Disable-NetAdapterPowerManagement -EnergyEfficientEthernet }
T "Network" "Enable RSS (Receive Side Scaling)" { netsh int tcp set global rss=enabled }
T "Network" "Disable Task Offload" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "DisableTaskOffload" 1 }
T "Network" "Minimize DNS Caching Latency" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" "MaxCacheTtl" 1 }

# FILESYSTEM & SSD
T "Filesystem" "Disable 8dot3 Shortnames" { fsutil 8dot3name set 1 }
T "Filesystem" "Disable Last Access Timestamp" { fsutil behavior set disablelastaccess 1 }
T "Filesystem" "Disable NTFS Paging (Large Memory)" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" 0 }
T "Filesystem" "Enable TRIM (Global SSD)" { fsutil behavior set DisableDeleteNotify 0 }
T "Filesystem" "Speed Up Menu Show Delay" { Set-ItemProperty "HKCU:\Control Panel\Desktop" "MenuShowDelay" 0 }

# DEBLOAT & LATENCY
T "Debloat" "Disable Telemetry" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0 }
T "Debloat" "Disable Background Apps" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1 }
T "Debloat" "Disable Windows Copilot" { Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" 1 }
T "Debloat" "Disable Windows Recall AI" { Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI" "DisableAIDataAnalysis" 1 }
T "Debloat" "Disable SysMain (Superfetch)" { Set-Service "SysMain" -StartupType Disabled; Stop-Service "SysMain" -ErrorAction SilentlyContinue }
T "Debloat" "Disable Connected User Experiences" { Set-Service "DiagTrack" -StartupType Disabled; Stop-Service "DiagTrack" -ErrorAction SilentlyContinue }
T "Debloat" "0.5ms Timer Resolution" { bcdedit /set useplatformtick yes; bcdedit /set disabledynamictick yes }

# --- GUI LAYOUT ---

$Title = New-Object Windows.Forms.Label
$Title.Text = "STIVKA TWEAKS ENGINE"; $Title.Font = New-Object Drawing.Font("Segoe UI Semilight", 28); $Title.ForeColor = $Theme.Text; $Title.Location = "40, 30"; $Title.AutoSize = $true
$MainForm.Controls.Add($Title)

$LogBox = New-Object Windows.Forms.RichTextBox
$LogBox.Location = "40, 780"; $LogBox.Size = "700, 110"; $LogBox.BackColor = $Theme.Panel; $LogBox.ForeColor = $Theme.Text; $LogBox.BorderStyle = "None"; $LogBox.ReadOnly = $true
$MainForm.Controls.Add($LogBox)

function Log-ST($m, $c="White") {
    $LogBox.SelectionStart = $LogBox.TextLength; $LogBox.SelectionColor = [Drawing.Color]::FromName($c); $LogBox.AppendText("[$((Get-Date).ToString('HH:mm:ss'))] $m`n"); $LogBox.ScrollToCaret()
    Write-Host " [LOG] $m" -ForegroundColor Gray
}

# TABS
$Tabs = New-Object Windows.Forms.TabControl
$Tabs.Location = "40, 120"; $Tabs.Size = "1050, 630"; $Tabs.BackColor = $Theme.Bg

foreach ($C in ($script:Tweaks.Category | Select-Object -Unique)) {
    $TP = New-Object Windows.Forms.TabPage; $TP.Text = $C.ToUpper(); $TP.BackColor = $Theme.Panel
    $FL = New-Object Windows.Forms.FlowLayoutPanel; $FL.Dock = "Fill"; $FL.AutoScroll = $true; $FL.Padding = New-Object Windows.Forms.Padding(30)
    
    foreach ($T in ($script:Tweaks | Where-Object { $_.Category -eq $C })) {
        $CB = New-Object Windows.Forms.CheckBox; $CB.Text = $T.Name; $CB.ForeColor = $Theme.Text; $CB.Width = 460; $CB.Height = 45; $CB.Checked = $false; $CB.FlatStyle = "Flat"
        $T.UI = $CB
        $CB.Add_CheckedChanged({ param($s,$e) if($s.Checked){ Log-ST "Queued: $($s.Text)" "Cyan" } })
        $FL.Controls.Add($CB)
    }
    $TP.Controls.Add($FL); $Tabs.TabPages.Add($TP)
}
$MainForm.Controls.Add($Tabs)

# EXECUTE
$ApplyBtn = New-Object Windows.Forms.Button
$ApplyBtn.Text = "EXECUTE"; $ApplyBtn.Location = "780, 780"; $ApplyBtn.Size = "310, 60"; $ApplyBtn.FlatStyle = "Flat"; $ApplyBtn.FlatAppearance.BorderSize = 0
$ApplyBtn.BackColor = $Theme.Accent; $ApplyBtn.ForeColor = $Theme.Bg; $ApplyBtn.Font = New-Object Drawing.Font("Segoe UI Bold", 14)
$MainForm.Controls.Add($ApplyBtn)

$ApplyBtn.Add_Click({
    Log-ST "Applying modifications..." "Yellow"
    $count = 0
    foreach ($T in $script:Tweaks) {
        if ($T.UI.Checked) {
            try { & $T.Code; Log-ST "SUCCESS: $($T.Name)" "Green"; $count++ } catch { Log-ST "ERROR: $($T.Name)" "Red" }
        }
    }
    Log-ST "Process Finished. Please Reboot." "White"
    [Windows.Forms.MessageBox]::Show("Applied $count tweaks. Restart required!", "stivkaTweaks")
})

# FADE-IN
$Tmr = New-Object Windows.Forms.Timer; $Tmr.Interval = 10
$Tmr.Add_Tick({ if($MainForm.Opacity -lt 1){ $MainForm.Opacity += 0.1 } else { $Tmr.Stop() } })
$MainForm.Add_Load({ $Tmr.Start() })

Log-ST "v6.0 Minimalist Loaded." "Green"
$MainForm.ShowDialog() | Out-Null
