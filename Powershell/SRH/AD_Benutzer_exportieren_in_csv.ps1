$server = "svhd-dc34.edu.srh.de"
$server = "SVHD-DC12.srhk.srh.de"


$OUs = @(
    "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=Extern,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"
    )

$users = Foreach($OU in $OUs){ 
    (Get-ADUser -server $server -SearchBase $OU -filter * -properties name, SAMaccountname | 
        select-object name, SAMaccountname)
}

$users | Export-Csv .\documents\users.csv -Delimiter ";" -Encoding utf8
