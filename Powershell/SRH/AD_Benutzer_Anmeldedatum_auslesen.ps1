# Das letzte Anmeldedatum der Benutzer auslesen

Get-ADUser -server SVHD-DC12.srhk.srh.de -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"  -Filter * -Properties * | 
    Sort-Object LastlogonDate | Format-Table Name, LastLogonDate