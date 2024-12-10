$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"
$serverSRH      = "SVHD-DC05.srh.de"

$OU_EDU_BBWN    =  "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de"
$OU_EDU_SHS     =  "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de"

$OU_SRHK_BBWN   = "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
$OU_SRHK_SHS    = "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"


#EDU
$dom2pc = Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_BBWN -filter *
Add-ADGroupMember -server $serverSRH -Identity "BC_SRH LAN BBW" -Members $dom2pc
  
$dom2pc = Get-ADComputer -server $serverEDU -SearchBase $OU_EDU_SHS -filter *
Add-ADGroupMember -server $serverSRH -Identity "BC_SRH LAN SHS" -Members $dom2pc


#SRHK
$dom2pc = Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_BBWN -filter *
Add-ADGroupMember -server $serverSRHK -Identity "BC_SRHK LAN BBWN" -Members $dom2pc
Add-ADGroupMember -server $serverSRHK -Identity "C_SRHK_LAN_WLAN_Gesamt" -Members $dom2pc

$dom2pc = Get-ADComputer -server $serverSRHK -SearchBase $OU_SRHK_SHS -filter *
Add-ADGroupMember -server $serverSRHK -Identity "BC_SRHK LAN SRHS" -Members $dom2pc
Add-ADGroupMember -server $serverSRHK -Identity "C_SRHK_LAN_WLAN_Gesamt" -Members $dom2pc
