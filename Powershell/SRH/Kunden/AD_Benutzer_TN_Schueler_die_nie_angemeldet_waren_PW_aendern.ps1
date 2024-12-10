function Transcript {
    if(!(test-Path ".\logs\Teilnehmer_aufraeumen")){
    mkdir ".\logs\Teilnehmer_aufraeumen"
}
    [string]$transcript = (".\logs\Teilnehmer_aufraeumen\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


$Erstellt = (Get-Date).AddDays(-14)
$geaendert = (Get-Date).AddMonths(-3)
$server   = "SVHD-DC12.srhk.srh.de"

$OUs= @(
    "OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de",
    "OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de",
    "OU=Martinsschule,OU=AAD,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de")
    

$path_bbw = "OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"   
$path_shs = "OU=Schueler,OU=SHS,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"      
    
    
$Anzahl_bbw  = (Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (whencreated -lt $Erstellt) -and (lastlogontimestamp -notlike "*")} -SearchBase $path_bbw -Properties Surname, Givenname, sAMAccountName, Userprincipalname, whenCreated, lastlogontimestamp | Where-Object {$_.PasswordLastSet -eq $null}| Sort-Object name).count
$Anzahl_shs  = (Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (whencreated -lt $Erstellt) -and (lastlogontimestamp -notlike "*")} -SearchBase $path_shs -Properties Surname, Givenname, sAMAccountName, Userprincipalname, whenCreated, lastlogontimestamp | Where-Object {$_.PasswordLastSet -eq $null}| Sort-Object name).count


$Benutzer1   = Foreach($OU in $OUs){(Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (whencreated -lt $Erstellt) -and (lastlogontimestamp -notlike "*")} -SearchBase $OU -Properties Surname, Givenname, sAMAccountName, Userprincipalname, whenCreated, whenchanged, lastlogontimestamp | Where-Object {($_.PasswordLastSet -eq $null) -and ($_.WhenChanged.date -eq $_.whenCreated.date)} | Sort-Object name)
}

$Benutzer2   = Foreach($OU in $OUs){(Get-ADUser -server $server -Filter {(Enabled -eq $true) -and (whenChanged -lt $geaendert) -and (lastlogontimestamp -notlike "*")} -SearchBase $OU -Properties Surname, Givenname, sAMAccountName, Userprincipalname, whenCreated, whenchanged, lastlogontimestamp | Where-Object {$_.PasswordLastSet -eq $null} | Sort-Object name)
}

$benutzer = $($Benutzer1; $benutzer2)

$Anzahl_geandert = $Benutzer.count

if ($benutzer -notlike ""){
Write-Host ""
Write-Host "-------------------Benutzer---------------------" -ForegroundColor green
$benutzer.name
Write-Host ""
Write-Host "-------------------Passworte--------------------" -ForegroundColor green

foreach ($user in $benutzer){
    
# PW Generator Anfang----------------------------------------------------------------------------------------------------------------------------------
    function Get-RandomCharacters($length, $characters) {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs=""
        return [String]$characters[$random]
    }
    
    function Scramble-String([string]$inputString){     
        $characterArray = $inputString.ToCharArray()   
        $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
        $outputString = -join $scrambledStringArray
        return $outputString 
    }
    
    $password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
    $password += Get-RandomCharacters -length 5 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
    $password += Get-RandomCharacters -length 5 -characters '1234567890'
    $password += Get-RandomCharacters -length 5 -characters '!"§$%&/()=?}][{@#*+'
    
    
    $pw = Scramble-String $password
    
    
    $pw
# PW Generator Ende----------------------------------------------------------------------------------------------------------------------------------

    Set-ADAccountPassword -server $server -Identity $user -Reset -NewPassword (ConvertTo-SecureString $Pw -AsPlainText -force)
    

}
}

Write-host ""
Write-host ""
Write-host ""
Write-host ""
Write-host " $Anzahl_bbw Teilnehmerkonten und $Anzahl_shs Schülerkonten wurden bisher nicht genutzt" -ForegroundColor green
Write-host ""
Write-host ""

if ($Anzahl_geandert -like "0"){
	Write-Host ""
	Write-Host " Alle Paßworte wurden bereits geändert!" -ForegroundColor yellow
}

if ($Anzahl_geandert -gt "0"){
	Write-Host ""
	Write-Host " $Anzahl_geandert Passworte wurden geändert!" -ForegroundColor yellow
}

Start-sleep 15


# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\Teilnehmer_aufraeumen\"		# Wichtig: muss mit "\" enden
$Days = 180					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}
