Get-NetAdapter

$NetzwerkKarte = Read-Host "Netzwerk-Adapter Name eingeben"

$Auswahl = Read-Host "Netzwerkkarte (a)ktivieren, (d)eaktivieren oder (n)eustarten"

if ($Auswahl -match "a"){
    Enable-NetAdapter -Name "$NetzwerkKarte"   
    Start-Sleep 10
    exit
}

if ($Auswahl -match "d"){
    Disable-NetAdapter -Name "$NetzwerkKarte" 
    Start-Sleep 10
    exit  
}

if ($Auswahl -match "n"){
    Restart-NetAdapter -Name "$NetzwerkKarte" 
    Start-Sleep 10
    exit  
}

else {
    exit
}