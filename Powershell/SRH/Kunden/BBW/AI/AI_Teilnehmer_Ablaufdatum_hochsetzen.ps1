$server        = "SVHD-DC12.srhk.srh.de"
$OU            = "OU=Hirschhorn,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
$then          = (Get-Date)
$user          = (Get-ADUser -server $server -Filter {(Enabled -eq $False) -and (accountExpires -lt $then)} -SearchBase $OU -properties AccountExpirationDate)
$user2         = (Search-ADAccount -server $server -AccountExpired -SearchBase $OU)

foreach ($Benutzer in $user){
$Ablauf        = $Benutzer.AccountExpirationDate
$Ablauf_neu    = $Ablauf.AddDays(60)

Set-ADUser -server $server -identity $Benutzer -AccountExpirationDate $Ablauf_neu

Set-ADAccountPassword -server $server -identity $Benutzer -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Willkommen!" -Force) |
     Set-ADUser -Enabled $true |
     Set-ADuser -ChangePasswordAtLogon $True
}





Set-ADAccountPassword -server $server -identity $user2 -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Willkommen!" -Force) |
     Set-ADUser -Enabled $true |
     Set-ADuser -ChangePasswordAtLogon $True