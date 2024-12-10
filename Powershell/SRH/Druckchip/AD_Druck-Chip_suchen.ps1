# ChipNummer eingeben
$ChipNr = Read-Host "Chip Nummer eingeben"

$server = "SVHD-DC34.edu.srh.de"
$server2 = "SVHD-DC12.srhk.srh.de"

# Chip in EDU suchen
$user = Get-ADUser -server $server -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2 
$user


# Chip in SRHK suchen
$user2 = Get-ADUser -server $server2 -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2 
$user2

start-sleep 2

$Benutzer = $user.Name
$Benutzer2 = $user2.Name

Clear-Host

if ($user -notlike $null -And $user2 -notlike $null){
    write-host "---------------------------------------------------------------" -ForegroundColor red
    write-host "Chip $ChipNr an $Benutzer und an $Benutzer2 vergeben!" -ForegroundColor red
    write-host "---------------------------------------------------------------" -ForegroundColor Red
    start-sleep 20
    exit
}

if ($user -notlike $null){
    write-host "---------------------------------------------------------------" -ForegroundColor blue
    write-host "Chip $ChipNr an $Benutzer vergeben!" -ForegroundColor blue
    write-host "---------------------------------------------------------------" -ForegroundColor blue
}

if ($user2 -notlike $null){
    write-host "---------------------------------------------------------------" -ForegroundColor blue
    write-host "Chip $ChipNr an $Benutzer2 vergeben!" -ForegroundColor blue
    write-host "---------------------------------------------------------------" -ForegroundColor blue
}

if ($null -eq $user -And $null -eq $user2){
    write-host "---------------------------------------------------------------" -ForegroundColor green
    write-host "Chip $ChipNr nicht vergeben!" -ForegroundColor green
    write-host "---------------------------------------------------------------" -ForegroundColor green

    start-sleep 20
    exit
}

start-sleep 20