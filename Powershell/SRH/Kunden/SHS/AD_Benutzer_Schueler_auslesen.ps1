$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date

$ou = "OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"
$excludeOU = "OU=_AlteSchueler,OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"


$user = Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase $ou -Properties distinguishedname, Surname, Givenname, sAMAccountName, Userprincipalname, Displayname, emailaddress, description, whenCreated, Accountexpirationdate, LastLogonDate, enabled
$user | Where-Object { $_.DistinguishedName -notlike "*$excludeOU*" } |   
	Sort-Object Displayname | Select-Object Surname, Givenname, Displayname,sAMAccountName,Userprincipalname,emailaddress,description, whenCreated, @{N='Ablaufdatum'; E={[DateTime]::FromFileTime($_.AccountExpires)}}, LastLogonDate, enabled | 
    	export-csv C:\Users\srhsegnermi-t0\Documents\Schueler_$heute.csv -Delimiter ";"
