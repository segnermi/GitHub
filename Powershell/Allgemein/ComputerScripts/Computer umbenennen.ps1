param(
    $Computername = $(Read-Host -Prompt 'Wie soll der neue Computername lauten?')
)

# Computer umbenennen
Rename-Computer -NewName $Computername

# Computer neustarten
Restart-Computer