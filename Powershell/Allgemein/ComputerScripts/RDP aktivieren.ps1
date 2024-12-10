# RDP aktivieren
Set-ItemProperty -Path 'HKLM:\\System\\CurrentControlSet\\Control\\Terminal Server' -Name "fDenyTSConnections" -Value 0

# RDP-Port in der Windows-Firewall öffnen
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
