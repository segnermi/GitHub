$heute = (get-date -format dd-MM-yyyy)
$Server = "SVHD-DC12.srhk.srh.de"

Set-Location C:\Users\srhsegnermi-t0

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
     Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate |
         export-csv .\Documents\TN-Liste_Gesamt_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Bürstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate| Sort-Object AccountExpirationDate |
             export-csv .\Documents\TN-Liste_Bürstadt_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Darmstadt,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate| Sort-Object AccountExpirationDate |
             export-csv .\Documents\TN-Liste_Darmstadt_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Heidelberg_$heute.csv -Delimiter ";"

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Hirschhorn,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Hirschhorn_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Lampertheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Lampertheim_$heute.csv -Delimiter ";" -Encoding utf8
        
Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Mörlenbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Mörlenbach_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Neckargemünd,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Neckargemünd_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Schwetzingen,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Schwetzingen_$heute.csv -Delimiter ";" -Encoding utf8
    
Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Viernheim,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Viernheim_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Waldmichelbach,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Waldmichelbach_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADUser -server $server -Filter {(enabled -eq $true)} -SearchBase "OU=Wiesloch,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate, enabled, lastlogondate |
    Select-object Name, SamAccountName, AccountExpirationDate, lastlogondate | Sort-Object AccountExpirationDate |
        export-csv .\Documents\TN-Liste_Wiesloch_$heute.csv -Delimiter ";" -Encoding utf8
        