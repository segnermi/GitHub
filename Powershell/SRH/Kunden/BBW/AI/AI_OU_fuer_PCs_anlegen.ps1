$OU = read-host "Name der neuen OU eingeben" 

$serverSRHK = "SVHD-DC12.srhk.srh.de"
$serverEDU  = "svhd-dc34.edu.srh.de"
$targetSRHK = "OU=AI Arbeitsintegration,OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
$targetEDU  = "OU=10_Arbeitsintegration,OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" 




New-ADOrganizationalUnit -server $serverSRHK  -Name $OU -Path $targetSRHK
New-ADOrganizationalUnit -server $serverEDU  -Name $OU -Path $targetEDU