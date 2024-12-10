
$dom = read-host "Domäne eingeben (edu oder srhk)"
$sAMAccountName = read-host "Neuen Anmeldenamen eingeben" 
$UserName = read-host "Neue Emailadresse eingeben"

$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}



$PruefungUser = Get-ADUser -server $server -Identity $sAMAccountName
$PruefungUser2 = Get-ADUser -server $server -Identity $UserName

if ($PruefungUser -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 10
    exit
}

if ($PruefungUser2 -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 10
    exit
}

write-host "Neuer Name ist noch frei!" -ForegroundColor green
Start-Sleep 10