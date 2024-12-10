Search-ADAccount -server SVHD-DC12.srhk.srh.de -AccountExpired -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" | 
        Select-object Name, SamAccountName, AccountExpirationDate |
             export-csv .\Documents\Abgelaufene_TN-Konten.csv -Delimiter ";"

Search-ADAccount -server SVHD-DC12.srhk.srh.de -AccountExpired -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" |
     out-gridview



$KontoAbgelaufen = Search-ADAccount -server SVHD-DC12.srhk.srh.de -AccountExpired -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"