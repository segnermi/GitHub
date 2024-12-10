$server = "SVHD-DC34.edu.srh.de"
$pfad   = "OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"
$target     = "OU=__delete,DC=srhk,DC=srh,DC=de"
 


$CSVImport = Import-Csv .\documents\account.csv -Delimiter ";" -Encoding Default
    
     
foreach ($Benutzer in $CSVImport){
    Set-ADUser -server $server -identity $Benutzer -Enabled $false
    }



$user = "AytimuTu"
(Get-ADUser $user -server $server -properties memberof).memberof | Remove-ADGroupMember -server $server -Members $user -Confirm:$false




foreach ($Benutzer in $CSVImport){
    $user = $benutzer.samaccountname
    Get-ADUser -identity $user -server $server |
    Remove-ADUser -Confirm:$false
    }
