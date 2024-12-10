$dom = read-host "Domäne eingeben (srh, edu oder srhk)"

if ($dom -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}


$Benutzer = read-host "Benutzernamen eingeben"
$Benutzer2 = $benutzer + "*" 
$Benutzer3 = Get-ADUser -server $server -filter {(Name -like $Benutzer2)}
$Benutzer3 
$AnzeigeName = $Benutzer3.name
$SA = $Benutzer3.samAccountname

# ----------------------------------------------------------------------------------------------------------------------------------------

Function Transcript {
    if(!(test-Path ".\logs\BenutzerPWreset")){
    mkdir ".\logs\BenutzerPWreset"
}
    [string]$transcript = (".\logs\BenutzerPWreset\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+"_$SA"+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader
}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


$NewPassword = (Read-Host "Neues Passwort eingeben")
Set-ADAccountPassword -server $server -Identity $Benutzer3 -Reset -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -force) 
Get-ADUser -server $server -Identity $Benutzer3 | Set-ADuser -ChangePasswordAtLogon $True
Set-ADUser -server $server -Identity $Benutzer3 -enabled $true 
Unlock-ADAccount -server $server $Benutzer3

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -ForegroundColor red
}

else{
	write-host "Passwort für $AnzeigeName auf $NewPassword zurückgesetzt" -ForegroundColor green
}
Stop-Transcript

Start-sleep 12

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


#Alte Logs löschen
$Source = ".\logs\BenutzerPWreset\"		# Wichtig: muss mit "\" enden
$Days = 90					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"

get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
