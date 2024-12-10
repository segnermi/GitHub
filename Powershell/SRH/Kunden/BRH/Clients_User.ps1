
#Aktive Rechner
#EDU
$ClientsEDU = (Get-ADComputer -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=BRH,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=EDU,DC=srh,DC=de").count

#SRHK
$ClientsSRHK = (Get-ADComputer -server SVHD-DC12.SRHK.srh.de -Filter {(Enabled -eq $True)}  -SearchBase "OU=BRH,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=SRHK,DC=srh,DC=de").count


#Aktive Benutzer
#EDU
$UserEDU = (Get-ADUser -server SVHD-DC34.edu.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=BRH,OU=_Reha,DC=edu,DC=srh,DC=de").count

#SRHK
$UserSRHK = (Get-ADUser -server SVHD-DC12.SRHK.srh.de -Filter {(Enabled -eq $True)} -SearchBase "OU=BRH,OU=_Reha,DC=srhk,DC=srh,DC=de").count

Write-Host "$ClientsEDU aktive Clients und $UserEDU aktive User in EDU"
Write-Host ""
Write-Host "$ClientsSRHK aktive Clients und $UserSRHK aktive User in SRHK"

Start-Sleep 30