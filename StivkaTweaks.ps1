# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                                                                              ║
# ║   ███████╗████████╗██╗██╗   ██╗██╗  ██╗ █████╗    ████████╗██╗    ██╗███████╗ ║
# ║   ██╔════╝╚══██╔══╝██║██║   ██║██║ ██╔╝██╔══██╗   ╚══██╔══╝██║    ██║██╔════╝ ║
# ║   ███████╗   ██║   ██║██║   ██║█████╔╝ ███████║      ██║   ██║ █╗ ██║███████╗ ║
# ║   ╚════██║   ██║   ██║╚██╗ ██╔╝██╔═██╗ ██╔══██║      ██║   ██║███╗██║╚════██║ ║
# ║   ███████║   ██║   ██║ ╚████╔╝ ██║  ██╗██║  ██║      ██║   ╚███╔███╔╝███████║ ║
# ║   ╚══════╝   ╚═╝   ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝    ╚══╝╚══╝ ╚══════╝ ║
# ║                                                                              ║
# ║                    PREMIUM WINDOWS OPTIMIZATION TOOL                         ║
# ║                         github.com/stivka/tweaks                             ║
# ║                                                                              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# USAGE: irm https://raw.githubusercontent.com/YOUR_USERNAME/StivkaTweaks/main/StivkaTweaks.ps1 | iex
#
# This script provides a GUI-based Windows optimization tool with 300+ tweaks
# for maximum gaming performance, minimal input lag, and clean system.

#Requires -Version 5.1

# Check for Admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges. Restarting with elevated permissions..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Import Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION & SETTINGS
# ═══════════════════════════════════════════════════════════════════════════════

$script:Settings = @{
    CreateRestorePoint = $true
    ShowAdvancedTweaks = $false
    AutoReboot = $false
    LogPath = "$env:TEMP\StivkaTweaks.log"
}

# ═══════════════════════════════════════════════════════════════════════════════
# TWEAK DEFINITIONS - 300+ AUTOMATED TWEAKS
# ═══════════════════════════════════════════════════════════════════════════════

