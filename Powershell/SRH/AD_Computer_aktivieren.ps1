Get-ADComputer -server SVHD-DC34.edu.srh.de -Filter *  -SearchBase "CN=BBWN0-4DWM4G3,OU=__Neu,DC=edu,DC=srh,DC=de" |
     set-ADComputer -Enable $True

Get-ADComputer -server SVHD-DC34.edu.srh.de -Filter {(Name -like "BBW*")}  -SearchBase "OU=__Neu,DC=edu,DC=srh,DC=de" |
     set-ADComputer -Enable $True