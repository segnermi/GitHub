function Transcript {
    if(!(test-Path ".\logs\AI_aufraeumen")){
    mkdir ".\logs\AI_aufraeumen"
}
    [string]$transcript = (".\logs\AI_aufraeumen\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


Write-host ""
Write-host ""
Write-host "Konten die länger als 2 Monate abgelaufen sind, werden verschoben" -ForegroundColor green
Write-Host "Konten die länger als 3 Monate abgelaufen sind, werden endgültig gelöscht" -ForegroundColor green
Write-Host ""
Write-Host "Konten die seit 2 Monaten nicht genutzt wurden, werden deaktiviert" -ForegroundColor green
Write-Host ""
Write-Host "Konten, die vor 9 Monaten erstellt und bisher nicht genutzt wurden, werden deaktiviert." -ForegroundColor green

$heute      = get-date
$then       = (Get-Date).AddMonths(-2)
$then_del   = (Get-Date).AddMonths(-3)
$server     = "SVHD-DC12.srhk.srh.de"
$target     = "OU=__delete,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
$source     = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" 

#Anzahl der Konten auslesen
$before = (get-aduser -server $server -Filter * -SearchBase $source | Measure-Object).count
$before_aktiv = (get-aduser -server $server -Filter {(Enabled -eq $true)} -SearchBase $source | Measure-Object).count


#Benutzer, die seit 2 Monaten nicht angemeldet waren, werden auf "vor 10 Tagen abgelaufen" gesetzt und deaktiviert.
$LetzteAnmeldung    = $heute.AddMonths(-2)
$user               = (Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (LastLogonDate -lt $LetzteAnmeldung)} -SearchBase $source -properties LastLogonDate,AccountExpirationDate)
$Deaktiviert1	    = ($user | Measure-Object).count
$Abl_neu            = $heute.AddDays(-10)

foreach ($Benutzer in $user){
    Set-ADUser -server $server -identity $Benutzer -AccountExpirationDate $Abl_neu -Enabled $false
    }


#Konten, die vor 9 Monaten erstellt und bisher nicht genutzt wurden, werden deaktiviert.
$Erstellt 	= $heute.AddMonths(-9)
$konten   	= (Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (whencreated -lt $Erstellt) -and (lastlogontimestamp -notlike "*")} -SearchBase $source -properties whencreated,lastlogontimestamp,AccountExpirationDate)
$Deaktiviert2	= ($konten | Measure-Object).count

foreach ($Account in $konten){
    Set-ADUser -server $server -identity $Account -AccountExpirationDate $Abl_neu -Enabled $false
    }

if(($user -notlike $null) -or ($konten -notlike $null)){
        Write-Host "Deaktivierte Konten:" -ForegroundColor red
        $user.name
        $konten.name
        Write-Host ""
    }

#Konten nach __delete verschieben
$verschoben = (Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (whenChanged -lt $then)} -SearchBase $source -properties AccountExpirationDate, whenChanged | Measure-Object).count

$versch = Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (whenChanged -lt $then)} -SearchBase $source -properties AccountExpirationDate, whenChanged

if($verschoben -notlike "0" ){
    Write-Host "Konten nach _delete verschoben:" -ForegroundColor red
    $versch.name
    Write-Host ""
}


Get-ADUser -server $server -Filter {(accountExpires -lt $heute)} -SearchBase $source -properties AccountExpirationDate |
	Set-ADUser -Enabled $false

Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (whenChanged -lt $then)} -SearchBase $source -properties AccountExpirationDate, whenChanged |
    Move-ADObject -TargetPath $target

#Gruppen von Benutzern in delete entfernen
$DelUser = Get-ADUser -server $server -Filter {(Description -like "Teilnehmer BBWN AI*")} -SearchBase $target -properties MemberOf

foreach ($Benutzer in $DelUser){
    $Gruppen = $benutzer.MemberOf
    $account = $Benutzer.SamAccountName
    $KBBWN = $gruppen -match "KBBWN"
    $Office = $gruppen -match "O365"
    
    if($KBBWN -notlike $null ){
    Remove-ADGroupMember -Identity "$KBBWN" -server $server -member $account -Confirm:$false
    Remove-ADGroupMember -Identity "$Office" -server $server -member $account -Confirm:$false
    }
}



#Konten aus OU __delete löschen
$geloescht =(Get-ADUser -server $server -Filter {(Description -like "Teilnehmer BBWN AI*") -and (accountExpires -lt $then_del)} -SearchBase $target -properties AccountExpirationDate, Description | Measure-Object).count
Get-ADUser -server $server -Filter {(Description -like "Teilnehmer BBWN AI*") -and (accountExpires -lt $then_del)} -SearchBase $target -properties AccountExpirationDate, Description |
    Remove-ADUser -Confirm:$false

$Deaktiviert = $Deaktiviert1 + $Deaktiviert2

Start-sleep 5

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
Write-Host ""


#Nutzbare Accounts auslesen
$heute = (get-date -format dd-MM-yyyy)
$logon = (Get-Date).AddDays(-21)
$Ablauf40 = (Get-Date).AddDays(40)
$Ablauf7 = (Get-Date).AddDays(7)
$Server = "SVHD-DC12.srhk.srh.de"



$Gesamt = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$Gesamt_a40 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf40) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$Gesamt_a7 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf7) -and (lastlogontimestamp -notlike "*")} | Measure-Object).count
$A_Gesamt = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -gt $heute) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$A_Gesamt_a40 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf40) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count
$A_Gesamt_a7 = (Get-ADUser -server $server -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (AccountExpirationDate -lt $Ablauf7) -and (lastlogontimestamp -gt $logon)} | Measure-Object).count




Write-host ""
Write-host " $Gesamt unbenutzte und $A_Gesamt Benutzer, die in den letzten 3 Wochen angemeldet waren gesamt" -ForegroundColor blue
Write-host ""
Write-host " $Gesamt_a40 unbenutze und $A_Gesamt_a40 aktive laufen innerhalb 40 Tagen ab" -ForegroundColor yellow
Write-host ""
Write-host " $Gesamt_a7 unbenutze und $A_Gesamt_a7 aktive laufen innerhalb 7 Tagen ab" -ForegroundColor red



Start-sleep 45

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\AI_aufraeumen\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
