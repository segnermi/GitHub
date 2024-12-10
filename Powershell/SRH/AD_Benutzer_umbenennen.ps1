######################################################################################################################################################################

#Variables
$SamAccountNameBefore_EDU="SchindJa"
$SamAccountNameBefore_SRHK=""



#neu
$surname_neu="Schendell"
$upn_Name="Schendell"

# 6+2
$sAMAccountName_EDU="SchendJa"
$sAMAccountName_SRHK=""


######################################################################################################################################################################

$server_EDU = "SVHD-DC34.edu.srh.de"   
$server_SRHK = "SVHD-DC12.srhk.srh.de"   

########## E D U ###########################################################################################################################################################################

$EDU_User = get-ADUser -server $server_edu -Identity $SamAccountNameBefore_edu -properties DisplayName

# Firma fuer Displayname auslesen
$givenName=$EDU_User.givenName
$surName=$EDU_User.surName
$Displayname=$EDU_User.Displayname
$1 = $Displayname.Replace($surname, "")
$2 = $1.Replace($givenname, "")
$3 = $2.Replace(",", "")
$Firma_EDU = $3.Replace(" ", "")

# Neue Namen generieren
$Displayname_neu    = $surname_neu + "," + " " + $givenName + " " + $Firma_EDU
$UPN_neu            = $givenName + "." + $upn_Name + "@srh.de"



$PruefungUser1 = Get-ADUser -server $server_edu -Identity $sAMAccountName_edu
$PruefungUser2 = Get-ADUser -server $server_edu -Identity $UPN_neu


if ($PruefungUser1 -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 12
    exit
}


if ($PruefungUser2 -notlike $null){
    write-host "Name ist bereits vergeben!" -ForegroundColor red
    Start-Sleep 12
    exit
}

write-host "Neuer Name ist noch frei!" -ForegroundColor green
Start-Sleep 12

$homelaufwerk = get-ADUser -server $server_edu -Identity $SamAccountNameBefore_edu -properties homeDirectory | Select-Object homeDirectory
$hl = $homelaufwerk.homeDirectory

$hl,$sAMAccountName_edu > C:\Users\srhsegnermi-t0\documents\AD-Umbennung-$SamAccountNameBefore_edu.txt
explorer .\documents\

   

if ($hl -like "\\SVNGDBBWNMH1.edu.srh.de\SVNGDBBWNMH1*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1\$sAMAccountName_edu"
    }

if ($hl -like "\\SVNGDBBWNMH3.edu.srh.de\SVNGDBBWNMH3*"){
    $homeDirectory="\\SVNGDBBWNMH3.edu.srh.de\SVNGDBBWNMH3\$sAMAccountName_edu"
    }

if ($hl -like "\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH1\$sAMAccountName_edu"
    }

if ($hl -like "\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH2*"){
    $homeDirectory="\\SVNGDSRHSMH1.edu.srh.de\SVNGDSRHSMH2\$sAMAccountName_edu"
    }


#Abfrage persönlicher Ordner umbenannt? Ja, Nein
$Abfrage = read-host "Persönlicher Ordner umbenannt? (j, n)"
    
if ($Abfrage -match "n"){
            exit
        }


#Script
$User=Get-ADUser -server $server_edu -Identity $SamAccountNameBefore_edu
Rename-ADObject -Server $Server_edu -Identity $User -NewName $Displayname_neu

$UserNeu=Get-ADUser -server $server_edu -Identity $SamAccountNameBefore_edu


Set-ADUser -server $Server_edu -Identity $UserNeu -surname $surName_neu -givenname $givenname -displayname $Displayname_neu -UserPrincipalName $UPN_neu -SamAccountname $sAMAccountName_EDU -homeDirectory $homeDirectory


########## S R H K ###########################################################################################################################################################################

if($SamAccountNameBefore_SRHK -like "*"){

    $SRHK_User = get-ADUser -server $server_srhk -Identity $SamAccountNameBefore_srhk -properties DisplayName

    # Firma fuer Displayname auslesen
    $Displayname=$srhk_User.Displayname
    $1 = $Displayname.Replace($surname, "")
    $2 = $1.Replace($givenname, "")
    $3 = $2.Replace(",", "")
    $Firma_srhk = $3.Replace(" ", "")
    
    # Neue Namen generieren
    $Displayname_neu    = $surname_neu + "," + " " + $givenName + " " + $Firma_srhk
    $UPN_neu            = $givenName + "." + $upn_Name + "@srh-bildung.de"



#Script
$User=Get-ADUser -server $server_srhk -Identity $SamAccountNameBefore_srhk
Rename-ADObject -Server $Server_srhk -Identity $User -NewName $Displayname_neu

$UserNeu=Get-ADUser -server $server_srhk -Identity $SamAccountNameBefore_srhk


Set-ADUser -server $Server_srhk -Identity $UserNeu -surname $surName_neu -givenname $givenname -displayname $Displayname_neu -UserPrincipalName $UPN_neu -SamAccountname $sAMAccountName_SRHK 


}

start-sleep 10