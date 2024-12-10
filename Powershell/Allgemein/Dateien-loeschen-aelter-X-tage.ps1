# Autor: René Albarus - https://www.tech-faq.net
# Datum: 16. April 2019
#
# Beschreibung:
# Dieses Skript löscht Dateien, die eine bestimmte Anzahl von Tagen alt sind. Die Dateierweiterungen, das Alter sowie der Ablageort sind definierbar.
# Der Löschvorgang erstreckt sich auf alle Unterordner. Alle Operationen werden in einem Logfile im Quellordner gespeichert
# !!! Benutzung auf eigene Gefahr !!!
#
# Hier können Sie den Quellordner, das Alter der Dateien (in Tagen) und die Dateierweiterungen festlegen
$Source = "C:\Temp\"		# Wichtig: muss mit "\" enden
$Days = 90					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$log = "$Source$(get-date -format yymmddHHmmss).txt"
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

# Start Script
start-transcript $log
write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | where {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -verbose}
stop-transcript