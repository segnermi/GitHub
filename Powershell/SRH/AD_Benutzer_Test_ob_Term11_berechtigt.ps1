$dom = read-host "Domäne  des Benutzers eingeben (srh, edu)"

if ($dom -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}


$Benutzer = read-host "DisplayName eingeben (mit *)" 
$User = Get-ADUser -Server $server -filter {(Name -like $Benutzer)} -Properties MemberOf
$User
$Benutzername = $user.name

$Gruppen = (Get-ADUser -server $server -identity $user -Properties MemberOf).MemberOf

write-host ""
write-host ""
write-host ""
write-host ""

if($Gruppen -match "BRDP_SVHD-TERM11_2"){
    write-host "$Benutzername ist für Term11 berechtigt!  " -BackgroundColor green -ForegroundColor white
}

else{
    write-host "$Benutzername ist nicht für Term11 berechtigt!!!  " -BackgroundColor red -ForegroundColor white
        
}

Start-Sleep 12