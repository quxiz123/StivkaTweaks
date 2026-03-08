# =================================================================================
# CS2 System Restore Script - Zurücksetzen auf Windows-Standardwerte
# =================================================================================

Write-Host "Setze System-Einstellungen auf Standard zurück..." -ForegroundColor Cyan

# 1. Power Plan auf 'Ausbalanciert' (Balanced) zurückstellen
Write-Host "[1/6] Setze Energiesparplan auf 'Ausbalanciert'..." -ForegroundColor Yellow
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e

# 2. Windows Gaming Features wieder aktivieren
Write-Host "[2/6] Aktiviere Game Bar und Standard-Gaming-Settings..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 1
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1

# 3. Netzwerk-Optimierung (TCP Standardwerte)
Write-Host "[3/6] Setze Netzwerk-Stack auf Windows-Standard zurück..." -ForegroundColor Yellow
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=default
netsh int tcp set global dca=disabled
netsh int tcp set global netdma=default
netsh int tcp set global ecncapability=disabled
netsh int tcp set global timestamps=disabled

# Nagle's Algorithmus Registry-Einträge entfernen
$interfaces = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
Get-ChildItem $interfaces | ForEach-Object {
    Remove-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -ErrorAction SilentlyContinue
}

# 4. System Responsiveness & Scheduler Defaults
Write-Host "[4/6] Setze Multimedia-Scheduler-Profile zurück..." -ForegroundColor Yellow
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $registryPath -Name "NetworkThrottlingIndex" -Value 10
Set-ItemProperty -Path $registryPath -Name "SystemResponsiveness" -Value 20

# 5. Dienste wieder aktivieren
Write-Host "[5/6] Reaktiviere Hintergrunddienste..." -ForegroundColor Yellow
$services = @("SysMain", "DiagTrack", "RemoteRegistry")
foreach ($service in $services) {
    if (Get-Service $service -ErrorAction SilentlyContinue) {
        Set-Service $service -StartupType Automatic
        Start-Service $service -ErrorAction SilentlyContinue
    }
}

# 6. DNS-Cache und Netzwerk-Flush (für frische Verbindung)
Write-Host "[6/6] Bereinige Netzwerk-Cache..." -ForegroundColor Yellow
ipconfig /release
ipconfig /renew
ipconfig /flushdns

Write-Host "Wiederherstellung abgeschlossen! Bitte starte deinen PC neu." -ForegroundColor Green
