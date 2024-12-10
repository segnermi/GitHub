
$heute = (get-date -format dd-MM-yyyy)

Get-SmbSession | Sort-Object ClientUserName > C:\Users\srhsegnermi-t1\documents\SmbSession_$heute.txt
explorer .\documents\