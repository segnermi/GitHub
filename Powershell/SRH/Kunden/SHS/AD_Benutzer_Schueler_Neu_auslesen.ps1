$heute = (get-date -format dd-MM-yyyy)
$date = (Get-Date).AddDays(-7)

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de" -Properties sAMAccountName, Userprincipalname, Displayname, emailaddress, description, AccountExpires, Accountexpirationdate, whenCreated | 
    Where-Object{$_.whenCreated -ge $date} | 
    Sort-Object description | Select-Object Displayname,sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}} | 
	export-csv C:\Users\srhsegnermi-t0\Documents\Neue_Schueler_$heute.csv -Delimiter ";" -Encoding utf8
    