function Transcript {
    if(!(test-Path ".\logs\Gruppen")){
    mkdir ".\logs\Gruppen"
}
    [string]$transcript = (".\logs\Gruppen\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+"Aufnahme"+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



$domPC = read-host "Computer Domäne eingeben (srh oder edu)"

if ($domPC -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($domPC -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

$domGroup = read-host "Gruppen Domäne eingeben (srh oder edu)"

if ($domGroup -match "srh"){
    $server2 = "SVHD-DC05.srh.de"   
}

if ($domGroup -match "edu"){
    $server2 = "SVHD-DC34.edu.srh.de"   
}

$Rechner = read-host "PCname eingeben (mit *)"  
$PC = Get-adcomputer -server $server -filter {(Name -like $Rechner)}
$PC

$Gruppe = read-host "Gruppennamen eingeben (mit *)"  
$Group = get-adgroup -server $server2 -filter {(name -like $Gruppe)} 
$Group

Start-Sleep -Seconds 2

$dom2pc = Get-adcomputer -Server $server $PC
Add-ADGroupMember -server $server2 -Identity $Group -Members $dom2pc

$PCname = $dom2pc.name
$Groupname = $group.name

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -ForegroundColor red
}

else{
	write-host "$PCname in $Groupname aufgenommen" -BackgroundColor Yellow -ForegroundColor black
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


