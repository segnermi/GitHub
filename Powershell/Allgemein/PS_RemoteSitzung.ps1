Enter-PSSession -ComputerName ncc74656 -Credential "michael segner"
Exit-PSSession

Stop-Computer -Force
Restart-Computer -Force

Invoke-Command -ComputerName ncc74656 -Credential "michael segner" -ScriptBlock{
    hostname
    Test-Connection 8.8.8.8
    Stop-Computer -Force
}



$session_server01 = New-PSSession -ComputerName server01

Invoke-Command -Session $session_server01 -ScriptBlock {
    hostname
    Test-Connection 8.8.8.8
    Stop-Computer -Force

}
