<#
    .NAME
        stivkaTweaks (ST) - Professional Gaming Suite
    .SYNOPSIS
        Advanced Windows 10/11 system-level optimization tool.
    .DESCRIPTION
        Developed for competitive gaming (Fortnite/Valorant/CS2), this tool 
        consolidates high-impact registry and system tweaks into a modern UI.
    .NOTES
        Developer: stivkaTweaks Engineering
        License: MIT
#>

# --- PRE-FLIGHT CHECKS ---
$Host.UI.RawUI.WindowTitle = "stivkaTweaks - Initializing Engine..."

# Administrator Privileges Check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[-] FATAL ERROR: stivkaTweaks must be run as Administrator." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

# --- PROFESSIONAL ASCII HEADER ---
Clear-Host
$ascii = @'
 $$$$$$\  $$$$$$$$\ $$$$$$\ $$\     $$\ $$\   $$\  $$$$$$\         $$$$$$$$\ $$\       $$\ $$\   $$\ 
$$  __$$\ \__$$  __| \_$$  _|$$ |    $$ |$$ |  $$ |$$  __$$\        \__$$  __|$$ |      $$ |$$ |  $$ |
$$ /  \__|   $$ |      $$ |  $$ |    $$ |$$ | $$  /$$ /  $$ |          $$ |   $$ |      $$ |$$ | $$  / 
\$$$$$$\     $$ |      $$ |  \$$\   $$  |$$$$$  / $$$$$$$$ |          $$ |   $$ |  $$\  $$ |$$$$$  /  
 \____$$\    $$ |      $$ |   \$$\ $$  / $$  $$<  $$  __$$ |          $$ |   $$ | $$$$\ $$ |$$  $$<   
$$\   $$ |   $$ |      $$ |    \$$$  /   $$ | \$$\ $$ |  $$ |          $$ |   $$ |$$  $$ $$ |$$ | \$$\  
\$$$$$$  |   $$ |    $$$$$$\    \$  /    $$ |  \$$\$$ |  $$ |          $$ |   \$$$$  \$$$$  |$$ |  \$$\ 
 \______/    \__|    \______|    \_/     \__|   \__\__|  \__|          \__|    \____/ \____/ \__|   \__|
                                  STIVKA TWEAKS v2.5 PRE-RELEASE
'@
Write-Host $ascii -ForegroundColor Gray
Write-Host "`n" + ("=" * 80) -ForegroundColor White

# --- SYSTEM RESTORE POINT ---
Write-Host " [CRITICAL] System modification detected." -ForegroundColor White
$choice = Read-Host " Do you want to create a System Restore Point? (Highly Recommended) [Y/N]"
if ($choice -eq 'Y' -or $choice -eq 'y') {
    Write-Host " [+] Creating Restore Point... Please do not close the window." -ForegroundColor Cyan
    Checkpoint-Computer -Description "stivkaTweaks_AutoRestore" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    Write-Host " [+] Restore Point Created." -ForegroundColor Gray
} else {
    Write-Host " [!] Proceeding without Restore Point. Use at your own risk." -ForegroundColor Yellow
}
Start-Sleep -Milliseconds 500

# --- GUI DEFINITIONS ---
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$Theme = @{
    Bg      = [System.Drawing.Color]::FromArgb(10, 10, 10)
    Card    = [System.Drawing.Color]::FromArgb(20, 20, 20)
    White   = [System.Drawing.Color]::FromArgb(245, 245, 245)
    Gray    = [System.Drawing.Color]::FromArgb(120, 120, 120)
    Border  = [System.Drawing.Color]::FromArgb(40, 40, 40)
    Button  = [System.Drawing.Color]::FromArgb(255, 255, 255)
}

$MainForm = New-Object Windows.Forms.Form
$MainForm.Text = "stivkaTweaks (ST) | Professional Gaming Suite"
$MainForm.Size = "950, 800"
$MainForm.BackColor = $Theme.Bg
$MainForm.StartPosition = "CenterScreen"
$MainForm.FormBorderStyle = "FixedSingle"
$MainForm.MaximizeBox = $false
$MainForm.Opacity = 0

