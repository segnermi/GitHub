# Jörn Walter 2019
# https://www.der-windows-papst.de
$From = "90Days@ndsedv.de.de"
$To = "joern.walter@ndsedv.de.de"
$smtpServer = "EX16"
$reportfile = "C:\Install\90Days.txt"if (Test-Path $reportfile) 
{
  Remove-Item $reportfile -Force -Erroraction SilentlyContinue
}$OUs= @(    "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de",    "OU=Externe MA,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de",    "OU=User,OU=Austria,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de",    "OU=User,OU=Eschborn,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de",    "OU=User,OU=Flintbeck,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de",    "OU=User,OU=Zeitarbeiter,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de")$target = "OU=Ausgeschieden,OU=SITES,OU=KONFIGURATION,DC=ndsedv,DC=de"$Date = Get-Date -Format G$90Days = (get-date).adddays(-90)$DisabledDate = Get-Date $users= Foreach($OU in $OUs){ (Get-ADUser -SearchBase $OU -properties * -filter {(lastlogondate -notlike "*" -OR lastlogondate -le $90days) -AND (passwordlastset -le $90days) -AND (enabled -eq $True) -and (PasswordNeverExpires -eq $false) -and (whencreated -le $90days)} | select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,distinguishedName)}ForEach ($user in $users){$samAccountName = $user.samAccountName$distinguishedName = $user.distinguishedNameDisable-ADAccount -Identity $samAccountName -Passthru -Whatif | Move-ADObject -TargetPath $target -WhatIfWrite-Host "Account  $samAccountName wurde deaktiviert und verschoben" -ForegroundColor CyanAdd-Content C:\Install\90days.txt -Value "$samAccountName wurde am $date deaktiviert und verschoben aus OU $distinguishedName"Add-Content C:\Install\90days.txt -Value ""}IF (Test-Path $reportfile){
 If ((Get-Item $reportfile).length -gt 0kb) {
 write-Host "------------------" -ForegroundColor green
 Write-Host "Send Mail to Admin" -ForegroundColor green
 write-Host "------------------" -ForegroundColor greenSend-MailMessage -SmtpServer $smtpServer -To $To -From $From -Subject "Automatic deactivation after 90 Days not logon - Report ndsedv.de" -Body "Report about not logon user - ndsedv IT-Operations" -Attachments $reportfile -Priority High -Encoding "UTF8"}

 } else {
 write-Host "-----------------" -ForegroundColor red
 write-Host "No File no E-Mail" -ForegroundColor red
 write-Host "-----------------" -ForegroundColor red
}