$server     = "SVHD-DC12.srhk.srh.de"
$OU         = "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" 




Get-ADUser -server $server -Filter {(AccountExpirationDate -lt "03.01.2023") -and (enabled -eq $true)} -SearchBase $OU -Properties CN,AccountExpirationDate

Get-ADUser -server $server -Filter {(AccountExpirationDate -lt "03.01.2023") -and (enabled -eq $true) -and (lastlogondate -gt "01.11.2022")} -SearchBase $OU -properties cn,lastlogondate,AccountExpirationDate | 
    Select-Object cn,lastlogondate,AccountExpirationDate


#####################################################################################################################################################################

$server        = "SVHD-DC12.srhk.srh.de"
$OU            = "OU=Heidelberg,OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
$then          = (Get-Date)
$user          = (Get-ADUser -server $server -Filter {(AccountExpirationDate -lt "03.01.2023") -and (enabled -eq $true) -and (lastlogondate -gt "01.11.2022")} -SearchBase $OU -properties AccountExpirationDate)


foreach ($Benutzer in $user){
$Ablauf        = $Benutzer.AccountExpirationDate
$Ablauf_neu    = $Ablauf.AddYears(1)

Set-ADUser -server $server -identity $Benutzer -AccountExpirationDate $Ablauf_neu
}

#####################################################################################################################################################################


    
Get-ADUser -server $server -Filter {(AccountExpirationDate -lt "03.01.2023") -and (enabled -eq $true)} -SearchBase $OU -Properties CN,AccountExpirationDate
Get-ADUser -server $server -Filter {(AccountExpirationDate -lt "03.01.2023") -and (enabled -eq $true) -and (lastlogondate -lt "01.09.2022")} -SearchBase $OU |
     Set-ADUser -Enabled $false
 


$heute = (get-date -format dd-MM-yyyy)
$server        = "SVHD-DC12.srhk.srh.de"
$OU            = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"

Get-ADUser -server $server -Filter {(Enabled -eq $true)} -SearchBase $ou -properties AccountExpirationDate,pwdlastset,lastlogondate |
    Select-object Name,SamAccountName,AccountExpirationDate,pwdlastset,lastlogondate |
         export-csv .\Documents\TN-Liste_Gesamt_$heute.csv -Delimiter ";" -Encoding utf8



$CSVImport = Import-Csv .\documents\AI\ADatum_setzen.csv -Delimiter ";" -Encoding Default    
$server        = "SVHD-DC12.srhk.srh.de"
$OU            = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
            
# Für jeden Datensatz im CSV            
foreach ($Benutzer in $CSVImport){   
                 
    $Name        = $Benutzer.SamAccountName
    $Ablauf         = $Benutzer.Ablaufdatum

    Set-ADUser -server $server -identity $Name -AccountExpirationDate $Ablauf
    }