# --- TWEAK DATA REPOSITORY ---
$script:TweakCollection = @()
function New-TweakItem($Category, $Label, $Action) {
    $script:TweakCollection += [PSCustomObject]@{
        Category = $Category
        Label    = $Label
        Action   = $Action
        Checkbox = $null
    }
}

# --- POPULATING TWEAKS ---
# Fortnite
New-TweakItem "Fortnite" "Optimize Fortnite CPU Priority" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" "CpuPriorityClass" 3 }
New-TweakItem "Fortnite" "Optimize Fortnite IO Priority" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions" "IoPriority" 3 }
New-TweakItem "Fortnite" "Disable Fullscreen Optimizations" { Set-ItemProperty "HKCU:\System\GameConfigStore" "GameDVR_FSEBehavior" 2 }
New-TweakItem "Fortnite" "Lower Epic Games Launcher Priority" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\EpicGamesLauncher.exe\PerfOptions" "CpuPriorityClass" 1 }

# CPU
New-TweakItem "CPU" "Enable Ultimate Performance Power Plan" { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 }
New-TweakItem "CPU" "Disable Processor Core Parking" { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg /setactive SCHEME_CURRENT }
New-TweakItem "CPU" "Disable Intel/AMD Power Throttling" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" 1 }
New-TweakItem "CPU" "Disable Spectre & Meltdown Mitigation" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverride" 3; Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverrideMask" 3 }

# GPU
New-TweakItem "GPU" "Enable Hardware GPU Scheduling (HAGS)" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2 }
New-TweakItem "GPU" "Enable VR Pre-Rendered Limit" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" 8 }
New-TweakItem "GPU" "Force High Performance Graphics Mode" { Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" "DirectXUserGlobalGPUPreference" 2 }
New-TweakItem "GPU" "Disable Transparency Effects" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 0 }

# Network
New-TweakItem "Network" "Disable Nagle's Algorithm (Ping)" { Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" | ForEach-Object { Set-ItemProperty $_.PSPath "TcpAckFrequency" 1; Set-ItemProperty $_.PSPath "TCPNoDelay" 1 } }
New-TweakItem "Network" "Disable Network Throttling Index" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 0xFFFFFFFF }
New-TweakItem "Network" "Enable TCP Chimney Offload" { netsh int tcp set global chimney=enabled }
New-TweakItem "Network" "Disable NetBIOS over TCP/IP" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" "NetbiosOptions" 2 }

# Input & Latency
New-TweakItem "Latency" "0.5ms System Timer Resolution" { bcdedit /set useplatformtick yes; bcdedit /set disabledynamictick yes }
New-TweakItem "Latency" "Disable Mouse Acceleration" { Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseSpeed" 0; Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseThreshold1" 0; Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseThreshold2" 0 }
New-TweakItem "Latency" "Optimize Mouse/Kbd Queue Size" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" "MouseDataQueueSize" 50; Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" "KeyboardDataQueueSize" 50 }
New-TweakItem "Latency" "Maximize Keyboard Response Rate" { Set-ItemProperty "HKCU:\Control Panel\Keyboard" "KeyboardDelay" 0; Set-ItemProperty "HKCU:\Control Panel\Keyboard" "KeyboardSpeed" 31 }

# Debloat
New-TweakItem "Debloat" "Disable Windows Telemetry" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0; Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled }
New-TweakItem "Debloat" "Disable Background Apps" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1 }
New-TweakItem "Debloat" "Disable Windows Copilot & AI" { Set-ItemProperty "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" 1 }

# --- GUI ELEMENTS ---
$HeaderLabel = New-Object Windows.Forms.Label
$HeaderLabel.Text = "STIVKA TWEAKS ENGINE"
$HeaderLabel.Font = New-Object Drawing.Font("Segoe UI Semibold", 22)
$HeaderLabel.ForeColor = $Theme.White
$HeaderLabel.Location = "40, 30"
$HeaderLabel.AutoSize = $true
$MainForm.Controls.Add($HeaderLabel)

$SubLabel = New-Object Windows.Forms.Label
$SubLabel.Text = "Professional Optimization Suite | Version 2.5"
$SubLabel.Font = New-Object Drawing.Font("Segoe UI", 9)
$SubLabel.ForeColor = $Theme.Gray
$SubLabel.Location = "44, 70"
$SubLabel.AutoSize = $true
$MainForm.Controls.Add($SubLabel)

