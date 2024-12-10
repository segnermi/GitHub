$DruckerNameALT = read-host "Name des alten Druckers eingeben" 
$DruckerALT = "*$DruckerNameALT*"
write-host ""
$DruckerNameNEU = read-host "Name des neuen Druckers eingeben" 
$DruckerNeu = "*$DruckerNameNeu*"


function Transcript {
  if(!(test-Path ".\logs\Druckerrollout")){
  mkdir ".\logs\Druckerrollout"
}
  [string]$transcript = (".\logs\Druckerrollout\"+(get-date -Format "yyyy-MM-dd-HH-mm")+"_"+"$DruckerNameALT"+"-"+"$DruckerNameNEU"+".log")


  Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------


######### E D U ######################################################################################################################

$server = "SVHD-DC34.edu.srh.de"
$OU_source = "OU=BBWN,OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de"
$OU_target = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=edu,DC=srh,DC=de"

$AlteGruppe = Get-ADGroup -server $server -searchbase $OU_source -filter {Name -like $DruckerALT}
Write-Host "-------------------------------------------------------------------------------------------"
Write-Host "Mitglieder alte EDU Gruppe"
Write-Host "-------------------------------------------------------------------------------------------"
Get-ADGroupMember $AlteGruppe -server $server
$AG_EDU = $AlteGruppe.name
$NeueGruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU} 
$NG_EDU = $NeueGruppe.name

if ($NeueGruppe -like $null){
  exit
}

$AlteGruppe | Get-ADGroupMember  | Foreach-Object {
  
  # Member zur neuen Gruppe hinzufügen
  Add-ADGroupMember -server $server $NeueGruppe.DistinguishedName -Members $_

  # Member aus der alten gruppe entfernen
  Remove-ADGroupMember -server $server $AlteGruppe.DistinguishedName -Members $_ -Confirm:$false
}



$Zielgruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU}
$Anzahl_EDU = (Get-ADGroupMember $Zielgruppe -server $server).count
Write-Host "-------------------------------------------------------------------------------------------"
Write-Host "Mitglieder neue EDU Gruppe"
Write-Host "-------------------------------------------------------------------------------------------"
Get-ADGroupMember $Zielgruppe -server $server

#Leere Grupen löschen
$Geloescht_EDU = (Get-ADGroup -server $server -searchbase $OU_source -filter * -Properties Members  | Where-Object { -not $_.Members}).count
Get-ADGroup -server $server -searchbase $OU_source -filter * -Properties Members  | Where-Object { -not $_.Members} |
  Remove-ADGroup -server $server -Confirm:$false


######### S R H K ######################################################################################################################

$server = "SVHD-DC12.srhk.srh.de"   
$OU_source = "OU=BBWN,OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=srhk,DC=srh,DC=de"
$OU_target = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=srhk,DC=srh,DC=de" 

$AlteGruppe = Get-ADGroup -server $server -searchbase $OU_source -filter {Name -like $DruckerALT}
Write-Host "-------------------------------------------------------------------------------------------"
Write-Host "Mitglieder alte SRHK Gruppe"
Write-Host "-------------------------------------------------------------------------------------------"
Get-ADGroupMember $AlteGruppe -server $server
$AG_SRHK = $AlteGruppe.name
$NeueGruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU} 
$NG_SRHK = $NeueGruppe.name

if ($NeueGruppe -like $null){
  exit
}
 
$AlteGruppe | Get-ADGroupMember  | Foreach-Object {
  
    # Member zur neuen Gruppe hinzufügen
    Add-ADGroupMember -server $server $NeueGruppe.DistinguishedName -Members $_
  
    # Member aus der alten gruppe entfernen
    Remove-ADGroupMember -server $server $AlteGruppe.DistinguishedName -Members $_ -Confirm:$false
  }

$Zielgruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU}
$Anzahl_SRHK = (Get-ADGroupMember $Zielgruppe -server $server).count
Write-Host "-------------------------------------------------------------------------------------------"
Write-Host "Mitglieder neue SRHK Gruppe"
Write-Host "-------------------------------------------------------------------------------------------"
Get-ADGroupMember $Zielgruppe -server $server


#Leere Grupen löschen
$Geloescht_SRHK = (Get-ADGroup -server $server -searchbase $OU_source -filter * -Properties Members  | Where-Object { -not $_.Members}).count
Get-ADGroup -server $server -searchbase $OU_source -filter * -Properties Members  | Where-Object { -not $_.Members} |
  Remove-ADGroup -server $server -Confirm:$false

######### Ergebnis ausgeben ######################################################################################################################

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-host "$Anzahl_EDU Computer in EDU wurden von $AG_EDU zu $NG_EDU verschoben." -foregroundcolor green
Write-Host ""
Write-host "$Anzahl_SRHK Computer wurden in SRHK von $AG_SRHK zu $NG_SRHK verschoben." -foregroundcolor green
Write-Host ""
Write-Host ""
Write-host "$Geloescht_EDU leere Gruppen wurden in EDU gelöscht." -foregroundcolor red
Write-Host ""
Write-host "$Geloescht_SRHK leere Gruppen wurden in SRHK gelöscht." -foregroundcolor red
Write-Host ""

Start-Sleep 10


Stop-Transcript
