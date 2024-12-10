$TestPath = 'D:\'
Get-ChildItem -Path $TestPath -Recurse -Directory |
    Get-Acl |
        Select-Object -Property Path,Owner,Group,AccessToString | 
            Export-Csv -Path 'c:\temp\Folder-ACL.csv' -NoTypeInformation
