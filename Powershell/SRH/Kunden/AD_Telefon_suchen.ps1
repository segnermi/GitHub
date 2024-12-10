# Telefonnummer eingeben
$Tel = Read-Host "Telefonnummer eingeben"


$server = "SVHD-DC34.edu.srh.de"


# Name suchen
$user = Get-ADUser -server $server -filter {(telephoneNumber -like $Tel)} -Properties telephoneNumber | Select-Object Name, telephoneNumber
$Benutzer = $user.name
$Nummer = $user.telephoneNumber 

cls
Write-Host ""
Write-Host "Die Nummer $Nummer gehört $Benutzer" -ForegroundColor green
Write-Host ""

start-sleep 20