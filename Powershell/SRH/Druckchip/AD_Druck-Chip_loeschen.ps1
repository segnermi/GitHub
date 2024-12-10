# Auswahl Domaene
$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}


# ChipNummer und Benutzer eingeben
$ChipNr = Read-Host "Chip Nummer eingeben"

$Benutzer = read-host "DisplayName eingeben (mit *)" 
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)} -Properties srhChipkarte2Key2, SamAccountName
$user



# Chip loeschen
Set-ADUser -server $server -Identity $user.SamAccountName -Remove @{ srhChipkarte2Key2 = @("$ChipNr")}



# Ergebnis ausgeben
for ($i = 0; $i -lt 20; $i++){
    write-host ""
}

if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -ForegroundColor red
}

else{
    
        Write-Host "Chip $ChipNr gelöscht " -ForegroundColor yellow
        
}


Start-Sleep 15

