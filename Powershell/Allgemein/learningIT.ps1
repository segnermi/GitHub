Get-ChildItem

Write-Host "Hallo"

Read-Host "Gib eine Zahl ein"

Get-Location
Set-Location C:\

Get-Date

Get-Process
Start-Process calc

Get-Service | Where-Object {$_.Status -eq "stopped"}

Get-LocalUser -filter true
Set-LocalUser -name "Guest" -Description "Depp"

Test-Connection 8.8.8.8 -quiet

# Variablen
$var = 5
write-host "$var" -ForegroundColor Yellow

$aps = Read-Host "Wie viele APs gibt es?" 

# Datentypen
Int Ganzzahl 5
Float Gleitkommazahl 5.4
Double Gleitkommazahl 3.142527
String Text "Das ist Text"
Array 
$var = 5
$eingabe.GetType()
[int]$eingabe = read-host "Gib eine Zahl ein!"

# Mathematische Operationen
5 + 5
11 * 7
$zahl1 = 3.141527
$zahl2 = Read-Host "Bitte Durchmesser eingeben"
$zahl3 = $zahl1 * $zahl2 * $zahl2 / 4
Write-Host "Fläche: $zahl3"

$total = ((Get-Volume)[1]).size
$remaining = ((Get-Volume)[1]).sizeremaining
$prozentfrei = $remaining / $total * 100
write-host "Auf der HDD sind noch $prozentfrei % frei"

Arrays:
$colors = @("black","white","green")

$colors = @()
$colors += "black"
$colors += "yellow"
$colors += "green"
$colors += $color
$colors[0] erster wert
$colors[0..2]
$colors[-1] letzter Wert
$colors.count

$proc = Get-Process
$proc.GetType()

# Hashtables
$DNS = @{}
$DNS = @{Google = "8.8.8.8"; Test = "1.1.1.1"}
$DNS.Add("local", "10.1.1.1")
$DNS.Google
Test-Connection $DNS.Google
$DNS.Remove("local")

$usersettings = @{

    Name = "Guest"
    Description = "Neuer Test"

}

Set-LocalUser @usersettings


# If/ELSE

if (bedingung){
    code
}
else {
    code
}

[int]$var = Read-Host "Bitte gib eine Zahl ein"

if ($var -eq 11){
    write-host "Die Zahl ist 11" -ForegroundColor Green

}
elseif ($var -gt 11){
     Write-Host "Die Zahl ist größer als 11" -ForegroundColor blue
     
}
else {
    Write-Host "Die Zahl ist kleiner als 11" -ForegroundColor red

}

<#
-eq = ist bleich
-ne = ist nicht gleich
-lt = kleiner als
-le = kleiner gleich
-gt = größer als
-ge = größer gleich
#>

$string = "test"
if ($string -match "test"){
    write-host "Der Text ist test"
}

$server = "server1"
if (Test-Connection $server){
   write-host "$server ist erreichbar" -ForegroundColor Green 

}
else {
    write-host "$server ist nicht erreichbar" -ForegroundColor red
}

# Schleifen
    #for
    #Foreach
    #While
    #Do-While
    #Do-Until

for ($i = 0; $i -lt 10; $i++){
    write-host "test"
}


stop-computer server1

while (Test-Connection 8.8.8.8){
    write-host "8.8.8.8 ist online"
}

# do-while
$i = 5
do {
    write-host "test"
    $i++
} while($i -lt 10)


# foreach
$array = @()
$array += "8.8.8.8"
$array += "10.1.1.1"
$array += "10.1.1.10"


foreach ($one In $array){
    write-host "Teste $one" -ForegroundColor green
    test-connection $one -quiet
}

# pipelines
Get-ChildItem -Path *.txt |
    where {$_.Length -ge 0} |
        Sort-Object -Property Length -Descending |
            Select-Object name, length

Get-ChildItem -Path *.txt |
    where {$_.Length -eq 0} |
        Remove-Item

Get-Process | Sort-Object -Property "CPU"
Get-Process | select-Object -Property "CPU"
Get-Process | where-Object {$_.CPU -gt 1}

# Passworte
    # Methode 1
    $pass = read-host "Bitte Passwort eingeben" -AsSecureString | ConvertFrom-SecureString | out-file "D:\pass.txt"
    $passimport = Get-Content -Path "D:\pass.txt" | ConvertTo-SecureString

    #Methode 2
    Install-Module -name Microsoft.powershell.secretmanagement -AllowPrerelease
    Import-Module Microsoft.powershell.secretmanagement

    Set-Secret -Name "Sicherheitstest" -SecureStringSecret $passimport

