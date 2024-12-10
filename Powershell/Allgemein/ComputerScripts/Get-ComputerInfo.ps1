Get-ComputerInfo

get-psdrive



Send-MailMessage -To "xyz@tech-faq.net" -From "abc@tech-faq.net" -Subject "Das ist der Betreff" -Body "Das ist der Inhalt" -SmtpServer "server.tech-faq.net"



get-command -module “ntfssecurity”


Get-WmiObject -class "Win32_PhysicalMemoryArray"


dir -recurse | Where {$_.Length -gt 100MB} | ft length, fullname -autosize


