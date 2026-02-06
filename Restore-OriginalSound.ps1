# Restore-OriginalSound.ps1
# Script para restaurar o som original

Write-Host "=== Restaurador de Som Original ===" -ForegroundColor Cyan

# Verificar se é administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "Reiniciando como administrador..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Caminho do backup
$backupFile = Join-Path $PSScriptRoot "backup_original_sound.txt"
$regPath = "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current"

if (Test-Path $backupFile) {
    $originalSound = Get-Content $backupFile -Raw
    
    Write-Host "Restaurando som original..." -ForegroundColor Yellow
    
    try {
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value $originalSound -Force
        Write-Host "✓ Som original restaurado com sucesso!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Erro ao restaurar: $_" -ForegroundColor Red
        pause
        exit 1
    }
    
    # Remover arquivo de backup
    Remove-Item $backupFile -Force
}
else {
    Write-Host "Arquivo de backup não encontrado!" -ForegroundColor Red
    Write-Host "Restaurando para o padrão do Windows..." -ForegroundColor Yellow
    
    try {
        Remove-ItemProperty -Path $regPath -Name "(Default)" -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Restaurado para o som padrão do Windows!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Erro ao restaurar padrão: $_" -ForegroundColor Red
    }
}

Write-Host "`nReiniciando Windows Explorer..." -ForegroundColor Yellow
taskkill /f /im explorer.exe
Start-Process explorer.exe

Write-Host "`nRestauração concluída!" -ForegroundColor Green
pause