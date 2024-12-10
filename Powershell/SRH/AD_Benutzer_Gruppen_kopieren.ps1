$Benutzer = read-host "DisplayName für Source-Benutzer eingeben (mit *)" 
$user1 = Get-ADUser -server SVHD-DC34.edu.srh.de -filter {(Name -like $Benutzer)} 
$user1

$Benutzer2 = read-host "DisplayName für Ziel-Benutzer eingeben (mit *)" 
$user2 = Get-ADUser -server SVHD-DC34.edu.srh.de -filter {(Name -like $Benutzer2)} 
$user2



Get-ADUser -server SVHD-DC34.edu.srh.de -Identity $user1 -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -server SVHD-DC34.edu.srh.de -Members $user2
Get-ADUser -server SVHD-DC34.edu.srh.de -Identity $user1 -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -server SVHD-DC05.srh.de -Members $user2



Start-sleep 10