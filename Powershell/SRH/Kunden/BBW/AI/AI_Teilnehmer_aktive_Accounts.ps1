function Transcript {
    if(!(test-Path ".\logs\AI_AkiveAccounts")){
    mkdir ".\logs\AI_AktiveAccounts"
}
    [string]$transcript = (".\logs\AI_AktiveAccounts\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$heute = (get-date -format dd-MM-yyyy)
$logon = (Get-Date).AddDays(-10)
$Ablauf = (Get-Date).AddDays(40)
$Server = "SVHD-DC12.srhk.srh.de"

Set-Location C:\Users\srhsegnermi-t0

$Gesamt = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Gesamt_a = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count

$Bürstadt = (Get-ADUser -server $server -SearchBase "OU=Bürstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Bürstadt_a = (Get-ADUser -server $server -SearchBase "OU=Bürstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Darmstadt = (Get-ADUser -server $server -SearchBase "OU=Darmstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Darmstadt_a = (Get-ADUser -server $server -SearchBase "OU=Darmstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Heidelberg = (Get-ADUser -server $server -SearchBase "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Heidelberg_a = (Get-ADUser -server $server -SearchBase "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Hirschhorn = (Get-ADUser -server $server -SearchBase "OU=Hirschhorn,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Hirschhorn_a = (Get-ADUser -server $server -SearchBase "OU=Hirschhorn,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Lampertheim = (Get-ADUser -server $server -SearchBase "OU=Lampertheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Lampertheim_a = (Get-ADUser -server $server -SearchBase "OU=Lampertheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Mörlenbach = (Get-ADUser -server $server -SearchBase "OU=Mörlenbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Mörlenbach_a = (Get-ADUser -server $server -SearchBase "OU=Mörlenbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Neckargemünd = (Get-ADUser -server $server -SearchBase "OU=Neckargemünd,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Neckargemünd_a = (Get-ADUser -server $server -SearchBase "OU=Neckargemünd,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Schwetzingen = (Get-ADUser -server $server -SearchBase "OU=Schwetzingen,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Schwetzingen_a = (Get-ADUser -server $server -SearchBase "OU=Schwetzingen,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Viernheim = (Get-ADUser -server $server -SearchBase "OU=Viernheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Viernheim_a = (Get-ADUser -server $server -SearchBase "OU=Viernheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Wiesloch = (Get-ADUser -server $server -SearchBase "OU=Wiesloch,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$Wiesloch_a = (Get-ADUser -server $server -SearchBase "OU=Wiesloch,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$uebergeordnet = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (SamAccountName -like "TNAI*") -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$uebergeordnet_a = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf) -and (SamAccountName -like "TNAI*") -and (lastlogontimestamp -gt $logon)} | Measure-Object).count

Write-host ""
Write-host " $Gesamt aktive Accounts gesamt" -ForegroundColor blue
Write-host " $Gesamt_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow
Write-host ""
Write-host ""

if($Bürstadt -gt 10){
    Write-host " $Bürstadt aktive Accounts in Bürstadt" -ForegroundColor Green

}else{Write-host " $Bürstadt aktive Accounts in Bürstadt" -ForegroundColor red
}
Write-host " $Bürstadt_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if($Darmstadt -gt 10){
    Write-host " $Darmstadt aktive Accounts in Darmstadt" -ForegroundColor Green

}else{Write-host " $Darmstadt aktive Accounts in Darmstadt" -ForegroundColor red
}
Write-host " $Darmstadt_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Heidelberg -gt 10){
    Write-host " $Heidelberg aktive Accounts in Heidelberg" -ForegroundColor Green
}else {Write-host " $Heidelberg aktive Accounts in Heidelberg" -ForegroundColor red
}
Write-host " $Heidelberg_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""


if ($Hirschhorn -gt 10){
    Write-host " $Hirschhorn aktive Accounts in Hirschhorn" -ForegroundColor Green
}else {Write-host " $Hirschhorn aktive Accounts in Hirschhorn" -ForegroundColor red
}
Write-host " $Hirschhorn_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Lampertheim -gt 10){
    Write-host " $Lampertheim aktive Accounts in Lampertheim" -ForegroundColor Green
}else {Write-host " $Lampertheim aktive Accounts in Lampertheim" -ForegroundColor red
}
Write-host " $Lampertheim_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Mörlenbach -gt 10){
    Write-host " $Mörlenbach aktive Accounts in Mörlenbach" -ForegroundColor Green
}else {Write-host " $Mörlenbach aktive Accounts in Mörlenbach" -ForegroundColor red
}
Write-host " $Mörlenbach_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Neckargemünd -gt 10){
    Write-host " $Neckargemünd aktive Accounts in Neckargemünd" -ForegroundColor Green
}else {Write-host " $Neckargemünd aktive Accounts in Neckargemünd" -ForegroundColor red
}
Write-host " $Neckargemünd_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Schwetzingen -gt 10){
    Write-host " $Schwetzingen aktive Accounts in Schwetzingen" -ForegroundColor Green
}else {Write-host " $Schwetzingen aktive Accounts in Schwetzingen" -ForegroundColor red
}
Write-host " $Schwetzingen_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Viernheim -gt 10){
    Write-host " $Viernheim aktive Accounts in Viernheim" -ForegroundColor Green
}else {Write-host " $Viernheim aktive Accounts in Viernheim" -ForegroundColor red
}
Write-host " $Viernheim_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if ($Wiesloch -gt 10){
    Write-host " $Wiesloch aktive Accounts in Wiesloch" -ForegroundColor Green
}else {Write-host " $Wiesloch aktive Accounts in Wiesloch" -ForegroundColor red
}
Write-host " $Wiesloch_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow

Write-host ""

if($uebergeordnet -gt 10){
    Write-host "$uebergeordnet aktive standortunabhängige Accounts" -ForegroundColor Green

}else{Write-host "$uebergeordnet aktive standortunabhängige Accounts" -ForegroundColor red
}
Write-host " $uebergeordnet_a laufen innerhalb 40 Tagen ab" -ForegroundColor yellow


Start-sleep 30

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\AI_AktiveAccounts\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}