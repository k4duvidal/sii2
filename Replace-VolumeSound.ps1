# Replace-VolumeSound.ps1
# Script para substituir o som de aumentar volume no Windows 11

Write-Host "=== Substituidor de Som de Volume ===" -ForegroundColor Cyan
Write-Host "Este script substituirá o som de aumentar volume por sii.wav`n"

# Verificar se é administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "Reiniciando como administrador..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Caminho do arquivo de som
$soundFile = "sii.wav"
$soundPath = Join-Path $PSScriptRoot $soundFile

# Verificar se o arquivo existe
if (-not (Test-Path $soundPath)) {
    Write-Host "ERRO: Arquivo $soundFile não encontrado!" -ForegroundColor Red
    Write-Host "Certifique-se de que $soundFile está na mesma pasta deste script.`n"
    pause
    exit 1
}

# Caminho do registro para sons do sistema
$regPath = "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current"

Write-Host "Fazendo backup do som atual..." -ForegroundColor Yellow

# Fazer backup do valor atual
$currentSound = (Get-ItemProperty -Path $regPath -Name "(Default)" -ErrorAction SilentlyContinue)."(Default)"
if ($currentSound) {
    $backupFile = Join-Path $PSScriptRoot "backup_original_sound.txt"
    $currentSound | Out-File -FilePath $backupFile
    Write-Host "Backup salvo em: $backupFile" -ForegroundColor Green
}

Write-Host "`nSubstituindo o som..." -ForegroundColor Yellow

# Atualizar o registro
try {
    Set-ItemProperty -Path $regPath -Name "(Default)" -Value $soundPath -Force
    Write-Host "✓ Som substituído com sucesso!" -ForegroundColor Green
}
catch {
    Write-Host "✗ Erro ao substituir o som: $_" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "`nPara aplicar as alterações:" -ForegroundColor Cyan
Write-Host "1. Reinicie o Windows Explorer"
Write-Host "   Ou reinicie o computador"
Write-Host "2. Ajuste o volume usando as teclas de volume"

Write-Host "`nPressione qualquer tecla para reiniciar o Windows Explorer agora..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Reiniciar Windows Explorer para aplicar mudanças
taskkill /f /im explorer.exe
Start-Process explorer.exe

Write-Host "`nProcesso concluído!" -ForegroundColor Green
Write-Host "Teste ajustando o volume com as teclas de volume.`n"
pause