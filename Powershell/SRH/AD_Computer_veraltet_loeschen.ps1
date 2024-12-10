
$RechnerEDU = Foreach($OU in $OUs_EDU){ 
    (Get-ADComputer -server $serverEDU -SearchBase $OU -filter {(Enabled -eq $False) -and (whenchanged -lt $letzteAenderung) -and (whenCreated -lt $veraltet)} -properties CN,CanonicalName,whenCreated,whenchanged,Enabled,description |
    Sort-Object whenCreated | Select-Object CN,CanonicalName,whenCreated,whenchanged,Enabled,description    
    )
    $heute = (get-date -format dd-MM-yyyy)

$veraltet           = (Get-Date).AddMonths(-46)
$letzteAenderung    = (Get-Date).AddMonths(-3)

$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"

$tagetEDU       = "__delete,OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de"
$targetSRHK     = "__delete,OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"


$OUs_EDU = @(
    "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" 
    "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de"
)

$OUs_SRHK = @(
    "OU=Rechner,OU=SRHSchulenGmbH,OU=_Schulen,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
    "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRHK,DC=srhk,DC=srh,DC=de"
)

}

$RechnerEDU | export-csv C:\Users\srhsegnermi-t0\Documents\Veraltete_EDU-Rechner_$heute.csv -Delimiter ";" -Encoding utf8


$RechnerSRHK = Foreach($OU in $OUs_SRHK){ 
    (Get-ADComputer -server $serverSRHK -SearchBase $OU -filter {(Enabled -eq $False) -and (whenchanged -lt $letzteAenderung) -and (whenCreated -lt $veraltet)} -properties ObjectGUID,distinguishedname,SamAccountName,CN,whenCreated,whenchanged,Enabled,description
    
    )  
}

$PCSRHK=$RechnerSRHK.distinguishedname

foreach($PC in $PCSRHK) {

remove-ADComputer $PC -server $serverSRHK -Confirm:$False

}



$PCSRHK=$RechnerSRHK.distinguishedname

foreach($Rechner in $PCSRHK) {
	$RechnerName=$Rechner.name

	Remove-ADObject $rechner -server $serverSRHK -verbose -Recursive -Confirm:$False 
}

  


$RechnerSRHK | export-csv C:\Users\srhsegnermi-t0\Documents\Veraltete_SRHK-Rechner_$heute.csv -Delimiter ";" -Encoding utf8



Move-ADObject -identity BBWNMMPS1130102 -server $serverSRHK -TargetPath $targetSRHK


Move-ADObject 