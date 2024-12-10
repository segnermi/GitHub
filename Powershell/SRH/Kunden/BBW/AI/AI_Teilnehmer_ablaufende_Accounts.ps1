$heute = (get-date -format dd-MM-yyyy)
$Ablauf = (Get-Date).AddDays(40)
$Server = "SVHD-DC12.srhk.srh.de"

Set-Location C:\Users\srhsegnermi-t0

$Bürstadt = (Get-ADUser -server $server -SearchBase "OU=Bürstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Darmstadt = (Get-ADUser -server $server -SearchBase "OU=Darmstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Heidelberg = (Get-ADUser -server $server -SearchBase "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Hirschhorn = (Get-ADUser -server $server -SearchBase "OU=Hirschhorn,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Lampertheim = (Get-ADUser -server $server -SearchBase "OU=Lampertheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Mörlenbach = (Get-ADUser -server $server -SearchBase "OU=Mörlenbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Neckargemünd = (Get-ADUser -server $server -SearchBase "OU=Neckargemünd,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Schwetzingen = (Get-ADUser -server $server -SearchBase "OU=Schwetzingen,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Viernheim = (Get-ADUser -server $server -SearchBase "OU=Viernheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Waldmichelbach = (Get-ADUser -server $server -SearchBase "OU=Waldmichelbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count
$Wiesloch = (Get-ADUser -server $server -SearchBase "OU=Wiesloch,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -notlike "*")}).count

Write-host ""
Write-host " $Bürstadt ablaufende Accounts in Bürstadt" -ForegroundColor Green
Write-host ""
Write-host " $Darmstadt ablaufende Accounts in Darmstadt" -ForegroundColor Green
Write-host ""

Write-host " $Heidelberg ablaufende Accounts in Heidelberg" -ForegroundColor Green
Write-host ""
Write-host " $Hirschhorn ablaufende Accounts in Hirschhorn" -ForegroundColor Green
Write-host ""
Write-host " $Lampertheim ablaufende Accounts in Lampertheim" -ForegroundColor Green
Write-host ""
Write-host " $Mörlenbach ablaufende Accounts in Mörlenbach" -ForegroundColor Green
Write-host ""
Write-host " $Neckargemünd ablaufende Accounts in Neckargemünd" -ForegroundColor Green
Write-host ""
Write-host " $Schwetzingen ablaufende Accounts in Schwetzingen" -ForegroundColor Green
Write-host ""
Write-host " $Viernheim ablaufende Accounts in Viernheim" -ForegroundColor Green
Write-host ""
Write-host " $Waldmichelbach ablaufende Accounts in Waldmichelbach" -ForegroundColor Green
Write-host ""
Write-host " $Wiesloch ablaufende Accounts in Wiesloch" -ForegroundColor Green

Start-sleep 30