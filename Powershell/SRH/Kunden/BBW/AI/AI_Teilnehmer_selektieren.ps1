$server     = "SVHD-DC12.srhk.srh.de"
$OU         = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" 
$Nachname   = "Lampertheim"
#Vorname
$von        = "061"
$bis        = "120"


$Ablauf_neu = (Get-Date).Adddays(262)
$Ablauf_neu = (Get-Date).Adddays(170)

$user = Get-ADUser -server $server -Filter {(Surname -eq $Nachname) -and (GivenName -ge $von) -and (GivenName -le $bis)} -SearchBase $OU
 

Get-ADUser -server $server -Filter {(Surname -eq $Nachname) -and (GivenName -ge $von) -and (GivenName -le $bis)} -SearchBase $OU |
    Remove-ADUser -Confirm:$false

Get-ADUser -server $server -Filter {(Surname -eq $Nachname) -and (GivenName -ge $von) -and (GivenName -le $bis)} -SearchBase $OU |
    Set-ADUser -server $server -AccountExpirationDate $Ablauf_neu