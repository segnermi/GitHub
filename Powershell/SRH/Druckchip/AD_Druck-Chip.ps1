#####################################
## Auswahl Server ###################

$server = "SVHD-DC34.edu.srh.de"
$server = "SVHD-DC12.srhk.srh.de"


####################################
## Chip suchen #####################

$ChipNr = Read-Host "Chip Nummer eingeben"

Get-ADUser -server $server -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2
$user = Get-ADUser -server $server -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2 


#####################################
## Chip l�schen #####################

Set-ADUser -server $server -Identity $user -Remove @{ srhChipkarte2Key2 = @("$ChipNr")}


#####################################
## Chip vergeben ####################

$Benutzer = read-host "DisplayName eingeben (mit *)" 
Get-ADUser -server $server -filter {(Name -like $Benutzer)}
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer)}

Set-ADUser -server $server -Identity $user -Add @{ srhChipkarte2Key2 = @("$ChipNr")} 


#####################################


Get-ADUser -server $server -Identity $user -Properties *



Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 |
Select-object Name, SamAccountName, srhChipkarte2Key2 |
export-csv .\Documents\Druck-Chips.csv -Delimiter ";"






$3239 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3239,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3219 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3219,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3210 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3210,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3230 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3230,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3211 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3211,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3231 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3231,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2
$3241 = Get-ADUser -server SVHD-DC12.srhk.srh.de -filter {(srhChipkarte2Key2 -gt 0)} -SearchBase "OU=3241,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Properties srhChipkarte2Key2 | Select-object Name, SamAccountName, srhChipkarte2Key2

$3239, $3219, $3210, $3230, $3211, $3231, $3241 > .\Documents\Druck-Chips.txt