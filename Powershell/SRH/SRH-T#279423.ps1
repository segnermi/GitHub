$server = "SVHD-DC34.edu.srh.de"

$OUs= @(
    "OU=Ergotherapie,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=Physiotherapie,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=Psychologie,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=BCK,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=Internat,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=Schulsekretariat,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de",
    "OU=TSG,OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de")


$user = Foreach($OU in $OUs){ 
    (Get-ADUser -server $server -SearchBase $OU -properties * -filter * | 
    select-object Surname, GivenName, SAMaccountname, UserPrincipalName, Description |
    Sort-Object Surname)
    
}

$user | export-csv C:\Users\srhsegnermi-t0\Documents\SHS.csv -Delimiter ";"