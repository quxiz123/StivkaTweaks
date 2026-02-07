# Stivka Tweaks - Premium Windows Optimization Tool
# Stivka Tweaks - Windows Optimization Tool
# Usage: irm https://raw.githubusercontent.com/YOUR_USERNAME/StivkaTweaks/main/StivkaTweaks.ps1 | iex
# Admin check that works with irm | iex
$ErrorActionPreference = "SilentlyContinue"
# Admin check
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "`n  [!] Administrator-Rechte erforderlich!" -ForegroundColor Red
    Write-Host "  [i] Starte PowerShell als Administrator und fuehre den Befehl erneut aus.`n" -ForegroundColor Yellow
    pause
    Write-Host ""
    Write-Host "  [!] Administrator-Rechte erforderlich!" -ForegroundColor Red
    Write-Host "  [i] Starte PowerShell als Administrator" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Druecke Enter zum Beenden"
    exit
}
# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
# ============================================================================
# TWEAKS DATABASE
# ============================================================================
$script:AllTweaks = @(
    # === PERFORMANCE ===
    @{ Id="perf-1"; Cat="Performance"; Name="Ultimate Performance Power Plan"; Desc="Aktiviert versteckten Modus"; Cmd={ powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null; powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null }; Type="cmd"; Impact="High"; Risk="Safe" }
    @{ Id="perf-2"; Cat="Performance"; Name="High Performance Power Plan"; Desc="Windows Hochleistungsmodus"; Cmd={ powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null }; Type="cmd"; Impact="High"; Risk="Safe" }
    @{ Id="perf-3"; Cat="Performance"; Name="Core Parking deaktivieren"; Desc="Alle CPU-Kerne aktiv halten"; Cmd={ powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100; powercfg -setactive SCHEME_CURRENT }; Type="cmd"; Impact="High"; Risk="Safe" }
    @{ Id="perf-4"; Cat="Performance"; Name="Timer Resolution 0.5ms"; Desc="Reduziert Windows Timer"; Cmd={ bcdedit /set useplatformtick yes 2>$null; bcdedit /set disabledynamictick yes 2>$null }; Type="cmd"; Impact="High"; Risk="Moderate" }
    @{ Id="perf-5"; Cat="Performance"; Name="Game Mode optimieren"; Desc="Windows Game Mode Boost"; Reg=@{Path="HKCU:\Software\Microsoft\GameBar"; Values=@{AutoGameModeEnabled=1; AllowAutoGameMode=1}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-6"; Cat="Performance"; Name="Hardware GPU Scheduling"; Desc="GPU-Planung aktivieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"; Values=@{HwSchMode=2}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="perf-7"; Cat="Performance"; Name="Power Throttling aus"; Desc="CPU Throttling deaktivieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"; Values=@{PowerThrottlingOff=1}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="perf-8"; Cat="Performance"; Name="CPU fuer Programme priorisieren"; Desc="Vordergrund-Apps bevorzugen"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"; Values=@{Win32PrioritySeparation=38}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-9"; Cat="Performance"; Name="Prefetch deaktivieren"; Desc="Fuer SSD optimiert"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"; Values=@{EnablePrefetcher=0; EnableSuperfetch=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-10"; Cat="Performance"; Name="Search Indexing aus"; Desc="Hintergrund-Indizierung stoppen"; Cmd={ Stop-Service WSearch -Force -EA 0; Set-Service WSearch -StartupType Disabled -EA 0 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-11"; Cat="Performance"; Name="Hibernate deaktivieren"; Desc="SSD Speicher sparen"; Cmd={ powercfg /hibernate off }; Type="cmd"; Impact="Low"; Risk="Safe" }
    @{ Id="perf-12"; Cat="Performance"; Name="Fast Startup aus"; Desc="Saubere Neustarts"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"; Values=@{HiberbootEnabled=0}}; Type="reg"; Impact="Low"; Risk="Safe" }
    @{ Id="perf-13"; Cat="Performance"; Name="SSD TRIM optimieren"; Desc="TRIM aktivieren"; Cmd={ fsutil behavior set DisableDeleteNotify 0 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-14"; Cat="Performance"; Name="Kernel im RAM halten"; Desc="Windows-Kernel nicht auslagern"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Values=@{DisablePagingExecutive=1}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="perf-15"; Cat="Performance"; Name="GPU Priority fuer Games"; Desc="Spiele GPU-Prioritaet erhoehen"; Reg=@{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"; Values=@{Priority=6; "GPU Priority"=8}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="perf-16"; Cat="Performance"; Name="Max CPU State 100%"; Desc="Volle CPU Leistung"; Cmd={ powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100; powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100; powercfg -setactive SCHEME_CURRENT }; Type="cmd"; Impact="High"; Risk="Moderate" }
    @{ Id="perf-17"; Cat="Performance"; Name="Startup Delay entfernen"; Desc="Schnellerer Windows-Start"; Reg=@{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"; Values=@{StartupDelayInMSec=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="perf-18"; Cat="Performance"; Name="NTFS Last Access aus"; Desc="Dateisystem optimieren"; Cmd={ fsutil behavior set disablelastaccess 1 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    # === KEYBOARD ===
    @{ Id="kb-1"; Cat="Keyboard"; Name="Max Tastatur-Response"; Desc="Delay 0, Speed 31"; Reg=@{Path="HKCU:\Control Panel\Keyboard"; Values=@{KeyboardDelay="0"; KeyboardSpeed="31"}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="kb-2"; Cat="Keyboard"; Name="Keyboard Data Queue"; Desc="Groesserer Datenpuffer"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters"; Values=@{KeyboardDataQueueSize=100}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="kb-3"; Cat="Keyboard"; Name="Sticky Keys deaktivieren"; Desc="Einrastfunktion aus"; Reg=@{Path="HKCU:\Control Panel\Accessibility\StickyKeys"; Values=@{Flags="506"}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="kb-4"; Cat="Keyboard"; Name="Filter Keys deaktivieren"; Desc="Anschlagverzoegerung aus"; Reg=@{Path="HKCU:\Control Panel\Accessibility\Keyboard Response"; Values=@{Flags="122"}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="kb-5"; Cat="Keyboard"; Name="Toggle Keys deaktivieren"; Desc="Toggle-Key Sounds aus"; Reg=@{Path="HKCU:\Control Panel\Accessibility\ToggleKeys"; Values=@{Flags="58"}}; Type="reg"; Impact="Low"; Risk="Safe" }
    @{ Id="kb-6"; Cat="Keyboard"; Name="USB Keyboard Latency"; Desc="USB Polling optimieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters"; Values=@{ThreadPriority=31}}; Type="reg"; Impact="High"; Risk="Safe" }
    # === MOUSE ===
    @{ Id="mouse-1"; Cat="Mouse"; Name="Mouse Acceleration aus"; Desc="Raw Input aktivieren"; Reg=@{Path="HKCU:\Control Panel\Mouse"; Values=@{MouseSpeed="0"; MouseThreshold1="0"; MouseThreshold2="0"}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="mouse-2"; Cat="Mouse"; Name="Enhanced Pointer aus"; Desc="Zeigerbeschleunigung deaktivieren"; Reg=@{Path="HKCU:\Control Panel\Mouse"; Values=@{MouseSensitivity="10"}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="mouse-3"; Cat="Mouse"; Name="Mouse Data Queue"; Desc="Groesserer Datenpuffer"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"; Values=@{MouseDataQueueSize=100}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="mouse-4"; Cat="Mouse"; Name="USB Mouse Latency"; Desc="USB Polling optimieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\mouhid\Parameters"; Values=@{ThreadPriority=31}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="mouse-5"; Cat="Mouse"; Name="MarkC Mouse Fix"; Desc="1:1 Mausbewegung"; Reg=@{Path="HKCU:\Control Panel\Mouse"; Values=@{SmoothMouseXCurve=[byte[]](0,0,0,0,0,0,0,0,192,204,12,0,0,0,0,0,128,153,25,0,0,0,0,0,64,102,38,0,0,0,0,0,0,51,51,0,0,0,0,0); SmoothMouseYCurve=[byte[]](0,0,0,0,0,0,0,0,0,0,56,0,0,0,0,0,0,0,112,0,0,0,0,0,0,0,168,0,0,0,0,0,0,0,224,0,0,0,0,0)}}; Type="reg"; Impact="High"; Risk="Safe" }
    # === NVIDIA ===
    @{ Id="nv-1"; Cat="NVIDIA"; Name="NVIDIA Telemetry aus"; Desc="Tracking deaktivieren"; Cmd={ Stop-Service NvTelemetryContainer -Force -EA 0; Set-Service NvTelemetryContainer -StartupType Disabled -EA 0 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="nv-2"; Cat="NVIDIA"; Name="NVIDIA Treiber Prioritaet"; Desc="Treiber-Thread Prioritaet erhoehen"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters"; Values=@{ThreadPriority=31}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="nv-3"; Cat="NVIDIA"; Name="CUDA Force P2 State"; Desc="GPU State optimieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"; Values=@{DisableDynamicPstate=1}}; Type="reg"; Impact="High"; Risk="Moderate" }
    @{ Id="nv-4"; Cat="NVIDIA"; Name="NVIDIA MSI Mode"; Desc="Message Signaled Interrupts"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters"; Values=@{EnableMSI=1}}; Type="reg"; Impact="High"; Risk="Moderate" }
    @{ Id="nv-5"; Cat="NVIDIA"; Name="Shader Cache optimieren"; Desc="Shader-Cache vergroessern"; Reg=@{Path="HKCU:\SOFTWARE\NVIDIA Corporation\Global\NVTweak"; Values=@{NvCplShaderCacheSize=5368709120}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    # === NETWORK ===
    @{ Id="net-1"; Cat="Network"; Name="Nagle Algorithm aus"; Desc="TCP Latenz reduzieren"; Reg=@{Path="HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters"; Values=@{TCPNoDelay=1}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="net-2"; Cat="Network"; Name="Network Throttling aus"; Desc="Drosselung deaktivieren"; Reg=@{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; Values=@{NetworkThrottlingIndex=0xffffffff; SystemResponsiveness=0}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="net-3"; Cat="Network"; Name="DNS Cloudflare"; Desc="1.1.1.1 DNS Server"; Cmd={ netsh interface ip set dns "Ethernet" static 1.1.1.1 validate=no 2>$null; netsh interface ip add dns "Ethernet" 1.0.0.1 index=2 validate=no 2>$null; ipconfig /flushdns 2>$null }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="net-4"; Cat="Network"; Name="DNS Google"; Desc="8.8.8.8 DNS Server"; Cmd={ netsh interface ip set dns "Ethernet" static 8.8.8.8 validate=no 2>$null; netsh interface ip add dns "Ethernet" 8.8.4.4 index=2 validate=no 2>$null; ipconfig /flushdns 2>$null }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="net-5"; Cat="Network"; Name="TCP Stack optimieren"; Desc="Netzwerk-Stack tunen"; Cmd={ netsh int tcp set global autotuninglevel=normal 2>$null; netsh int tcp set global ecncapability=disabled 2>$null; netsh int tcp set global timestamps=disabled 2>$null }; Type="cmd"; Impact="High"; Risk="Safe" }
    @{ Id="net-6"; Cat="Network"; Name="QoS deaktivieren"; Desc="Bandbreitenreservierung aus"; Reg=@{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"; Values=@{NonBestEffortLimit=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="net-7"; Cat="Network"; Name="DNS Cache leeren"; Desc="DNS Neustart"; Cmd={ ipconfig /flushdns; ipconfig /registerdns; netsh winsock reset 2>$null }; Type="cmd"; Impact="Low"; Risk="Safe" }
    # === DEBLOAT ===
    @{ Id="deb-1"; Cat="Debloat"; Name="Cortana deaktivieren"; Desc="Cortana ausschalten"; Reg=@{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Values=@{AllowCortana=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="deb-2"; Cat="Debloat"; Name="Telemetry reduzieren"; Desc="Datensammlung aus"; Reg=@{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Values=@{AllowTelemetry=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="deb-3"; Cat="Debloat"; Name="Game DVR deaktivieren"; Desc="Xbox Game Recording aus"; Reg=@{Path="HKCU:\System\GameConfigStore"; Values=@{GameDVR_Enabled=0; GameDVR_FSEBehaviorMode=2}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="deb-4"; Cat="Debloat"; Name="Xbox Services aus"; Desc="Xbox Dienste stoppen"; Cmd={ Stop-Service XboxGipSvc -Force -EA 0; Set-Service XboxGipSvc -StartupType Disabled -EA 0; Stop-Service XblAuthManager -Force -EA 0; Set-Service XblAuthManager -StartupType Disabled -EA 0 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="deb-5"; Cat="Debloat"; Name="Superfetch aus"; Desc="SysMain deaktivieren"; Cmd={ Stop-Service SysMain -Force -EA 0; Set-Service SysMain -StartupType Disabled -EA 0 }; Type="cmd"; Impact="Medium"; Risk="Safe" }
    @{ Id="deb-6"; Cat="Debloat"; Name="Windows Tips aus"; Desc="Tipps-Benachrichtigungen deaktivieren"; Reg=@{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Values=@{SoftLandingEnabled=0; SubscribedContent_338389Enabled=0}}; Type="reg"; Impact="Low"; Risk="Safe" }
    @{ Id="deb-7"; Cat="Debloat"; Name="OneDrive Autostart aus"; Desc="OneDrive nicht starten"; Cmd={ Remove-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive" -EA 0 }; Type="cmd"; Impact="Low"; Risk="Safe" }
    @{ Id="deb-8"; Cat="Debloat"; Name="Background Apps aus"; Desc="Hintergrund-Apps deaktivieren"; Reg=@{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"; Values=@{GlobalUserDisabled=1}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    # === LATENCY ===
    @{ Id="lat-1"; Cat="Latency"; Name="USB Selective Suspend aus"; Desc="USB Energiesparen aus"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\USB"; Values=@{DisableSelectiveSuspend=1}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="lat-2"; Cat="Latency"; Name="MMCSS Gaming Priority"; Desc="Multimedia-Prioritaet erhoehen"; Reg=@{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; Values=@{SystemResponsiveness=0}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="lat-3"; Cat="Latency"; Name="DPC Watchdog aus"; Desc="Watchdog Timer aus"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\WHEA\Policies"; Values=@{IgnoreDpcTimeoutViolations=1}}; Type="reg"; Impact="High"; Risk="Moderate" }
    @{ Id="lat-4"; Cat="Latency"; Name="Interrupt Affinity"; Desc="IRQ Affinitaet optimieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"; Values=@{InterruptSteeringDisabled=0}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="lat-5"; Cat="Latency"; Name="Windows DWM Latency"; Desc="Desktop Compositor optimieren"; Reg=@{Path="HKCU:\Software\Microsoft\Windows\DWM"; Values=@{EnableAeroPeek=0}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    # === MEMORY ===
    @{ Id="mem-1"; Cat="Memory"; Name="Large System Cache"; Desc="Groesserer System-Cache"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Values=@{LargeSystemCache=1}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    @{ Id="mem-2"; Cat="Memory"; Name="Clear Pagefile beim Shutdown"; Desc="RAM Swap bereinigen"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Values=@{ClearPageFileAtShutdown=0}}; Type="reg"; Impact="Low"; Risk="Safe" }
    @{ Id="mem-3"; Cat="Memory"; Name="I/O Page Lock aus"; Desc="Speichersperren entfernen"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Values=@{IoPageLockLimit=983040}}; Type="reg"; Impact="Medium"; Risk="Safe" }
    # === CONTROLLER ===
    @{ Id="ctrl-1"; Cat="Controller"; Name="Controller Polling Max"; Desc="Controller Abfragerate max"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters"; Values=@{ThreadPriority=31}}; Type="reg"; Impact="High"; Risk="Safe" }
    @{ Id="ctrl-2"; Cat="Controller"; Name="Xbox Controller Latency"; Desc="Xbox Input optimieren"; Reg=@{Path="HKLM:\SYSTEM\CurrentControlSet\Services\xusb22\Parameters"; Values=@{ThreadPriority=31}}; Type="reg"; Impact="High"; Risk="Safe" }
# Tweaks Data
$script:Tweaks = @(
    @{Id="p1";Cat="Performance";Name="Ultimate Power Plan";Desc="Maximale Leistung";Type="cmd";Cmd={powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null;powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null}}
    @{Id="p2";Cat="Performance";Name="Core Parking aus";Desc="Alle CPU-Kerne aktiv";Type="cmd";Cmd={powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100;powercfg -setactive SCHEME_CURRENT}}
    @{Id="p3";Cat="Performance";Name="Timer Resolution";Desc="0.5ms Timer";Type="cmd";Cmd={bcdedit /set useplatformtick yes 2>$null;bcdedit /set disabledynamictick yes 2>$null}}
    @{Id="p4";Cat="Performance";Name="Game Mode";Desc="Windows Game Mode Boost";Type="reg";Path="HKCU:\Software\Microsoft\GameBar";Values=@{AutoGameModeEnabled=1;AllowAutoGameMode=1}}
    @{Id="p5";Cat="Performance";Name="GPU Scheduling";Desc="Hardware GPU Scheduling";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers";Values=@{HwSchMode=2}}
    @{Id="p6";Cat="Performance";Name="Power Throttling aus";Desc="Kein CPU Throttling";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling";Values=@{PowerThrottlingOff=1}}
    @{Id="p7";Cat="Performance";Name="CPU Prioritaet";Desc="Vordergrund bevorzugen";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl";Values=@{Win32PrioritySeparation=38}}
    @{Id="p8";Cat="Performance";Name="Prefetch aus";Desc="SSD optimiert";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters";Values=@{EnablePrefetcher=0;EnableSuperfetch=0}}
    @{Id="p9";Cat="Performance";Name="Search Indexing aus";Desc="Hintergrund-Index stoppen";Type="cmd";Cmd={Stop-Service WSearch -Force -EA 0;Set-Service WSearch -StartupType Disabled -EA 0}}
    @{Id="p10";Cat="Performance";Name="Hibernate aus";Desc="Speicher sparen";Type="cmd";Cmd={powercfg /hibernate off}}
    @{Id="kb1";Cat="Keyboard";Name="Max Response";Desc="Delay 0, Speed 31";Type="reg";Path="HKCU:\Control Panel\Keyboard";Values=@{KeyboardDelay="0";KeyboardSpeed="31"}}
    @{Id="kb2";Cat="Keyboard";Name="Data Queue";Desc="Groesserer Puffer";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters";Values=@{KeyboardDataQueueSize=100}}
    @{Id="kb3";Cat="Keyboard";Name="Sticky Keys aus";Desc="Einrastfunktion aus";Type="reg";Path="HKCU:\Control Panel\Accessibility\StickyKeys";Values=@{Flags="506"}}
    @{Id="kb4";Cat="Keyboard";Name="Filter Keys aus";Desc="Anschlagverzoegerung aus";Type="reg";Path="HKCU:\Control Panel\Accessibility\Keyboard Response";Values=@{Flags="122"}}
    @{Id="kb5";Cat="Keyboard";Name="USB Latency";Desc="USB Polling optimieren";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\kbdhid\Parameters";Values=@{ThreadPriority=31}}
    @{Id="m1";Cat="Mouse";Name="Acceleration aus";Desc="Raw Input";Type="reg";Path="HKCU:\Control Panel\Mouse";Values=@{MouseSpeed="0";MouseThreshold1="0";MouseThreshold2="0"}}
    @{Id="m2";Cat="Mouse";Name="Enhanced Pointer aus";Desc="Zeigerbeschleunigung aus";Type="reg";Path="HKCU:\Control Panel\Mouse";Values=@{MouseSensitivity="10"}}
    @{Id="m3";Cat="Mouse";Name="Data Queue";Desc="Groesserer Puffer";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters";Values=@{MouseDataQueueSize=100}}
    @{Id="m4";Cat="Mouse";Name="USB Latency";Desc="USB Polling optimieren";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\mouhid\Parameters";Values=@{ThreadPriority=31}}
    @{Id="nv1";Cat="NVIDIA";Name="Telemetry aus";Desc="Tracking deaktivieren";Type="cmd";Cmd={Stop-Service NvTelemetryContainer -Force -EA 0;Set-Service NvTelemetryContainer -StartupType Disabled -EA 0}}
    @{Id="nv2";Cat="NVIDIA";Name="Treiber Prioritaet";Desc="Thread Prioritaet max";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters";Values=@{ThreadPriority=31}}
    @{Id="nv3";Cat="NVIDIA";Name="MSI Mode";Desc="Message Signaled Interrupts";Type="reg";Path="HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters";Values=@{EnableMSI=1}}
    @{Id="net1";Cat="Network";Name="Nagle aus";Desc="TCP Latenz reduzieren";Type="reg";Path="HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters";Values=@{TCPNoDelay=1}}
    @{Id="net2";Cat="Network";Name="Throttling aus";Desc="Drosselung deaktivieren";Type="reg";Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile";Values=@{NetworkThrottlingIndex=0xffffffff;SystemResponsiveness=0}}
    @{Id="net3";Cat="Network";Name="DNS Cloudflare";Desc="1.1.1.1 Server";Type="cmd";Cmd={netsh interface ip set dns "Ethernet" static 1.1.1.1 validate=no 2>$null;ipconfig /flushdns 2>$null}}
    @{Id="net4";Cat="Network";Name="TCP optimieren";Desc="Netzwerk-Stack tunen";Type="cmd";Cmd={netsh int tcp set global autotuninglevel=normal 2>$null;netsh int tcp set global ecncapability=disabled 2>$null}}
    @{Id="deb1";Cat="Debloat";Name="Cortana aus";Desc="Cortana deaktivieren";Type="reg";Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search";Values=@{AllowCortana=0}}
    @{Id="deb2";Cat="Debloat";Name="Telemetry aus";Desc="Datensammlung aus";Type="reg";Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection";Values=@{AllowTelemetry=0}}
    @{Id="deb3";Cat="Debloat";Name="Game DVR aus";Desc="Xbox Recording aus";Type="reg";Path="HKCU:\System\GameConfigStore";Values=@{GameDVR_Enabled=0;GameDVR_FSEBehaviorMode=2}}
    @{Id="deb4";Cat="Debloat";Name="Xbox Services aus";Desc="Xbox Dienste stoppen";Type="cmd";Cmd={Stop-Service XboxGipSvc -Force -EA 0;Set-Service XboxGipSvc -StartupType Disabled -EA 0}}
    @{Id="deb5";Cat="Debloat";Name="Superfetch aus";Desc="SysMain deaktivieren";Type="cmd";Cmd={Stop-Service SysMain -Force -EA 0;Set-Service SysMain -StartupType Disabled -EA 0}}
    @{Id="deb6";Cat="Debloat";Name="Background Apps aus";Desc="Hintergrund-Apps aus";Type="reg";Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications";Values=@{GlobalUserDisabled=1}}
)
$script:Categories = @("Performance", "Keyboard", "Mouse", "NVIDIA", "Network", "Debloat", "Latency", "Memory", "Controller")
$script:Categories = @("Performance","Keyboard","Mouse","NVIDIA","Network","Debloat")
$script:Profiles = @{
    "Fortnite Pro" = @("Performance", "Keyboard", "Mouse", "Network", "Latency")
    "Maximum FPS" = @("Performance", "NVIDIA", "Debloat", "Memory")
    "Low Latency" = @("Keyboard", "Mouse", "Latency", "Controller")
    "Clean System" = @("Debloat", "Memory")
    "All Tweaks" = @("Performance", "Keyboard", "Mouse", "NVIDIA", "Network", "Debloat", "Latency", "Memory", "Controller")
}
$script:Settings = @{
    CreateRestorePoint = $true
}
# ============================================================================
# GUI CREATION
# ============================================================================
function Show-StivkaGUI {
    # Colors
    $bgDark = [System.Drawing.Color]::FromArgb(18, 18, 18)
    $bgMid = [System.Drawing.Color]::FromArgb(28, 28, 28)
    $bgLight = [System.Drawing.Color]::FromArgb(38, 38, 38)
    $accent = [System.Drawing.Color]::FromArgb(99, 102, 241)
function Show-GUI {
    $bgDark = [System.Drawing.Color]::FromArgb(18,18,18)
    $bgMid = [System.Drawing.Color]::FromArgb(28,28,28)
    $bgLight = [System.Drawing.Color]::FromArgb(40,40,40)
    $accent = [System.Drawing.Color]::FromArgb(99,102,241)
    $textMain = [System.Drawing.Color]::White
    $textDim = [System.Drawing.Color]::FromArgb(156, 163, 175)
    $success = [System.Drawing.Color]::FromArgb(34, 197, 94)
    $warning = [System.Drawing.Color]::FromArgb(251, 191, 36)
    $textDim = [System.Drawing.Color]::FromArgb(160,160,160)
    $green = [System.Drawing.Color]::FromArgb(34,197,94)
    # Main Form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Stivka Tweaks"
    $form.Size = New-Object System.Drawing.Size(900, 650)
    $form.Size = New-Object System.Drawing.Size(850,600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $bgDark
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false
    $form.Opacity = 0
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    # Fade-in Timer
    $fadeTimer = New-Object System.Windows.Forms.Timer
    $fadeTimer.Interval = 15
    $fadeTimer.Add_Tick({
        if ($form.Opacity -lt 1) {
            $form.Opacity += 0.05
        } else {
            $form.Opacity = 1
            $fadeTimer.Stop()
        }
    })
    # Header
    $header = New-Object System.Windows.Forms.Panel
    $header.Size = New-Object System.Drawing.Size(900, 60)
    $header.BackColor = $bgMid
    $header.Dock = "Top"
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "STIVKA TWEAKS"
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = $textMain
    $title.Location = New-Object System.Drawing.Point(20, 15)
    $title.AutoSize = $true
    $header.Controls.Add($title)
    $subtitle = New-Object System.Windows.Forms.Label
    $subtitle.Text = "Windows Optimization Tool"
    $subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $subtitle.ForeColor = $textDim
    $subtitle.Location = New-Object System.Drawing.Point(200, 22)
    $subtitle.AutoSize = $true
    $header.Controls.Add($subtitle)
    $form.Font = New-Object System.Drawing.Font("Segoe UI",9)
    $header = New-Object System.Windows.Forms.Label
    $header.Text = "STIVKA TWEAKS"
    $header.Font = New-Object System.Drawing.Font("Segoe UI",18,[System.Drawing.FontStyle]::Bold)
    $header.ForeColor = $textMain
    $header.Location = New-Object System.Drawing.Point(20,15)
    $header.AutoSize = $true
    $form.Controls.Add($header)
    # Tab Control
    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Location = New-Object System.Drawing.Point(10, 70)
    $tabControl.Size = New-Object System.Drawing.Size(865, 470)
    $tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $sub = New-Object System.Windows.Forms.Label
    $sub.Text = "Windows Optimization Tool"
    $sub.Font = New-Object System.Drawing.Font("Segoe UI",10)
    $sub.ForeColor = $textDim
    $sub.Location = New-Object System.Drawing.Point(220,22)
    $sub.AutoSize = $true
    $form.Controls.Add($sub)
    $tabs = New-Object System.Windows.Forms.TabControl
    $tabs.Location = New-Object System.Drawing.Point(10,55)
    $tabs.Size = New-Object System.Drawing.Size(815,440)
    # Create tabs for each category
    foreach ($cat in $script:Categories) {
        $tab = New-Object System.Windows.Forms.TabPage
        $tab.Text = $cat
        $tab.BackColor = $bgDark
        $tab.Tag = $cat
        $page = New-Object System.Windows.Forms.TabPage
        $page.Text = $cat
        $page.BackColor = $bgDark
        $listView = New-Object System.Windows.Forms.ListView
        $listView.Location = New-Object System.Drawing.Point(5, 5)
        $listView.Size = New-Object System.Drawing.Size(845, 425)
        $listView.View = "Details"
        $listView.FullRowSelect = $true
        $listView.CheckBoxes = $true
        $listView.BackColor = $bgMid
        $listView.ForeColor = $textMain
        $listView.BorderStyle = "None"
        $listView.GridLines = $false
        $listView.Tag = $cat
        $list = New-Object System.Windows.Forms.ListView
        $list.Location = New-Object System.Drawing.Point(5,5)
        $list.Size = New-Object System.Drawing.Size(795,395)
        $list.View = "Details"
        $list.FullRowSelect = $true
        $list.CheckBoxes = $true
        $list.BackColor = $bgMid
        $list.ForeColor = $textMain
        $list.BorderStyle = "None"
        $list.Tag = $cat
        $listView.Columns.Add("Tweak", 280) | Out-Null
        $listView.Columns.Add("Beschreibung", 350) | Out-Null
        $listView.Columns.Add("Impact", 80) | Out-Null
        $listView.Columns.Add("Risiko", 80) | Out-Null
        [void]$list.Columns.Add("Tweak",280)
        [void]$list.Columns.Add("Beschreibung",450)
        # Add tweaks to list
        $tweaksInCat = $script:AllTweaks | Where-Object { $_.Cat -eq $cat }
        foreach ($tweak in $tweaksInCat) {
            $item = New-Object System.Windows.Forms.ListViewItem($tweak.Name)
            $item.SubItems.Add($tweak.Desc) | Out-Null
            $item.SubItems.Add($tweak.Impact) | Out-Null
            $item.SubItems.Add($tweak.Risk) | Out-Null
            $item.Tag = $tweak
            if ($tweak.Risk -eq "Moderate") {
                $item.ForeColor = $warning
            }
            $listView.Items.Add($item) | Out-Null
        $catTweaks = $script:Tweaks | Where-Object {$_.Cat -eq $cat}
        foreach ($tw in $catTweaks) {
            $item = New-Object System.Windows.Forms.ListViewItem($tw.Name)
            [void]$item.SubItems.Add($tw.Desc)
            $item.Tag = $tw
            [void]$list.Items.Add($item)
        }
        $tab.Controls.Add($listView)
        $tabControl.TabPages.Add($tab)
        $page.Controls.Add($list)
        $tabs.TabPages.Add($page)
    }
    # Settings Tab
    $settingsTab = New-Object System.Windows.Forms.TabPage
    $settingsTab.Text = "Settings"
    $settingsTab.BackColor = $bgDark
    $settingsPage = New-Object System.Windows.Forms.TabPage
    $settingsPage.Text = "Settings"
    $settingsPage.BackColor = $bgDark
    $cbRestore = New-Object System.Windows.Forms.CheckBox
    $cbRestore.Text = "Wiederherstellungspunkt erstellen (Empfohlen)"
    $cbRestore.Location = New-Object System.Drawing.Point(20, 20)
    $cbRestore.Size = New-Object System.Drawing.Size(400, 25)
    $cbRestore.Location = New-Object System.Drawing.Point(20,20)
    $cbRestore.Size = New-Object System.Drawing.Size(400,25)
    $cbRestore.ForeColor = $textMain
    $cbRestore.Checked = $true
    $cbRestore.Tag = "restore"
    $settingsTab.Controls.Add($cbRestore)
    $settingsPage.Controls.Add($cbRestore)
    $profileLabel = New-Object System.Windows.Forms.Label
    $profileLabel.Text = "Profile:"
    $profileLabel.Location = New-Object System.Drawing.Point(20, 70)
    $profileLabel.Size = New-Object System.Drawing.Size(100, 25)
    $profileLabel.ForeColor = $textMain
    $profileLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $settingsTab.Controls.Add($profileLabel)
    $profileLbl = New-Object System.Windows.Forms.Label
    $profileLbl.Text = "Schnell-Profile:"
    $profileLbl.Location = New-Object System.Drawing.Point(20,60)
    $profileLbl.Size = New-Object System.Drawing.Size(200,25)
    $profileLbl.ForeColor = $textMain
    $profileLbl.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $settingsPage.Controls.Add($profileLbl)
    $yPos = 100
    foreach ($profileName in $script:Profiles.Keys) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $profileName
        $btn.Location = New-Object System.Drawing.Point(20, $yPos)
        $btn.Size = New-Object System.Drawing.Size(180, 35)
        $btn.BackColor = $bgLight
        $btn.ForeColor = $textMain
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor = $bgLight
        $btn.Tag = $profileName
        $btn.Add_Click({
            param($s, $e)
            $pName = $s.Tag
            $cats = $script:Profiles[$pName]
            foreach ($tp in $tabControl.TabPages) {
                foreach ($ctrl in $tp.Controls) {
                    if ($ctrl -is [System.Windows.Forms.ListView]) {
                        $shouldCheck = $cats -contains $ctrl.Tag
                        foreach ($itm in $ctrl.Items) {
                            $itm.Checked = $shouldCheck
                        }
                    }
                }
            }
            [System.Windows.Forms.MessageBox]::Show("Profil '$pName' geladen!", "Profil", "OK", "Information")
        })
        $settingsTab.Controls.Add($btn)
        $descLabel = New-Object System.Windows.Forms.Label
        $descLabel.Text = ($script:Profiles[$profileName] -join ", ")
        $descLabel.Location = New-Object System.Drawing.Point(210, ($yPos + 8))
        $descLabel.Size = New-Object System.Drawing.Size(400, 20)
        $descLabel.ForeColor = $textDim
        $settingsTab.Controls.Add($descLabel)
        $yPos += 45
    $profiles = @{
        "Fortnite Pro"=@("Performance","Keyboard","Mouse","Network")
        "Maximum FPS"=@("Performance","NVIDIA","Debloat")
        "Low Latency"=@("Keyboard","Mouse")
        "All Tweaks"=@("Performance","Keyboard","Mouse","NVIDIA","Network","Debloat")
    }
    $tabControl.TabPages.Add($settingsTab)
    $form.Controls.Add($tabControl)
    $yp = 95
    foreach ($pn in $profiles.Keys) {
        $pb = New-Object System.Windows.Forms.Button
        $pb.Text = $pn
        $pb.Location = New-Object System.Drawing.Point(20,$yp)
        $pb.Size = New-Object System.Drawing.Size(150,32)
        $pb.BackColor = $bgLight
        $pb.ForeColor = $textMain
        $pb.FlatStyle = "Flat"
        $pb.Tag = $pn
    # Bottom Panel
    $bottom = New-Object System.Windows.Forms.Panel
    $bottom.Location = New-Object System.Drawing.Point(0, 550)
    $bottom.Size = New-Object System.Drawing.Size(900, 70)
    $bottom.BackColor = $bgMid
        $pb.Add_Click({
            param($sender,$e)
            $pName = $sender.Tag
            $pCats = $profiles[$pName]
            foreach ($tp in $tabs.TabPages) {
                foreach ($c in $tp.Controls) {
                    if ($c -is [System.Windows.Forms.ListView]) {
                        $check = $pCats -contains $c.Tag
                        foreach ($i in $c.Items) {$i.Checked = $check}
                    }
                }
            }
            [System.Windows.Forms.MessageBox]::Show("Profil geladen: $pName","Info","OK","Information")
        }.GetNewClosure())
    $selectAllBtn = New-Object System.Windows.Forms.Button
    $selectAllBtn.Text = "Alle"
    $selectAllBtn.Location = New-Object System.Drawing.Point(20, 15)
    $selectAllBtn.Size = New-Object System.Drawing.Size(80, 35)
    $selectAllBtn.BackColor = $bgLight
    $selectAllBtn.ForeColor = $textMain
    $selectAllBtn.FlatStyle = "Flat"
    $selectAllBtn.Add_Click({
        foreach ($tp in $tabControl.TabPages) {
            foreach ($ctrl in $tp.Controls) {
                if ($ctrl -is [System.Windows.Forms.ListView]) {
                    foreach ($itm in $ctrl.Items) { $itm.Checked = $true }
        $settingsPage.Controls.Add($pb)
        $pdesc = New-Object System.Windows.Forms.Label
        $pdesc.Text = ($profiles[$pn] -join ", ")
        $pdesc.Location = New-Object System.Drawing.Point(180,($yp+8))
        $pdesc.Size = New-Object System.Drawing.Size(400,20)
        $pdesc.ForeColor = $textDim
        $settingsPage.Controls.Add($pdesc)
        $yp += 40
    }
    $tabs.TabPages.Add($settingsPage)
    $form.Controls.Add($tabs)
    $btnAll = New-Object System.Windows.Forms.Button
    $btnAll.Text = "Alle"
    $btnAll.Location = New-Object System.Drawing.Point(20,510)
    $btnAll.Size = New-Object System.Drawing.Size(80,35)
    $btnAll.BackColor = $bgLight
    $btnAll.ForeColor = $textMain
    $btnAll.FlatStyle = "Flat"
    $btnAll.Add_Click({
        foreach ($tp in $tabs.TabPages) {
            foreach ($c in $tp.Controls) {
                if ($c -is [System.Windows.Forms.ListView]) {
                    foreach ($i in $c.Items) {$i.Checked = $true}
                }
            }
        }
    })
    $bottom.Controls.Add($selectAllBtn)
    $form.Controls.Add($btnAll)
    $deselectBtn = New-Object System.Windows.Forms.Button
    $deselectBtn.Text = "Keine"
    $deselectBtn.Location = New-Object System.Drawing.Point(110, 15)
    $deselectBtn.Size = New-Object System.Drawing.Size(80, 35)
    $deselectBtn.BackColor = $bgLight
    $deselectBtn.ForeColor = $textMain
    $deselectBtn.FlatStyle = "Flat"
    $deselectBtn.Add_Click({
        foreach ($tp in $tabControl.TabPages) {
            foreach ($ctrl in $tp.Controls) {
                if ($ctrl -is [System.Windows.Forms.ListView]) {
                    foreach ($itm in $ctrl.Items) { $itm.Checked = $false }
    $btnNone = New-Object System.Windows.Forms.Button
    $btnNone.Text = "Keine"
    $btnNone.Location = New-Object System.Drawing.Point(110,510)
    $btnNone.Size = New-Object System.Drawing.Size(80,35)
    $btnNone.BackColor = $bgLight
    $btnNone.ForeColor = $textMain
    $btnNone.FlatStyle = "Flat"
    $btnNone.Add_Click({
        foreach ($tp in $tabs.TabPages) {
            foreach ($c in $tp.Controls) {
                if ($c -is [System.Windows.Forms.ListView]) {
                    foreach ($i in $c.Items) {$i.Checked = $false}
                }
            }
        }
    })
    $bottom.Controls.Add($deselectBtn)
    $form.Controls.Add($btnNone)
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Bereit"
    $statusLabel.Location = New-Object System.Drawing.Point(210, 22)
    $statusLabel.Size = New-Object System.Drawing.Size(400, 25)
    $statusLabel.ForeColor = $success
    $bottom.Controls.Add($statusLabel)
    $status = New-Object System.Windows.Forms.Label
    $status.Text = "Bereit"
    $status.Location = New-Object System.Drawing.Point(210,518)
    $status.Size = New-Object System.Drawing.Size(400,25)
    $status.ForeColor = $green
    $form.Controls.Add($status)
    $applyBtn = New-Object System.Windows.Forms.Button
    $applyBtn.Text = "ANWENDEN"
    $applyBtn.Location = New-Object System.Drawing.Point(720, 10)
    $applyBtn.Size = New-Object System.Drawing.Size(150, 45)
    $applyBtn.BackColor = $accent
    $applyBtn.ForeColor = $textMain
    $applyBtn.FlatStyle = "Flat"
    $applyBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $applyBtn.Add_Click({
        # Collect selected tweaks
        $selected = @()
        foreach ($tp in $tabControl.TabPages) {
            foreach ($ctrl in $tp.Controls) {
                if ($ctrl -is [System.Windows.Forms.ListView]) {
                    foreach ($itm in $ctrl.Items) {
                        if ($itm.Checked) { $selected += $itm.Tag }
    $btnApply = New-Object System.Windows.Forms.Button
    $btnApply.Text = "ANWENDEN"
    $btnApply.Location = New-Object System.Drawing.Point(680,505)
    $btnApply.Size = New-Object System.Drawing.Size(140,45)
    $btnApply.BackColor = $accent
    $btnApply.ForeColor = $textMain
    $btnApply.FlatStyle = "Flat"
    $btnApply.Font = New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
    $btnApply.Add_Click({
        $sel = @()
        foreach ($tp in $tabs.TabPages) {
            foreach ($c in $tp.Controls) {
                if ($c -is [System.Windows.Forms.ListView]) {
                    foreach ($i in $c.Items) {
                        if ($i.Checked) {$sel += $i.Tag}
                    }
                }
        }
        if ($selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Keine Tweaks ausgewaehlt!", "Hinweis", "OK", "Warning")
        if ($sel.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Keine Tweaks ausgewaehlt!","Hinweis","OK","Warning")
            return
        }
        $confirm = [System.Windows.Forms.MessageBox]::Show("$($selected.Count) Tweaks anwenden?", "Bestaetigen", "YesNo", "Question")
        if ($confirm -ne "Yes") { return }
        $confirm = [System.Windows.Forms.MessageBox]::Show("$($sel.Count) Tweaks anwenden?","Bestaetigen","YesNo","Question")
        if ($confirm -ne "Yes") {return}
        # Restore Point
        if ($cbRestore.Checked) {
            $statusLabel.Text = "Erstelle Wiederherstellungspunkt..."
            $statusLabel.ForeColor = $warning
            $status.Text = "Erstelle Wiederherstellungspunkt..."
            $status.ForeColor = [System.Drawing.Color]::Orange
            [System.Windows.Forms.Application]::DoEvents()
            try {
                Enable-ComputerRestore -Drive "C:\" -EA SilentlyContinue
                Checkpoint-Computer -Description "Stivka Tweaks" -RestorePointType "MODIFY_SETTINGS" -EA SilentlyContinue
                Checkpoint-Computer -Description "StivkaTweaks" -RestorePointType "MODIFY_SETTINGS" -EA SilentlyContinue
            } catch {}
        }
        # Apply tweaks
        $applied = 0
        foreach ($tw in $selected) {
            $statusLabel.Text = "Wende an: $($tw.Name)..."
        $done = 0
        foreach ($tw in $sel) {
            $status.Text = "Anwenden: $($tw.Name)"
            [System.Windows.Forms.Application]::DoEvents()
            try {
                if ($tw.Type -eq "reg" -and $tw.Reg) {
                    $path = $tw.Reg.Path
                    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                    foreach ($key in $tw.Reg.Values.Keys) {
                        Set-ItemProperty -Path $path -Name $key -Value $tw.Reg.Values[$key] -Force -EA SilentlyContinue
                if ($tw.Type -eq "reg") {
                    if (-not (Test-Path $tw.Path)) {New-Item -Path $tw.Path -Force | Out-Null}
                    foreach ($k in $tw.Values.Keys) {
                        Set-ItemProperty -Path $tw.Path -Name $k -Value $tw.Values[$k] -Force -EA SilentlyContinue
                    }
                    $applied++
                    $done++
                }
                elseif ($tw.Type -eq "cmd" -and $tw.Cmd) {
                elseif ($tw.Type -eq "cmd") {
                    & $tw.Cmd
                    $applied++
                    $done++
                }
            } catch {}
        }
        $statusLabel.Text = "Fertig! $applied Tweaks angewendet"
        $statusLabel.ForeColor = $success
        $status.Text = "Fertig! $done Tweaks angewendet"
        $status.ForeColor = $green
        $result = [System.Windows.Forms.MessageBox]::Show("$applied Tweaks erfolgreich angewendet!`n`nNeustart empfohlen. Jetzt neu starten?", "Fertig", "YesNo", "Information")
        if ($result -eq "Yes") { Restart-Computer -Force }
        $restart = [System.Windows.Forms.MessageBox]::Show("$done Tweaks angewendet!`n`nNeustart empfohlen. Jetzt neu starten?","Fertig","YesNo","Information")
        if ($restart -eq "Yes") {Restart-Computer -Force}
    })
    $bottom.Controls.Add($applyBtn)
    $form.Controls.Add($bottom)
    # Start
    $form.Add_Shown({ $fadeTimer.Start() })
    $form.Controls.Add($btnApply)
    [System.Windows.Forms.Application]::Run($form)
}
# ============================================================================
# MAIN
# ============================================================================
Write-Host ""
Write-Host "  STIVKA TWEAKS" -ForegroundColor Cyan
Write-Host ""
Show-StivkaGUI
Show-GUI
