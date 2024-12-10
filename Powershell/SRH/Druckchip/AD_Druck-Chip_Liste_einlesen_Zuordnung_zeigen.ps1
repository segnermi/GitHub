$CSVImport = Import-Csv "C:\Users\srhsegnermi-t0\Documents\Druckchips.csv" -Delimiter ";" -Encoding Default

$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}


foreach ($Benutzer in $CSVImport)  {
$ChipNr = $Benutzer.chip
Get-ADUser -server $server -filter {(srhChipkarte2Key2 -eq $ChipNr)} -Properties srhChipkarte2Key2 | Select-Object name, srhChipkarte2Key2 | Sort-Object name
}

Start-Sleep 15