# ExecutionPolicy
    # AllSigned
    # ByPass
    # RemoteSigned
    # Restricted
    # Unrestricted

Set-ExecutionPolicy ALLSigned

#Simple Array
$array = @()
$array += "test1"
$array += "test2"

    #EQ, Contains, NE
    $array -eq "test1"
    $array -contains "test1"

    #Addition von Arrays
    $array2 = @()
    $array2 = "test3"

    $array3 = $array + $array2

    #Verschiedene Datentypen
    [int]$zahl = 5
    [string]$string = "12345"
    $array4 = @()
    $array4 += $string
    $array4 += $zahl

    #Strongly Typed
    [int[]]$array5 = @()
    $array5 +=  $zahl
    $array5 += $string

    #Nested Arrays
    $nested = @(
        @(1,2,3),
        @(4,5,6),
        @(7,8,9)
    )
    $nested[1]
    $nested[1][0]

    #Eigene Array-Objekte
    $eigenesarray = @()
    $PC = HOSTNAME
    $disk = (Get-Disk).count

    $object = New-Object psobject
    $object | add-Member NoteProperty PC $PC
    $object | add-Member NoteProperty Plattenanzahl $disk
    $eigenesarray += $object

    $object = New-Object psobject
    $object | add-Member NoteProperty PC "NX74205"
    $object | add-Member NoteProperty Plattenanzahl "1"
    $eigenesarray += $object

    #Array Anzeige
    $eigenesarray.PC
#CSV
$neuesarray = @()
$PC = HOSTNAME
$disk = (Get-Disk).count

$object = New-Object psobject
$object | add-Member NoteProperty PC $PC
$object | add-Member NoteProperty Disks $disk
$neuesarray += $object

$neuesarray | Export-Csv -Path ".\Rechner.csv" -Delimiter ";"

$import = Import-Csv "D:\Git\Powershell\Rechner.csv" -Delimiter ";"



# Dateisystemberechtigungen
Get-Acl "D:\OneDrive-SRH\OneDrive - SRH IT\learningIT.ps1"
(Get-Acl "D:\OneDrive-SRH\OneDrive - SRH IT\learningIT.ps1").Access

Get-Acl "D:\OneDrive-SRH\OneDrive - SRH IT\txt1.txt" | set-Acl "D:\OneDrive-SRH\OneDrive - SRH IT\txt2.txt"



# Remoting
Enable-PSRemoting -Force
Enter-PSSession 10.1.1.110

Exit-PSSession


Invoke-Command -ComputerName ncc74656 -Credential "michael segner" -ScriptBlock{
    hostname
    Test-Connection 8.8.8.8
    Stop-Computer -Force
}



$session_server01 = New-PSSession -ComputerName server01

Invoke-Command -Session $session_server01 -ScriptBlock {
    hostname
    Test-Connection 8.8.8.8
    Stop-Computer -Force

}



# Event Log (nicht mehr in PWS7!)
Get-EventLog -LogName system | where {$_.EventId -eq 7036} |select EventId, TimeWritten

Get-EventLog -ComputerName server02 -LogName System
Get-EventLog -EntryType Error -LogName System -newest 10

$time = (Get-Date).AddDays(-5)
Get-EventLog -After $time  -EntryType Error -LogName System


# Software Management (nicht mehr in PWS7!)
Get-CimInstance -ClassName Win32_Product -Property *

$arguments = @{
    PackageLocation="H:\Install\vlc\vlcplus-3.0.14-win64.msi" 
 }
 Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments $arguments
 
 
 Invoke-CimMethod -ClassName Win32_Product -MethodName Install -Arguments {PackageLocation="H:\Install\vlc\vlcplus-3.0.14-win64.msi"}


 Get-CimInstance -ClassName Win32_Product | Where-Object {$_.Name -like "*vlc*"} | Invoke-CimMethod -MethodName Uninstall


# Transcript

Start-Transcript
Stop-Transcript


if(!(test-Path ".\logs")){
    mkdir ".\logs"
}
[string]$transcript = ".\logs\."+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
Start-Transcript -Path $transcript

Write-Host "test"

Stop-Transcript

function Transcript {
    if(!(test-Path ".\logs")){
    mkdir ".\logs"
}
    [string]$transcript = (".\logs\."+(get-date -Format "yyyy-MM-dd-HH-mm-ss")+".log")
    Start-Transcript -Path $transcript

}

Transcript

Write-Host "test"

Stop-Transcript
