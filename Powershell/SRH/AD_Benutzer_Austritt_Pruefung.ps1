Function Transcript {
    if(!(test-Path ".\logs\BenutzerAustritt_Pruefung")){
    mkdir ".\logs\BenutzerAustritt_Pruefung"
}
    [string]$transcript = (".\logs\BenutzerAustritt_Pruefung\"+(get-date -Format "yyyy-MM-dd-HH-mm")+"_Pruefung"+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$frist= (Get-Date).AddDays(-14)

$server_EDU = "SVHD-DC34.edu.srh.de"
$OUs_EDU= @(
    "OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de",
    "OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de")

$Server_SRHK = "SVHD-DC12.srhk.srh.de"
$OUs_SRHK= @(
    "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de",
    "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de")


# EDU ##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################


$user = Foreach($OU in $OUs_EDU){(Get-ADUser -server $server_EDU -filter {(Description -like "*Austritt*") -and (enabled -eq $false) -and (whenChanged -lt $Frist)} -SearchBase $OU -Properties name,whenChanged,Description)}
$ausgabe_EDU = $user |Select-Object -Property name,Description
$ausgabe_EDU.name

# SRHK ##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################

$user = Foreach($OU in $OUs_SRHK){(Get-ADUser -server $server_SRHK -filter {(Description -like "*Austritt*") -and (enabled -eq $false) -and (whenChanged -lt $Frist)} -SearchBase $OU -Properties whenChanged,Description)}
$ausgabe_SRHK = $user | Select-Object -Property name,Description
$ausgabe_SRHK.name

$ausgabe = @() 
$ausgabe += $ausgabe_EDU
$ausgabe += $ausgabe_SRHK 
$ausgabe | Sort-Object -Property name | Out-File .\logs\BenutzerAustritt_Pruefung\Austritte.txt




Start-Sleep 5
Stop-Transcript
explorer .\logs\BenutzerAustritt_pruefung\
# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\BenutzerAustritt_Pruefung\"		# Wichtig: muss mit "\" enden
$Days = 14					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}






