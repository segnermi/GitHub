$Tage = "180"
$then = (Get-Date).AddDays(-$Tage)
$server = "SVHD-DC34.edu.srh.de"
$ou = "OU=SHS,OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"


Get-ADUser -server $server -Filter {(lastlogondate -lt $then)} -SearchBase $ou -properties lastlogondate | 
    Select-Object name,lastlogondate | 
    Sort-Object lastlogondate |
    Export-Csv .\documents\LastLogon_$Tage-Tage.csv -Delimiter ";" -Encoding utf8

    