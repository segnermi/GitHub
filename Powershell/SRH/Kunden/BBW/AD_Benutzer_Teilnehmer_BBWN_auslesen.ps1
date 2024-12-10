$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties Surname, Givenname, sAMAccountName, Userprincipalname, Displayname, emailaddress, description, AccountExpires, whenCreated, Accountexpirationdate, srhChipkarte2Key2 | 
    Where-Object{$_.Accountexpirationdate -ge $date} | 
    Sort-Object Displayname | Select-Object Surname, Givenname, Displayname,sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, srhChipkarte2Key2, @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}} | 
    export-csv C:\Users\srhsegnermi-t0\Documents\BBWNTeilnehmer_$heute.csv -Delimiter ";" -Encoding utf8
    