function Transcript {
    if(!(test-Path ".\logs\TN_aufraeumen")){
    mkdir ".\logs\TN_aufraeumen"
}
    [string]$transcript = (".\logs\TN_aufraeumen\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

Write-host ""
Write-host ""
Write-host "Konten die länger als 2 Monate abgelaufen sind, werden verschoben" -ForegroundColor green
Write-Host "Konten die länger als 4 Monate abgelaufen sind, werden endgültig gelöscht" -ForegroundColor green
Write-Host ""
#Write-Host "Konten die seit 2 Monaten nicht genutzt wurden, werden deaktiviert" -ForegroundColor green
Write-Host ""
#Write-Host "Abgelaufene aber ungenutzte Konten werden wieder aktiviert" -ForegroundColor green


$aktuell    = (get-date -format dd-MM-yyyy)
$then       = (Get-Date).AddMonths(-2)
$then_del   = (Get-Date).AddMonths(-4)
$server     = "SVHD-DC12.srhk.srh.de"
$target     = "OU=__delete,DC=srhk,DC=srh,DC=de"
$source     = "OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" 

#Anzahl der Konten auslesen
$before = (get-aduser -server $server -Filter * -SearchBase $source | Measure-Object).count
$before_aktiv = (get-aduser -server $server -Filter {(Enabled -eq $true)} -SearchBase $source | Measure-Object).count



#Konten nach __delete verschieben
$verschoben = (Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (accountExpires -lt $then)} -SearchBase $source -properties AccountExpirationDate | Measure-Object).count
$versch = Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (accountExpires -lt $then)} -SearchBase $source -properties AccountExpirationDate

if($verschoben -notlike "0" ){
    Write-Host "Konten nach _delete verschoben:" -ForegroundColor red
    $versch.name
    Write-Host ""
    
}



Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (accountExpires -lt $then)} -SearchBase $source -properties AccountExpirationDate |
    Move-ADObject -TargetPath $target




#Konten aus OU __delete löschen
#$geloescht =(Get-ADUser -server $server -Filter {(accountExpires -lt $then_del)} -SearchBase $target -properties AccountExpirationDate, Description | Measure-Object).count
#Get-ADUser -server $server -Filter {(accountExpires -lt $then_del)} -SearchBase $target -properties AccountExpirationDate, Description |
#    Remove-ADObject -Recursive -Verbose -Confirm:$false

Start-sleep 20

#Anzahl der Konten auslesen
$after = (get-aduser -server $server -Filter * -SearchBase $source | Measure-Object).count
$after_aktiv = (get-aduser -server $server -Filter {(Enabled -eq $true)} -SearchBase $source | Measure-Object).count
Write-Host ""
Write-Host "$Deaktiviert Konten deaktiviert." -ForegroundColor red
Write-Host "$verschoben Konten nach __delete verschoben." -ForegroundColor red
Write-Host "$geloescht Konten aus __delete gelöscht." -ForegroundColor red
Write-Host ""

if($Deaktiviert+$verschoben -eq "0" ){
    Write-Host "$after Konten vorhanden, davon $after_aktiv aktiv." -ForegroundColor yellow
}
else {
    Write-Host "Vorher $before Konten, davon $before_aktiv aktiv, nun $after Konten vorhanden, davon $after_aktiv aktiv." -ForegroundColor yellow
}

Write-Host ""

Start-sleep 20  

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\TN_aufraeumen\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
