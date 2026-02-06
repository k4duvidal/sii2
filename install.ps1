# Caminho do audio (mesma pasta do script)
$SoundPath = Join-Path $PSScriptRoot "sii.wav"

if (!(Test-Path $SoundPath)) {
    Write-Host "sii.wav nao encontrado."
    Read-Host
    exit
}

# Pasta de inicializacao do usuario
$Startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Script que toca o som
$LoginScript = Join-Path $Startup "sii-login.ps1"

@"
Add-Type -AssemblyName presentationCore
\$player = New-Object System.Windows.Media.MediaPlayer
\$player.Open('$SoundPath')
\$player.Play()
Start-Sleep -Seconds 6
"@ | Out-File $LoginScript -Encoding UTF8 -Force

Write-Host "Configurado com sucesso."
Write-Host "O SII tocara apos o login no Windows."
Read-Host
