﻿Get-ADUser -filter * -properties passwordlastset, passwordneverexpires | sort-object name | select-object Name, passwordlastset, passwordneverexpires | Export-csv -path C:\Temp\Kennwort-Info-20160530.csv