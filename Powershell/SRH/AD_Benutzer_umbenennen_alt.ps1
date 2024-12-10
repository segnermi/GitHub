######################################################################################################################################################################

#Variables
$SamAccountNameBefore="StaehlKa"



#neu
$givenName="Kathrin"
$lastName="Hertel"
$Displayname="Hertel, Kathrin (SHS)"
# 6+2
$sAMAccountName="HertelKa"
$UserName="Kathrin.Hertel@srh.de"
# HomeOrdner muss vorher existieren/umbenannt sein 

######################################################################################################################################################################

$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
}


$homelaufwerk = get-ADUser -server $server -Identity $SamAccountNameBefore -properties homeDirectory | Select-Object homeDirectory
$hl = $homelaufwerk.homeDirectory


$PruefungUser = Get-ADUser -server $server -Identity $sAMAccountName
$PruefungUser2 = Get-ADUser -server $server -Identity $UserName

if ($PruefungUser -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 10
    exit
}

if ($PruefungUser2 -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 10
    exit
}

write-host "Neuer Name ist noch frei!" -ForegroundColor green
Start-Sleep 10


$hl,$sAMAccountName > C:\Users\srhsegnermi-t0\documents\AD-Umbennung-$SamAccountNameBefore.txt
explorer .\documents\

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"   

    if ($hl -like "\\SVNGDBBWNMH1.edu.srh.de\SVNGDBBWNMH1*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1\$sAMAccountName"
    }

    if ($hl -like "\\SVNGDBBWNMH3.edu.srh.de\SVNGDBBWNMH3*"){
    $homeDirectory="\\SVNGDBBWNMH3.edu.srh.de\SVNGDBBWNMH3\$sAMAccountName"
    }

    if ($hl -like "\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1\$sAMAccountName"
    }

    if ($hl -like "\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH2*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH2\$sAMAccountName"
    }


    #Abfrage persönlicher Ordner umbenannt? Ja, Nein
    $Abfrage = read-host "Persönlicher Ordner umbenannt? (j, n)"
    
        if ($Abfrage -match "n"){
            exit
        }
}

#Script
$User=Get-ADUser -server $server -Identity $SamAccountNameBefore
Rename-ADObject -Server $Server -Identity $User -NewName $Displayname

$UserNeu=Get-ADUser -server $server -Identity $SamAccountNameBefore


Set-ADUser -server $Server -Identity $UserNeu -surname $lastName -givenname $givenname -displayname $Displayname -UserPrincipalName $UserName -SamAccountname $SamAccountName -homeDirectory $homeDirectory