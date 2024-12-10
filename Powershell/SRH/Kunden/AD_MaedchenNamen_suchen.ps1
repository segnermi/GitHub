# Name eingeben
$Name_ = Read-Host "Name eingeben (Vorname.Nachname)"
$Name  = $Name_ + "*"

$server = "SVHD-DC34.edu.srh.de"


# Name suchen
$user = Get-ADUser -server $server -filter {(mailNickname -like $Name)} -Properties mailNickname 
$user


start-sleep 2

$Benutzer = $user.Name


Clear-Host


if ($user -notlike $null){
    write-host "---------------------------------------------------------------" -ForegroundColor blue
    write-host "$Name ist $Benutzer!" -ForegroundColor blue
    write-host "---------------------------------------------------------------" -ForegroundColor blue
}


start-sleep 20