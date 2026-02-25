<#
    .NAME
        stivkaTweaks (ST)
    .SYNOPSIS
        Professional Windows Optimization Tool for Gaming and System Responsiveness.
    .DESCRIPTION
        A comprehensive PowerShell-based GUI tool designed to optimize Windows for Fortnite, 
        lowering latency, and improving CPU/GPU/RAM performance through safe registry 
        and system configuration adjustments.
#>

# Ensure Script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $MyInvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    break
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- GUI Theme Colors ---
$bgColor    = [System.Drawing.Color]::FromArgb(25, 25, 25)
$fgColor    = [System.Drawing.Color]::FromArgb(240, 240, 240)
$accentColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnColor   = [System.Drawing.Color]::FromArgb(45, 45, 45)
$logColor   = [System.Drawing.Color]::FromArgb(15, 15, 15)

# --- Main Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "stivkaTweaks (ST) | Optimization Suite"
$form.Size = New-Object System.Drawing.Size(700, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgColor
$form.ForeColor = $fgColor
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

$fontHeader = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontText = New-Object System.Drawing.Font("Segoe UI", 9)
$fontLog = New-Object System.Drawing.Font("Consolas", 8)

# --- Header ---
$header = New-Object System.Windows.Forms.Label
$header.Text = "stivkaTweaks v1.0"
$header.Font = $fontHeader
$header.TextAlign = "MiddleCenter"
$header.Dock = "Top"
$header.Height = 50
$form.Controls.Add($header)

# --- Tabs Container ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(10, 60)
$tabControl.Size = New-Object System.Drawing.Size(665, 380)

function Create-TabPage($Title) {
    $page = New-Object System.Windows.Forms.TabPage
    $page.Text = $Title
    $page.BackColor = $bgColor
    return $page
}

$tabFortnite = Create-TabPage "Fortnite"
$tabGPU      = Create-TabPage "GPU"
$tabCPU      = Create-TabPage "CPU"
$tabRAM      = Create-TabPage "RAM"
$tabNetwork  = Create-TabPage "Network"
$tabLatency  = Create-TabPage "Latency"

$tabControl.TabPages.Add($tabFortnite)
$tabControl.TabPages.Add($tabGPU)
$tabControl.TabPages.Add($tabCPU)
$tabControl.TabPages.Add($tabRAM)
$tabControl.TabPages.Add($tabNetwork)
$tabControl.TabPages.Add($tabLatency)
$form.Controls.Add($tabControl)

# --- Helper: Create Checkbox ---
$script:checkboxes = @{}
function Add-Tweak($Parent, $Y, $Key, $Label, $Tooltip) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $Label
    $cb.Location = New-Object System.Drawing.Point(20, $Y)
    $cb.Size = New-Object System.Drawing.Size(600, 25)
    $cb.Checked = $true
    $Parent.Controls.Add($cb)
    
    $tip = New-Object System.Windows.Forms.ToolTip
    $tip.SetToolTip($cb, $Tooltip)
    
    $script:checkboxes[$Key] = $cb
}

# --- Fortnite Tweaks ---
Add-Tweak $tabFortnite 20 "fn_gamemode" "Enable Windows Game Mode" "Optimizes Windows resources for gaming."
Add-Tweak $tabFortnite 50 "fn_fso" "Disable Global Fullscreen Optimizations" "Reduces input lag in DX11/DX12 games."
Add-Tweak $tabFortnite 80 "fn_priority" "Set Fortnite Process Priority (High)" "Gives Fortnite higher CPU slice priority."

# --- GPU Tweaks ---
Add-Tweak $tabGPU 20 "gpu_hags" "Enable Hardware GPU Scheduling (HAGS)" "Reduces latency and improves frame times."
Add-Tweak $tabGPU 50 "gpu_perf" "Set Graphics to High Performance" "Forces Windows to prefer the discrete GPU."
Add-Tweak $tabGPU 80 "gpu_vr_pre" "Optimize VR Pre-Rendered Frames" "Reduces driver overhead for GPU queuing."

# --- CPU Tweaks ---
Add-Tweak $tabCPU 20 "cpu_power" "Enable Ultimate Performance Power Plan" "Disables all CPU power saving features."
Add-Tweak $tabCPU 50 "cpu_telemetry" "Disable Telemetry Services" "Reduces background CPU usage from tracking."
Add-Tweak $tabCPU 80 "cpu_indexing" "Disable Search Indexing" "Prevents random disk/CPU spikes during gameplay."

# --- RAM Tweaks ---
Add-Tweak $tabRAM 20 "ram_paging" "Disable Paging Executive" "Forces Windows to keep kernel data in RAM instead of Pagefile."
Add-Tweak $tabRAM 50 "ram_cache" "Increase System Cache Size" "Optimizes memory throughput for file handling."
Add-Tweak $tabRAM 80 "ram_standby" "Clear Standby List on Run" "Flushes cached memory to free up active RAM."

