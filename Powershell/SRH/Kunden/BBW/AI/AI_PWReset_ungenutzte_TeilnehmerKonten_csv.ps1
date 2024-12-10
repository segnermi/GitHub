#Liste erstellen

$heute = (get-date -format dd-MM-yyyy)
$server        = "SVHD-DC12.srhk.srh.de"
$OU            = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"

Get-ADUser -server $server -Filter {(Enabled -eq $true)} -SearchBase $ou -properties AccountExpirationDate,pwdlastset,lastlogondate |
    Select-object Name,SamAccountName,AccountExpirationDate,pwdlastset,lastlogondate |
         export-csv .\Documents\AI\Teilnehmerkonten_$heute.csv -Delimiter ";" -Encoding utf8


# Passwort reset über csv

$CSVImport = Import-Csv .\documents\AI\PW-Liste.csv -Delimiter ";" -Encoding Default    
$server    = "SVHD-DC12.srhk.srh.de"
                    
foreach ($Benutzer in $CSVImport){   
                 
    $User        = $Benutzer.SamAccountName
    $Passwort    = $Benutzer.pw
    $Ablauf      = $Benutzer.AccountExpirationDate
    

    Set-ADAccountPassword -server $server -identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Passwort -Force)
    
    Set-ADuser -server $server -identity $user -ChangePasswordAtLogon $True
    
    Set-ADUser -server $server -identity $user -AccountExpirationDate $Ablauf
    }