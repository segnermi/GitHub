function Transcript {
    if(!(test-Path ".\logs\Standorte")){
    mkdir ".\logs\Standorte"
}
    [string]$transcript = (".\logs\Standorte\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


$CSVImport = Import-Csv "C:\Users\srhsegnermi-t1\Documents\Fritzboxen.csv" -Delimiter ";" -Encoding ANSI

$Ausfall = @()


foreach ($Standort in $CSVImport){

$IP         = $Standort.IP_Fritzbox
$Strasse    = $Standort.Strasse
$Detail     = $Standort.Kommentar
$Ort        = $Standort.Ort



if ((Test-NetConnection $IP).PingSucceeded) { 
    
    if ($Detail -notlike ""){ 
	write-Host "$Strasse $Ort - $Detail - ist erreichbar" -ForegroundColor Green
	}
    else {
	write-Host "$Strasse $Ort ist erreichbar" -ForegroundColor Green
}	

}

else {
    write-Host "$Strasse $Ort $Detail nicht erreichbar!"  -ForegroundColor red
	$Ausfall += "$Strasse $Ort $Detail"
	
}

}

Start-Sleep 5
Clear-Host


if ($Ausfall -like "*") {
    write-host "Folgende Standorte sind ausgefallen!                                     " -ForegroundColor black -BackgroundColor red
    $Ausfall
    
    start-sleep 20

    $Ausfall > C:\Users\srhsegnermi-t1\documents\logs\Standorte\Ausfall.txt
    explorer C:\Users\srhsegnermi-t1\Documents\logs\Standorte\
    exit
}
else {
    write-Host "Alle Standorte sind erreichbar!" -ForegroundColor Green	

	}
start-sleep 10


# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\Standorte\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
