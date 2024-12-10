$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date


Get-ADUser -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de" -Properties Surname, Givenname, sAMAccountName, Userprincipalname, Displayname, emailaddress, description, mailNickname, AccountExpires, whenCreated, LastLogonDate, Accountexpirationdate | 
    Sort-Object Displayname | Select-Object Surname, Givenname, Displayname, sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, LastLogonDate, mailNickname,  @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}} | 
    export-csv C:\Users\srhsegnermi-t0\Documents\BBWN_Mitarbeiter_$heute.csv -Delimiter ";" -Encoding utf8
    