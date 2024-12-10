# Importieren der CSV Informationen            
$CSVImport = Import-Csv .\documents\Ordner_Loeschen.csv -Delimiter ";" -Encoding Default            
            
# Für jeden Datensatz im CSV            
foreach ($HD in $CSVImport)            
{            

Remove-Item $HD.homeDirectory -Recurse -Confirm:$false

}