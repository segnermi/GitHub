﻿# Jörn Walter 2019
# https://www.der-windows-papst.de
$From = "90Days@ndsedv.de.de"
$To = "joern.walter@ndsedv.de.de"
$smtpServer = "EX16"
$reportfile = "C:\Install\90Days.txt"
{
  Remove-Item $reportfile -Force -Erroraction SilentlyContinue
}
 If ((Get-Item $reportfile).length -gt 0kb) {
 write-Host "------------------" -ForegroundColor green
 Write-Host "Send Mail to Admin" -ForegroundColor green
 write-Host "------------------" -ForegroundColor green

 } else {
 write-Host "-----------------" -ForegroundColor red
 write-Host "No File no E-Mail" -ForegroundColor red
 write-Host "-----------------" -ForegroundColor red
}