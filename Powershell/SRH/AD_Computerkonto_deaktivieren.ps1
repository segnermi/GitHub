$serverSRHK     = "SVHD-DC12.srhk.srh.de"
$serverEDU      = "svhd-dc34.edu.srh.de"

Set-ADComputer BBWNDAIKURPOG07 -server $serverEDU -enabled $false -Description "Deaktiviert 02.12.2022 MS wegen veraltetem BS SRH-T#293477"

Set-ADComputer BBWNMARCHE101 -server $serverSRHK -enabled $false -Description "Deaktiviert 05.12.2022 MS wegen veraltetem BS SRH-T#295130"


Computerkonto deaktiviert