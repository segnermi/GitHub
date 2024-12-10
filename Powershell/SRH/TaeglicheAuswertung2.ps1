$date = '07.01.2021'

$SRHKCountAllPC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter * -SearchBase "OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "SRHK Rechner Gesamt:  " $SRHKCountAllPC

$SRHKCountActivePC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "SRHK Rechner  Aktiv:  " $SRHKCountActivePC

$SRHKCountAllPC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter * -SearchBase "OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "SRHS PC SRHK Gesamt:   " $SRHKCountAllPC

$SRHKCountActivePC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "SRHS PC SRHK  Aktiv:   " $SRHKCountActivePC

$SRHKCountAllPC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter * -SearchBase "OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "BBWN PC SRHK Gesamt:  " $SRHKCountAllPC

$SRHKCountActivePC = @(Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "BBWN PC SRHK  Aktiv:   " $SRHKCountActivePC

$date = '08.01.2021'

$EDUCountAllPC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter * -SearchBase "OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "EDU       PC Gesamt:  " $EDUCountAllPC

$EDUCountActivePC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "EDU        PC Aktiv:  " $EDUCountActivePC

$EDUCountAllPC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter * -SearchBase "OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "SRHS PC EDU  Gesamt:   " $EDUCountAllPC

$EDUCountActivePC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "SRHS PC EDU   Aktiv:   " $EDUCountActivePC

$EDUCountAllPC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter * -SearchBase "OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date }|select name, lastlogondateI).count
Write-Host "BBWN PC EDU  Gesamt:   " $EDUCountAllPC

$EDUCountActivePC = @(Get-ADComputer -server SVHD-DC34.EDU.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de" -properties name, Lastlogondate |Where-Object {$_.LastLogonDate -ge $date}|select name, lastlogondateI).count
Write-Host "BBWN PC EDU   Aktiv:   " $EDUCountActivePC

$EDUCountGesamtUSerBBWN = @(Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de"  -properties distinguishedname, pwdlastset, Lastlogontimestamp  |Where{ [datetime]::FromFileTime($_.LastLogonTimestamp) -ge $date} | select distinguishedname).count
Write-Host "BBWN User    gesamt:   " $EDUCountGesamtUSerBBWN

$date = '10.01.2021'

$EDUCountActiveUSerBBWN = @(Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de"  -properties distinguishedname, pwdlastset, Lastlogontimestamp  |Where{ [datetime]::FromFileTime($_.LastLogonTimestamp) -ge $date} | select distinguishedname).count
Write-Host "BBWN User    gesamt:   " $EDUCountActiveUserBBWN

$date = '08.01.2021'

$EDUCountGesamtUSerSRHS = @(Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"  -properties distinguishedname, pwdlastset, Lastlogontimestamp  |Where{ [datetime]::FromFileTime($_.LastLogonTimestamp) -ge $date} | select distinguishedname).count
Write-Host "SRHS User    gesamt:   " $EDUCountGesamtUSerSRHS

$date = '10.01.2021'

$EDUCountActiveUSerSRHS = @(Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"  -properties distinguishedname, pwdlastset, Lastlogontimestamp  |Where{ [datetime]::FromFileTime($_.LastLogonTimestamp) -ge $date} | select distinguishedname).count
Write-Host "SRHS User    gesamt:   " $EDUCountActiveUserSRHS
