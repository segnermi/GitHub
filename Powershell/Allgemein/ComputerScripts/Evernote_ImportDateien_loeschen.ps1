function Transcript {
    if(!(test-Path "D:\logs\Evernote")){
    mkdir "D:\logs\Evernote"
}
    [string]$transcript = ("D:\logs\Evernote\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader

}

Transcript

$Dateien = Get-ChildItem "D:\Evernote Import\*.*" -recurse 
Get-ChildItem "D:\Evernote Import\*.*" -recurse  | Remove-Item -force


Write-Host "$Dateien gelöscht!" -BackgroundColor Yellow -ForegroundColor black
Stop-Transcript

#Alte Logs löschen
$Source = "D:\logs\Evernote\"		# Wichtig: muss mit "\" enden
$Days = 90					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}





