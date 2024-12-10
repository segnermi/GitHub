function Transcript {
    if(!(test-Path ".\logs\DruckChip")){
    mkdir ".\logs\DruckChip"
}
    [string]$transcript = (".\logs\DruckChip\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


# Auswahl Domaene
$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}

$CSVImport = Import-Csv "C:\Users\srhsegnermi-t0\Documents\Druckchips.csv" -Delimiter ";" -Encoding Default

$ServerEDU = "SVHD-DC34.edu.srh.de"
$ServerSRHK = "SVHD-DC12.srhk.srh.de" 

foreach($Eintrag in $CSVImport) {
$ChipNr = $Eintrag.chip
$user = $Eintrag.SamAccountName

# Chip suchen (ob bereits vergeben)
$user1 = Get-ADUser -server $ServerEDU -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2, SamAccountName 
$user1

$user2 = Get-ADUser -server $ServerSRHK -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2, SamAccountName
$user2 

# Chip ggf. loeschen
if ($user1 -notlike $null){
    Set-ADUser -server $ServerEDU -Identity $user1.SamAccountName -Remove @{ srhChipkarte2Key2 = @("$ChipNr")}
}

if ($user2 -notlike $null){
    Set-ADUser -server $ServerSRHK -Identity $user2.SamAccountName -Remove @{ srhChipkarte2Key2 = @("$ChipNr")}
}

# Chip neu vergeben 
    # ggf. alten Chip loeschen
$ChipNr_alt = Get-ADUser -server $server $user -Properties srhChipkarte2Key2 | Select-Object srhChipkarte2Key2
if ($ChipNr_alt.srhChipkarte2Key2 -gt "0"){
        Set-ADUser -server "$server" -Identity $user -Remove @{ srhChipkarte2Key2 = @($ChipNr_alt.srhChipkarte2Key2)}
}

Set-ADUser -server $server -Identity $user -Add @{ srhChipkarte2Key2 = @("$ChipNr")} 
}

Clear-Host

# Ergebnis ausgeben
write-host "Neue Zuordnung:" -ForegroundColor green
write-host ""
foreach ($Benutzer in $CSVImport)  {
    $ChipNr = $Benutzer.chip
    Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2 | Select-Object name, srhChipkarte2Key2 | Sort-Object name
    }

Start-Sleep 40

Stop-Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\DruckChip\"		# Wichtig: muss mit "\" enden
$Days = 30					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
