function Transcript {
    if(!(test-Path ".\logs\BerechtigungU_WLAN")){
    mkdir ".\logs\BerechtigungU_WLAN"
}
    [string]$transcript = (".\logs\BerechtigungU_WLAN\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$server = "SVHD-DC34.edu.srh.de"   


$Benutzer = read-host "DisplayName eingeben (mit *)"  
$Dom2User = Get-ADUser -Server $server -filter {(Name -like $Benutzer)}
$Dom2User

Add-ADGroupMember -server $server -Identity U-WLAN -Members $Dom2User
$Benutzername = $Dom2User.name

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -BackgroundColor red -ForegroundColor black
}

else{
	write-host "$Benutzername aufgenommen!" -BackgroundColor Yellow -ForegroundColor black
}

Start-sleep 12
Stop-Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\BerechtigungU_WLAN\"		# Wichtig: muss mit "\" enden
$Days = 90					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}


