
$Date = Get-Date -Format "dd/MM/yyyy"




$PCName = Hostname
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Sort-Object Displayname | Select-Object DisplayName, DisplayVersion, InstallDate, Publisher |
   export-csv -Path c:\temp\$PCName-Software-$Date.csv -Delimiter ";"

   explorer c:\temp\