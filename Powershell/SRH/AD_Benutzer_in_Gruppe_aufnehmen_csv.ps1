$dom = read-host "Domäne eingeben (srh oder edu)"

if ($dom -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}



$Gruppe = read-host "Gruppennamen eingeben (mit *)" 
$Group = get-adgroup -server $server -filter {(name -like $Gruppe)}
$Group




$Benutzer = import-csv ".\documents\ADGroupMember\Benutzer_in_Gruppe.csv" -Delimiter ";"
 
 
foreach ($User in $Benutzer) {
    
    $Benutzer.sAMAccountName
    
        Add-ADGroupMember -server $server -Identity $Group -Members $user.sAMAccountName
}
 



