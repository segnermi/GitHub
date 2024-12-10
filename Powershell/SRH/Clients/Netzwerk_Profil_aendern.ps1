Get-NetConnectionProfile


$Index = Read-Host "InterfaceIndex eingeben"

Set-NetConnectionProfile -InterfaceIndex $Index -NetworkCategory Private

Start-Sleep 10


