$heute = (get-date -format dd-MM-yyyy)

Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Description -like "*Lehr*")} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de" -Properties Surname, Givenname, sAMAccountName, Userprincipalname, Displayname, emailaddress, description, AccountExpires, whenCreated, Accountexpirationdate | 
    Sort-Object Displayname | Select-Object Surname, Givenname, Displayname,sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}} | 
    export-csv C:\Users\srhsegnermi-t0\Documents\SHS_Lehrer_$heute.csv -Delimiter ";" -Encoding utf8
    