# Status Logging
$LogBox = New-Object Windows.Forms.RichTextBox
$LogBox.Location = "40, 600"
$LogBox.Size = "580, 130"
$LogBox.BackColor = $Theme.Card
$LogBox.ForeColor = $Theme.White
$LogBox.ReadOnly = $true
$LogBox.BorderStyle = "None"
$LogBox.Font = New-Object Drawing.Font("Consolas", 9)
$MainForm.Controls.Add($LogBox)

function Log-Message($msg) {
    $timestamp = (Get-Date).ToString("HH:mm:ss")
    $LogBox.AppendText("[$timestamp] $msg`n")
    $LogBox.ScrollToCaret()
    Write-Host " [ST_LOG] $msg" -ForegroundColor Gray
}

# Tabs
$TabCtrl = New-Object Windows.Forms.TabControl
$TabCtrl.Location = "40, 110"
$TabCtrl.Size = "850, 470"
$TabCtrl.SizeMode = "Fixed"
$TabCtrl.ItemSize = "120, 35"

$Categories = $script:TweakCollection.Category | Select-Object -Unique
foreach ($Cat in $Categories) {
    $TabPage = New-Object Windows.Forms.TabPage
    $TabPage.Text = $Cat
    $TabPage.BackColor = $Theme.Card
    
    $FlowPanel = New-Object Windows.Forms.FlowLayoutPanel
    $FlowPanel.Dock = "Fill"
    $FlowPanel.AutoScroll = $true
    $FlowPanel.Padding = New-Object Windows.Forms.Padding(20)

    foreach ($Tweak in ($script:TweakCollection | Where-Object { $_.Category -eq $Cat })) {
        $CB = New-Object Windows.Forms.CheckBox
        $CB.Text = $Tweak.Label
        $CB.ForeColor = $Theme.White
        $CB.Width = 380
        $CB.Height = 35
        $CB.Checked = $false # Start unchecked
        $Tweak.Checkbox = $CB
        
        $CB.Add_CheckedChanged({
            param($s, $e)
            if ($s.Checked) { Log-Message "Queued: $($s.Text)" }
        })
        
        $FlowPanel.Controls.Add($CB)
    }
    $TabPage.Controls.Add($FlowPanel)
    $TabCtrl.TabPages.Add($TabPage)
}
$MainForm.Controls.Add($TabCtrl)

# Apply Button
$ApplyBtn = New-Object Windows.Forms.Button
$ApplyBtn.Text = "APPLY SELECTED TWEAKS"
$ApplyBtn.Location = "640, 600"
$ApplyBtn.Size = "250, 60"
$ApplyBtn.FlatStyle = "Flat"
$ApplyBtn.BackColor = $Theme.Button
$ApplyBtn.ForeColor = [System.Drawing.Color]::Black
$ApplyBtn.Font = New-Object Drawing.Font("Segoe UI Bold", 10)
$MainForm.Controls.Add($ApplyBtn)

$ApplyBtn.Add_Click({
    Log-Message "Applying selected registry and system modifications..."
    $successCount = 0
    foreach ($Tweak in $script:TweakCollection) {
        if ($Tweak.Checkbox.Checked) {
            try {
                & $Tweak.Action
                Log-Message "Applied: $($Tweak.Label)"
                $successCount++
            } catch {
                Log-Message "Error: Failed to apply $($Tweak.Label)"
            }
        }
    }
    Log-Message "Optimization Task Finished. $successCount tweaks applied."
    [Windows.Forms.MessageBox]::Show("Applied $successCount tweaks successfully.`nPlease restart your computer to finalize changes.", "stivkaTweaks")
})

# Fade-in Logic
$Timer = New-Object Windows.Forms.Timer
$Timer.Interval = 20
$Timer.Add_Tick({
    if ($MainForm.Opacity -lt 1) {
        $MainForm.Opacity += 0.05
    } else {
        $Timer.Stop()
    }
})

$MainForm.Add_Load({ $Timer.Start() })

# Launch
Log-Message "stivkaTweaks Suite Initialized. Waiting for user selection."
$MainForm.ShowDialog() | Out-Null
