$dom = read-host "Domäne eingeben (srh, edu oder srhk)"

if ($dom -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}



$Benutzer = read-host "DisplayName eingeben (mit *)" 
Get-ADUser -server $server -filter {(Name -like $Benutzer)} 
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)}
$Filename = $user.SamAccountName


(Get-ADUser -server $server -identity $user -Properties MemberOf).MemberOf > .\documents\ADGruppen-$filename.txt
