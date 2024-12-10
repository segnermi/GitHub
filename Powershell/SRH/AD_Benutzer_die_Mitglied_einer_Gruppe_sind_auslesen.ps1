$server = "SVHD-DC34.edu.srh.de"
$Pfad   = "OU=Jugendhilfe,OU=Mitarbeiter,OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"

Get-ADUser -Server $server -SearchBase $Pfad -Properties Name, Description, MemberOf -Filter {(description -like "*Jugendhilfe*")} | 
    Where-Object {$_.MemberOf -like "*BRDP_SVHD-TERM11_2*"} | 
    Select-Object name | 
        export-csv -Path C:\Users\srhsegnermi-t0\Documents\Berechtigte-Term11.csv -Delimiter ";"


########## ODER SO ####################################################################################################################################       


$server = "SVHD-DC34.edu.srh.de"

$Pfade = @(
    "OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de",
    "OU=Benutzer,OU=SRHSChulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"
    )
        
        
$users = Foreach($Pfad in $Pfade){ 
    (Get-ADUser -Server $server -SearchBase $Pfad -Properties Name, Description, MemberOf -Filter * | 
    Where-Object {$_.MemberOf -like "*BRDP_SVHD-TERM11_2*"} | 
    Select-Object name)
    }
            
$users | Export-Csv .\documents\Berechtigte-Term11.csv -Delimiter ";" -Encoding utf8