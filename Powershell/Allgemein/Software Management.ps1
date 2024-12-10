$Computername = Hostname
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Sort Displayname | Select-Object DisplayName, DisplayVersion, InstallDate, Publisher |
   export-csv .\Software-$Computername.csv -Delimiter ";"



# Software Management (nicht mehr in PWS7!)
Get-CimInstance -ClassName Win32_Product -Property *

$arguments = @{
    PackageLocation="H:\Install\vlc\vlcplus-3.0.14-win64.msi" 
 }
 Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments $arguments
 

 Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments {PackageLocation="H:\Install\vlc\vlcplus-3.0.14-win64.msi"}


 Get-CimInstance -ClassName Win32_Product | Where-Object {$_.Name -like "*vlc*"} | Invoke-CimMethod -MethodName Uninstall