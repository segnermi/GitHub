$server = "SVHD-DC34.edu.srh.de"



$Benutzer = read-host "DisplayName eingeben (mit *)" 
Get-ADUser -server $server -filter {(Name -like $Benutzer)}
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)}


$Group = read-host "Gruppe eingeben"

Add-ADGroupMember -server $server -Identity $Group -Members $user


Remove-ADGroupMember -server $server -Identity $Group -Members $user


Get-ADGroupMember -server $server -Identity $Group | Out-GridView