# =================================================================================
# CS2 Windows Optimization Script (Safe & Legit)
# Version: 1.0 | Fokus: Input-Lag & Frametimes
# =================================================================================

Write-Host "Starte CS2 System-Optimierung..." -ForegroundColor Cyan

# 1. Systemwiederherstellungspunkt erstellen (Sicherheit geht vor!)
Write-Host "[1/7] Erstelle Wiederherstellungspunkt..." -ForegroundColor Yellow
Checkpoint-Computer -Description "Vor CS2 Optimierung" -RestorePointType "MODIFY_SETTINGS"

# 2. Power Plan: Ultimate Performance aktivieren
# Dies schaltet CPU-Parking aus und hält den Takt stabil.
Write-Host "[2/7] Aktiviere 'Ultimate Performance' Power Plan..." -ForegroundColor Yellow
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
$ultimatePlan = powercfg -list | Select-String "Ultimate Performance"
if ($ultimatePlan) {
    $guid = $ultimatePlan.ToString().Split()[3]
    powercfg -setactive $guid
}

# 3. Windows Gaming Features
# Game Mode sollte AN sein (priorisiert CPU-Zyklen für Spiele).
# Game Bar sollte AUS sein (verursacht Overlay-Lag).
Write-Host "[3/7] Konfiguriere Gaming-Features..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0

# 4. Netzwerk-Optimierung (TCP Latency)
# Reduziert das 'Queuing' von Paketen für schnellere Response-Zeiten.
Write-Host "[4/7] Optimiere Netzwerk-Latency..." -ForegroundColor Yellow
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global timestamps=disabled

# Nagle's Algorithmus deaktivieren (Registry)
$interfaces = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
Get-ChildItem $interfaces | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -ErrorAction SilentlyContinue
}

# 5. System Responsiveness & Timer Resolution
# Setzt die Priorität für Games im Scheduler höher.
Write-Host "[5/7] Optimiere System-Responsiveness..." -ForegroundColor Yellow
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $registryPath -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF
Set-ItemProperty -Path $registryPath -Name "SystemResponsiveness" -Value 0

# 6. Dienste-Cleanup
# Stoppt Dienste, die während des Gamings oft für Spikes sorgen.
Write-Host "[6/7] Deaktiviere unnötige Hintergrunddienste..." -ForegroundColor Yellow
$services = @("SysMain", "DiagTrack", "RemoteRegistry") # SysMain = Superfetch
foreach ($service in $services) {
    if (Get-Service $service -ErrorAction SilentlyContinue) {
        Stop-Service $service -Force -ErrorAction SilentlyContinue
        Set-Service $service -StartupType Disabled
    }
}

# 7. System Cleanup
Write-Host "[7/7] Lösche temporäre Dateien..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Optimierung abgeschlossen! Bitte starte deinen PC neu." -ForegroundColor Green
