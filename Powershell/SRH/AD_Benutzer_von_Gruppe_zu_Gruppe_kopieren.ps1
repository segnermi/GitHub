$Source = read-host "Quellgruppennamen eingeben" 
$Target = read-host "Zielgruppennamen eingeben" 
$server = "SVHD-DC34.edu.srh.de"

Write-Host "-------------------------------------------------------------------------------------------"
Write-Host "Mitglieder alte Gruppe"
Write-Host "-------------------------------------------------------------------------------------------"
Get-ADGroupMember $source -server $server
$NeueGruppe = Get-ADGroup -server $server -filter {Name -like $Target} 

if ($Target -like $null){
  exit
}

$NeueGruppe.DistinguishedName | Get-ADGroupMember -server $server | Foreach-Object {
  
   # Member aus der alten gruppe entfernen
Remove-ADGroupMember -server $server $NeueGruppe.DistinguishedName -Members $_ -Confirm:$false
    
  }



$Source | Get-ADGroupMember -server $server | Foreach-Object {
  
  # Member zur neuen Gruppe hinzufügen
  Add-ADGroupMember -server $server $NeueGruppe.DistinguishedName -Members $_

  
}

Start-Sleep 10

