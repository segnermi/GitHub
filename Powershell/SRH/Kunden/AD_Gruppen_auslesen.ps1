$heute = (get-date -format dd-MM-yyyy)
$date = Get-Date

#EDU---------------------------------------------------------------------------------------------------------------------------------------------------------------
Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=Gruppen,OU=BBWNeckargemuend,OU=_reha,DC=edu,DC=srh,DC=de" -Properties Name, description, mail, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, mail, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_BBWN-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8


Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=Gruppen,OU=SRHSchulenGmbH,OU=_Schulen,DC=edu,DC=srh,DC=de" -Properties Name, description, mail, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, mail, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_SHS-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8


Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=SVNGDFS12,OU=Dateiserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_SVNGDFS12-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8


Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=SVNGDFS33,OU=Dateiserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_SVNGDFS33-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8


Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=SVNGDFS34,OU=Dateiserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=edu,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_SVNGDFS34-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8

Get-ADGroup -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=KonfigGruppen,OU=Infrastruktur,DC=edu,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\EDU_KonfigGruppen_$heute.csv -Delimiter ";" -Encoding utf8

#SRHK------------------------------------------------------------------------------------------------------------------------------------------------------------

$OUs_BBWN = @(
    "OU=Gruppen,OU=BBWNeckargemuend,OU=_reha,DC=srhk,DC=srh,DC=de" 
    "OU=Benutzer,OU=BBWNeckargemuend,OU=_reha,DC=srhk,DC=srh,DC=de"
)

$GruppenBBWN = Foreach($OU in $OUs_BBWN){ 
    (Get-ADGroup -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase $OU -Properties Name, description, mail, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, mail, DistinguishedName
    )
    
}

$GruppenBBWN | export-csv C:\Users\srhsegnermi-t0\Documents\SRHK_BBWN-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8



$OUs_SHS = @(
    "OU=Gruppen,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de" 
    "OU=Benutzer,OU=SRHSchulenGmbH,OU=_Schulen,DC=srhk,DC=srh,DC=de"
)

$GruppenSHS = Foreach($OU in $OUs_SHS){ 
    (Get-ADGroup -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase $OU -Properties Name, description, mail, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, mail, DistinguishedName
    )
    
}

$GruppenSHS | export-csv C:\Users\srhsegnermi-t0\Documents\SRHK_SHS-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8



Get-ADGroup -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=SVNGDFS12,OU=Dateiserver,OU=NGD,OU=Server,OU=Infrastruktur,DC=srhk,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\SRHK_SVNGDFS12-Gruppen_$heute.csv -Delimiter ";" -Encoding utf8


Get-ADGroup -server SVHD-DC12.srhk.srh.de -Filter * -SearchBase "OU=KonfigGruppen,OU=Infrastruktur,DC=srhk,DC=srh,DC=de" -Properties Name, description, DistinguishedName | 
    Sort-Object Name | Select-Object Name, description, DistinguishedName | 
    export-csv C:\Users\srhsegnermi-t0\Documents\SRHK_KonfigGruppen_$heute.csv -Delimiter ";" -Encoding utf8