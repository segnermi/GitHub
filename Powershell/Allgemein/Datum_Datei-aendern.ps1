$d1 = get-date "01.01.2024 09:00"


[System.IO.File]::SetCreationTime("s:\Sicherung\Outlook\backup 2021-12-01_MS.txt", $d1)

[System.IO.File]::SetLastAccessTime("s:\Sicherung\Outlook\backup 2021-12-01_MS.txt", $d1)

[System.IO.File]::SetLastWriteTime("s:\Sicherung\Outlook\backup 2021-12-01_MS.txt", $d1)