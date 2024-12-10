$dom = read-host "Domäne eingeben (srh, edu oder srhk)"

if ($dom -match "srh"){
    $server = "SVHD-DC05.srh.de"   
}

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}

$Gruppe = read-host "Gruppennamen eingeben (mit *)" 
$Group = get-adgroup -server $server -filter {(name -like $Gruppe)} 
$Group
$Gruppendetails = get-adgroup -server $server $Group -Properties *



while(($Auswahl = Read-Host -Prompt "(D)etails (B)eschreibung oder (M)itglieder anzeigen? Beenden mit Q") -ne "Q"){
    switch($Auswahl){
    D {get-adgroup -server $server $Group -Properties *}
    B {write-host $Gruppendetails.description -ForegroundColor blue}
    M {Get-ADGroupMember -server $server -Identity $Gruppendetails.sAMAccountName |
        Select-Object name |
        Out-GridView
        
        $Export = read-host "Mitglieder exportieren? (j, n)"

        if ($Export -match "j"){
        $csv = $Gruppendetails.sAMAccountName
        Get-ADGroupMember -server $server -Identity $Gruppendetails.sAMAccountName |
        Select-Object name, sAMAccountName | 
        export-csv -Path C:\Users\srhsegnermi-t0\Documents\Mitglieder-$csv.csv -Delimiter ";" 

        explorer .\documents\
        exit}
        if ($Export -match "n"){
            exit
        }
    
    Q {exit}
    }    
}}