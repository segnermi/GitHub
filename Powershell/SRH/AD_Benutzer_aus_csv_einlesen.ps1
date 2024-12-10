$server = "svhd-dc34.edu.srh.de"
$server = "SVHD-DC12.srhk.srh.de"


$CSVImport = Import-Csv .\documents\benutzer.csv -Delimiter ";" -Encoding Default



foreach($dataRecord in $CSVImport) {
	$benutzer=$dataRecord.name

	Get-ADUser -server $server -filter {(Name -like $Benutzer) -and (lastlogontimestamp -notlike "*")} -Properties name, SamAccountName, lastLogonTimestamp | select-object name, SamAccountName, lastlogontimestamp | Sort-Object SamAccountName
	#Get-ADUser -server $server -filter {(Name -like $Benutzer)} -Properties name, SamAccountName, lastLogonTimestamp | select-object name, SamAccountName, lastLogonTimestamp | Sort-Object SamAccountName
}
