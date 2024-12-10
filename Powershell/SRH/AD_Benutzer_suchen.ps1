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


$Benutzer = read-host "Benutzernamen eingeben"
$Benutzer2 = $benutzer + "*" 
$user = Get-ADUser -server $server -filter {(Name -like $Benutzer2)}
$user


while(($Auswahl = Read-Host -Prompt "(D)etails, Des(c)ription oder (G)ruppen anzeigen, (L)astLogonDate, (A)blauf PW, (e)ntsperren, (s)perren oder (b)eenden?") -ne "b"){
    switch($Auswahl){
    D {Get-ADUser -server $server $user -properties *}
    c {Get-ADUser -server $server $user -properties Description | Select-Object -Property Description}
    G {(Get-ADUser -server $server -identity $user -Properties MemberOf).MemberOf |
        Out-GridView
    
    $Export = read-host "Gruppen exportieren? (j, n)"
    
        if ($Export -match "j"){
        $TXTName = $user.SamAccountName
            (Get-ADUser -server $server -identity $user -Properties MemberOf).MemberOf > C:\Users\srhsegnermi-t0\documents\ADGruppen-$TXTName.txt
            explorer .\documents\
            exit}

        if ($Export -match "n"){
                exit
        }}
        
        L {Get-ADUser -server $server $user -properties LastLogonDate | Select-Object LastLogonDate}

        E {Unlock-ADAccount -server $server $user
        Set-ADUser -server $server $user -enable $true -Description " "
        $UserName = $user.name
        Write-Host "$username entsperrt!" -BackgroundColor blue -ForegroundColor black
        start-sleep 5
        exit
        }

        S {$Beschreibung = Read-Host "Beschreibung eingeben"
        Set-ADUser -server $server $user -enabled $false -Description "$Beschreibung"
        exit}
    
        A {Get-ADUser -server $server $user -properties Name, SamAccountName, msDS-UserPasswordExpiryTimeComputed | Select-Object @{Name='msDS-UserPasswordExpiryTimeComputed';Expression={[DateTime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}}  

    B {exit}
    }    
}
