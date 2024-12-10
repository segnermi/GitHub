$server = "SVHD-DC34.edu.srh.de"

Set-Location C:\Users\srhsegnermi-t0



Get-ADUser -server $server -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de" -properties Name, SamAccountName, msDS-UserPasswordExpiryTimeComputed | 
    Select-Object Name, SamAccountName, msDS-UserPasswordExpiryTimeComputed |
    Sort-Object msDS-UserPasswordExpiryTimeComputed | Format-Table Name,SamAccountName,@{Name='msDS-UserPasswordExpiryTimeComputed';Expression={[DateTime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} > .\documents\PWAblauf-Schule.txt


Get-ADUser -server $server -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de" -properties Name, SamAccountName, msDS-UserPasswordExpiryTimeComputed | 
    Select-Object Name, SamAccountName, msDS-UserPasswordExpiryTimeComputed |
    Sort-Object msDS-UserPasswordExpiryTimeComputed | Format-Table Name,SamAccountName,@{Name='msDS-UserPasswordExpiryTimeComputed';Expression={[DateTime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} > .\documents\PWAblauf-BBWN.txt
