Test-Connection svngd072.srhk.srh.de -quiet

$Env:COMPUTERNAME
$env:OS
$env:TEMP

Get-Location
Set-Location C:\

Get-ChildItem

Get-Service | Where-Object {$_.Status -eq "stopped"}
Start-Sleep 12



Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex 10 -NetworkCategory Private


$KW = Get-Date -UFormat %W
"Die aktuelle KW ist $KW"

