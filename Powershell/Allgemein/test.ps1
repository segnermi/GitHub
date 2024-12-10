Get-ExecutionPolicy
invoke
Restart-Computer -ComputerName ncc74656 -credential michael.segner@outlook.com
Stop-Computer

test-connection ncc74656


Enter-PSSession -ComputerName ncc74656 -Credential "michael segner"
New-PSSession -ComputerName 3CX -Credential pi
Disconnect-PSSession

Stop-Computer -Force
Restart-Computer -Force


Set-Location "D:\Evernote Import"
Get-ChildItem "D:\Evernote Import\*.*" -recurse  | Remove-Item -force
Remove-Item "D:\Evernote Import\*.*" -recurse -force

Get-ChildItem -Path "D:\Evernote Import\" -Filter * -Recurse -Force | Remove-Item -Force
mkdir