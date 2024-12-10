# ggf. als lapsadm anmelden, Powershell als Admin starten!

$PCName = Hostname
Add-Computer -WorkgroupName AG -ComputerName $PCName -Confirm -Credential srhsegnermi-t0@itssys.de -Force


Add-Computer -DomainName edu.srh.de -Credential srhsegnermi-t0@itssys.de

Restart-Computer
