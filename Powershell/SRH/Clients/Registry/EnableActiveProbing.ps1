Get-PSDrive

Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\internet' -Name 'EnableActiveProbing' -value '1'


Set-Location hklm:
Set-Location \SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\
Get-ChildItem