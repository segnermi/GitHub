$Datum = (get-Date).AddHours(-1)

net stop spooler

cd C:\Windows\System32\spool\PRINTERS

get-ChildItem | Where-Object {$_.LastWriteTime -lt ($Datum)} | Remove-Item

net start spooler

Start-sleep 5
