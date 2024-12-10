# With this Code you can test open Ports
 
# .PARAMETER
# $adresse, $startport, $endport
 
# .NOTES
# Author:Markus Elsberger
# Web:https://www.it-learner.de

## Code ##

# Der Command "param" kann die Variablen darin, beim Aufruf des Skriptes verändern (.\mehrere-ports-scannen.ps1 "127.0.0.1" "100" "102")
# $adresse wird mit "127.0.0.1" überschrieben. $startport wird mit "100" überschrieben. $endport wird mit "102" überschrieben
#Festlegen der einzelnen Variablen 
param 
(
$adresse = "8.8.8.8",
$startport = 442,
$endport = 445

)

# Abfragen der einzelnen Ports
foreach ($port in $startport..$endport) {

If (($a=Test-NetConnection -ComputerName $adresse -Port $port -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true)

#Ausgabe im Falle eines offen Ports
{ Write-Host -BackgroundColor Red "TCP port $port ist offen!"}
else
#Ausgbe im Falles eines geschlossenen Ports 
{ Write-Host -BackgroundColor Green "TCP Port $port ist geschlossen!"}

}