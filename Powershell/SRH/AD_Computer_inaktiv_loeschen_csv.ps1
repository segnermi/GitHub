$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"


###########################################################################################################################################################################
# S R H K
###########################################################################################################################################################################
$CSVImport = Import-Csv .\documents\SRHK-Rechner_zu_loeschen.csv -Delimiter ";" -Encoding Default

foreach($Rechner in $CSVImport) {
	$RechnerName=$Rechner.Name

	Get-ADComputer $RechnerName -server $serverSRHK | Remove-ADObject -Confirm:$False
}
 

###########################################################################################################################################################################
# E D U
###########################################################################################################################################################################
$CSVImport = Import-Csv .\documents\EDU-Rechner_zu_loeschen.csv -Delimiter ";" -Encoding Default

foreach($Rechner in $CSVImport) {
	$RechnerName=$Rechner.Name

	Get-ADComputer $RechnerName -server $serverEDU | Remove-ADObject -Confirm:$False
}


