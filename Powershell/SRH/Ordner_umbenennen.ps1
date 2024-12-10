$Source = read-host "Ursprungspfad eingeben"
$Neu = read-host "Neuer Ordnername eingeben"

Rename-Item -Path $Source -NewName $neu

