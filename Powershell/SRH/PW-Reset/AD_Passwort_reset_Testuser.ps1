
$user_srh       = @("Test99")
$user_edu       = @("bbwntestuser", "shstestuser", "shstestlehrer")
$user_srhk      = @("zweistalb", "thiemafin", "napfkar")

$PW             = "Kleckern2024#123"

$server_srh     = "SVHD-DC05.srh.de"
$server_edu     = "SVHD-DC34.edu.srh.de"
$server_srhk    = "SVHD-DC12.srhk.srh.de"


foreach ($User in $user_srh) {
    
    Set-ADAccountPassword -server $server_srh  -Identity $User -Reset -NewPassword (ConvertTo-SecureString $PW -AsPlainText -force)
    Set-ADuser -server $server_srh  -Identity $User -ChangePasswordAtLogon $false
    Set-ADuser -server $server_srh  -Identity $User -PasswordNeverExpires $false
Clear-ADAccountExpiration -server $server_srh  -Identity $User

}


foreach ($User in $user_edu) {
    
        Set-ADAccountPassword -server $server_edu  -Identity $User -Reset -NewPassword (ConvertTo-SecureString $PW -AsPlainText -force)
        Set-ADuser -server $server_edu  -Identity $User -ChangePasswordAtLogon $false
        Set-ADuser -server $server_edu  -Identity $User -PasswordNeverExpires $false
	Clear-ADAccountExpiration -server $server_edu  -Identity $User
	
}

foreach ($User in $user_srhk) {
    
    Set-ADAccountPassword -server $server_srhk  -Identity $User -Reset -NewPassword (ConvertTo-SecureString $PW -AsPlainText -force)
    Set-ADuser -server $server_srhk  -Identity $User -ChangePasswordAtLogon $false
    Set-ADuser -server $server_srhk  -Identity $User -PasswordNeverExpires $false
    Clear-ADAccountExpiration -server $server_srhk  -Identity $User
   
}