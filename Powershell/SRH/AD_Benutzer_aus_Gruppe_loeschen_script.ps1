function Transcript {
    if(!(test-Path ".\logs\Gruppen")){
    mkdir ".\logs\Gruppen"
}
    [string]$transcript = (".\logs\Gruppen\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+"Entfernung"+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


$domUser = read-host "Benutzer Domäne eingeben (srh oder edu)"

if ($domUser -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($domUser -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

$domGroup = read-host "Gruppen Domäne eingeben (srh oder edu)"

if ($domGroup -match "srh"){
    $server2 = "SVHD-DC05.srh.de"   
}

if ($domGroup -match "edu"){
    $server2 = "SVHD-DC34.edu.srh.de"   
}

$Benutzer = read-host "Benutzername eingeben (mit *)" 
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)}
$user

$Gruppe = read-host "Gruppennamen eingeben (mit *)" 
$Group = get-adgroup -server $server2 -filter {(name -like $Gruppe)}
$Group


$Dom2User = Get-ADUser -Server $server $user
Remove-ADGroupMember -server $server2 -Identity $Group -Members $Dom2User

$Benutzername = $Dom2User.name
$Groupname = $group.name

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -ForegroundColor red
}

else{
	write-host "$Benutzername aus $Groupname entfernt" -ForegroundColor green
}

Start-sleep 10

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\Gruppen\"		# Wichtig: muss mit "\" enden
$Days = 60					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}



