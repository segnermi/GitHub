$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date

Get-ADUser -server SVHD-DC05.srh.de -Filter * -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=_ITSolutions,DC=srh,DC=de" -Properties Surname, Givenname, Displayname, emailaddress, description, telephoneNumber, Department | 
    Sort-Object Displayname | Select-Object Surname, Givenname, Displayname,emailaddress, telephoneNumber, description, Department | 
    export-csv C:\Users\srhsegnermi-t0\Documents\ITS_Mitarbeiter_$heute.csv -Delimiter ";" -Encoding utf8
    