           # Load ActiveDirectory module
            Import-Module ActiveDirectory


            <#
---------------------------------------------------------------------------------------
   
powered by Roland Eich info@eich.me


---------------------------------------------------------------------------------------
#>

 'Programm wird ausgeführt bitte warten bis Eingabe erscheint.'


# Die ersten beiden Befehle holen sich die .NET-Erweiterungen (sog. Assemblies) für die grafische Gestaltung in den RAM.
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 


# Die nächste Zeile erstellt aus der Formsbibliothek das Fensterobjekt.
$objForm = New-Object System.Windows.Forms.Form

# Hintergrundfarbe für das Fenster festlegen
$objForm.Backcolor="white"

# Icon in die Titelleiste setzen
# $objForm.Icon="C:\Powershell\XXX.ico"  #kann selbst definiert werden

# Hintergrundbild mit Formatierung Zentral = 2
#$objForm.BackgroundImageLayout = 2
#$objForm.BackgroundImage = [System.Drawing.Image]::FromFile('C:\Powershell\xxxx.jpg')  #kann selbst definiert werden

# Position des Fensters festlegen
$objForm.StartPosition = "CenterScreen"

# Fenstergröße festlegen
$objForm.Size = New-Object System.Drawing.Size(800,500)

# Titelleiste festlegen
$objForm.Text = "Windows Uptime anzeigen lassen"



#############################################################################################################



# Vorhandene Kontakte auslesen

$Computer = Get-ADComputer -server SVHD-DC34.edu.srh.de -Filter * -SearchBase "OU=Rechner,OU=BBWNeckargemuend,OU=_Reha,OU=Clients,OU=Tier2,OU=SRH,DC=edu,DC=srh,DC=de" -Properties * | select * -ExpandProperty name




#############################################################################################################


#User aus dem Ad anzeigen

        $objLabel = New-Object System.Windows.Forms.Label
        $objLabel.Location = New-Object System.Drawing.Size(300,60) 
        $objLabel.Size = New-Object System.Drawing.Size(1000,20) 
        $objLabel.Text = "Bitte Computernamen wählen:"
        $objForm.Controls.Add($objLabel) 

            $objCombobox = New-Object System.Windows.Forms.Combobox 
            $objCombobox.Location = New-Object System.Drawing.Size(300,80) 
            $objCombobox.Size = New-Object System.Drawing.Size(200,20) 
            $objCombobox.Height = 70
            $objForm.Controls.Add($objCombobox) 
            $objForm.Topmost = $True
            $objForm.Add_Shown({$objForm.Activate()})
            $objCombobox.Items.AddRange($computer) #Computer werden aus der Variable geladen und angezeigt
            $objCombobox.SelectedItem #ausgewählter Computername wird übernommen
            
            $objCombobox.Add_SelectedIndexChanged({ })


    #OK Button anzeigen lassen
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(500,420)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Name = "OK"
    #$OKButton.DialogResult = "OK" # Ansonsten wird Fenster geschlossen
    $OKButton.Add_Click({$wmi=Get-WmiObject -computername $objCombobox.SelectedItem -Class Win32_OperatingSystem 
$wmi2 = $wmi.converttodatetime($wmi.lastbootuptime) 
[void] [Windows.Forms.MessageBox]::Show($wmi2)

    })
    $objForm.Controls.Add($OKButton) 


    #Abbrechen Button
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(600,420)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Abbrechen"
    $CancelButton.Name = "Abbrechen"
    $CancelButton.DialogResult = "Cancel"
    $CancelButton.Add_Click({$objForm.Close()})
    $objForm.Controls.Add($CancelButton) 


######################################################################################################

         
# Die letzte Zeile sorgt dafür, dass unser Fensterobjekt auf dem Bildschirm angezeigt wird.
[void] $objForm.ShowDialog()

