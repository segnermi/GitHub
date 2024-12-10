$date = (Get-Date).AddMonths(-6)
$server = "SVHD-DC34.edu.srh.de"

Set-Location C:\Users\srhsegnermi-t0

Get-ADUser -server $server -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"  -properties Name, SamAccountName, pwdlastset  |Where-Object{ [datetime]::FromFileTime($_.pwdlastset) -lt $date} | 
    Select-Object Name, SamAccountName, pwdlastset |
    Sort-Object pwdlastset | Format-Table Name,SamAccountName,@{Name='PwdLastSet';Expression={[DateTime]::FromFileTime($_.PwdLastSet)}} > .\documents\PWLastSet-Schule.txt


Get-ADUser -server $server -Filter {(Enabled -eq $True)} -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de"  -properties Name, SamAccountName, pwdlastset  |Where-Object{ [datetime]::FromFileTime($_.pwdlastset) -lt $date} | 
    Select-Object Name, SamAccountName, pwdlastset |
    Sort-Object pwdlastset | Format-Table Name,SamAccountName,@{Name='PwdLastSet';Expression={[DateTime]::FromFileTime($_.PwdLastSet)}} > .\documents\PWLastSet-BBWN.txt


lastLogonTimestamp



$CSVImport = Import-Csv .\documents\BenutzerListe.csv -Delimiter ";" -Encoding Default

foreach($user in $CSVImport) {
        $Benutzer=$user.SamaccountName
    
        Get-ADUser $Benutzer -server SVHD-DC34.edu.srh.de | Set-ADuser -ChangePasswordAtLogon $True
    }
    
