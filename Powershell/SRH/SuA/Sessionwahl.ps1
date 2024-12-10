# .\ps2exe.ps1 -inputFile .\sessionwahl9.ps1 -outputFile .\sessionwahl9.exe -noConsole
$Script:PSADModule = "ActiveDirectory"
$nL = [Environment]::NewLine
$Domaene = @{EDU="EDU.SRH.DE";SRH="SRH.de";SRHK="SRHK.SRH.DE";KLINIKEN="KLINIKEN.SRH.DE"}
$StatusSession = @("Aktiv","Verbunden","","Fernsteuerung","Getrennt","","","","","")
function Benutzerauswahl()
{
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objForm =  New-Object System.Windows.Forms.Form
	$objForm.StartPosition = "CenterScreen"
#	$objForm.Size = New-Object System.Drawing.Size(800,500)
	$objForm.Size = New-Object System.Drawing.Size(1200,700)
	$objForm.Text = "Sessionauswahl"
$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objForm.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$MyScriptRoot = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
$Picture = @{}
If ($PSScriptRoot){
    $Pictures = Get-ChildItem -Path "$PSScriptRoot\*.PNG" | Sort-Object -Property Name
}Else{
    #Fuer EXE
    $Pictures = Get-ChildItem -Path "$MyScriptRoot\*.PNG" | Sort-Object -Property Name
}
$I = 0
foreach($P in $Pictures){
   $i = $I + 1 
   $Picture[$i] = $P
   }
#$Picture[1] = (get-item (".\test2.png"))
#$Picture[2] = (get-item (".\test.png"))
$img = @{}
for ($k=1; $k -le $i; $k++) {$img[$k] = [System.Drawing.Image]::Fromfile($Picture[$k])}

#$img[1] = [System.Drawing.Image]::Fromfile($Picture[1])
#$img[2] = [System.Drawing.Image]::Fromfile($Picture[2])

	$objPicturebox = New-Object System.Windows.Forms.PictureBox
	$objPicturebox.Location = New-Object System.Drawing.Size(0,0)
	$objPicturebox.Size = New-Object System.Drawing.Size(1100,700)
	$objPicturebox.AutoSize = $true
	$objPicturebox.Image = $img[1]
    $objPicturebox.visible =$False
    
    $objPicturebox.Tag = 1
    $objPicturebox.Add_Click({
        $objPicturebox.Tag = $objPicturebox.Tag + 1
        if ($objPicturebox.Tag -gt $img.count ){
            $objPicturebox.visible =$False
            $objPicturebox.Tag = 1
            $objPicturebox.Image = $img[1]
        }else{
            $objPicturebox.Image = $img[$objPicturebox.Tag]
        }
    })
	$objForm.Controls.Add($objPicturebox)

	$objlabelName = New-Object System.Windows.Forms.Label
	$objlabelName.Location = New-Object System.Drawing.Size(20,20)
	$objlabelName.Size = New-Object System.Drawing.Size(120,20)
	$objlabelName.Text = "Terminalserverfarm:"
	 $objForm.Controls.Add($objlabelName)

	$objComboboxServer = New-Object System.Windows.Forms.Combobox
	$objComboboxServer.Location = New-Object System.Drawing.Size(150,20)
	$objComboboxServer.Size = New-Object System.Drawing.Size(200,20)
	$objComboboxServer.Text = ""
	$objComboboxServer.DropDownStyle = 2
    	[void] $objComboboxServer.Items.add("svbwiterm02a.kliniken.srh.de")
	[void] $objComboboxServer.Items.add("svgraterm01a.kliniken.srh.de")
	[void] $objComboboxServer.Items.add("svhd-term01a.srh.de")
	[void] $objComboboxServer.Items.add("svhd-term03a.srh.de")
    	[void] $objComboboxServer.Items.add("svdd-term04a.edu.srh.de")
    	[void] $objComboboxServer.Items.add("svhd-term08a.edu.srh.de")
	[void] $objComboboxServer.Items.add("svhd-term11a.srh.de")
	[void] $objComboboxServer.Items.add("svhd-term12a.kliniken.srh.de")
    	[void] $objComboboxServer.Items.add("svkarterm01a.kliniken.srh.de")
	[void] $objComboboxServer.Items.add("svngdterm05a.edu.srh.de")
	[void] $objComboboxServer.Items.add("svngdterm06a.edu.srh.de")
    	[void] $objComboboxServer.Items.add("svshlterm01a.kliniken.srh.de")
    	
    	[void] $objComboboxServer.Items.add("svnerterm01a.kliniken.srh.de")
	$objForm.Controls.Add($objComboboxServer)

	$objlabelFilter = New-Object System.Windows.Forms.Label
	$objlabelFilter.Location = New-Object System.Drawing.Size(400,20)
	$objlabelFilter.Size = New-Object System.Drawing.Size(120,20)
	$objlabelFilter.Text = "Filter (ganzeZeile):"
	$objForm.Controls.Add($objlabelFilter)


	$objTextBoxFilter = New-Object System.Windows.Forms.TextBox
	$objTextBoxFilter.Location = New-Object System.Drawing.Size(530,20)
	$objTextBoxFilter.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxFilter.Text = ""
	$objForm.Controls.Add($objTextBoxFilter)
<##
	$objCheckBoxAD = New-Object System.Windows.Forms.CheckBox
	$objCheckBoxAD.Location = New-Object System.Drawing.Size(780,20)
	$objCheckBoxAD.Size = New-Object System.Drawing.Size(50,20)
	$objCheckBoxAD.Text = "AD"
	$objForm.Controls.Add($objCheckBoxAD)
##>
   	$HelpButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$HelpButton.Location = New-Object System.Drawing.Size(1100,20)
	$HelpButton.Size = New-Object System.Drawing.Size(75,23)
	$HelpButton.Text = "Hilfe"
	$HelpButton.Name = "Hilfe"
	#$HelpButton.DialogResult = ""
	$HelpButton.Visible = ($img.count -gt 0)
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$HelpButton.Add_Click({
        $objPicturebox.visible =$true
 		})
    $objForm.Controls.Add($HelpButton)

	
	$objListbox = New-Object System.Windows.Forms.Listbox
	$objListbox.Location = New-Object System.Drawing.Size(20,80)
	$objListbox.Size = New-Object System.Drawing.Size(1150,20)
	$objListbox.Font = "Courier New,10"
	$objListbox.Visible = $true
	#$objListbox.SelectionMode = "MultiExtended"
	$objListbox.SelectionMode = "One"
	
#	$objListbox.Height = 250
	$objListbox.Height = 520
	$objForm.Controls.Add($objListbox)
   	$OKButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$OKButton.Location = New-Object System.Drawing.Size(20,50)
	$OKButton.Size = New-Object System.Drawing.Size(75,25)
	$OKButton.Text = "Aktualisieren"
	$OKButton.Name = "Aktualisieren"
	$OKButton.DialogResult = "OK"
	$OKButton.Visible = $true
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$OKButton.Add_Click({
        $objForm.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
        #$objForm.UseWaitCursor=$true
        $objListbox.Items.Clear()
            ##$Freigabe = "\\" + $objComboboxServer.SelectedItem.ToString() + "a\Scripts\sessions_" + $objComboboxServer.SelectedItem.ToString() + ".csv"
            #$Dateidatum = (get-item -Path #$Freigabe).LastWriteTime.tostring()
            #$objlabelStand.Text = "Stand: " + $objComboboxServer.SelectedItem.ToString() + " " + $Dateidatum 
            #$csv = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()
            $csv = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()
	         
		$Liste = $csv | sort UserName
		$Liste = $csv
		#$csv.SessionState = $StatusSession[$csv.SessionState]
            Foreach ($Anmeldung in $Liste) {
		 
			$space =" "
				
				if ([int]$Anmeldung.SessionId -lt 10) {$space= $space + " "}
				if ([int]$Anmeldung.SessionId -lt 100) {$space= $space + " "}
                $Filter = $objTextBoxFilter.Text
                #$Zeile = $Anmeldung.ServerName +" |" + $space + $Anmeldung.SessionId +" | "+ $Anmeldung.DomainName + "\" + $Anmeldung.UserName.PadRight(16, " ") +" | "+ $Anmeldung.SessionState.ToString().PadRight(18, " ")+" "+ $Anmeldung.DisconnectTime.ToString().PadRight(19, " ") 
		$Zeile = $Anmeldung.ServerName +" |" + $space + $Anmeldung.SessionId +" | "+ $Anmeldung.DomainName + "\" + $Anmeldung.UserName.PadRight(20, " ") +" | " +$StatusSession[$Anmeldung.SessionState].PadRight(20, " ") +" | "+ $Anmeldung.DisconnectTime

                if ($objCheckBoxAD.Checked){
				    $ADUser = Get-ADUser $Anmeldung.UserName -server $Anmeldung.DomainName
    				$Zeile = $Zeile +" | "+ $ADUser.Name
                }
                if ( $Zeile -like ("*"+$Filter+"*")){
					$objListbox.Items.add($Zeile)
				}
			}
        $objForm.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
        #$objForm.UseWaitCursor=$false		
		})
    $objForm.Controls.Add($OKButton)

	$objlabelStand = New-Object System.Windows.Forms.Label
	$objlabelStand.Location = New-Object System.Drawing.Size(100,55)
	$objlabelStand.Size = New-Object System.Drawing.Size(300,20)
	$objlabelStand.Text = "Zeige alle Sitzungen der gewünschten Farm"
	
	$objForm.Controls.Add($objlabelStand)



	$FernsteuerungButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$FernsteuerungButton.Location = New-Object System.Drawing.Size(20,620)
	$FernsteuerungButton.Size = New-Object System.Drawing.Size(150,23)
	$FernsteuerungButton.Text = "Fernsteuerung starten"
	$FernsteuerungButton.Name = "Fernsteuerung starten"
	$FernsteuerungButton.Visible = $true
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$FernsteuerungButton.Add_Click({
	       foreach ($objItem in $objListbox.SelectedItems) { 
				
				$Server,$ID,$Username,$aktiv = $objItem.split("|")
				$ID = $ID.Trim()
				$Server = $Server.Trim()
				$Username = $Username.Trim()
 				##$Freigabe = "\\" + $objComboboxServer.SelectedItem.ToString() + "a\Scripts\sessions_" + $objComboboxServer.SelectedItem.ToString() + ".csv"
				#$Liste = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()
                $Liste = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()				
                Foreach ($Anmeldung in $Liste) {
					IF ((( ($Anmeldung.DomainName + "\" + $Anmeldung.UserName) -eq $Username ) -and ( $Anmeldung.ServerName -eq $Server )) -and ( $Anmeldung.SessionId -eq $ID )) { Fernsteuerungstarten $Server $ID}
				}
			}
	    }) 
	$objForm.Controls.Add($FernsteuerungButton)
	
	#Invoke-RDUserLogoff -HostServer $server -UnifiedSessionID $id
	$LogoffButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$LogoffButton.Location = New-Object System.Drawing.Size(200,620)
	$LogoffButton.Size = New-Object System.Drawing.Size(150,23)
	$LogoffButton.Text = "Abmelden"
	$LogoffButton.Name = "Abmelden"
	$LogoffButton.Visible = $true
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$LogoffButton.Add_Click({
	       foreach ($objItem in $objListbox.SelectedItems) { 
				
				$Server,$ID,$Username,$aktiv = $objItem.split("|")
				$ID = $ID.Trim()
				$Server = $Server.Trim()
				$Username = $Username.Trim()
                #$Freigabe = "\\" + $objComboboxServer.SelectedItem.ToString() + "a\Scripts\sessions_" + $objComboboxServer.SelectedItem.ToString() + ".csv"
				$Liste = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()

				Foreach ($Anmeldung in $Liste) {
					IF ((( ($Anmeldung.DomainName + "\" + $Anmeldung.UserName) -eq $Username ) -and ( $Anmeldung.ServerName -eq $Server )) -and ( $Anmeldung.SessionId -eq $ID )) { Logoff $Server $ID}
				}
			}
	    }) 
	$objForm.Controls.Add($LogoffButton)

	$DisconnectButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$DisconnectButton.Location = New-Object System.Drawing.Size(380,620)
	$DisconnectButton.Size = New-Object System.Drawing.Size(150,23)
	$DisconnectButton.Text = "Trennen"
	$DisconnectButton.Name = "Trennen"
	$DisconnectButton.Visible = $false
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$DisconnectButton.Add_Click({
	       foreach ($objItem in $objListbox.SelectedItems) { 
				
				$Server,$ID,$Username,$aktiv = $objItem.split("|")
				$ID = $ID.Trim()
				$Server = $Server.Trim()
				$Username = $Username.Trim()
                #$Freigabe = "\\" + $objComboboxServer.SelectedItem.ToString() + "a\Scripts\sessions_" + $objComboboxServer.SelectedItem.ToString() + ".csv"
				$Liste = Get-CimInstance -ErrorAction Stop -classname "Win32_SessionDirectorySessionEx" -ComputerName $objComboboxServer.SelectedItem.ToString()
				Foreach ($Anmeldung in $Liste) {
					IF ((( ($Anmeldung.DomainName + "\" + $Anmeldung.UserName) -eq $Username ) -and ( $Anmeldung.ServerName -eq $Server )) -and ( $Anmeldung.SessionId -eq $ID )) { Disconnect $Server $ID}
				}
			}
	    }) 
	
	$objForm.Controls.Add($DisconnectButton)
<##
	$InfoButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$InfoButton.Location = New-Object System.Drawing.Size(1020,620)
	$InfoButton.Size = New-Object System.Drawing.Size(150,23)
	$InfoButton.Text = "Log Anmeldeskript"
	$InfoButton.Name = "Info"
	$InfoButton.Visible = $true
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$InfoButton.Add_Click({
           $objForm.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
	       foreach ($objItem in $objListbox.SelectedItems) { 
				
				$Server,$ID,$Username,$aktiv = $objItem.split("|")
				$ID = $ID.Trim()
				$Server = $Server.Trim()
				$Dom,$Username = $Username.Trim().Split("\")
				$Dom = $Domaene[$Dom]
	                Info $Server $Username
				
		   }
           $objForm.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
	    }) 
	$objForm.Controls.Add($InfoButton)


	$ADInfoButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$ADInfoButton.Location = New-Object System.Drawing.Size(850,620)
	$ADInfoButton.Size = New-Object System.Drawing.Size(150,23)
	$ADInfoButton.Text = "AD Infos"
	$ADInfoButton.Name = "ADInfo"
	$ADInfoButton.Visible = $true
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$ADInfoButton.Add_Click({
           $objForm.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
	       foreach ($objItem in $objListbox.SelectedItems) { 

				
				$Server,$ID,$Username,$aktiv = $objItem.split("|")
				$ID = $ID.Trim()
				$Server = $Server.Trim()
				$Dom,$Username = $Username.Trim().Split("\")
				$Dom = $Domaene[$Dom]
                ADInfo $Dom $Username
				
			}
           $objForm.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
	    }) 
	$objForm.Controls.Add($ADInfoButton)


##>	
	$ok = $true 
	While ( $ok)
	{
        [Void] $objForm.ShowDialog()
	    if ($objForm.DialogResult -ne "OK"){$ok = $false}
    
    }
}


Function Fernsteuerungstarten($Server, $ID)


{
mstsc /v:"$Server" /shadow:"$ID" /control
}

Function Logoff($Server, $ID)
{

#Invoke-Command -ComputerName $server -ScriptBlock {logoff $id}
#Invoke-RDUserLogoff -HostServer $server -UnifiedSessionID $id -force
logoff.exe $id /server:$server
}

Function Disconnect($Server, $ID)
{
Disconnect-RDUser  -HostServer $server -UnifiedSessionID $id -force
}

Function Info($Server, $User )
# $Eventliste = get-eventlog -logname Application -after 24.03.2020 -Source WSH -Message "*bucherbe*" | select Index,TimeWritten,EntryType,Message
{
#Get-WinEvent -Computername svhd-term11d -FilterHashtable @{logname="application";StartTime="24.03.2020";ProviderName="WSH";}| where Message -like "*Kani*"
#$Eventliste = Get-WinEvent -Computername $Server -FilterHashtable @{logname="application";StartTime="24.03.2020";ProviderName="WSH";}| where Message -like "*$User*"|select TimeCreated,LevelDisplayName,Message
$datum = get-date -Format "dd.MM.yyyy"
$Eventliste = Get-WinEvent -Computername $Server -FilterHashtable @{logname="application";StartTime=$datum;ProviderName="WSH";}| where Message -like "*$User*"|select TimeCreated,LevelDisplayName,Message

	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objForm =  New-Object System.Windows.Forms.Form
	$objForm.StartPosition = "CenterScreen"
#	$objForm.Size = New-Object System.Drawing.Size(1200,500)
	$objForm.Size = New-Object System.Drawing.Size(1200,1000)
	$objForm.Text = "Events der Anmeldung von " + $User + " an " + $server
$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAAFcAAAA9CAYAAADYp/VQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAhdEVYdENyZWF0aW9uIFRpbWUAMjAxOTowMzoyOSAwODoxNTozOO7qzQ4AABWaSURBVHhe7ZxpcJXndcfPvdoltLEICYlFGzIgzL54YQlgG7yAcRwvTRvHaZJOF7v90Dbth9b91g/tTGeapZO09Uynk6bt2EkTx3gBs1pCrLYBISTEKiQkIYH29Urq+Z33PtIrWcKSHWaC0d/z+N77vs96nrP8z/O+IjCgkEncEQTDn5O4A5gU7h3EpHDvICaFewcxKdw7iEnh3kEE+vv7vxAboy2luaVZys6XSUtbq2SmZ8rMtJmSnJgkMdEx4Zr3Hr6QcAOBgJVbTbdkz4EP5FDJh9LV3SWxMTGSNj1NCvILZPmS5TI3a65ERkRYG7cZ9wImLFxXNxgMmmCvXLsq7+/bLecqzpkAo6OjRfuU3lCvdPd0SygUkoT4BFm0oFA2PLBO5s6ea+39Y7rv9DcaPuv+byvG5XMHpE8X2Bf+NaSxVTXX5N0P3pUzZWckKirKBAuCEUH9HW0uISIiUuJi481FBFX4CIrCBjihsVEReo9PVwIBrwzdQ/PvLuFOQHO9haE8CLa9o112H9gjhw5/KFGRUSrMSK0RkP6Bfunr65POzk4T8NqVa2TjwxtlWupUa387oOk3Gm9Ie3u7CZW+2JRpqdMlUsdgm8c3198OjFu41KGwaEx+X9F+2XtwnwS0aXRMtCdY1UYEpD3K/QsL5ZGNm2VWela4hyH09PZKVXWVnC47LeXny+XilUvS0tIi0ar9ESrEIJYR1F3Uvjt0k3LmzpPndn5NCu8r/PIKF41FuB+d/lh27XlHmjSQYfoIQruRrq4ucw0bHlwv69W/xsfHh1t7wI0cPXHUWEVtXZ0MaJu4uDhrE6H9Yhxsks0n/L1T+5wxfbps27JVFi9YPLjJdwPGFK7zqyNxva5W3t69S86WlZrw/IJNUhPeuuUxWbN8dbi2h/LKCg1678vFy5dMMCZM9aMR6ptNmPpfUP2rzYMh9cNd61Utj4mNlUc2bJaH1jx0VwnXApp/wk47+bzRcEOOf3xCrlRdsXsAVlChwopWuuVMt7u7W6ZPmyY7Hn9qmGBraq/Lz37+3/Jv//nvUnnxgsSo+5iSkKDaHq0+1AtgtolhAdtmhuXmNtbcUG+PdCrFu9sQ1lynqd5FgtWJT07Knv0fSFraDHn68R2SlZFlZv3OnnelQv1krGoT6OzqNNPetnmraZYD2orruHL1imkqAQ9NdAGvu7tHenp6BikbGtqnPht/6/neSN2ASIlWH4yP3rz+K/LVp54x9nG3aK4J177oopxQ4a0112skOTlZnnj0cdmyfrMKJCQHDx/SZGGvCQfNY9H43Ec3PiLrHnjYOkRQRUeLdWP2aDDqUBoWp/40wtqQYLCDiVMSNdBlSH5OrmTPy5ZZMzM18fA2y6HhZoMGuotSeemClKoLysvOk+3btsvUlNS7S7gIBK56oPigCRUB9Pf164Jy5cnHnjDiX3ejzjTxzNkzpqnazhKElctWymObHlXKlGwdFh87LG+/v8uoWFxcrAmio6NDP0XycnPlgVVrZX5ugSSpgMcLNr1btXyKJiPw6btFuOZzL1+5bLTqkn4y+VjVxv7+PkmfmS5zsuZYRbToklKmSMxSlb2zs0tmZ86WVSpcBItmFx8t0qTiPenW4EYK3NPTa1QqLzdPXv2DV+SVb/+JrFyyclCwCIlNGln6+tVF9PXad+qQ4aGxLkm5WxDs0WBxq7VJQirMhLh4Ey48NVVJf3raTHMXoKGhURpv3jRfGFITRysXL1wk2XOy7f4p1ei9Hx6QtrY2idQ+cAGJiVNk55M75Vsvviy583Ks3jCBDoT0d79eDTv7MAISoeMOnUXgUihO2HcLgn1q/q0tbWa6pK1EbswdE0xJTrFK+L/GpkbTHMTA/YK8AilU3gk4Xyg5UaLCb7QghBmnpaVpANpp5wlQNidUv3A8IULBPGG7e2woLMFf3CZ/GvBibxM+VcJpu/vtMNZ1P/z3blfPD1fPlWBIza+to9UiN4vgIi4hKSlJUtQUwdWqKrlWfc0ifp/emz51ugq20D5hC5+c+VjOV1Za4EJIuIqXX/ymLCootPZusNHAQkX6w7x3iJ754Re2/553XbdIlcK1H1aCyjoiKN5v19ZZBr8pbn5uLozj2ow2roM3/pAC+NtY3zdv3RzYtfsdOaksIT4hXoXjmeGKZcuNBeBPCVLmS5XPcm+xprawCIR7tvys0bNr16tNowsXLJLtW7dLhvprM/3+UHgRnpmPhHfPmzi8+pOzpyw17tW+8O2wkuSkFEmbkSb5yhhwVW6jaIdb0zUYc8GlASyhVd0T4oKZQOcSp0yxAySH0TbczYX4wT3OM1gvtcggWY+/HsVdQ6D+dlyPhHd293ZLj/LNeHrRmzSKi441mgWTaG1rlT4Wq3UjoyIkc1amCZZgdf5CpVyrqbaFFOTPly0btphg3cSDwUj7HA1ugjca62V/0X5NjY+br8YCcBeASWItbNxjmx6TnU/ssOuu/yq1qP/b9UudR4XRPm1oa+A2XzmJ6wv1mdXl5ebL5nWblALm2bhgpIAbbzXKW+/9WkqOH9H+Yo31kM5/bcezqpWRNh/a0B6aCDOqvFhpCRX8fJP2v0WzSTbaVuCp9dBg3EjUVBbuSVrLUwY0JKSTzEibNRjEKi6Wy+ny05ZBzVTNeliTCAIXE3A7Cuhz5CKcYKtV49986xey/9AhrSMmIDYKd9PW3mbuCmEzRy/4De8vNSXFzh5oF68BGYXA79OHzUHrcbBEe2jk6z99XQ4cPmhB2cHf35SEKXaCF8+ZR5SyE93kgI7vncp58wZYOJaQoNYeqRvHuMSk+PjYQVbjqYd6IfUeJn2G8AuCxXV2dNruo/Y8vpk9yzvpqrl+3UpUdJQUqqtwAc4JzmHkbwcCH4dAnDnAnc0Edeili5fJH337D+Vv//Jv5Lsvf8dcFO3r1W3wGMn6CqBBfZb1cdYbUOFxHSHOnT1HHlyzVlYsXaFWlGHuzHiyCo7vR48flfLz53QGzGlobm7d+E0EC+2EliI4/wYAm4KVoESGN9+OXiOH6KIqrMpXG2F6JA4DuttRuvPOf/WGNE0Nqa/V6wkJCXaGwM6gcVeVJfSrQBYVLDL+6vySfxK3A+3LysskpP6SdvnKh1/57h9rMHxJ7teNYhOXFS6Vbzz3e/LPf/9P8tLzv2uLBX66xvwpaOMMnd8mTZVfePoFeemFb8hfvPLn8td/9lcaJxaronRLjPJvTL9Kx4ZLh+Wqn56QmQcuCFnwHTqJdfjh6iK6SA2m3kOAftX2BPXtSbZ+imkuOxNjJkBL8TRIOwbtStEoNJ6iQcHRs7r6erleW2vBBlqGnx0v3OTQwnZNkTErJoow52TOsYmxMFf4bU801OxHJhKk2PhFtBfL4oCeRbo++GRu9G1arqWrq1uaWlsGXYOjZoC1s94u3QgUKjYmzpTKD/qkEHNa29oH58lGpKR4mSoIRmg0xiSjmHRY4ey0ywfbUe0MH5OkOwM6utqtZGlwm5M1265NFLABRsIM+c5iRoMTlCv8dmhrb5dW9c2AexwokdE5UJVC/EBrWQdUs1ezR7QT+K3gVnOTxpgWM3HTRuXoLrV38GJUUELaR6+6GwYgX0BJ8fsOwUjlgQnqi9CekNEmlHlIuMQQZyIcFcbGxtiONTQ22v18jcCZqhVuNycC5+Ppn3GxhuraGtvMT83Dp13AaT+aC6PBJXnJj2qPWpODVrFijEgDL6duCABTj9ZY4Y0xNE6XBtKu7k5rQ9CKt6A1XHMdOns6pbNX6+o62LDExERN04ceZ6m7COpOx6svi5WBPgTEkWDIZzK60yo0IjYBAQ3o6Gw3v4WppiQlDz42nyhYJJsV0vGgMRcuV8ovoVVQG10cDMYJ2a9dfkHDKHjmRkCjPxaID0TwaBefrKdLFYLjzV5chwqVEz8YgHpq7StkfQGefHR399p6kQVmDntw/bk+QahX56EywyWhfFzlvkOQqDhj2gwj2X06YcflcP58pugk8LPwYYRIsDO/1N6hXHequoSJa62rT1SfnztfJ6s0S68TnTmI//5PfiA/feO/LO321jGi/wEW4C0CxoH2siijQipg/2ajBG/++hdyqKRIr0dZ8OTAKWderten9uVPcEhIbmmqz2ahSLyTcezj43L4eIl8eKTICkeqxceKpfzCObOaQaH7BAsiXnvttb9DWJhj/Y16c/iMmT5zpi0eDa68VGlHkVmzZkueEnAWdPzUSaVl6bJujXeOO1Gw+0wef1/XoMGxTimdai8+k0lW11yT8zou/hM65dcI2nraE5DSsrODCQR18L/nKs/JCZ1fUUmxvawC1QNobpJa2roH1smC/Pvsmh/0WVZRJud4GKD+GZA1nlZ+TIp/qvSUfp4yvnymrNTcGNPArgikC/ILJGduzqAi2IynTZ2mScBMejcNQthNzc2WQiKAZJ2QUTPVXmIdTxG6NZMaWuTE4bR33ux58swTT8vq5ats8URqAhxCrqurl5+9+T/y9p5daq4dnxqP1BoXQVDm0An3wqacOnNazpSWyuWrly3BIakAOfPmyfM7nx18FOXmAFzf8GA7Z1ElQ2hYFZ9B1W6CHEER67b3MjQ5Ya6cKJLNkWr7YcJlx3HwiepT8U99OulGNQ8EjOakJqfqIKL0pdmoEx0SNJK0/heBW1xmRqZ8/asvyjeVl85V5sECQ70hC6AEqZKjJXLyk4/CrYaAlrIZzB+FsIRHA1KPtgcELJSC1HfLxs3y6ndetcMkxsTlgWGbpb43GORswHN9HK8WzJ8vmzdsMu688aENslFT4Uc2bpG1q9aqzMJPRbQYSxkR+AZtLTMjy8ycZ1n4Js5lbzXfssEt4BHINFPjkJxd4kjSDs7DAvq8YJEUtGHxwvvl5d952XJ5IjCazFjQLRIOtNcPm48GoAjVKqjQrPRZ8vtf/5Z870+/J8uXLjOXxnXSdqgem3C7+ba0tmnhhRQNUGqlyUlJpuXbtz4lO9W6nnnqGSvbtz2lgl6v1q7yUjrm0bBY9fdjCJdnWvNz8k3dGZxggp/le1amknsNXK2treYqCIJwOg+4ErjnEE2aCJzmoCkIGRe0Y9t22bppqwm8TxfZr303tTSrJbVYXQeC1a2mm8onCUpiqTlzna1l5RJS35kqYOWz2sfRk0elRIOSM38nZD/zMK3XABWpm4DFIGSERj2nBBR+12l8orBhXMPyyV79GIoSitlqkkRSUlqoSF19nQa6aslIy5D0tFm2mJsaSQlCyUpRiM7QFRlgwuOjY25xrji470wcIGTegzCN0749SjYcsAQ4d0DHh5PirlzanpudJ3nZ+aa1WBgazqE+SQJjIRSDjy1grZaQ6C0sh8MbqOJo4OEClJR69IULg076YSO4XWTH8/PyjAfCMTmjvXDpolXk5ImBmnRy8N2p6odJPOiYybodHQ/ceG6RfiE79KrGoXVsHoGK0yfSS0B9Cj4WN6Y/rB9omLMoFpqTnSMZapHUY348hD1TdtruO7i5ANbGa1W4Ge3RYhBlNJByc2JIWzaU1HykAgz7xcTy5nEgnWE7Tgecl7LbBbkFdu/y1Ssq9GvmZzBl4BZ7O7hFEDBLjh+2l0XOVpy181vaIhwnaF4mKT1XaufIukrj4LxQTfblB+MjfNcO/0xscGMtyCuQpYsWW0AjSCE4aBYuzxAgM/R8Me1tTboJaCMZH5krQvODepSmFk2TNcDTFgvGyoZcpYdB4boJ8Th9vqa0pHP4uhp1C1XXqlRzZ8jC+xZqdG4zbZ7G6VhUjAmedobwMeBYYFJkRbxsd+rsafmX138s//CDf5Qfvv4jeeOtn8v//uoN+f6//lB+/B8/sSccugzp7urWsdPMXfkBebf3IHRoZzX0z1TcdPDZ2co7Pe3tNi58peqqcVTq8hjIf5iPhTjf77JGNms0QNVIVhgXioarpE8/hutxGMuXLNOywvxdrfpdNIxdyp6brdlaqtQq4V84/z7lpitNKxyGHQOORFjwTCZdWQmHPbqdRvcuXLwghw4flGLNonh8j8Vgll1KqRDMFqVCPD3wCw6TJMASeABUKH7YgY2nLDk65+X3L5N4pUmM16l+et+hfVJ05ENtqy4lDDaLVNrijW4KhTR6NBD4unqwOC/hMrrnO8d1GCZcNyESiiWF98uMGWk2eR7lVFw4rxx0jgp1gZltxcXzxoETfPSDtmPBL3hy9Tmz5qhvC5qfI5WG0vAcjCBF4Az19ciqZSvkhZ3PD77d2D9A5McP66Yoe+BM+Xp9rW02mskiR54VIKSFBQs1WZkrNxobrB0bePBwkVy8ctn6oiDYGs1SyVRrtN/W1hbVziFW4QcpcnVNtT3t5sVEjk7ByLqDbzl6JuXd4DsPCPfqDu/Zv9t2apVmUDuU7+GL39v3vvqYRHl8yzabvL/DzwJ9O/NBW6prr6mQalQ4nhZFR0faQ8isjNlqxp6/o3//GLTnhAvfSR8AfzctdZp9jqxLOa/KUFpeao+jFhYsGjxGdHVxg2xqm6b2lp1pIUkgoI01NgyEujCFqamp6kLihtetr68fwH/64SbEoQVPfTmoIFpv27zNspRjHx2TMxpw1qxYrfn0AuvQdUq78cCNcTvQJ/4PUNc/xljt/XNxGLuuV59bt7uv//cuKCYyrga74W6XCi5AsHOrV662M9umpmY5dvKY+V/eWUhNTpGK8xUW/V27iYAxXPBwxf8aE4U+3ULcd/9vf1t/m5FwdRkPNzc0rsc2xu6LjR3e32h9uf5GIugem7hJuwXQCSVXo+1zTz9rwYt3c9/b+7793cKm9ZskKiZafddBbeW91OH6GA/cOH6MFRBHzml8oL4nDD/84/q/TxSuret/tH5Mc/2V/HA7SIa2cd1XZLEGubPlZbK/6IDVX7poiWrbgJQpdwTjnShtRxtvJEbWc/2P1tZfl09PK71TM3ed9uOd43hAX05+oyHQ3Nw8wIPH28FNiui8a88u+eT0KVm76gF760Znbsd6U5UBTDS4fdkRaGhoGEjVSHc7OOECIioH0AeLD9qrS888udNOhzxtGfI7/Hbt/JpzLyFw8+bNAZ4n3Q4Ih4IJUKBmxcog3t79jrqMdDuGG/mKKLjXhDkSgbq6uoHp06cP07CxwH3qIWDAu1K/evctJfG1ynm3ysNrH/Ie+oU3A+DzCLjjPTX7MiHQ3t4+QF78WYIdCYRM4cjvyIkj9iIdz7r4wxP/3/eixW5TKPcSAm1tbSZcFv55BQzIWD44uNee3q5Rbvzg6gcHT7Hod6J9fxkQaGpqGuBZ/+eHJ2CnlJerLkvRkWJ7arCwYIEsXbzEEo57UcCDPvc3CXJvUueauut2mM2hCf/+wr0G09zPYguT+HyY/Bfx7iBGPSyfxG8Gk8K9YxD5f/KQNPuJqPiyAAAAAElFTkSuQmCC'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objForm.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	$objListbox = New-Object System.Windows.Forms.Listbox
	$objListbox.Location = New-Object System.Drawing.Size(20,20)
	$objListbox.Size = New-Object System.Drawing.Size(1150,20)
	$objListbox.Font = "Courier New,10"
	$objListbox.Visible = $true
	$objListbox.HorizontalScrollbar = $true
    Foreach ($X in $Eventliste) {
    #TimeCreated,LevelDisplayName
                $objListbox.Items.add($X.TimeCreated.toString() +" | "  + $X.LevelDisplayName.PadRight(16, " ") +" | "+ $X.Message.Replace("----------------",""))
    }		

	#$objListbox.SelectionMode = "MultiExtended"
	$objListbox.SelectionMode = "One"
    $objListbox.add_SelectedIndexChanged({
        $objTextBoxMessage.Text = $Eventliste[$objListbox.SelectedIndex].Message
        #$XX=$objListbox.SelectedIndex
    })
    $objListbox.Height = 400
	$objForm.Controls.Add($objListbox)

	$objTextBoxMessage = New-Object System.Windows.Forms.TextBox
	$objTextBoxMessage.Location = New-Object System.Drawing.Size(20,440)
	$objTextBoxMessage.Size = New-Object System.Drawing.Size(1150,500)
	$objTextBoxMessage.Multiline = "True"
    $objTextBoxMessage.ScrollBars = 3
	$objTextBoxMessage.AcceptsReturn = "True"
	$objTextBoxMessage.WordWrap = $false
	$objTextBoxMessage.Text = $Eventliste[0].Message
	$objForm.Controls.Add($objTextBoxMessage)
	

	
   	$OKButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$OKButton.Location = New-Object System.Drawing.Size(20,20)
	$OKButton.Size = New-Object System.Drawing.Size(75,23)
	$OKButton.Text = "Aktualisieren"
	$OKButton.Name = "Aktualisieren"
	$OKButton.DialogResult = "OK"
	$OKButton.Visible = $false
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$OKButton.Add_Click({
        $objListbox.Items.Clear()
        $Eventliste = Get-WinEvent -Computername $Server -FilterHashtable @{logname="application";StartTime="24.03.2020";ProviderName="WSH";}| where Message -like "*$User*"|select TimeCreated,LevelDisplayName,Message
        Foreach ($X in $Eventliste) {
                #TimeCreated,LevelDisplayName
                $objListbox.Items.add($X.TimeCreated.toString() +" | "  + $X.LevelDisplayName.PadRight(16, " ") +" | "+ ($X.Message).Replace("----------------",""))
                }		
		})
    $objForm.Controls.Add($OKButton)

	
	$ok = $true 
	While ( $ok)
	{
        [Void] $objForm.ShowDialog()
	    if ($objForm.DialogResult -ne "OK"){$ok = $false}
    
    }


}

Function ADInfo($DOM, $User )
{
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objForm =  New-Object System.Windows.Forms.Form
	$objForm.StartPosition = "CenterScreen"
#	$objForm.Size = New-Object System.Drawing.Size(1200,500)
	$objForm.Size = New-Object System.Drawing.Size(1200,1000)
	$objForm.Text = "AD-Info " + $DOM + "\" + $User
$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objForm.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

    If ($PSScriptRoot){
        $csv  = Import-Csv "$PSScriptRoot\ADFelder.csv" -Encoding utf8 -Delimiter ";" 
    }Else{
        #Fuer EXE
        $csv = Import-Csv  "$MyScriptRoot\ADFelder.csv" -Encoding utf8 -Delimiter ";" 
    } 
   
    $X = Get-ADUser $User -server $DOM -Properties * |select *
    $Y=""
    Foreach($Zeile in $csv){
        if ($Zeile.adFeld){
			if (($X.($Zeile.adFeld)).count -gt 1){
				foreach($XX in ($X.($Zeile.adFeld))){$Y = $Y + $XX + $nL}
			}else{
                $Y = $Y + $Zeile.Anzeige + $X.($Zeile.adFeld) + $nL
            }
        }Else{
            $Y = $Y + $nL
        }
    }
	
	$objTextBoxMessage = New-Object System.Windows.Forms.TextBox
	$objTextBoxMessage.Location = New-Object System.Drawing.Size(20,20)
	$objTextBoxMessage.Size = New-Object System.Drawing.Size(1150,900)
	$objTextBoxMessage.Multiline = "True"
    $objTextBoxMessage.ScrollBars = 3
	$objTextBoxMessage.AcceptsReturn = "True"
	$objTextBoxMessage.WordWrap = $false
	$objTextBoxMessage.Text =  $Y
	$objForm.Controls.Add($objTextBoxMessage)
	
	$ok = $true 
	While ( $ok)
	{
        [Void] $objForm.ShowDialog()
	    if ($objForm.DialogResult -ne "OK"){$ok = $false}
    
    }



}

Benutzerauswahl 