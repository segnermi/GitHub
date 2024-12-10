Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $False)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de" -Properties sAMAccountName, Displayname, enabled, description, whenChanged | 
    Sort-Object Displayname | Select-Object sAMAccountName, Displayname, enabled, description, whenChanged | 
    export-csv C:\Users\srhsegnermi-t0\Documents\BBWN_Deaktivierte_Accounts.csv -Delimiter ";" -Encoding utf8