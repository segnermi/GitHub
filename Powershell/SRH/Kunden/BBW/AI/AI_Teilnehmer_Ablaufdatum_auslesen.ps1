$heute = (get-date -format dd-MM-yyyy)
$Server = "SVHD-DC12.srhk.srh.de"

Set-Location C:\Users\srhsegnermi-t0

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
     Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate |
         export-csv .\Documents\TN-Liste_Gesamt_$heute.csv -Delimiter ";" -Encoding utf8

