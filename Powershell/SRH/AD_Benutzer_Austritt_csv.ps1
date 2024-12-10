Function Transcript {
    if(!(test-Path ".\logs\BenutzerAustritt")){
    mkdir ".\logs\BenutzerAustritt"
}
    [string]$transcript = (".\logs\BenutzerAustritt\"+(get-date -Format "yyyy-MM-dd-HH-mm")+".log")
    Start-Transcript -Path $transcript -UseMinimalHeader

}

Transcript

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Anfang eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------

$CSVImport = Import-Csv .\documents\Austritt\Austritte.csv -Delimiter ";" -Encoding ANSI

$Date = Get-Date -Format "dd/MM/yyyy"

$server_EDU   = "SVHD-DC34.edu.srh.de"
$OU_EDU_BBWN  ="OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de"
$OU_EDU_SHS   ="OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de"
   

$Server_SRHK  = "SVHD-DC12.srhk.srh.de"
$OU_SRHK_BBWN = "OU=Mitarbeiter,OU=Benutzer,OU=BBWNeckargemuend,OU=_Reha,DC=srhk,DC=srh,DC=de"
$OU_SRHK_SHS  = "OU=Mitarbeiter,OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"
  


         
foreach ($Eintrag in $CSVImport)            
{            
#####################################################################################################################################################################################################################


		
$Name        = $Eintrag.Kunde
$Benutzer    = $Name + "*"
$T           = $Eintrag.ticket
$FA          = $Eintrag.Firma


# EDU ##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################

if($FA -like "BBWN"){
$user = Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_BBWN -Properties Description
$user.name


Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_BBWN -Properties Description | 
  ForEach-Object { Set-ADUser $_ -Description  "$T / Austritt / $date" } 

Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_BBWN |
  set-aduser -Enabled $false
}

if($FA -like "SHS"){
    $user = Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_SHS -Properties Description
    $user.name
    
    
    Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_SHS -Properties Description | 
      ForEach-Object { Set-ADUser $_ -Description  "$T / Austritt / $date" } 
    
    Get-ADUser -server $server_EDU -filter {(Name -like $Benutzer)} -SearchBase $OU_EDU_SHS |
      set-aduser -Enabled $false
}
# SRHK ##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################

if($FA -like "BBWN"){
$user = Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_BBWN -Properties Description
$user.name

  If($user -like "*"){
    Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_BBWN -Properties Description | 
      ForEach-Object { Set-ADUser $_ -Description  "$T / Austritt / $date" }

      Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_BBWN |
      set-aduser -Enabled $false
}
}

if($FA -like "SHS"){
  $user = Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_SHS -Properties Description
  $user.name
  
    If($user -like "*"){
      Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_SHS -Properties Description | 
        ForEach-Object { Set-ADUser $_ -Description  "$T / Austritt / $date" }
  
        Get-ADUser -server $server_SRHK -filter {(Name -like $Benutzer)} -SearchBase $OU_SRHK_SHS |
        set-aduser -Enabled $false
  }
  }


  }
  
Start-Sleep 15
Stop-Transcript
explorer .\logs\BenutzerAustritt\

# ----------------------------------------------------------------------------------------------------------------------------------------
#               Ende eigentliche Funktion
# ----------------------------------------------------------------------------------------------------------------------------------------



#Alte Logs löschen
$Source = ".\logs\BenutzerAustritt\"		# Wichtig: muss mit "\" enden
$Days = 40					# Anzahl der Tage, nach denen die Dateien gelöscht werden
$ext = "*.txt","*.log"		# Array - erweitern mit  ,".xyz" 
$DateBeforeXDays = (Get-Date).AddDays(-$Days)

write-host "--------------------------------------------------------------------------------------"
write-host "Entfernen aller Dateien ($ext) im Ordner $Source die aelter sind als $Days Tage."
write-host "--------------------------------------------------------------------------------------"
get-childitem $Source\* -include $ext -recurse | Where-Object {$_.lastwritetime -lt $DateBeforeXDays -and -not $_.psiscontainer} | ForEach-Object {remove-item $_.fullname -force -verbose}





