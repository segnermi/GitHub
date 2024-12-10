$ServerEDU = "SVHD-DC34.edu.srh.de"
$ServerSRH = "SVHD-DC05.srh.de"



$Rechner = read-host "PCname eingeben"
$Rechner2 = $Rechner + "*"
$PC = Get-adcomputer -server $serverEDU -filter {(Name -like $Rechner2)}
$PC

Start-Sleep 2

$dom2pc = Get-adcomputer -Server $ServerEDU $PC
Add-ADGroupMember -server $ServerSRH -Identity B_PKI_Computer-Win10-certdeploy -Members $dom2pc
$Name = $dom2pc.name

write-host ""
write-host ""
write-host ""
write-host ""

if($dom2pc.name -like "BBWN*"){
    Add-ADGroupMember -server $ServerSRH -Identity "BC_SRH LAN BBW" -Members $dom2pc

    write-host "$Name in BC_SRH LAN BBW und B_PKI_Computer-Win10-certdeploy aufgenommen!" -ForegroundColor yellow
}

else{
	Add-ADGroupMember -server $ServerSRH -Identity "BC_SRH LAN SHS" -Members $dom2pc

    write-host "$Name in BC_SRH LAN SHS und B_PKI_Computer-Win10-certdeploy aufgenommen!" -ForegroundColor yellow
}


Start-Sleep 12