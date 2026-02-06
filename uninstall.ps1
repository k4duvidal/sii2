Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\sii-login.ps1" `
 -Force -ErrorAction SilentlyContinue

Write-Host "Removido com sucesso."
Read-Host
