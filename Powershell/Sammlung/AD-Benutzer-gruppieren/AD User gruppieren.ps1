$csv = Import-Csv 'C:\Temp\Gruppierungen.csv' -Delimiter ';'
$Fehler = @()
$Error.Clear()
foreach($line in $csv){
    try{
        Add-ADGroupMember -Identity $line.'Groups' -Members $line.samAccountName
    }
    catch{
        $Fehler += $line.samAccountName
    }
}
$Fehler