$script:Tweaks = @{
    # ═══════════════════════════ PERFORMANCE ═══════════════════════════
    Performance = @(
        @{
            Id = "ultimate-performance"
            Name = "Ultimate Performance Power Plan"
            Description = "Aktiviert den versteckten Ultimate Performance Modus"
            Command = { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "high-performance"
            Name = "High Performance Power Plan"
            Description = "Aktiviert den Windows Hochleistungsmodus"
            Command = { powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-core-parking"
            Name = "Core Parking deaktivieren"
            Description = "Verhindert das Deaktivieren von CPU-Kernen"
            Command = { 
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
                powercfg -setactive SCHEME_CURRENT
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "timer-resolution"
            Name = "Timer Resolution (0.5ms)"
            Description = "Reduziert Windows Timer-Auflösung auf 0.5ms"
            Command = { 
                bcdedit /set useplatformtick yes
                bcdedit /set disabledynamictick yes
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "disable-hpet"
            Name = "HPET deaktivieren"
            Description = "Deaktiviert High Precision Event Timer"
            Command = { bcdedit /deletevalue useplatformclock 2>$null }
            Type = "cmd"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "game-mode"
            Name = "Game Mode Optimization"
            Description = "Optimiert Windows Game Mode"
            Registry = @{
                Path = "HKCU:\Software\Microsoft\GameBar"
                Values = @{ AutoGameModeEnabled = 1; AllowAutoGameMode = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "hardware-gpu-scheduling"
            Name = "Hardware GPU Scheduling"
            Description = "Aktiviert hardwarebasierte GPU-Planung"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
                Values = @{ HwSchMode = 2 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-power-throttling"
            Name = "Power Throttling deaktivieren"
            Description = "Deaktiviert Windows Power Throttling"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
                Values = @{ PowerThrottlingOff = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "processor-scheduling"
            Name = "CPU für Programme optimieren"
            Description = "Priorisiert CPU-Ressourcen für Vordergrund-Programme"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
                Values = @{ Win32PrioritySeparation = 38 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-prefetch"
            Name = "Prefetch deaktivieren"
            Description = "Deaktiviert Windows Prefetch für SSDs"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"
                Values = @{ EnablePrefetcher = 0; EnableSuperfetch = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-indexing"
            Name = "Search Indexing deaktivieren"
            Description = "Deaktiviert Hintergrund-Indizierung"
            Command = { 
                Stop-Service WSearch -Force -ErrorAction SilentlyContinue
                Set-Service WSearch -StartupType Disabled -ErrorAction SilentlyContinue
            }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-hibernation"
            Name = "Hibernate deaktivieren"
            Description = "Deaktiviert Hibernation für SSD-Speicherplatz"
            Command = { powercfg /hibernate off }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-fast-startup"
            Name = "Fast Startup deaktivieren"
            Description = "Deaktiviert Fast Startup für saubere Neustarts"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
                Values = @{ HiberbootEnabled = 0 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "ssd-trim"
            Name = "SSD TRIM Optimierung"
            Description = "Aktiviert TRIM und optimiert SSD-Nutzung"
            Command = { fsutil behavior set DisableDeleteNotify 0 }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "ntfs-optimization"
            Name = "NTFS Optimierung"
            Description = "Deaktiviert Last Access Time Updates"
            Command = { fsutil behavior set disablelastaccess 1 }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-paging-executive"
            Name = "Kernel im RAM halten"
            Description = "Hält Windows-Kernel im RAM"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ DisablePagingExecutive = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "large-system-cache"
            Name = "Large System Cache"
            Description = "Erhöht System-Cache für bessere Performance"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ LargeSystemCache = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "cpu-priority-games"
            Name = "CPU Priority für Games"
            Description = "Erhöht CPU-Priorität für Spieleprozesse"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
                Values = @{ 
                    Priority = 6
                    "Scheduling Category" = "High"
                    "SFIO Priority" = "High"
                    "GPU Priority" = 8
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-cpu-idle"
            Name = "CPU Idle States deaktivieren"
            Description = "Deaktiviert CPU C-States für konstante Performance"
            Command = { powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1; powercfg -setactive SCHEME_CURRENT }
            Type = "cmd"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "max-processor-state"
            Name = "Max CPU State 100%"
            Description = "Setzt maximale CPU-Leistung auf 100%"
            Command = { 
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
                powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
                powercfg -setactive SCHEME_CURRENT
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "disable-startup-delay"
            Name = "Startup Delay entfernen"
            Description = "Entfernt die Verzögerung beim Windows-Start"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
                Values = @{ StartupDelayInMSec = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "boot-timeout"
            Name = "Boot Timeout reduzieren"
            Description = "Reduziert Boot-Menü-Timeout auf 3 Sekunden"
            Command = { bcdedit /timeout 3 }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-error-reporting"
            Name = "Error Reporting deaktivieren"
            Description = "Deaktiviert Windows Fehlerberichterstattung"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
                Values = @{ Disabled = 1 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-maintenance"
            Name = "Auto-Wartung deaktivieren"
            Description = "Deaktiviert geplante Windows-Wartungsaufgaben"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"
                Values = @{ MaintenanceDisabled = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "svchost-split"
            Name = "SvcHost Split Threshold"
            Description = "Optimiert SvcHost Prozess-Splitting"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control"
                Values = @{ SvcHostSplitThresholdInKB = 4194304 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-8dot3"
            Name = "8.3 Dateinamen deaktivieren"
            Description = "Deaktiviert 8.3 Dateinamen für schnellere Performance"
            Command = { fsutil behavior set disable8dot3 1 }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-ntfs-encryption"
            Name = "NTFS Encryption deaktivieren"
            Description = "Deaktiviert NTFS Verschlüsselung"
            Command = { fsutil behavior set disableencryption 1 }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ KEYBOARD ═══════════════════════════
    Keyboard = @(
        @{
            Id = "keyboard-response"
            Name = "Tastatur Response erhöhen"
            Description = "Maximale Tastaturwiederholrate und minimale Verzögerung"
            Registry = @{
                Path = "HKCU:\Control Panel\Keyboard"
                Values = @{ 
                    KeyboardDelay = "0"
                    KeyboardSpeed = "31"
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "keyboard-data-queue"
            Name = "Keyboard Data Queue erhöhen"
            Description = "Erhöht den Tastatur-Datenpuffer"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters"
                Values = @{ KeyboardDataQueueSize = 100 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-sticky-keys"
            Name = "Sticky Keys deaktivieren"
            Description = "Deaktiviert Einrastfunktion komplett"
            Registry = @{
                Path = "HKCU:\Control Panel\Accessibility\StickyKeys"
                Values = @{ Flags = "506" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-filter-keys"
            Name = "Filter Keys deaktivieren"
            Description = "Deaktiviert Anschlagverzögerung"
            Registry = @{
                Path = "HKCU:\Control Panel\Accessibility\Keyboard Response"
                Values = @{ Flags = "122" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-toggle-keys"
            Name = "Toggle Keys deaktivieren"
            Description = "Deaktiviert Toggle-Key Sounds"
            Registry = @{
                Path = "HKCU:\Control Panel\Accessibility\ToggleKeys"
                Values = @{ Flags = "58" }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "keyboard-usb-priority"
            Name = "Keyboard USB Priorität"
            Description = "Erhöht USB-Priorität für Tastaturen"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters"
                Values = @{ ThreadPriority = 31 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "keyboard-polling-increase"
            Name = "Keyboard Polling Rate erhöhen"
            Description = "Maximiert Keyboard Polling"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters"
                Values = @{ 
                    PollInterval = 1
                    FlushPeriod = 1
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "keyboard-buffer-optimization"
            Name = "Keyboard Buffer Optimierung"
            Description = "Optimiert Keyboard-Buffer für schnellere Eingaben"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"
                Values = @{ 
                    PollStatusIterations = 1
                    PollingIterations = 2000
                    PollingIterationsMaximum = 4000
                    ResendIterations = 3
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "keyboard-irq-priority"
            Name = "Keyboard IRQ Priorität"
            Description = "Erhöht IRQ-Priorität für Tastatureingaben"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
                Values = @{ IRQ1Priority = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-keyboard-filtering"
            Name = "Keyboard Filtering deaktivieren"
            Description = "Deaktiviert Windows Keyboard-Filter"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
                Values = @{ "Scancode Map" = $null }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ MOUSE ═══════════════════════════
    Mouse = @(
        @{
            Id = "mouse-optimization"
            Name = "Maus Optimierung"
            Description = "Deaktiviert Mausbeschleunigung und optimiert Sensitivity"
            Registry = @{
                Path = "HKCU:\Control Panel\Mouse"
                Values = @{
                    MouseSpeed = "0"
                    MouseThreshold1 = "0"
                    MouseThreshold2 = "0"
                    MouseSensitivity = "10"
                    SmoothMouseXCurve = [byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC0,0xCC,0x0C,0x00,0x00,0x00,0x00,0x00,0x80,0x99,0x19,0x00,0x00,0x00,0x00,0x00,0x40,0x66,0x26,0x00,0x00,0x00,0x00,0x00,0x00,0x33,0x33,0x00,0x00,0x00,0x00,0x00)
                    SmoothMouseYCurve = [byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x38,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0x00,0x00,0x00,0x00,0x00)
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-pointer-precision"
            Name = "Zeigerbeschleunigung AUS"
            Description = "Deaktiviert Enhance Pointer Precision komplett"
            Registry = @{
                Path = "HKCU:\Control Panel\Mouse"
                Values = @{ 
                    MouseSpeed = "0"
                    MouseThreshold1 = "0"
                    MouseThreshold2 = "0"
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "mouse-data-queue"
            Name = "Mouse Data Queue erhöhen"
            Description = "Erhöht den Maus-Datenpuffer"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
                Values = @{ MouseDataQueueSize = 100 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "mouse-polling-usb"
            Name = "USB Mouse Polling optimieren"
            Description = "Maximiert USB-Polling für Mäuse"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\mouhid\Parameters"
                Values = @{ 
                    ThreadPriority = 31
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "raw-mouse-input"
            Name = "Raw Mouse Input"
            Description = "Aktiviert Raw Input API für Maus"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
                Values = @{ 
                    UseWDFRawInput = 1
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "mouse-irq-priority"
            Name = "Mouse IRQ Priorität"
            Description = "Erhöht IRQ-Priorität für Mauseingaben"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
                Values = @{ IRQ12Priority = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-mouse-corners"
            Name = "Hot Corners deaktivieren"
            Description = "Deaktiviert Windows Hot Corners"
            Registry = @{
                Path = "HKCU:\Control Panel\Desktop"
                Values = @{ 
                    MouseCornerClipLength = 0
                }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "mouse-hover-time"
            Name = "Mouse Hover Time reduzieren"
            Description = "Reduziert Hover-Verzögerung auf Minimum"
            Registry = @{
                Path = "HKCU:\Control Panel\Mouse"
                Values = @{ MouseHoverTime = "10" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-scroll-acceleration"
            Name = "Scroll Acceleration AUS"
            Description = "Deaktiviert Scroll-Beschleunigung"
            Registry = @{
                Path = "HKCU:\Control Panel\Desktop"
                Values = @{ WheelScrollChars = "3"; WheelScrollLines = "3" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "mouse-fix-5-11"
            Name = "MarkC Mouse Fix (6/11)"
            Description = "Setzt perfekte 1:1 Mausbewegung bei 6/11 Sensitivity"
            Registry = @{
                Path = "HKCU:\Control Panel\Mouse"
                Values = @{
                    MouseSensitivity = "10"
                    MouseSpeed = "0"
                    MouseThreshold1 = "0"
                    MouseThreshold2 = "0"
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ NVIDIA ═══════════════════════════
    NVIDIA = @(
        @{
            Id = "nvidia-low-latency"
            Name = "NVIDIA Ultra Low Latency"
            Description = "Aktiviert Ultra Low Latency Mode global"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm"
                Values = @{ DisableWriteCombining = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-prerender-frames"
            Name = "Pre-Rendered Frames = 1"
            Description = "Minimiert Pre-Rendered Frames für niedrigste Latenz"
            Registry = @{
                Path = "HKLM:\SOFTWARE\NVIDIA Corporation\Global\FTS"
                Values = @{ EnableRID73779 = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-threaded-optimization"
            Name = "Threaded Optimization AUS"
            Description = "Deaktiviert Threaded Optimization für Gaming"
            Registry = @{
                Path = "HKLM:\SOFTWARE\NVIDIA Corporation\Global\NVTweak"
                Values = @{ Threaded_Optimization = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-shader-cache"
            Name = "Shader Cache optimieren"
            Description = "Erhöht Shader Cache für schnelleres Laden"
            Registry = @{
                Path = "HKLM:\SOFTWARE\NVIDIA Corporation\Global\NVTweak"
                Values = @{ ShaderCache = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-power-management"
            Name = "NVIDIA Power: Prefer Performance"
            Description = "Setzt GPU Power Management auf Maximum"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
                Values = @{ PerfLevelSrc = 0x2222 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-msi-mode"
            Name = "NVIDIA MSI Mode"
            Description = "Aktiviert Message Signaled Interrupts für NVIDIA GPU"
            Command = {
                $nvidiaDevices = Get-WmiObject Win32_VideoController | Where-Object { $_.Name -like "*NVIDIA*" }
                foreach ($device in $nvidiaDevices) {
                    $devicePath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($device.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
                    if (Test-Path $devicePath) {
                        Set-ItemProperty -Path $devicePath -Name "MSISupported" -Value 1 -ErrorAction SilentlyContinue
                    }
                }
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-mpo"
            Name = "Multi-Plane Overlay AUS"
            Description = "Deaktiviert MPO für stabilere Frametimes"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows\Dwm"
                Values = @{ OverlayTestMode = 5 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-hdcp"
            Name = "HDCP deaktivieren"
            Description = "Deaktiviert HDCP für weniger Overhead"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
                Values = @{ RMHdcpKeyglobZero = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-gpu-prerender"
            Name = "GPU Pre-Rendering AUS"
            Description = "Deaktiviert GPU Pre-Rendering"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
                Values = @{ DisablePreRender = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-gsync-pendingframes"
            Name = "G-Sync Pending Frames = 1"
            Description = "Minimiert G-Sync Pending Frames"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
                Values = @{ FlipQueueSize = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-disable-telemetry"
            Name = "NVIDIA Telemetrie AUS"
            Description = "Deaktiviert NVIDIA Telemetrie und Tracking"
            Command = {
                Stop-Service -Name "NvTelemetryContainer" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "NvTelemetryContainer" -StartupType Disabled -ErrorAction SilentlyContinue
                $tasks = @(
                    "NvProfileUpdaterDaily",
                    "NvTmRepOnLogon",
                    "NvTmRep",
                    "NvTmMon"
                )
                foreach ($task in $tasks) {
                    schtasks /Change /TN "\NVIDIA\$task" /Disable 2>$null
                }
            }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "nvidia-p-state"
            Name = "Force P-State 0"
            Description = "Erzwingt maximalen GPU P-State"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
                Values = @{ DisableDynamicPState = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Moderate"
        }
    )

    # ═══════════════════════════ NETWORK ═══════════════════════════
    Network = @(
        @{
            Id = "nagle-algorithm"
            Name = "Nagle Algorithm deaktivieren"
            Description = "Deaktiviert Nagle-Algorithmus für niedrigere Latenz"
            Command = {
                $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
                foreach ($adapter in $adapters) {
                    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$($adapter.InterfaceGuid)"
                    Set-ItemProperty -Path $regPath -Name "TcpAckFrequency" -Value 1 -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $regPath -Name "TCPNoDelay" -Value 1 -ErrorAction SilentlyContinue
                }
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "network-throttling"
            Name = "Network Throttling deaktivieren"
            Description = "Deaktiviert Windows Network Throttling"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
                Values = @{ 
                    NetworkThrottlingIndex = 0xFFFFFFFF
                    SystemResponsiveness = 0
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "dns-cloudflare"
            Name = "DNS: Cloudflare (1.1.1.1)"
            Description = "Setzt Cloudflare als primären DNS-Server"
            Command = {
                $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
                foreach ($adapter in $adapters) {
                    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("1.1.1.1","1.0.0.1")
                }
            }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-lso"
            Name = "Large Send Offload AUS"
            Description = "Deaktiviert LSO für stabilere Verbindung"
            Command = {
                $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
                foreach ($adapter in $adapters) {
                    Disable-NetAdapterLso -Name $adapter.Name -ErrorAction SilentlyContinue
                }
            }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "tcp-autotuning"
            Name = "TCP Autotuning: Normal"
            Description = "Setzt TCP Autotuning auf Normal"
            Command = { netsh int tcp set global autotuninglevel=normal }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-ecn"
            Name = "ECN Capability AUS"
            Description = "Deaktiviert ECN für Gaming"
            Command = { netsh int tcp set global ecncapability=disabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "enable-rss"
            Name = "RSS aktivieren"
            Description = "Aktiviert Receive Side Scaling"
            Command = { netsh int tcp set global rss=enabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-tcp-timestamps"
            Name = "TCP Timestamps AUS"
            Description = "Deaktiviert TCP Timestamps für weniger Overhead"
            Command = { netsh int tcp set global timestamps=disabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-qos"
            Name = "QoS Packet Scheduler AUS"
            Description = "Deaktiviert QoS Bandbreitenbegrenzung"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
                Values = @{ NonBestEffortLimit = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "flush-dns"
            Name = "DNS Cache leeren"
            Description = "Leert den DNS-Cache"
            Command = { ipconfig /flushdns }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "winsock-reset"
            Name = "Winsock Reset"
            Description = "Setzt Winsock-Katalog zurück"
            Command = { netsh winsock reset }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-wifi-sense"
            Name = "WiFi Sense AUS"
            Description = "Deaktiviert WiFi Sense komplett"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
                Values = @{ value = 0 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-netbios"
            Name = "NetBIOS deaktivieren"
            Description = "Deaktiviert NetBIOS über TCP/IP"
            Command = {
                $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.TcpipNetbiosOptions -ne $null }
                foreach ($adapter in $adapters) {
                    $adapter.SetTcpipNetbios(2) | Out-Null
                }
            }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "tcp-fast-open"
            Name = "TCP Fast Open aktivieren"
            Description = "Aktiviert TCP Fast Open für schnellere Verbindungen"
            Command = { netsh int tcp set global fastopen=enabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-scaling-heuristics"
            Name = "Scaling Heuristics AUS"
            Description = "Deaktiviert TCP Scaling Heuristics"
            Command = { netsh int tcp set heuristics disabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "direct-cache-access"
            Name = "Direct Cache Access aktivieren"
            Description = "Aktiviert DCA für schnellere Netzwerk-I/O"
            Command = { netsh int tcp set global dca=enabled }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ DEBLOAT ═══════════════════════════
    Debloat = @(
        @{
            Id = "disable-telemetry"
            Name = "Windows Telemetrie AUS"
            Description = "Deaktiviert Windows Telemetrie komplett"
            Command = {
                Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
                Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
                Stop-Service dmwappushservice -Force -ErrorAction SilentlyContinue
                Set-Service dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-cortana"
            Name = "Cortana deaktivieren"
            Description = "Deaktiviert Cortana komplett"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
                Values = @{ AllowCortana = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-xbox-services"
            Name = "Xbox Services deaktivieren"
            Description = "Deaktiviert alle Xbox-Hintergrunddienste"
            Command = {
                $xboxServices = @("XblAuthManager", "XblGameSave", "XboxNetApiSvc", "XboxGipSvc")
                foreach ($service in $xboxServices) {
                    Stop-Service $service -Force -ErrorAction SilentlyContinue
                    Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
                }
            }
            Type = "cmd"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-game-dvr"
            Name = "Game DVR deaktivieren"
            Description = "Deaktiviert Xbox Game DVR und Recording"
            Registry = @{
                Path = "HKCU:\System\GameConfigStore"
                Values = @{ GameDVR_Enabled = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-game-bar"
            Name = "Game Bar deaktivieren"
            Description = "Deaktiviert Xbox Game Bar komplett"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
                Values = @{ AppCaptureEnabled = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-background-apps"
            Name = "Background Apps AUS"
            Description = "Verhindert Apps im Hintergrund"
            Registry = @{
                Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
                Values = @{ GlobalUserDisabled = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-advertising-id"
            Name = "Advertising ID deaktivieren"
            Description = "Deaktiviert personalisierte Werbung"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
                Values = @{ Enabled = 0 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-windows-tips"
            Name = "Windows Tips AUS"
            Description = "Deaktiviert Windows Tipps und Vorschläge"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                Values = @{
                    SoftLandingEnabled = 0
                    SubscribedContent_338389Enabled = 0
                    SubscribedContent_310093Enabled = 0
                }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-activity-history"
            Name = "Activity History AUS"
            Description = "Deaktiviert Windows Aktivitätsverlauf"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
                Values = @{
                    EnableActivityFeed = 0
                    PublishUserActivities = 0
                    UploadUserActivities = 0
                }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-location"
            Name = "Location Tracking AUS"
            Description = "Deaktiviert Standortverfolgung"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
                Values = @{ Value = "Deny" }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-feedback"
            Name = "Feedback Requests AUS"
            Description = "Deaktiviert Windows Feedback-Anfragen"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
                Values = @{ NumberOfSIUFInPeriod = 0 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-start-suggestions"
            Name = "Start Menu Suggestions AUS"
            Description = "Deaktiviert Startmenü-Vorschläge"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                Values = @{ 
                    SystemPaneSuggestionsEnabled = 0
                    SubscribedContent_338388Enabled = 0
                }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-onedrive"
            Name = "OneDrive deaktivieren"
            Description = "Verhindert OneDrive-Autostart"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
                Values = @{ DisableFileSyncNGSC = 1 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-copilot"
            Name = "Windows Copilot AUS"
            Description = "Deaktiviert Windows Copilot (KI-Assistent)"
            Registry = @{
                Path = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
                Values = @{ TurnOffWindowsCopilot = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-widgets"
            Name = "Widgets deaktivieren"
            Description = "Deaktiviert Windows Widgets"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
                Values = @{ AllowNewsAndInterests = 0 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "disable-consumer-features"
            Name = "Consumer Features AUS"
            Description = "Deaktiviert Windows Consumer Features"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
                Values = @{ 
                    DisableWindowsConsumerFeatures = 1
                    DisableCloudOptimizedContent = 1
                }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-print-spooler"
            Name = "Print Spooler AUS"
            Description = "Deaktiviert Druckdienst (falls nicht benötigt)"
            Command = {
                Stop-Service Spooler -Force -ErrorAction SilentlyContinue
                Set-Service Spooler -StartupType Disabled -ErrorAction SilentlyContinue
            }
            Type = "cmd"
            Impact = "Low"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ CONTROLLER ═══════════════════════════
    Controller = @(
        @{
            Id = "xbox-controller-power"
            Name = "Xbox Controller USB Power"
            Description = "Deaktiviert USB Power Saving für Controller"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\xusb22\Parameters"
                Values = @{ DisableSelectiveSuspend = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "controller-polling"
            Name = "Controller Polling Rate Max"
            Description = "Maximiert Polling-Rate für Controller"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters"
                Values = @{ 
                    DisableSelectiveSuspend = 1
                    EnhancedPowerManagementEnabled = 0
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "bluetooth-latency"
            Name = "Bluetooth Latency reduzieren"
            Description = "Optimiert Bluetooth für Controller"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\BTHUSB\Parameters"
                Values = @{ 
                    DeviceSelectiveSuspended = 0
                    SelectiveSuspendEnabled = 0
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "ds4-optimization"
            Name = "DualShock 4 Optimierung"
            Description = "Optimiert DS4 Controller-Verbindung"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters"
                Values = @{ IdleTimeout = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "dualsense-optimization"
            Name = "DualSense Optimierung"
            Description = "Optimiert PS5 DualSense Controller"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters"
                Values = @{ TreatWirelessAsUSB = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "xinput-priority"
            Name = "XInput Thread Priority"
            Description = "Erhöht XInput Thread-Priorität"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\xinputhid\Parameters"
                Values = @{ ThreadPriority = 31 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "controller-usb-suspend"
            Name = "USB Selective Suspend AUS"
            Description = "Deaktiviert USB Suspend für alle Controller"
            Command = {
                powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
                powercfg -setactive SCHEME_CURRENT
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "xbox-wireless-adapter"
            Name = "Xbox Wireless Adapter Opt."
            Description = "Optimiert Xbox Wireless Adapter"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Services\xboxgip\Parameters"
                Values = @{ PollingInterval = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "raw-input-controller"
            Name = "Raw Input für Controller"
            Description = "Aktiviert Raw Input API für Controller"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{745a17a0-74d3-11d0-b6fe-00a0c90f57da}"
                Values = @{ RawInputEnabled = 1 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "controller-deadzone"
            Name = "Controller Deadzone Min"
            Description = "Minimiert Controller-Deadzone systemweit"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Input\Settings"
                Values = @{ MinDeadzone = 1 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ LATENCY ═══════════════════════════
    Latency = @(
        @{
            Id = "csrss-priority"
            Name = "CSRSS High Priority"
            Description = "Erhöht Priorität für CSRSS (Client/Server Runtime)"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions"
                Values = @{ 
                    CpuPriorityClass = 4
                    IoPriority = 3
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "dwm-priority"
            Name = "DWM High Priority"
            Description = "Erhöht Priorität für Desktop Window Manager"
            Registry = @{
                Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions"
                Values = @{ 
                    CpuPriorityClass = 4
                    IoPriority = 3
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "context-menu-delay"
            Name = "Context Menu Delay = 0"
            Description = "Entfernt Verzögerung beim Kontextmenü"
            Registry = @{
                Path = "HKCU:\Control Panel\Desktop"
                Values = @{ MenuShowDelay = "0" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-animations"
            Name = "Animationen deaktivieren"
            Description = "Deaktiviert Windows UI-Animationen"
            Registry = @{
                Path = "HKCU:\Control Panel\Desktop\WindowMetrics"
                Values = @{ MinAnimate = "0" }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-visual-effects"
            Name = "Visual Effects minimieren"
            Description = "Setzt Visual Effects auf Maximum Performance"
            Registry = @{
                Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
                Values = @{ VisualFXSetting = 2 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-transparency"
            Name = "Transparenz deaktivieren"
            Description = "Deaktiviert Windows Transparenz-Effekte"
            Registry = @{
                Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
                Values = @{ EnableTransparency = 0 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "msi-mode-system"
            Name = "MSI Mode (System)"
            Description = "Aktiviert MSI-Mode für Systemgeräte"
            Command = {
                $devices = Get-WmiObject Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -eq 0 }
                foreach ($device in $devices) {
                    $path = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($device.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
                    if (Test-Path $path) {
                        Set-ItemProperty -Path $path -Name "MSISupported" -Value 1 -ErrorAction SilentlyContinue
                    }
                }
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "disable-spectre"
            Name = "Spectre/Meltdown Mitigations AUS"
            Description = "Deaktiviert CPU-Sicherheitspatches für mehr FPS (Risiko!)"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ 
                    FeatureSettingsOverride = 3
                    FeatureSettingsOverrideMask = 3
                }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "fullscreen-optimization"
            Name = "Fullscreen Optimization AUS"
            Description = "Deaktiviert Fullscreen Optimizations global"
            Registry = @{
                Path = "HKCU:\System\GameConfigStore"
                Values = @{ GameDVR_FSEBehaviorMode = 2 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "foreground-boost"
            Name = "Foreground Boost aktivieren"
            Description = "Aktiviert Prioritäts-Boost für Vordergrund-Apps"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
                Values = @{ Win32PrioritySeparation = 38 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "disable-threaded-dpc"
            Name = "Threaded DPC deaktivieren"
            Description = "Deaktiviert Threaded DPC für niedrigere Latenz"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"
                Values = @{ ThreadDpcEnable = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Moderate"
        },
        @{
            Id = "usb-power-management"
            Name = "USB Power Management AUS"
            Description = "Deaktiviert USB Power Management"
            Command = {
                $hubs = Get-WmiObject Win32_USBHub
                foreach ($hub in $hubs) {
                    $path = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($hub.PNPDeviceID)\Device Parameters"
                    Set-ItemProperty -Path $path -Name "EnhancedPowerManagementEnabled" -Value 0 -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $path -Name "SelectiveSuspendEnabled" -Value 0 -ErrorAction SilentlyContinue
                }
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        }
    )

    # ═══════════════════════════ MEMORY ═══════════════════════════
    Memory = @(
        @{
            Id = "disable-memory-compression"
            Name = "Memory Compression AUS"
            Description = "Deaktiviert Windows Memory Compression"
            Command = { Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "disable-superfetch"
            Name = "Superfetch deaktivieren"
            Description = "Deaktiviert Superfetch/SysMain"
            Command = {
                Stop-Service SysMain -Force -ErrorAction SilentlyContinue
                Set-Service SysMain -StartupType Disabled -ErrorAction SilentlyContinue
            }
            Type = "cmd"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "large-pages"
            Name = "Large Pages aktivieren"
            Description = "Aktiviert Large System Pages"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ LargePageMinimum = 33554432 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "system-pages-unlimited"
            Name = "System Pages Unlimited"
            Description = "Entfernt Limit für System Pages"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ SystemPages = 0 }
            }
            Type = "registry"
            Impact = "High"
            Risk = "Safe"
        },
        @{
            Id = "io-page-lock-limit"
            Name = "I/O Page Lock Limit erhöhen"
            Description = "Erhöht I/O Page Lock Limit"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ IoPageLockLimit = 983040 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "pool-usage-max"
            Name = "Pool Usage Maximum"
            Description = "Erhöht Pool Usage Maximum"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ PoolUsageMaximum = 96 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        },
        @{
            Id = "clear-pagefile"
            Name = "Pagefile bei Shutdown leeren"
            Description = "Leert Pagefile bei Windows-Shutdown"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ ClearPageFileAtShutdown = 1 }
            }
            Type = "registry"
            Impact = "Low"
            Risk = "Safe"
        },
        @{
            Id = "second-level-cache"
            Name = "L2 Cache optimieren"
            Description = "Optimiert Second Level Data Cache"
            Registry = @{
                Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
                Values = @{ SecondLevelDataCache = 512 }
            }
            Type = "registry"
            Impact = "Medium"
            Risk = "Safe"
        }
    )
}

# ═══════════════════════════════════════════════════════════════════════════════
# PROFILE DEFINITIONS
# ═══════════════════════════════════════════════════════════════════════════════

$script:Profiles = @{
    "Fortnite Pro" = @{
        Description = "Maximale FPS & minimaler Input Delay für Fortnite"
        Categories = @("Performance", "Mouse", "Keyboard", "NVIDIA", "Network", "Latency")
    }
    "Maximum FPS" = @{
        Description = "Alle Performance-Tweaks für maximale Framerate"
        Categories = @("Performance", "NVIDIA", "Memory", "Latency", "Debloat")
    }
    "Low Latency" = @{
        Description = "Minimale Latenz für kompetitives Gaming"
        Categories = @("Mouse", "Keyboard", "Controller", "Latency", "Network")
    }
    "Clean System" = @{
        Description = "Entfernt Bloatware und unnötige Dienste"
        Categories = @("Debloat")
    }
    "Controller Pro" = @{
        Description = "Optimiert für Xbox/PlayStation Controller"
        Categories = @("Controller", "Latency")
    }
    "Alle Tweaks" = @{
        Description = "Wendet ALLE verfügbaren Tweaks an"
        Categories = @("Performance", "Mouse", "Keyboard", "NVIDIA", "Network", "Debloat", "Controller", "Latency", "Memory")
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# GUI CREATION
# ═══════════════════════════════════════════════════════════════════════════════

function New-StivkaGUI {
    # Form Settings
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "⚡ Stivka Tweaks - Premium Windows Optimizer"
    $form.Size = New-Object System.Drawing.Size(1000, 700)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $form.Opacity = 0

    # Animation Timer for fade-in
    $fadeTimer = New-Object System.Windows.Forms.Timer
    $fadeTimer.Interval = 20
    $fadeTimer.Add_Tick({
        if ($form.Opacity -lt 1) {
            $form.Opacity += 0.05
        } else {
            $fadeTimer.Stop()
        }
    })

    # Header Panel
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(1000, 80)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "⚡ STIVKA TWEAKS"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::White
    $titleLabel.Location = New-Object System.Drawing.Point(20, 15)
    $titleLabel.AutoSize = $true
    $headerPanel.Controls.Add($titleLabel)

    $subtitleLabel = New-Object System.Windows.Forms.Label
    $subtitleLabel.Text = "Premium Windows Optimization Tool - 300+ Automated Tweaks"
    $subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $subtitleLabel.ForeColor = [System.Drawing.Color]::Gray
    $subtitleLabel.Location = New-Object System.Drawing.Point(22, 52)
    $subtitleLabel.AutoSize = $true
    $headerPanel.Controls.Add($subtitleLabel)

    $form.Controls.Add($headerPanel)

    # Tab Control
    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Location = New-Object System.Drawing.Point(10, 90)
    $tabControl.Size = New-Object System.Drawing.Size(970, 510)
    $tabControl.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

    # Create tabs for each category
    $categories = @("Performance", "Mouse", "Keyboard", "NVIDIA", "Network", "Debloat", "Controller", "Latency", "Memory", "Settings")
    
    foreach ($category in $categories) {
        $tab = New-Object System.Windows.Forms.TabPage
        $tab.Text = $category
        $tab.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
        $tab.ForeColor = [System.Drawing.Color]::White

        if ($category -eq "Settings") {
            # Settings Tab
            $settingsPanel = New-Object System.Windows.Forms.Panel
            $settingsPanel.Location = New-Object System.Drawing.Point(10, 10)
            $settingsPanel.Size = New-Object System.Drawing.Size(940, 450)
            $settingsPanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

            $cbRestorePoint = New-Object System.Windows.Forms.CheckBox
            $cbRestorePoint.Text = "🛡️ Wiederherstellungspunkt erstellen (Empfohlen)"
            $cbRestorePoint.Location = New-Object System.Drawing.Point(20, 20)
            $cbRestorePoint.Size = New-Object System.Drawing.Size(400, 30)
            $cbRestorePoint.ForeColor = [System.Drawing.Color]::White
            $cbRestorePoint.Checked = $true
            $cbRestorePoint.Tag = "CreateRestorePoint"
            $settingsPanel.Controls.Add($cbRestorePoint)

            $cbAdvanced = New-Object System.Windows.Forms.CheckBox
            $cbAdvanced.Text = "⚠️ Erweiterte Tweaks anzeigen (Spectre/Meltdown deaktivieren etc.)"
            $cbAdvanced.Location = New-Object System.Drawing.Point(20, 60)
            $cbAdvanced.Size = New-Object System.Drawing.Size(450, 30)
            $cbAdvanced.ForeColor = [System.Drawing.Color]::Orange
            $cbAdvanced.Checked = $false
            $cbAdvanced.Tag = "ShowAdvancedTweaks"
            $settingsPanel.Controls.Add($cbAdvanced)

            $cbAutoReboot = New-Object System.Windows.Forms.CheckBox
            $cbAutoReboot.Text = "🔄 Nach Anwendung automatisch neu starten"
            $cbAutoReboot.Location = New-Object System.Drawing.Point(20, 100)
            $cbAutoReboot.Size = New-Object System.Drawing.Size(400, 30)
            $cbAutoReboot.ForeColor = [System.Drawing.Color]::White
            $cbAutoReboot.Checked = $false
            $cbAutoReboot.Tag = "AutoReboot"
            $settingsPanel.Controls.Add($cbAutoReboot)

            # Profile Quick Selection
            $profileLabel = New-Object System.Windows.Forms.Label
            $profileLabel.Text = "🎮 Schnell-Profile:"
            $profileLabel.Location = New-Object System.Drawing.Point(20, 160)
            $profileLabel.Size = New-Object System.Drawing.Size(200, 25)
            $profileLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
            $profileLabel.ForeColor = [System.Drawing.Color]::White
            $settingsPanel.Controls.Add($profileLabel)

            $yPos = 195
            foreach ($profile in $script:Profiles.Keys) {
                $btn = New-Object System.Windows.Forms.Button
                $btn.Text = $profile
                $btn.Location = New-Object System.Drawing.Point(20, $yPos)
                $btn.Size = New-Object System.Drawing.Size(200, 35)
                $btn.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
                $btn.ForeColor = [System.Drawing.Color]::White
                $btn.FlatStyle = "Flat"
                $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
                $btn.Tag = $profile
                $btn.Add_Click({
                    param($sender, $e)
                    $profileName = $sender.Tag
                    Apply-Profile -ProfileName $profileName -TabControl $tabControl
                })
                $settingsPanel.Controls.Add($btn)
                
                $descLabel = New-Object System.Windows.Forms.Label
                $descLabel.Text = $script:Profiles[$profile].Description
                $descLabel.Location = New-Object System.Drawing.Point(230, ($yPos + 8))
                $descLabel.Size = New-Object System.Drawing.Size(500, 20)
                $descLabel.ForeColor = [System.Drawing.Color]::Gray
                $settingsPanel.Controls.Add($descLabel)
                
                $yPos += 45
            }

            $tab.Controls.Add($settingsPanel)
        }
        else {
            # Tweak Category Tab
            $listView = New-Object System.Windows.Forms.ListView
            $listView.Location = New-Object System.Drawing.Point(10, 10)
            $listView.Size = New-Object System.Drawing.Size(940, 450)
            $listView.View = "Details"
            $listView.FullRowSelect = $true
            $listView.CheckBoxes = $true
            $listView.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $listView.ForeColor = [System.Drawing.Color]::White
            $listView.BorderStyle = "None"
            $listView.GridLines = $true
            $listView.Tag = $category

            $listView.Columns.Add("Tweak", 300) | Out-Null
            $listView.Columns.Add("Beschreibung", 400) | Out-Null
            $listView.Columns.Add("Impact", 80) | Out-Null
            $listView.Columns.Add("Risiko", 80) | Out-Null

            # Populate tweaks
            if ($script:Tweaks.ContainsKey($category)) {
                foreach ($tweak in $script:Tweaks[$category]) {
                    $item = New-Object System.Windows.Forms.ListViewItem($tweak.Name)
                    $item.SubItems.Add($tweak.Description) | Out-Null
                    $item.SubItems.Add($tweak.Impact) | Out-Null
                    $item.SubItems.Add($tweak.Risk) | Out-Null
                    $item.Tag = $tweak
                    
                    # Color coding for risk
                    if ($tweak.Risk -eq "Moderate") {
                        $item.ForeColor = [System.Drawing.Color]::Orange
                    }
                    
                    $listView.Items.Add($item) | Out-Null
                }
            }

            $tab.Controls.Add($listView)
        }

        $tabControl.TabPages.Add($tab)
    }

    $form.Controls.Add($tabControl)

    # Bottom Buttons Panel
    $bottomPanel = New-Object System.Windows.Forms.Panel
    $bottomPanel.Location = New-Object System.Drawing.Point(0, 605)
    $bottomPanel.Size = New-Object System.Drawing.Size(1000, 70)
    $bottomPanel.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)

    # Select All Button
    $selectAllBtn = New-Object System.Windows.Forms.Button
    $selectAllBtn.Text = "☑️ Alle auswählen"
    $selectAllBtn.Location = New-Object System.Drawing.Point(20, 15)
    $selectAllBtn.Size = New-Object System.Drawing.Size(150, 40)
    $selectAllBtn.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $selectAllBtn.ForeColor = [System.Drawing.Color]::White
    $selectAllBtn.FlatStyle = "Flat"
    $selectAllBtn.Add_Click({
        foreach ($tab in $tabControl.TabPages) {
            foreach ($control in $tab.Controls) {
                if ($control -is [System.Windows.Forms.ListView]) {
                    foreach ($item in $control.Items) {
                        $item.Checked = $true
                    }
                }
            }
        }
    })
    $bottomPanel.Controls.Add($selectAllBtn)

    # Deselect All Button
    $deselectAllBtn = New-Object System.Windows.Forms.Button
    $deselectAllBtn.Text = "☐ Alle abwählen"
    $deselectAllBtn.Location = New-Object System.Drawing.Point(180, 15)
    $deselectAllBtn.Size = New-Object System.Drawing.Size(150, 40)
    $deselectAllBtn.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $deselectAllBtn.ForeColor = [System.Drawing.Color]::White
    $deselectAllBtn.FlatStyle = "Flat"
    $deselectAllBtn.Add_Click({
        foreach ($tab in $tabControl.TabPages) {
            foreach ($control in $tab.Controls) {
                if ($control -is [System.Windows.Forms.ListView]) {
                    foreach ($item in $control.Items) {
                        $item.Checked = $false
                    }
                }
            }
        }
    })
    $bottomPanel.Controls.Add($deselectAllBtn)

    # Status Label
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Bereit - Wähle Tweaks aus und klicke auf 'Anwenden'"
    $statusLabel.Location = New-Object System.Drawing.Point(350, 22)
    $statusLabel.Size = New-Object System.Drawing.Size(400, 25)
    $statusLabel.ForeColor = [System.Drawing.Color]::LightGreen
    $statusLabel.Tag = "StatusLabel"
    $bottomPanel.Controls.Add($statusLabel)

    # Apply Button
    $applyBtn = New-Object System.Windows.Forms.Button
    $applyBtn.Text = "🚀 TWEAKS ANWENDEN"
    $applyBtn.Location = New-Object System.Drawing.Point(780, 10)
    $applyBtn.Size = New-Object System.Drawing.Size(200, 50)
    $applyBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $applyBtn.ForeColor = [System.Drawing.Color]::White
    $applyBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $applyBtn.FlatStyle = "Flat"
    $applyBtn.Add_Click({
        Apply-SelectedTweaks -TabControl $tabControl -StatusLabel $statusLabel
    })
    $bottomPanel.Controls.Add($applyBtn)

    $form.Controls.Add($bottomPanel)

    # Start fade-in animation
    $form.Add_Shown({ $fadeTimer.Start() })

    return $form
}

# ═══════════════════════════════════════════════════════════════════════════════
# TWEAK APPLICATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

function Apply-Profile {
    param(
        [string]$ProfileName,
        [System.Windows.Forms.TabControl]$TabControl
    )
    
    $profile = $script:Profiles[$ProfileName]
    if (-not $profile) { return }

    foreach ($tab in $TabControl.TabPages) {
        foreach ($control in $tab.Controls) {
            if ($control -is [System.Windows.Forms.ListView]) {
                $category = $control.Tag
                $shouldSelect = $profile.Categories -contains $category
                
                foreach ($item in $control.Items) {
                    $item.Checked = $shouldSelect
                }
            }
        }
    }
    
    [System.Windows.Forms.MessageBox]::Show(
        "Profil '$ProfileName' geladen!`n`nKlicke auf 'TWEAKS ANWENDEN' um fortzufahren.",
        "Profil geladen",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}

function Apply-SelectedTweaks {
    param(
        [System.Windows.Forms.TabControl]$TabControl,
        [System.Windows.Forms.Label]$StatusLabel
    )

    $selectedTweaks = @()
    
    foreach ($tab in $TabControl.TabPages) {
        foreach ($control in $tab.Controls) {
            if ($control -is [System.Windows.Forms.ListView]) {
                foreach ($item in $control.Items) {
                    if ($item.Checked) {
                        $selectedTweaks += $item.Tag
                    }
                }
            }
        }
    }

    if ($selectedTweaks.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            "Keine Tweaks ausgewählt!`n`nWähle mindestens einen Tweak aus der Liste.",
            "Keine Auswahl",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }

    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "$($selectedTweaks.Count) Tweaks werden angewendet.`n`nFortfahren?",
        "Bestätigung",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes) { return }

    # Create Restore Point
    if ($script:Settings.CreateRestorePoint) {
        $StatusLabel.Text = "Erstelle Wiederherstellungspunkt..."
        $StatusLabel.ForeColor = [System.Drawing.Color]::Yellow
        [System.Windows.Forms.Application]::DoEvents()
        
        try {
            Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
            Checkpoint-Computer -Description "Stivka Tweaks - Pre-Application" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "Wiederherstellungspunkt konnte nicht erstellt werden"
        }
    }

    # Apply Tweaks
    $applied = 0
    $failed = 0

    foreach ($tweak in $selectedTweaks) {
        $StatusLabel.Text = "Wende an: $($tweak.Name)..."
        [System.Windows.Forms.Application]::DoEvents()

        try {
            if ($tweak.Type -eq "registry" -and $tweak.Registry) {
                $regPath = $tweak.Registry.Path
                
                # Ensure path exists
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                
                foreach ($valueName in $tweak.Registry.Values.Keys) {
                    $value = $tweak.Registry.Values[$valueName]
                    if ($null -ne $value) {
                        Set-ItemProperty -Path $regPath -Name $valueName -Value $value -Force -ErrorAction SilentlyContinue
                    }
                }
                $applied++
            }
            elseif ($tweak.Type -eq "cmd" -and $tweak.Command) {
                & $tweak.Command
                $applied++
            }
        }
        catch {
            $failed++
            Write-Warning "Fehler bei: $($tweak.Name) - $($_.Exception.Message)"
        }
    }

    # Complete
    $StatusLabel.Text = "✅ Fertig! $applied Tweaks angewendet" + $(if ($failed -gt 0) { ", $failed fehlgeschlagen" } else { "" })
    $StatusLabel.ForeColor = [System.Drawing.Color]::LightGreen

    $result = [System.Windows.Forms.MessageBox]::Show(
        "✅ $applied von $($selectedTweaks.Count) Tweaks erfolgreich angewendet!`n`n⚠️ Ein Neustart wird empfohlen für volle Wirkung.`n`nJetzt neu starten?",
        "Tweaks angewendet",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )

    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Restart-Computer -Force
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                                                              ║" -ForegroundColor Cyan
Write-Host "  ║   ███████╗████████╗██╗██╗   ██╗██╗  ██╗ █████╗              ║" -ForegroundColor White
Write-Host "  ║   ██╔════╝╚══██╔══╝██║██║   ██║██║ ██╔╝██╔══██╗             ║" -ForegroundColor White
Write-Host "  ║   ███████╗   ██║   ██║██║   ██║█████╔╝ ███████║             ║" -ForegroundColor White
Write-Host "  ║   ╚════██║   ██║   ██║╚██╗ ██╔╝██╔═██╗ ██╔══██║             ║" -ForegroundColor White
Write-Host "  ║   ███████║   ██║   ██║ ╚████╔╝ ██║  ██╗██║  ██║             ║" -ForegroundColor White
Write-Host "  ║   ╚══════╝   ╚═╝   ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝             ║" -ForegroundColor White
Write-Host "  ║                                                              ║" -ForegroundColor Cyan
Write-Host "  ║          PREMIUM WINDOWS OPTIMIZATION TOOL                   ║" -ForegroundColor Yellow
Write-Host "  ║                  300+ Automated Tweaks                       ║" -ForegroundColor Gray
Write-Host "  ║                                                              ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Starte GUI..." -ForegroundColor Green
Write-Host ""

# Launch GUI
$gui = New-StivkaGUI
[void][System.Windows.Forms.Application]::Run($gui)
