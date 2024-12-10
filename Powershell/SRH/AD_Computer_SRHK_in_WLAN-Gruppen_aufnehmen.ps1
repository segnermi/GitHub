$ServerSRHK = "SVHD-DC12.srhk.srh.de"



$Rechner = read-host "PCname eingeben"
$Rechner2 = $Rechner + "*"
$PC = Get-adcomputer -server $ServerSRHK -filter {(Name -like $Rechner2)}
$PC

Start-Sleep 2

$dom2pc = Get-adcomputer -Server $ServerSRHK $PC
Add-ADGroupMember -server $ServerSRHK -Identity  C_SRHK_LAN_WLAN_Gesamt -Members $dom2pc
$Name = $dom2pc.name

write-host ""
write-host ""
write-host ""
write-host ""

if($dom2pc.name -like "BBWN*"){
    Add-ADGroupMember -server $ServerSRHK -Identity "BC_SRHK LAN BBWN" -Members $dom2pc

    write-host "$Name in BC_SRHK LAN BBW und  C_SRHK_LAN_WLAN_Gesamt aufgenommen!" -ForegroundColor yellow
}

else{
	Add-ADGroupMember -server $ServerSRHK -Identity "BC_SRHK LAN SHS" -Members $dom2pc

    write-host "$Name in BC_SRHK LAN SHS und  C_SRHK_LAN_WLAN_Gesamt aufgenommen!" -ForegroundColor yellow
}


Start-Sleep 12



Start-Sleep 12