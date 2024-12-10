for ($i = 0; $i -lt 5; $i++){
    write-host ""
}

$server = "svngd072.srhk.srh.de"
if (Test-Connection $server -quiet){
   write-host "$server ist erreichbar" -ForegroundColor Green 

}
else {
    write-host "$server ist nicht erreichbar" -ForegroundColor red
}

Start-Sleep 12