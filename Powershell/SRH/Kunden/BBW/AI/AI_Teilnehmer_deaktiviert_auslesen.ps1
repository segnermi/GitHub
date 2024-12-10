Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter {(Enabled -eq $False)} -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate | 
    Select-Object Name, SamAccountName, AccountExpirationDate, enabled |
         Out-GridView

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter {(Enabled -eq $False)} -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate |
     Select-Object Name, SamAccountName, AccountExpirationDate, enabled |
         export-csv .\Documents\Deaktivierte_AI_Teilnehmer.csv -Delimiter ";"