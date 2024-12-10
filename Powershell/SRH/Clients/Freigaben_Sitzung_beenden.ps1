$ID = read-host "Session ID eingeben"

Close-SmbSession -SessionId $ID -force

write-host "Sitzung beendet" -BackgroundColor blue -ForegroundColor black

Start-sleep 10 