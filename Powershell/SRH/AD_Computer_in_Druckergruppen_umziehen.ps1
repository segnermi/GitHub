function Transcript {
  if(!(test-Path ".\logs\Druckerrollout")){
  mkdir ".\logs\Druckerrollout"
}
  [string]$transcript = (".\logs\Druckerrollout\"+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
  Start-Transcript -Path $transcript -UseMinimalHeader 

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------




$dom = read-host "Domäne eingeben (edu oder srhk)"

if ($dom -match "edu"){
    $server = "SVHD-DC34.edu.srh.de"
    $OU_source = "OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de"
    $OU_target = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=edu,DC=srh,DC=de"

    # Rückgängig machen   
    #$OU_target = "OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de"
    #$OU_source = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=edu,DC=srh,DC=de"   
}

if ($dom -match "srhk"){
    $server = "SVHD-DC12.srhk.srh.de"   
    $OU_source = "OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=srhk,DC=srh,DC=de"
    $OU_target = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=srhk,DC=srh,DC=de" 

	  # Rückgängig machen
	  #$OU_target = "OU=Druckserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=srhk,DC=srh,DC=de"
	  #$OU_source = "OU=SVNGD078,OU=Druckerzuweisung,OU=KonfigGruppen,OU=Infrastruktur,DC=srhk,DC=srh,DC=de"
    
}


$DruckerNameALT = read-host "Name des alten Druckers eingeben" 
$DruckerALT = "*$DruckerNameALT*"
write-host ""
$DruckerNameNEU = read-host "Name des neuen Druckers eingeben" 
$DruckerNeu = "*$DruckerNameNeu*"


$AlteGruppe = Get-ADGroup -server $server -searchbase $OU_source -filter {Name -like $DruckerALT}
$AG = $AlteGruppe.name
$NeueGruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU} 
$NG = $NeueGruppe.name


$AlteGruppe | Get-ADGroupMember  | Foreach-Object {
  
  # Member zur neuen Gruppe hinzufügen
  Add-ADGroupMember -server $server $NeueGruppe.DistinguishedName -Members $_

  # Member aus der alten gruppe entfernen
  Remove-ADGroupMember -server $server $AlteGruppe.DistinguishedName -Members $_ -Confirm:$false
}

$Zielgruppe = Get-ADGroup -server $server -searchbase $OU_target -filter {Name -like $DruckerNEU}
$Anzahl = (Get-ADGroupMember $Zielgruppe -server $server).count
Get-ADGroupMember $Zielgruppe -server $server

Write-Host ""
Write-Host ""
Write-host "$Anzahl Computer wurden von $AG zu $NG verschoben." -foregroundcolor green
Start-Sleep 10

Stop-Transcript
