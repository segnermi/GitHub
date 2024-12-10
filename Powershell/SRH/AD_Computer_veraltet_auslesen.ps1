$heute = (get-date -format dd-MM-yyyy)

$veraltet       = (Get-Date).AddMonths(-46)

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
    (Get-ADComputer -server $serverEDU -SearchBase $OU -filter {(whenCreated -lt $veraltet)} -properties CN,CanonicalName,whenCreated,Enabled,description |
    Sort-Object whenCreated | Select-Object CN,CanonicalName,whenCreated,Enabled,description    
    )
    
}

$RechnerEDU | export-csv C:\Users\srhsegnermi-t0\Documents\Veraltete_EDU-Rechner_$heute.csv -Delimiter ";" -Encoding utf8


$RechnerSRHK = Foreach($OU in $OUs_SRHK){ 
    (Get-ADComputer -server $serverSRHK -SearchBase $OU -filter {(whenCreated -lt $veraltet)} -properties CN,CanonicalName,whenCreated,Enabled,description |
    Sort-Object whenCreated | Select-Object CN,CanonicalName,whenCreated,Enabled,description 
    )
    
}

$RechnerSRHK | export-csv C:\Users\srhsegnermi-t0\Documents\Veraltete_SRHK-Rechner_$heute.csv -Delimiter ";" -Encoding utf8
