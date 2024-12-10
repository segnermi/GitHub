$SRVName = read-host "DNS Namen eingeben" 

$ip = Resolve-DnsName $SRVName
$IPAdresse = $ip.ipaddress

if($IPAdresse -match "10.16.1.26"){
    Write-Host "Server = SVNGDFS33.edu.srh.de"
}

if($IPAdresse -match "10.16.1.27"){
    Write-Host "Server = SVNGDFS34.edu.srh.de"
}

if($IPAdresse -match "10.16.1.124"){
    Write-Host "Server = SVNGDFS12.srhk.srh.de"
}

Start-sleep 10