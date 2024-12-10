$Benutzer = read-host "DisplayName eingeben (mit *)" 
Get-ADUser -server SVHD-DC34.edu.srh.de -filter {(Name -like $Benutzer)} 

$user = read-host "SamAccountName eingeben"
(Get-ADUser -server SVHD-DC34.edu.srh.de -identity $user -Properties MemberOf).MemberOf > .\documents\ADGruppen-$user.txt
    

$Group = read-host "Gruppe eingeben"
Get-ADGroupMember -server SVHD-DC34.edu.srh.de -Identity $Group |
    export-csv .\Documents\Mtiglieder-$Group.csv


Get-ADGroup -server SVHD-DC34.edu.srh.de -Identity V_SRHS_SHS_Schulleitung -Properties *
