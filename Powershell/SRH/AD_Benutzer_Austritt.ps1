Function Transcript {
    if(!(test-Path ".\logs\BenutzerAustritt")){
    mkdir ".\logs\BenutzerAustritt"
}
    [string]$transcript = (".\logs\BenutzerAustritt\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 
}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$server_EDU   = "SVHD-DC34.edu.srh.de"
$OU_EDU_BBWN  ="OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de"
$OU_EDU_SHS   ="OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"
   

$Server_SRHK  = "SVHD-DC12.srhk.srh.de"
$OU_SRHK_BBWN = "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
$OU_SRHK_SHS  = "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"


$Benutz = read-host "DisplayName eingeben" 
$Benutzer = $Benutz + "*"
$user_EDU = Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)}
$user_EDU

$user_SRHK = Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)}
$user_SRHK


$Ticketnummer = read-host "Ticketnummer eingeben" 

$Date = Get-Date -Format "dd/MM/yyyy"


get-aduser -server $server_EDU $user_EDU -Properties Description | 
    ForEach-Object { Set-ADUser $_ -Description  "$Ticketnummer / Austritt / $date" }

set-aduser -server $server_EDU $user_EDU -Enabled $false

$Auser = $user.name

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -BackgroundColor red -ForegroundColor black
}

else{
	write-host "EDU AD-Konto von $Auser mit Ticket $Ticketnummer deaktiviert" -BackgroundColor Yellow -ForegroundColor black
}


if ($user_SRHK -like "*"){
    get-aduser -server $server_SRHK $user_SRHK -Properties Description | 
    ForEach-Object { Set-ADUser $_ -Description  "$Ticketnummer / Austritt / $date" }

    set-aduser -server $server_SRHK $user_SRHK -Enabled $false

	if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -BackgroundColor red -ForegroundColor black
	}

	else{
	write-host "SRHK AD-Konto von $Auser mit Ticket $Ticketnummer deaktiviert" -BackgroundColor Yellow -ForegroundColor black
}


}




Start-Sleep 15
Stop-Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\BenutzerAustritt\"		# Wichtig: muss mit "\" enden
$Days = 90					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}





