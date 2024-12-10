# Loeschen Downloads
$Source = "C:\Users\segnermi\Downloads\"		# Wichtig: muss mit "\" enden
$Days = 120					# Anzahl der Tage, nach denen die Dateien gelÃ¶scht werden
$ext = "*.*"		# Array - erweitern mit  ,".xyz" 
$log = "$Source$(get-date -format yymmddHHmmss).txt"
$DateBeforeXDays = (Get-Date).AddDays(-$Days)


get-childitem $Source\* -include $ext -recurse | where {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -verbose}





# Loeschen Temp
$Source = "C:\Users\segnermi\AppData\Local\Temp\"		# Wichtig: muss mit "\" enden
$Days = 14					# Anzahl der Tage, nach denen die Dateien gelÃ¶scht werden
$ext = "*.*"		# Array - erweitern mit  ,".xyz" 
$log = "$Source$(get-date -format yymmddHHmmss).txt"
$DateBeforeXDays = (Get-Date).AddDays(-$Days)


get-childitem $Source\* -include $ext -recurse | where {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -verbose}
