# Event Log (nicht mehr in PWS7!)

Get-EventLog -LogName system | Where-Object {$_.EventId -eq 7036} |Select-Object EventId, TimeWritten

Get-EventLog -ComputerName server02 -LogName System
Get-EventLog -EntryType Error -LogName System -newest 10

$time = (Get-Date).AddDays(-5)
Get-EventLog -After $time  -EntryType Error -LogName System

