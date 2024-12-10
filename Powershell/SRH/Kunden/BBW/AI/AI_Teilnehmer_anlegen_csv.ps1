          
# Importieren der CSV Informationen            
$CSVImport = Import-Csv .\documents\AI\Teilnehmer_anlegen.csv -Delimiter ";" -Encoding Default            
            
# Für jeden Datensatz im CSV            
foreach ($Benutzer in $CSVImport)            
{            
#####################################################################################################################################################################################################################

# Benutzerdaten einlesen und diese den jeweiligen Variablen zuweisen
# In der csv Ablaufdatum plus ein Tag eintragen
		
	$vorname        = $Benutzer.vorname
	$nachname 	    = $Benutzer.name
  $Login          = $Benutzer.login
  $UPN            = $login+("@srhk.de")
  $Beschreibung   = $Benutzer.beschreibung
  $kennwort       = $Benutzer.Passwort
  $Ablauf         = $Benutzer.Ablaufdatum
  $script         = "SRHGlobal.vbs"
  $Firma          = "Berufsbildungswerk Neckargemünd GmbH"
  
  $OU             = "OU=AI_Teilnehmer,OU=AAD,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
  $Server         = "SVHD-DC12.srhk.srh.de"
  
  $Gruppe1        = "KBBWN TN"
  $Gruppe2        = "L_SRHK_BBWN_MS_O365_AppsSUBkeinEmail"
  
##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################

  # Active Directory Benutzer erstellen            
    New-ADUser -server $server -Path $OU -name "$($nachname), $($vorname) (TN BBWN)" -Surname $nachname -GivenName $vorname -SamAccountName $Login -UserPrincipalName $UPN -Company $Firma -Description $Beschreibung -EmployeeNumber "$($nachname)$($vorname)" -scriptPath $script -Enabled:$true -DisplayName "$($nachname), $($vorname) (TN BBWN)"-AccountPassword ($kennwort | ConvertTo-SecureString -AsPlainText -Force) -ChangePasswordAtLogon $True -AccountExpirationDate $Ablauf
  
    #Benutzer in Gruppen aufnehmen
    Add-ADGroupMember -server $server -Identity $Gruppe1 -Members $Login
    Add-ADGroupMember -server $server -Identity $Gruppe2 -Members $Login
    
  
  }