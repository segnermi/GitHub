Add-ADGroupMember -server SVHD-DC34.edu.srh.de -Identity STANDARDWOFFPACK_FACULTY_Users_BBWN -Members LueckDa,MatschSo,MeinhoLa,WolfCa,SchreiNi,KoehleDe,StollJa,BaierC2,LazisJa,RoheKa
Remove-ADGroupMember -server SVHD-DC34.edu.srh.de -Identity STANDARDWOFFPACK_FACULTY_Users_BBWN -Members LueckDa

Add-ADGroupMember -server SVHD-DC34.edu.srh.de -Identity ELinkSAPLogonPadGesamtliste -Members LueckDa,MatschSo,MeinhoLa,WolfCa,SchreiNi,KoehleDe,StollJa,BaierC2,LazisJa,RoheKa


$Benutzer = import-csv ".\documents\ADGroupMember\Benutzer.csv" -Delimiter ";"
Add-ADGroupMember -server SVHD-DC34.edu.srh.de -Identity STANDARDWOFFPACK_FACULTY_Users_BBWN -Members $Benutzer



$Dom2User = Get-ADUser -Server SVHD-DC34.edu.srh.de Eschenfelder
Add-ADGroupMember -server SVHD-DC05.srh.de -Identity BRDP_SVHD-TERM11_2 -Members $Dom2User


$User = Get-ADUser -server SVHD-DC34.edu.srh.de -SearchBase "OU=01_Casemangement,OU=01_Kundenservice,OU=02_KundenUndMaerkte,OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de" -Filter * 
Add-AdGroupMember -server SVHD-DC05.srh.de -Identity BRDP_SVHD-TERM11_2 -Members $User








#$server = "SVHD-DC05.srh.de"
#$server = "SVHD-DC12.srhk.srh.de"

#Get-ADUser -server $server -Filter * -SearchBase "OU=3241,OU=Metall,OU=ISREHA,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"

$server = "SVHD-DC34.edu.srh.de"

$Benutzer = @()
$Benutzer += Get-ADUser -server $server -Filter * -SearchBase "OU=06_TechnischesProduktDesign,OU=06_Ausbildung,OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=edu,DC=srh,DC=de"
Add-ADGroupMember -server $server -Identity BDruckBBWNA4SW -Members $Benutzer
Add-ADGroupMember -server $server -Identity BDruckBBWNA4Farbe -Members $Benutzer
Add-ADGroupMember -server $server -Identity BDruckBBWNA3SW -Members $Benutzer
Add-ADGroupMember -server $server -Identity BDruckBBWNA3Farbe -Members $Benutzer


if($error.length -gt 0){
    write-host "Fehler aufgetreten!" -BackgroundColor red -ForegroundColor black
}

else{
	write-host "Benutzer aufgenommen!" -BackgroundColor Yellow -ForegroundColor black
}

Start-sleep 12