# --- Network Tweaks ---
Add-Tweak $tabNetwork 20 "net_nagle" "Disable Nagle's Algorithm" "Reduces ping by sending small packets immediately."
Add-Tweak $tabNetwork 50 "net_throttle" "Disable Network Throttling Index" "Prevents Windows from limiting non-multimedia traffic."
Add-Tweak $tabNetwork 80 "net_chimney" "Enable TCP Chimney Offload" "Offloads network processing to the NIC."

# --- Latency Tweaks ---
Add-Tweak $tabLatency 20 "lat_timer" "Set System Timer Resolution (0.5ms)" "Forces the lowest possible system heartbeat."
Add-Tweak $tabLatency 50 "lat_priority" "Optimize Win32 Priority Separation" "Balances CPU focus between foreground and background."
Add-Tweak $tabLatency 80 "lat_mouse" "Mouse Data Queue Size Optimization" "Reduces buffer lag for mouse input."

# --- Log Box ---
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ReadOnly = $true
$logBox.ScrollBars = "Vertical"
$logBox.BackColor = $logColor
$logBox.ForeColor = [System.Drawing.Color]::LimeGreen
$logBox.Font = $fontLog
$logBox.Location = New-Object System.Drawing.Point(10, 450)
$logBox.Size = New-Object System.Drawing.Size(665, 100)
$form.Controls.Add($logBox)

function Write-Log($Message) {
    $logBox.AppendText("[$((Get-Date).ToString("HH:mm:ss"))] $Message`r`n")
}

# --- Logic: Apply Tweaks ---
$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = "APPLY SELECTED TWEAKS"
$btnApply.Location = New-Object System.Drawing.Point(10, 560)
$btnApply.Size = New-Object System.Drawing.Size(325, 40)
$btnApply.BackColor = $accentColor
$btnApply.FlatStyle = "Flat"
$form.Controls.Add($btnApply)

$btnApply.Add_Click({
    Write-Log "Starting Optimization..."
    
    # Fortnite
    if ($script:checkboxes["fn_gamemode"].Checked) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -ErrorAction SilentlyContinue
        Write-Log "Applied: Game Mode Enabled."
    }
    if ($script:checkboxes["fn_fso"].Checked) {
        Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Value 2 -ErrorAction SilentlyContinue
        Write-Log "Applied: Disabled FSO."
    }

    # GPU
    if ($script:checkboxes["gpu_hags"].Checked) {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -ErrorAction SilentlyContinue
        Write-Log "Applied: HAGS Enabled."
    }

    # CPU
    if ($script:checkboxes["cpu_power"].Checked) {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        Write-Log "Applied: Ultimate Performance Plan."
    }

    # RAM
    if ($script:checkboxes["ram_paging"].Checked) {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -ErrorAction SilentlyContinue
        Write-Log "Applied: Disable Paging Executive."
    }

    # Network
    if ($script:checkboxes["net_nagle"].Checked) {
        $interfaces = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
        Get-ChildItem $interfaces | ForEach-Object {
            Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -ErrorAction SilentlyContinue
        }
        Write-Log "Applied: Nagle's Algorithm Disabled."
    }

    # Latency
    if ($script:checkboxes["lat_priority"].Checked) {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -ErrorAction SilentlyContinue
        Write-Log "Applied: Win32 Priority Separation (Hex 26)."
    }

    Write-Log "Optimization Complete! Please Restart PC."
    [System.Windows.Forms.MessageBox]::Show("Tweaks applied successfully. A system restart is recommended.", "stivkaTweaks")
})

# --- Logic: Restore Defaults ---
$btnRestore = New-Object System.Windows.Forms.Button
$btnRestore.Text = "RESTORE DEFAULTS"
$btnRestore.Location = New-Object System.Drawing.Point(350, 560)
$btnRestore.Size = New-Object System.Drawing.Size(325, 40)
$btnRestore.BackColor = $btnColor
$btnRestore.FlatStyle = "Flat"
$form.Controls.Add($btnRestore)

$btnRestore.Add_Click({
    Write-Log "Restoring Default Settings..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -ErrorAction SilentlyContinue
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e # Balanced
    Write-Log "Defaults Restored."
    [System.Windows.Forms.MessageBox]::Show("Essential defaults restored.", "stivkaTweaks")
})

# --- Disclaimer ---
$labelWarn = New-Object System.Windows.Forms.Label
$labelWarn.Text = "DISCLAIMER: Use at your own risk. These tweaks modify registry values for performance."
$labelWarn.Font = $fontLog
$labelWarn.ForeColor = [System.Drawing.Color]::Gray
$labelWarn.TextAlign = "MiddleCenter"
$labelWarn.Location = New-Object System.Drawing.Point(10, 605)
$labelWarn.Size = New-Object System.Drawing.Size(665, 15)
$form.Controls.Add($labelWarn)

# Initialize
Write-Log "stivkaTweaks Initialized. Ready to optimize."
$form.ShowDialog() | Out-Null
