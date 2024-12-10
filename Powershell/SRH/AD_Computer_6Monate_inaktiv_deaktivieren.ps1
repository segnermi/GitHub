function Transcript {
    if(!(test-Path ".\logs\PCdeaktiviert")){
    mkdir ".\logs\PCdeaktiviert"
}
    [string]$transcript = (".\logs\PCdeaktiviert\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


$letztaktiv     = (Get-Date).AddMonths(-6)
$veraltet       = (Get-Date).AddMonths(-46)

$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"
$OU_SRHK_SHS    = "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
$OU_SRHK_BBWN   = "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
$OU_EDU_SHS     = "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" 
$OU_EDU_BBWN    = "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" 

Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)}
[int]$SRHK_SHS = (Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} | Measure-Object).count
Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv) -and (whenCreated -lt $veraltet)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert da ausser Garantie"
Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert aufgrund 6 Monate Inaktivität"

Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)}
[int]$SRHK_BBWN = (Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} | Measure-Object).count    
Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv) -and (whenCreated -lt $veraltet)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert da ausser Garantie"
Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert aufgrund 6 Monate Inaktivität"

Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)}
[int]$EDU_SHS = (Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} | Measure-Object).count
Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv) -and (whenCreated -lt $veraltet)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert da ausser Garantie"
Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_SHS -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert aufgrund 6 Monate Inaktivität"

Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)}
[int]$EDU_BBWN = (Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} | Measure-Object).count
Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv) -and (whenCreated -lt $veraltet)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert da ausser Garantie"
Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_BBWN -filter {(enabled -eq $true) -and (lastLogonTimestamp -lt $letztaktiv)} |
    Set-ADComputer -enabled $false -Description "Deaktiviert aufgrund 6 Monate Inaktivität"

# Ergebnis ausgeben
$Summe = $SRHK_SHS + $SRHK_BBWN + $EDU_SHS + $EDU_BBWN

Write-Host ""

if($Summe -eq "1" ){
    Write-Host "$summe Computerkonto wurde deaktiviert!" -ForegroundColor green 
}
else {
    Write-Host "$summe Computerkonten wurden deaktiviert!" -ForegroundColor green
}



Start-Sleep 20

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\PCdeaktiviert\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}