function Transcript {
    if(!(test-Path ".\logs\AI_NutzbareAccounts")){
    mkdir ".\logs\AI_NutzbareAccounts"
}
    [string]$transcript = (".\logs\AI_NutzbareAccounts\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$heute = (get-date -format dd-MM-yyyy)
$logon = (Get-Date).AddDays(-10)
$Ablauf40 = (Get-Date).AddDays(40)
$Ablauf7 = (Get-Date).AddDays(7)
$Server = "SVHD-DC12.srhk.srh.de"

Set-Location C:\Users\srhsegnermi-t0

$Gesamt = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$Gesamt_a40 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf40) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$Gesamt_a7 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf7) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$A_Gesamt = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$A_Gesamt_a40 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf40) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$A_Gesamt_a7 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf7) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count




Write-host ""
Write-host " $Gesamt unbenutzte und $A_Gesamt aktive Accounts gesamt" -ForegroundColor blue
Write-host ""
Write-host " $Gesamt_a40 unbenutze und $A_Gesamt_a40 aktive laufen innerhalb 40 Tagen ab" -ForegroundColor yellow
Write-host ""
Write-host " $Gesamt_a7 unbenutze und $A_Gesamt_a7 aktive laufen innerhalb 7 Tagen ab" -ForegroundColor red



Start-sleep 45

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\AI_NutzbareAccounts\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}