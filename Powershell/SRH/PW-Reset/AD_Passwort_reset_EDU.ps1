Import-Module Active Directory
$Resetpassword = Import-Csv .\documents\pw-reset\passwort-liste.csv -Delimiter ";"
 #Store CSV file into $Resetpassword variable
 
foreach ($User in $Resetpassword) {
    #For each name or account in the CSV file $Resetpassword, reset the password with the Set-ADAccountPassword string below
    $User.sAMAccountName
    $User.Password
        Set-ADAccountPassword -server SVHD-DC34.edu.srh.de -Identity $User.sAMAccountName -Reset -NewPassword (ConvertTo-SecureString $User.Password -AsPlainText -force)
        Set-ADuser -server SVHD-DC34.edu.srh.de -Identity $User.sAMAccountName -ChangePasswordAtLogon $True
}
 Write-Host " Passwords changed "
 $total = ($Resetpassword).count
 $total
 Write-Host "Accounts passwords have been reset..."
