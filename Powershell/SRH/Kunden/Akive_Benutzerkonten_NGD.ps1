$heute = (get-date -format dd-MM-yyyy)

#EDU BBWN
$MitBBWN = [INT](Get-ADUser -server SVHD-DC34.edu.srh.de -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de" -Filter {(enabled -eq $true)-and (lastlogontimestamp -like "*")}).count
$EXTBBWN = [INT](Get-ADUser -server SVHD-DC34.edu.srh.de -SearchBase "OU=Extern,OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de" -Filter {(enabled -eq $true)-and (lastlogontimestamp -like "*")}).count

#EDU SHS
$MITSHS = [INT](Get-ADUser -server SVHD-DC34.edu.srh.de -SearchBase "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de" -Filter {(enabled -eq $true)-and (lastlogontimestamp -like "*")}).count
$EXTSHS = [INT](Get-ADUser -server SVHD-DC34.edu.srh.de -SearchBase "OU=Extern,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de" -Filter {(enabled -eq $true)-and (lastlogontimestamp -like "*")}).count

#Teilnehmer
$Teilnehmer = [INT](Get-ADUser -server SVHD-DC12.srhk.srh.de -SearchBase "OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (lastlogontimestamp -like "*")}).count

#Schüler
$schueler = [INT](Get-ADUser -server SVHD-DC12.srhk.srh.de -SearchBase "OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de" -Filter {(enabled -eq $true) -and (lastlogontimestamp -like "*")}).count



$BBWN = $MitBBWN + $EXTBBWN
$SHS = $MITSHS + $EXTSHS
$GesamtEDU = $BBWN + $SHS
$GesamtSRHK = $Teilnehmer + $schueler
$Total = $GesamtEDU + $GesamtSRHK
Write-host "$BBWN aktive Mitarbeiterkonten BBWN" -ForegroundColor green
Write-host "$SHS aktive Mitarbeiterkonten SHS" -ForegroundColor green
Write-host "$GesamtEDU aktive Mitarbeiterkonten Gesamt" -ForegroundColor green
Write-host ""
Write-host "$Teilnehmer aktive Teilnehmerkonten" -ForegroundColor green
Write-host "$Schueler aktive Schülerkonten" -ForegroundColor green
Write-host ""
Write-host "$Total aktive Konten insgesamt" -ForegroundColor green

Start-Sleep 30