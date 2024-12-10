function Transcript {
    if(!(test-Path ".\logs\Berechtigungsmatrix")){
    mkdir ".\logs\Berechtigungsmatrix"
}
    [string]$transcript = (".\logs\Berechtigungsmatrix\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+"Aufnahme"+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------




$server = "SVHD-DC34.edu.srh.de"



$Benutzer = read-host "DisplayName eingeben (mit *)" 
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)}
$user


$Gruppe = read-host "Gruppennamen eingeben (mit *)" 
$Group = get-adgroup -server $server -filter {(name -like $Gruppe)}
$Group

Start-Sleep -Seconds 2

Add-ADGroupMember -server $server -Identity $Group -Members $user

$Benutzername = $user.name
$Groupname = $group.name

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -BackgroundColor red -ForegroundColor black
}

else{
	write-host "$Benutzername in $Groupname aufgenommen" -BackgroundColor Yellow -ForegroundColor black
}

Start-Sleep 15
Stop-Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\Berechtigungsmatrix\"		# Wichtig: muss mit "\" enden
$Days = 60					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}




