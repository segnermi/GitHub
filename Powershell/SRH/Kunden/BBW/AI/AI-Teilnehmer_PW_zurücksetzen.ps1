Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" |
     Set-ADAccountPassword -server SVHD-DC12.srhk.srh.de -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Willkommen!" -Force)

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" |
     Set-ADuser -ChangePasswordAtLogon $True

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter {(Enabled -eq $False)} -SearchBase "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -properties AccountExpirationDate |
    Set-ADUser -Enabled $true