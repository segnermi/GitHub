$OU = "OU=7 G,OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_schulen,DC=srhk,DC=srh,DC=de"




Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase $OU |
     Set-ADAccountPassword -server SVHD-DC12.srhk.srh.de -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Winter#2023!" -Force)

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase $OU |
     Set-ADuser -ChangePasswordAtLogon $True

Get-ADUser -server SVHD-DC12.srhk.srh.de -Filter {(Enabled -eq $False)} -SearchBase $OU -properties AccountExpirationDate |
    Set-ADUser -Enabled $true