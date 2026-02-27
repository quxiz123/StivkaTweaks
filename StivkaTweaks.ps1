# ========================================================================================
# CS2 SYSTEM OPTIMIZER (POWERSHELL) - PERFORMANCE ONLY
# ========================================================================================

# Prüfen auf Administratorrechte
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Dieses Script benötigt Administratorrechte für Registry- und Systemänderungen."
    return
}

Write-Host "Starte System-Optimierung für CS2..." -ForegroundColor Cyan

# 1. ENERGIEPLAN: ULTIMATIVE LEISTUNG
# Schaltet das versteckte 'Ultimative Leistung' Schema frei und aktiviert es.
# Standard-Backup: 'Ausbalanciert' (381b4222-f694-41f0-9685-ff5bb260df2e)
$UltimatePlanGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
powercfg -duplicatescheme $UltimatePlanGuid | Out-Null
powercfg -setactive $UltimatePlanGuid
Write-Host "[+] Energieplan auf 'Ultimative Leistung' gesetzt."

# 2. PROZESS-PRIORITÄT FÜR CS2.EXE
# Weist Windows an, der cs2.exe immer die CPU-Priorität 'Hoch' zu geben.
# Rückgängig machen: Registry-Pfad 'PerfOptions' löschen.
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cs2.exe\PerfOptions"
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
Set-ItemProperty -Path $RegistryPath -Name "CpuPriorityClass" -Type DWord -Value 3
Write-Host "[+] CPU-Priorität für CS2 auf 'Hoch' gesetzt."

# 3. WINDOWS GAME MODE & HAGS
# Aktiviert den Spielmodus und Hardware-accelerated GPU Scheduling für bessere Latenz.
# Default: HwSchMode 1 (Aus) oder 2 (An)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Type DWord -Value 1
$GpuSchedPath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
Set-ItemProperty -Path $GpuSchedPath -Name "HwSchMode" -Type DWord -Value 2
Write-Host "[+] Game Mode und HAGS (GPU Scheduling) aktiviert."

# 4. NETZWERK-OPTIMIERUNG (TCP/IP STACK)
# Optimiert die Paketverarbeitung für geringere Latenz.
# Rückgängig machen: 'netsh int tcp set global autotuninglevel=normal'
netsh int tcp set global autotuninglevel=disabled # Verhindert Puffer-bedingte Delays
netsh int tcp set global chimney=enabled          # Lagert TCP-Aufgaben an die NIC aus
netsh int tcp set global rss=enabled              # Receive Side Scaling für Multicore-NIC-Verarbeitung
Write-Host "[+] Netzwerk-Stack für geringere Latenz optimiert."

# 5. DEAKTIVIERUNG UNNÖTIGER HINTERGRUND-DIENSTE (TEMPORÄR)
# Stoppt Dienste, die Frametime-Spikes verursachen können (SysMain = Superfetch).
# Rückgängig machen: 'Start-Service [Name]'
$Services = @("SysMain", "DiagTrack", "dmwappushservice")
foreach ($Service in $Services) {
    if (Get-Service -Name $Service -ErrorAction SilentlyContinue) {
        Stop-Service -Name $Service -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Dienst gestoppt: $Service"
    }
}

# 6. SYSTEM-CACHE & RAM CLEANUP
# Leert DNS-Cache und löscht temporäre Dateien zur Entlastung der I/O.
ipconfig /flushdns | Out-Null
$TempPaths = @($env:TEMP, "C:\Windows\Temp")
foreach ($Path in $TempPaths) {
    Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "[+] System-Caches geleert."

# 7. VISUELLE EFFEKTE (MINIMALISMUS)
# Setzt Windows-Leistungsoptionen auf 'Für optimale Leistung anpassen'.
# Hinweis: Dies ändert das Design zu einem klassischeren Look für weniger GPU-Last.
$VisualPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
Set-ItemProperty -Path $VisualPath -Name "VisualFXSetting" -Type DWord -Value 2
Write-Host "[+] Visuelle Windows-Effekte auf Leistung getrimmt."

Write-Host "`nOptimierung abgeschlossen! Starte CS2 für beste Ergebnisse." -ForegroundColor Green
Write-Host "Hinweis: Einige Änderungen (HAGS) erfordern einen Windows-Neustart." -ForegroundColor Yellow
