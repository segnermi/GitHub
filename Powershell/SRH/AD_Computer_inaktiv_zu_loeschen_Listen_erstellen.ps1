$heute = (get-date -format dd-MM-yyyy)
$zuloeschen    = (Get-Date).AddMonths(-18)

$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"
$OUs_EDU = @(
    "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" 
    "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de"
)

$OUs_SRHK = @(
    "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
    "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
)


$RechnerEDU = Foreach($OU in $OUs_EDU){ 
    (Get-ADComputer -server $serverEDU -SearchBase $OU -filter {(enabled -eq $false) -and (lastLogonTimestamp -lt $zuloeschen)} -properties Name,LastLogonDate,Enabled,description |
    Sort-Object LastLogonDate | Select-Object Name,LastLogonDate,Enabled,description
    )
    
}

$RechnerEDU | export-csv C:\Users\srhsegnermi-t0\Documents\EDU-Rechner_zu_loeschen_$heute.csv -Delimiter ";" -Encoding utf8


$RechnerSRHK = Foreach($OU in $OUs_SRHK){ 
    (Get-ADComputer -server $serverSRHK -SearchBase $OU -filter {(enabled -eq $false) -and (lastLogonTimestamp -lt $zuloeschen)} -properties Name,LastLogonDate,Enabled,description |
    Sort-Object LastLogonDate | Select-Object Name,LastLogonDate,Enabled,description
    )
    
}

$RechnerSRHK | export-csv C:\Users\srhsegnermi-t0\Documents\SRHK-Rechner_zu_loeschen_$heute.csv -Delimiter ";" -Encoding utf8



