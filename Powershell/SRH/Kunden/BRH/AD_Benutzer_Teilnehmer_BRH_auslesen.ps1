$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=REHA-Teilnehmer,OU=Benutzer,OU=Heidelberg,OU=BRH,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties Surname, Givenname, sAMAccountName, Userprincipalname, Displayname, emailaddress, description, whenCreated, Accountexpirationdate, LastLogonDate | 
    Where-Object{$_.Accountexpirationdate -ge $date} | 
    Sort-Object Displayname | Select-Object Surname, Givenname, Displayname,sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, LastLogonDate, @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}}, enabled | 
    export-csv C:\Users\srhsegnermi-t0\Documents\REHA-Teilnehmer_$heute.csv -Delimiter ";" 

