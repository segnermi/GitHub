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


$PCName = read-host "PC Namen eingeben" 
Get-ADComputer $PCName -server $server

while(($Auswahl = Read-Host -Prompt "(D)etails, Des(c)ription oder (G)ruppen anzeigen, (s)perren, (e)ntsperren oder (b)eenden?") -ne "b"){
    switch($Auswahl){
    D {Get-ADComputer $PCName -server $server -properties *}

    c {Get-ADComputer $PCName -server $server -properties Description | Select-Object -Property Description}
    
    G {(Get-ADComputer $PCName -server $server -Properties MemberOf).MemberOf |
        Out-GridView
    
    $Export = read-host "Gruppen exportieren? (j, n)"
    
        if ($Export -match "j"){
        $TXTName = $user.SamAccountName
            (Get-ADComputer $PCName -server $server -Properties MemberOf).MemberOf > C:\Users\srhsegnermi-t0\documents\ADGruppen-$PCName.txt
            explorer .\documents\
            exit}

        if ($Export -match "n"){
                exit
        }}
    
    S {$Beschreibung = Read-Host "Beschreibung eingeben"
        Set-ADComputer $PCName -server $server -enabled $false -Description "$Beschreibung"
        exit}

    E {Set-ADComputer $PCName -server $server -enabled $true -Description " "
        exit}
    
    B {exit}
    }    
}

