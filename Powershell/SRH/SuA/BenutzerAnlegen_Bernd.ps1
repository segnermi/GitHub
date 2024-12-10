# .\ps2exe.ps1 -inputFile ".\Benutzeranlegen2.0.3.2.ps1" -outputFile "Benutzeranlegen2.0.3.2.exe" -noConsole -sta
# für hideConsole .\ps2exe.ps1 -inputFile ".\Benutzeranlegen2.0.2.1.ps1" -outputFile "Benutzeranlegen2.0.2.1.exe"  -sta
Param( [String]$Konfigdatei = "" ,
	[String]$Fehlermailadresse = "sua.its@srh.de",
	[String]$InfoMailAdresse = "",
	[String]$TicketID = "",
	[String]$Vorname,
	[String]$Name,
	[String]$Firma,
	[String]$Konfiguration,
	[String]$Personalnummer,
	[String]$Endedatum,
	[String]$ExterneMail,
	[String]$Eingabeliste,
	[String]$Ausgabeliste,
	[String]$DoppelterNameAnlegen
	)
$Error.Clear()
#Falls Parameter mit "Variable=Wert" angegeben werden (dann funktioniert das auch mit der EXE)
$Parameterliste = @($Konfigdatei,$Fehlermailadresse,$InfoMailAdresse,$TicketID,$Vorname,$Name,$Firma,$Konfiguration,$Personalnummer,$Endedatum,$ExterneMail,$Eingabeliste,$Ausgabeliste,$DoppelterNameAnlegen)
$P,$Wert=$Parameterliste[0].Split("=") 
If($Wert){
	$Konfigdatei =""
    $Fehlermailadresse = "sua.its@srh.de"
	$InfoMailAdresse = ""
	$TicketID = ""
	$Vorname = ""
	$Name = ""
	$Firma = ""
	$Konfiguration = ""
	$Personalnummer = ""
	$Endedatum = ""
	$ExterneMail = ""
	$Eingabeliste = ""
	$Ausgabeliste = ""
	$DoppelterNameAnlegen = ""
}
foreach ($Z in $Parameterliste){ 
    $P=""
    $Wert=""
    $P,$Wert = $Z.split("=")
	$P = $P.ToLower()
    If ($Wert){
        switch ($P)
            {
            "konfigdatei" {$Konfigdatei= $Wert; Break}
            "fehlermailadresse" {$Fehlermailadresse= $Wert; Break}
            "infomailadresse" {$InfoMailAdresse= $Wert ; Break}
            "ticketid" {$TicketID= $Wert ; Break}
            "vorname" {$Vorname= $Wert; Break}
            "name" {$Name= $Wert ; Break}
            "firma" {$Firma= $Wert ; Break}
            "konfiguration" {$Konfiguration= $Wert; Break}
            "personalnummer" {$Personalnummer= $Wert ; Break}
            "endedatum" {$Endedatum= $Wert ; Break}
            "externemail" {$ExterneMail= $Wert; Break}
            "eingabeliste" {$Eingabeliste= $Wert ; Break}
            "ausgabeliste" {$Ausgabeliste= $Wert ; Break}
            "doppelternameanlegen" {$DoppelterNameAnlegen= $Wert; Break}
            }
    }
}

#Global da für Variablenersetzen so benötigt wird.
#Wie Name Vorname etc. später in den Parametern in der Benutzerkonfigurationfile als Variable verwendet wird
$sSamid = ""

If ($PSScriptRoot){$Script:Path =$PSScriptRoot}ELSE{$Script:Path = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])}
if ($Konfigdatei -eq""){$Konfigdatei =$Script:Path + "\DialogConfig.csv"}
	   
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.DirectoryEntry")
$nL = [Environment]::NewLine
# ----------------------------------------------------------------------------------------------------------------------
# 	Globals: Script Information
# ----------------------------------------------------------------------------------------------------------------------
$Script:AppName		= "BenutzerAnlegen"
$Script:AppVersion	= "2.0.3.2"
$Script:AppAuthor	= "Bernd Buchert"
$Script:Company		= "SRH IT-Solutions GmbH"
$Script:ReleaseDate = "13.04.2021"
# ----------------------------------------------------------------------------------------------------------------------
# 	Globals
# ----------------------------------------------------------------------------------------------------------------------
If ($PSScriptRoot){$Script:Path =$PSScriptRoot}ELSE{$Script:Path = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])}
$Script:PSADModule = "ActiveDirectory"
#$Script:Wartung= $Script:Path + "\Wartung.TXT"
$Script:ExportFileDate = (Get-Date).ToShortDateString()
$Script:ExportFilePath = $ENV:UserProfile
$Script:ExportFileNameXLS = $ExportFilePath + "\ADGroups_And_Members_" + $ExportFileDate + ".xls"
$Script:ReqExcelVersion = 14.0
$Script:manuellerAblauf = $True
$Script:AdminAblauf = $false
$Script:Email = ""
$Script:FehlernachAnlegen = $FALSE
#nur zu Testzwecken
#$Script:FehlernachAnlegen = $TRUE
# ----------------------------------------------------------------------------------------------------------------------
if ($Konfigdatei -eq""){$Konfigdatei =$Script:Path + "\DialogConfig.csv"}
#-------------------------------------------------

<#
# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console
#>

#-------------------------------------------------
function Main()
{
	if ($Konfigdatei) {$Konfigdatei = $Konfigdatei.Trim()}
	if ($Fehlermailadresse) {$Fehlermailadresse = $Fehlermailadresse.Trim()}
	if ($InfoMailAdresse) {$InfoMailAdresse = $InfoMailAdresse.Trim()}
	if ($TicketID) {$TicketID = $TicketID.Trim()}
	if ($Vorname) {$Vorname = $Vorname.Trim()}
	if ($Name) {$Name = $Name.Trim()}
	if ($Firma) {$Firma = $Firma.Trim()}
	if ($Konfiguration) {$Konfiguration = $Konfiguration.Trim()}
	if ($Personalnummer) {$Personalnummer = $Personalnummer.Trim()}
	if ($Endedatum) {$Endedatum = $Endedatum.Trim()}
	if ($ExterneMail) {$ExterneMail = $ExterneMail.Trim()}
	if ($Ausgabeliste) {
		$Ausgabeliste = $Ausgabeliste.Trim()
	 	If (!(Test-Path $Ausgabeliste)) {"Name;Vorname;Firma;Konfiguration;Domain;SAMID;PWD;Mail;Fehler" | set-content $Ausgabeliste}
		}
	if ($DoppelterNameAnlegen) {$DoppelterNameAnlegen = ($DoppelterNameAnlegen.Trim()).ToUpper()}
	
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Firmenliste = $csv | select-object Firma | sort firma -Unique  

	$Script:Ausgabezeile = ""
	#Automatischer Ablauf wenn Name Firma und Konfiguration als Parameter angegeben sind
	#sonst Dialogfenster
	$Script:manuellerAblauf = (-not (($Name)-and (($firma) -and ($Konfiguration))))

	If ($Script:manuellerAblauf){

	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objForm =  New-Object System.Windows.Forms.Form
	$objForm.StartPosition = "CenterScreen"
#	$objForm.Size = New-Object System.Drawing.Size(800,500)
	$objForm.Size = New-Object System.Drawing.Size(800,700)
	$objForm.Text = "SRH Benutzer anlegen"
	
$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objForm.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())
	



	$objlabelName = New-Object System.Windows.Forms.Label
	$objlabelName.Location = New-Object System.Drawing.Size(20,20)
	$objlabelName.Size = New-Object System.Drawing.Size(100,20)
	$objlabelName.Text = "Name:"
	$objForm.Controls.Add($objlabelName)

	$objTextBoxName = New-Object System.Windows.Forms.TextBox
	$objTextBoxName.Location = New-Object System.Drawing.Size(120,20)
	$objTextBoxName.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxName.Text = $Name
	#$objTextBoxName_TextChanged = {
#	$objlabelFirma.Visible = $objTextBoxName.Text -ne ''
#	$objComboboxFirma.Visible = $objTextBoxName.Text -ne ''
#	}
	$objForm.Controls.Add($objTextBoxName)

	$objlabelVorname = New-Object System.Windows.Forms.Label
	$objlabelVorname.Location = New-Object System.Drawing.Size(20,50)
	$objlabelVorname.Size = New-Object System.Drawing.Size(100,20)
	$objlabelVorname.Text = "Vorname:"
	$objForm.Controls.Add($objlabelVorname)


	$objTextBoxVorname = New-Object System.Windows.Forms.TextBox
	$objTextBoxVorname.Location = New-Object System.Drawing.Size(120,50)
	$objTextBoxVorname.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxVorname.Text = $Vorname
	$objForm.Controls.Add($objTextBoxVorname)



	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,80)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objForm.Controls.Add($objlabelFirma)

	$objComboboxFirma = New-Object System.Windows.Forms.Combobox
	$objComboboxFirma.Location = New-Object System.Drawing.Size(120,80)
	$objComboboxFirma.Size = New-Object System.Drawing.Size(260,20)
	#$objComboboxFirma.Visible = $false
	$objComboboxFirma.Text = $Firma
	foreach($f in $Firmenliste)
		{
		[void] $objComboboxFirma.Items.Add($f.firma)
		}
	$objComboboxFirma.Height = 200
	$objComboboxFirma.DropDownStyle = 2
	$objComboboxFirma.Add_SelectedIndexChanged(
		{
		$objComboboxKonfiguration.Visible = $true
		$objDataGridView.Visible = $true
		$objlabelKonfiguration.Visible = $true
		$OKButton.Visible = $true
        $CSVButton.Visible = $Script:AdminAblauf
		[void] $objComboboxKonfiguration.Items.Clear()
		$Konfigurationliste = $csv | ? Firma -eq $objComboboxFirma.selecteditem.ToString()  | select-object Konfiguration | sort Konfiguration -Unique  
		#$objlabelFirma.Text = $objComboboxFirma.selecteditem.ToString()
		foreach($C in $Konfigurationliste)
			{
			[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
			}
		$objComboboxKonfiguration.SelectedIndex=0
		})
	$objForm.Controls.Add($objComboboxFirma)

	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,110)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objlabelKonfiguration.Visible = $false
	$objForm.Controls.Add($objlabelKonfiguration)

	$objComboboxKonfiguration = New-Object System.Windows.Forms.Combobox
	$objComboboxKonfiguration.Location = New-Object System.Drawing.Size(120,110)
	$objComboboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objComboboxKonfiguration.Height = 200
	$objComboboxKonfiguration.DropDownStyle = 2
	$objComboboxKonfiguration.Visible = $false
	$objForm.Controls.Add($objComboboxKonfiguration)
	$objComboboxKonfiguration.Add_SelectedIndexChanged(
		{
		[void] $objDataGridView.Rows.Clear()
		$Liste = $csv | ? Firma -eq $objComboboxFirma.selecteditem.ToString() | ? Konfiguration -eq $objComboboxKonfiguration.selecteditem.ToString() | select-object Parameter,Wert  

		# Ausgewählte Konfiguration zur Ansicht ordnen ahnhand ConfigSchema.csv
		$KonfigSchemadatei = $Script:Path + ".\ConfigSchema.csv"
		$CSVFelder=Import-Csv $KonfigSchemadatei -Encoding Default -Delimiter ";"

		#xliste ergänzen mit INfos aus csvFelder und Sortieren nach Ordnung
		[array]$Result=@()
		$CSVFelder|ForEach-object{
			If ($_.Ordnung  -match '^[0-9]+$'){
				foreach($X in  $Liste){
					If($X.Parameter -eq $_.Name){
						$result+=New-Object PSObject -Property @{Parameter=$X.Parameter.trim();Wert=$X.Wert.trim();Ordnung=[INT]$_.Ordnung;Pflicht=$_.Pflicht;Multi=$_.Multi;MaxZeichen=$_.MaxZeichen;Hilfe=$_.Hilfe}
					}
				}
			}
		} 
		$Liste =$result | Sort -Property Ordnung,Wert
		$UserDom=""
		foreach($Z in $Liste){If ($Z.Parameter -eq "DOMAIN" ){$UserDom=$Z.Wert}}
		foreach($Z in $Liste)
			{
			$Row=$objDataGridView.Rows.Add($Z.Parameter,$Z.Wert)
			If ($Z.Pflicht -eq 1 -and $Z.Wert -eq "")
				{
				$objDataGridView.Rows[$Row].Cells[1].Style.BackColor="LightPink"
				}
			If ($Z.Parameter -eq "OU" )
				{
				if ((pruefe_OU($Z.Wert)) -eq 0)
					{
					$objDataGridView.Rows[$Row].Cells[1].Style.BackColor="LightPink"
					}
				}
			If (($Z.Parameter -eq "GROUPS" ) -and $UserDom)
				{
				if ((pruefe_Gruppe $Z.Wert $UserDom) -eq "")
					{
					$objDataGridView.Rows[$Row].Cells[1].Style.BackColor="LightPink"
					}
				}
 			}
		$objDataGridView.AutoResizeColumns()
        $objForm.Show()
		})

	$objlabelPersonalnummer = New-Object System.Windows.Forms.Label
	$objlabelPersonalnummer.Location = New-Object System.Drawing.Size(400,20)
	$objlabelPersonalnummer.Size = New-Object System.Drawing.Size(100,20)
	$objlabelPersonalnummer.Text = "Personalnummer:"
	$objForm.Controls.Add($objlabelPersonalnummer)

	$objTextBoxPersonalnummer = New-Object System.Windows.Forms.TextBox
	$objTextBoxPersonalnummer.Location = New-Object System.Drawing.Size(550,20)
	$objTextBoxPersonalnummer.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxPersonalnummer.Text = $Personalnummer
	$objForm.Controls.Add($objTextBoxPersonalnummer)

	#Datum des Austritts (dd.mm.yyyy, leer wenn unbegrenzt gültig):
	$objlabelEndedatum = New-Object System.Windows.Forms.Label
	$objlabelEndedatum.Location = New-Object System.Drawing.Size(400,50)
	$objlabelEndedatum.Size = New-Object System.Drawing.Size(120,20)
	$objlabelEndedatum.Text = "Datum des Austritts:"
	$objForm.Controls.Add($objlabelEndedatum)

	$objTextBoxEndedatum = New-Object System.Windows.Forms.TextBox
	$objTextBoxEndedatum.Location = New-Object System.Drawing.Size(550,50)
	$objTextBoxEndedatum.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxEndedatum.Text = $Endedatum
	$objForm.Controls.Add($objTextBoxEndedatum)

	#Datum des Austritts (dd.mm.yyyy, leer wenn unbegrenzt gültig):
	$objlabelExtAdr = New-Object System.Windows.Forms.Label
	$objlabelExtAdr.Location = New-Object System.Drawing.Size(400,80)
	$objlabelExtAdr.Size = New-Object System.Drawing.Size(120,40)
	$objlabelExtAdr.Text = "Externe Mail (im Adressbuch, kein Postfach):"
	$objForm.Controls.Add($objlabelExtAdr)

	$objTextBoxExtAdr = New-Object System.Windows.Forms.TextBox
	$objTextBoxExtAdr.Location = New-Object System.Drawing.Size(550,80)
	$objTextBoxExtAdr.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxExtAdr.Text = $ExterneMail
	$objForm.Controls.Add($objTextBoxExtAdr)

	$objDataGridView = New-Object System.Windows.Forms.DataGridView
	$objDataGridView.Location = New-Object System.Drawing.Size(20,150)
	$objDataGridView.Size = New-Object System.Drawing.Size(730,450)
	$objDataGridView.Visible = $false
	$objDataGridView.ColumnCount = 2
	$objDataGridView.ColumnHeadersVisible = $true
    $objDataGridView.RowHeadersVisible = $false
    $objDataGridView.ClipboardCopyMode = "EnableWithoutHeaderText"
    $objDataGridView.AutoSize = $false
    $objDataGridView.AllowUserToAddRows=$false
    $objDataGridView.AllowUserToOrderColumns=$false
    $objDataGridView.AllowUserToResizeColumns =$false
    #$objDataGridView.AllowSorting = $false
    $objDataGridView.ReadOnly = $true
	$objDataGridView.Columns[0].Name = "Parameter"
    $objDataGridView.Columns[0].ReadOnly = $true
	$objDataGridView.Columns[1].Name = "Wert"
    $objDataGridView.Columns[1].ReadOnly = $true
    #$objDataGridView.ContextMenuStrip = $objContextMenuStripA
	$objForm.Controls.Add($objDataGridView)
	
	$objListbox = New-Object System.Windows.Forms.Listbox
	$objListbox.Location = New-Object System.Drawing.Size(20,150)
	$objListbox.Size = New-Object System.Drawing.Size(730,20)
	$objListbox.Visible = $false
	$objListbox.SelectionMode = "MultiExtended"

#	$objListbox.Height = 250
	$objListbox.Height = 450
	#$objForm.Controls.Add($objListbox)

	$CancelButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
#	$CancelButton.Location = New-Object System.Drawing.Size(600,420)
	$CancelButton.Location = New-Object System.Drawing.Size(600,620)
	$CancelButton.Size = New-Object System.Drawing.Size(75,23)
	$CancelButton.Text = "Beenden"
	$CancelButton.Name = "Beenden"
	$CancelButton.DialogResult = "Cancel"
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	#$CancelButton.Add_Click({$objForm.Close()})
	$objForm.Controls.Add($CancelButton)

	$OKButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
#	$OKButton.Location = New-Object System.Drawing.Size(100,420)
	$OKButton.Location = New-Object System.Drawing.Size(100,620)
	$OKButton.Size = New-Object System.Drawing.Size(75,23)
	$OKButton.Text = "Starten"
	$OKButton.Name = "Starten"
	$OKButton.DialogResult = "OK"
	$OKButton.Visible = $false
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$OKButton.Add_Click({
        $OKButton.Visible = $false
        $CancelButton.Visible = $false
		$Name = $objTextBoxName.Text.Trim()
		$Vorname = $objTextBoxVorname.Text.Trim()
		$Personalnummer = $objTextBoxPersonalnummer.Text.Trim()
		$Endedatum = $objTextBoxEndedatum.Text.Trim()
		$ExterneMail = $objTextBoxExtAdr.Text.Trim()
		$Firma= $objComboboxFirma.selecteditem.ToString()
		$Konfiguration = $objComboboxKonfiguration.selecteditem.ToString()
		$rBenutzerpruefen = Benutzerpruefen $Name $Vorname $Personalnummer
		if ($rBenutzerpruefen[0]) {
				Benutzeranlegen $Name $Vorname $Personalnummer $Endedatum  $Firma  $Konfiguration $ExterneMail $rBenutzerpruefen
			}Else{
				$Script:Ausgabezeile = "$Name;$Vorname;$Firma;$Konfiguration;;;;;Nicht angelegt wegen doppeltem Namen"
				If ($Ausgabeliste){$Script:Ausgabezeile| Add-content $Ausgabeliste}
			}
		})
	$objForm.Controls.Add($OKButton)

	$CSVButton = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
	$CSVButton.Location = New-Object System.Drawing.Size(200,620)
	$CSVButton.Size = New-Object System.Drawing.Size(120,23)
	$CSVButton.Text = "CSV bearbeiten"
	$CSVButton.Name = "CSV bearbeiten"
	$CSVButton.DialogResult = "Retry"
	$CSVButton.Visible = $false
	#Die folgende Zeile ordnet dem Click-Event die Schließen-Funktion für das Formular zu
	$CSVButton.Add_Click({
		$objForm.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
		$Firma= $objComboboxFirma.selecteditem.ToString()
		$Konfiguration = $objComboboxKonfiguration.selecteditem.ToString()
		$Firma,$Konfiguration = CSV_bearbeiten $Firma  $Konfiguration 
		$objForm.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})
	$objForm.Controls.Add($CSVButton)


	$DialogOK = $true
	While ( $DialogOK)
	{
	
    	$objForm.Visible=$false    
    	[Void] $objForm.ShowDialog()
		if ($objForm.DialogResult -eq "Retry"){
			$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
			$Firmenliste = $csv | select-object Firma | sort firma -Unique  
			$objComboboxFirma.Items.Clear()
			foreach($f in $Firmenliste)
			{
				[void] $objComboboxFirma.Items.Add($f.firma)
			}
			$objComboboxFirma.SelectedIndex=0
    		$objDataGridView.AutoResizeColumns()
            $objForm.Show()
		}Else{If ($objForm.DialogResult -eq "OK")
			{
				$objTextBoxName.Text = ""
				$objTextBoxVorname.Text = ""
				$objTextBoxPersonalnummer.Text = ""
				$objTextBoxEndedatum.Text = ""
				$objTextBoxExtAdr.Text = ""
				$OKButton.Visible = $true
				$CancelButton.Visible = $true

			}ELSE{
				$DialogOK = $false
			}
		}
	}

	[Void] $objForm.Close()
	[Void] $objForm.Dispose()



	}Else{
		If (($csv | ? Firma -eq $Firma | ? Konfiguration -eq $Konfiguration | select-object Parameter,Wert).Count -gt 0){

			$rBenutzerpruefen = Benutzerpruefen $Name $Vorname $Personalnummer
			if ($rBenutzerpruefen[0]) {
				Benutzeranlegen $Name $Vorname $Personalnummer $Endedatum  $Firma  $Konfiguration $ExterneMail $rBenutzerpruefen $InfoMailAdresse $TicketID
			}Else{
				$Script:Ausgabezeile = "$Name;$Vorname;$Firma;$Konfiguration;;;;;Nicht angelegt wegen doppeltem Namen"
				If ($Ausgabeliste){$Script:Ausgabezeile| Add-content $Ausgabeliste}
			}
		}ELSE{
			$Script:Ausgabezeile = "$Name;$Vorname;$Firma;$Konfiguration;;;;;Konfiguration nicht bekannt"
			If ($Ausgabeliste){$Script:Ausgabezeile| Add-content $Ausgabeliste}
		}
	}
}
function pruefe_OU($OU)
{
	$E=0
	$Dom = Finde_Domain $OU
	$error.Clear()
	Try{$O = Get-ADOrganizationalUnit $OU -server $Dom}
	catch{$ERR= $error[0].Exception}
	if ($Error){$E=0}Else{$E=1}
	$E
}
function pruefe_Gruppe($G,$domUser)
{
	$E=0
	If ($G.contains("CN=")){
		$Dom = Finde_Domain $G
	}else{
		If ($G.contains("\")){
			$D = ($G.split("\"))[0]
			$G = ($G.split("\"))[1]
			$Dom = $D
			try{$Dom = (Get-ADDomain $D).DNSRoot}
			catch{$ERR= $error[0].Exception}
			if ($Error){$Dom = $D}
		}else{
			$Dom = $domUser
		}
	}
	$error.Clear()
	Try{$O = get-adgroup "$G" -server $Dom}
	catch{$ERR= $error[0].Exception}
	if ($Error){$E=""}Else{if ($domUser -like $Dom){$E=$O.SamaccountName}ELSE{
		$D=(Get-ADDomain $Dom).NetBIOSName
		$E=$D + "\" + $O.SamaccountName}}
	$E
}
function Finde_Domain($OU)
{
 	#Domain (Domain) bestimmen
	$Domain = ""
    If ($OU -like "*DC=*"){
	    $OU -split(',dc=') | %{if( -not($_ -like "??=*")){$Domain=$Domain+"."+$_}}
	    $Domain = $Domain.Substring(1)
    }
    $Domain
}
function Finde_DC($DOM)
{
 	#Domain (Domain) bestimmen
	$DC = ""
	if($DOM -like "*EDU*")
		{
		    $DC ="svhd-dc35"
		}else{
            if($DOM -like "*KLINIKEN*"){$DC ="svhd-dc21"}else{$DC ="svhd-dc06"}
 		}
	$DC

}
Function CSV_Neue_Firma ()
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Neue Firma anlegen"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Add_TextChanged({
		$OKButtonneu.Visible = ($objTextboxFirma.text -ne "")
		})
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.Text = "Standard Mitarbeiter"
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)


	#Beschreibung eingeben
	$objlabelInfo = New-Object System.Windows.Forms.Label
	$objlabelInfo.Location = New-Object System.Drawing.Size(20,80)
	$objlabelInfo.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelInfo.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelInfo)
	
	$objTextboxInfo = New-Object System.Windows.Forms.Textbox
	$objTextboxInfo.Location = New-Object System.Drawing.Size(120,80)
	$objTextboxInfo.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxInfo.Text = "Standardkonfiguration"
	$objFormcsvneu.Controls.Add($objTextboxInfo)

	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Firma anlegen"
	$OKButtonneu.Name = "Firma anlegen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			If ($KonfNeu -eq ""){$KonfNeu = "Standard Mitarbeiter"}
			#Prüfen, ob Firma neu
			$X=$csv | ? Firma -eq $FirmaNeu
			if ($X.count -eq 0){
				#Anfügen einer Zeile in CSV
				$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
				copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung

				$Protokoll =  $Script:AppName
				$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
				$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
				$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
				$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
				$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
				$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
				$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
				$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Neue Firma:"
				$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
				$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "-------NEU---------"
				$csvneu = $csv | Where-Object{($_.Firma -ne $FirmaNeu) } #| select-object Firma,Konfiguration,Parameter,Wert  
				$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="INFO";Wert=$objTextboxInfo.Text.trim()  }
				
				$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $FirmaNeu) -and ($_.Konfiguration -eq $KonfNeu)}| Sort -Property Firma,Konfiguration,Parameter,Wert
				foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
				$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

				$utf8 = New-Object System.Text.utf8encoding
#				Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

				$Protokoll | out-file -filepath $LogFile
                $ok = $false
				#CSV_bearbeiten $FirmaNeu $KonfNeu
                $FirmaNeu
			}Else{
				[void][System.Windows.Forms.MessageBox]::Show("Firma existiert schon!","Fehler",0)
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()
}

Function CSV_Neue_Konfiguration ($uFirma)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Neue Konfiguration anlegen"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.Add_TextChanged({
		$OKButtonneu.Visible = ($objTextboxKonfiguration.text -ne "")
		})
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)


	#Beschreibung eingeben
	$objlabelInfo = New-Object System.Windows.Forms.Label
	$objlabelInfo.Location = New-Object System.Drawing.Size(20,80)
	$objlabelInfo.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelInfo.Text = "Beschreibung:"
	$objFormcsvneu.Controls.Add($objlabelInfo)
	
	$objTextboxInfo = New-Object System.Windows.Forms.Textbox
	$objTextboxInfo.Location = New-Object System.Drawing.Size(120,80)
	$objTextboxInfo.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxInfo.Text = ""
	$objFormcsvneu.Controls.Add($objTextboxInfo)

	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Konfiguration anlegen"
	$OKButtonneu.Name = "Konfiguration anlegen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			#Prüfen, ob Konfiguration neu
			$X= $csv | ? Firma -eq $FirmaNeu | ? Konfiguration -eq $KonfNeu
			if ($X.count -eq 0){
				#Anfügen einer Zeile in CSV
				$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
				copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
				[String]$FirmaNeu = $objTextboxFirma.text.Trim()
				[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()

				$Protokoll =  $Script:AppName
				$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
				$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
				$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
				$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
				$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
				$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
				$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
				$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Neue Konfiguration:"
				$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
				$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "-------NEU---------"
				$csvneu = $csv | Where-Object{($_.Firma -ne $FirmaNeu) -or ($_.Konfiguration -ne $KonfNeu)}
				$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="INFO";Wert=$objTextboxInfo.Text.trim()  }
				
				$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $FirmaNeu) -and ($_.Konfiguration -eq $KonfNeu)}| Sort -Property Firma,Konfiguration,Parameter,Wert
				foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
				$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

				$utf8 = New-Object System.Text.utf8encoding
#				Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

				$Protokoll | out-file -filepath $LogFile
                $ok = $false
				#CSV_bearbeiten $FirmaNeu $KonfNeu
                $KonfNeu
			}Else{
				[void][System.Windows.Forms.MessageBox]::Show("Kofiguration existiert schon!","Fehler",0)
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}
Function CSV_Firma_umbenennen ($uFirma)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Firma " + $uFirma + " umbenennen"

$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAAFcAAAA9CAYAAADYp/VQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAhdEVYdENyZWF0aW9uIFRpbWUAMjAxOTowMzoyOSAwODoxNTozOO7qzQ4AABWaSURBVHhe7ZxpcJXndcfPvdoltLEICYlFGzIgzL54YQlgG7yAcRwvTRvHaZJOF7v90Dbth9b91g/tTGeapZO09Uynk6bt2EkTx3gBs1pCrLYBISTEKiQkIYH29Urq+Z33PtIrWcKSHWaC0d/z+N77vs96nrP8z/O+IjCgkEncEQTDn5O4A5gU7h3EpHDvICaFewcxKdw7iEnh3kEE+vv7vxAboy2luaVZys6XSUtbq2SmZ8rMtJmSnJgkMdEx4Zr3Hr6QcAOBgJVbTbdkz4EP5FDJh9LV3SWxMTGSNj1NCvILZPmS5TI3a65ERkRYG7cZ9wImLFxXNxgMmmCvXLsq7+/bLecqzpkAo6OjRfuU3lCvdPd0SygUkoT4BFm0oFA2PLBO5s6ea+39Y7rv9DcaPuv+byvG5XMHpE8X2Bf+NaSxVTXX5N0P3pUzZWckKirKBAuCEUH9HW0uISIiUuJi481FBFX4CIrCBjihsVEReo9PVwIBrwzdQ/PvLuFOQHO9haE8CLa9o112H9gjhw5/KFGRUSrMSK0RkP6Bfunr65POzk4T8NqVa2TjwxtlWupUa387oOk3Gm9Ie3u7CZW+2JRpqdMlUsdgm8c3198OjFu41KGwaEx+X9F+2XtwnwS0aXRMtCdY1UYEpD3K/QsL5ZGNm2VWela4hyH09PZKVXWVnC47LeXny+XilUvS0tIi0ar9ESrEIJYR1F3Uvjt0k3LmzpPndn5NCu8r/PIKF41FuB+d/lh27XlHmjSQYfoIQruRrq4ucw0bHlwv69W/xsfHh1t7wI0cPXHUWEVtXZ0MaJu4uDhrE6H9Yhxsks0n/L1T+5wxfbps27JVFi9YPLjJdwPGFK7zqyNxva5W3t69S86WlZrw/IJNUhPeuuUxWbN8dbi2h/LKCg1678vFy5dMMCZM9aMR6ptNmPpfUP2rzYMh9cNd61Utj4mNlUc2bJaH1jx0VwnXApp/wk47+bzRcEOOf3xCrlRdsXsAVlChwopWuuVMt7u7W6ZPmyY7Hn9qmGBraq/Lz37+3/Jv//nvUnnxgsSo+5iSkKDaHq0+1AtgtolhAdtmhuXmNtbcUG+PdCrFu9sQ1lynqd5FgtWJT07Knv0fSFraDHn68R2SlZFlZv3OnnelQv1krGoT6OzqNNPetnmraZYD2orruHL1imkqAQ9NdAGvu7tHenp6BikbGtqnPht/6/neSN2ASIlWH4yP3rz+K/LVp54x9nG3aK4J177oopxQ4a0112skOTlZnnj0cdmyfrMKJCQHDx/SZGGvCQfNY9H43Ec3PiLrHnjYOkRQRUeLdWP2aDDqUBoWp/40wtqQYLCDiVMSNdBlSH5OrmTPy5ZZMzM18fA2y6HhZoMGuotSeemClKoLysvOk+3btsvUlNS7S7gIBK56oPigCRUB9Pf164Jy5cnHnjDiX3ejzjTxzNkzpqnazhKElctWymObHlXKlGwdFh87LG+/v8uoWFxcrAmio6NDP0XycnPlgVVrZX5ugSSpgMcLNr1btXyKJiPw6btFuOZzL1+5bLTqkn4y+VjVxv7+PkmfmS5zsuZYRbToklKmSMxSlb2zs0tmZ86WVSpcBItmFx8t0qTiPenW4EYK3NPTa1QqLzdPXv2DV+SVb/+JrFyyclCwCIlNGln6+tVF9PXad+qQ4aGxLkm5WxDs0WBxq7VJQirMhLh4Ey48NVVJf3raTHMXoKGhURpv3jRfGFITRysXL1wk2XOy7f4p1ei9Hx6QtrY2idQ+cAGJiVNk55M75Vsvviy583Ks3jCBDoT0d79eDTv7MAISoeMOnUXgUihO2HcLgn1q/q0tbWa6pK1EbswdE0xJTrFK+L/GpkbTHMTA/YK8AilU3gk4Xyg5UaLCb7QghBmnpaVpANpp5wlQNidUv3A8IULBPGG7e2woLMFf3CZ/GvBibxM+VcJpu/vtMNZ1P/z3blfPD1fPlWBIza+to9UiN4vgIi4hKSlJUtQUwdWqKrlWfc0ifp/emz51ugq20D5hC5+c+VjOV1Za4EJIuIqXX/ymLCootPZusNHAQkX6w7x3iJ754Re2/553XbdIlcK1H1aCyjoiKN5v19ZZBr8pbn5uLozj2ow2roM3/pAC+NtY3zdv3RzYtfsdOaksIT4hXoXjmeGKZcuNBeBPCVLmS5XPcm+xprawCIR7tvys0bNr16tNowsXLJLtW7dLhvprM/3+UHgRnpmPhHfPmzi8+pOzpyw17tW+8O2wkuSkFEmbkSb5yhhwVW6jaIdb0zUYc8GlASyhVd0T4oKZQOcSp0yxAySH0TbczYX4wT3OM1gvtcggWY+/HsVdQ6D+dlyPhHd293ZLj/LNeHrRmzSKi441mgWTaG1rlT4Wq3UjoyIkc1amCZZgdf5CpVyrqbaFFOTPly0btphg3cSDwUj7HA1ugjca62V/0X5NjY+br8YCcBeASWItbNxjmx6TnU/ssOuu/yq1qP/b9UudR4XRPm1oa+A2XzmJ6wv1mdXl5ebL5nWblALm2bhgpIAbbzXKW+/9WkqOH9H+Yo31kM5/bcezqpWRNh/a0B6aCDOqvFhpCRX8fJP2v0WzSTbaVuCp9dBg3EjUVBbuSVrLUwY0JKSTzEibNRjEKi6Wy+ny05ZBzVTNeliTCAIXE3A7Cuhz5CKcYKtV49986xey/9AhrSMmIDYKd9PW3mbuCmEzRy/4De8vNSXFzh5oF68BGYXA79OHzUHrcbBEe2jk6z99XQ4cPmhB2cHf35SEKXaCF8+ZR5SyE93kgI7vncp58wZYOJaQoNYeqRvHuMSk+PjYQVbjqYd6IfUeJn2G8AuCxXV2dNruo/Y8vpk9yzvpqrl+3UpUdJQUqqtwAc4JzmHkbwcCH4dAnDnAnc0Edeili5fJH337D+Vv//Jv5Lsvf8dcFO3r1W3wGMn6CqBBfZb1cdYbUOFxHSHOnT1HHlyzVlYsXaFWlGHuzHiyCo7vR48flfLz53QGzGlobm7d+E0EC+2EliI4/wYAm4KVoESGN9+OXiOH6KIqrMpXG2F6JA4DuttRuvPOf/WGNE0Nqa/V6wkJCXaGwM6gcVeVJfSrQBYVLDL+6vySfxK3A+3LysskpP6SdvnKh1/57h9rMHxJ7teNYhOXFS6Vbzz3e/LPf/9P8tLzv2uLBX66xvwpaOMMnd8mTZVfePoFeemFb8hfvPLn8td/9lcaJxaronRLjPJvTL9Kx4ZLh+Wqn56QmQcuCFnwHTqJdfjh6iK6SA2m3kOAftX2BPXtSbZ+imkuOxNjJkBL8TRIOwbtStEoNJ6iQcHRs7r6erleW2vBBlqGnx0v3OTQwnZNkTErJoow52TOsYmxMFf4bU801OxHJhKk2PhFtBfL4oCeRbo++GRu9G1arqWrq1uaWlsGXYOjZoC1s94u3QgUKjYmzpTKD/qkEHNa29oH58lGpKR4mSoIRmg0xiSjmHRY4ey0ywfbUe0MH5OkOwM6utqtZGlwm5M1265NFLABRsIM+c5iRoMTlCv8dmhrb5dW9c2AexwokdE5UJVC/EBrWQdUs1ezR7QT+K3gVnOTxpgWM3HTRuXoLrV38GJUUELaR6+6GwYgX0BJ8fsOwUjlgQnqi9CekNEmlHlIuMQQZyIcFcbGxtiONTQ22v18jcCZqhVuNycC5+Ppn3GxhuraGtvMT83Dp13AaT+aC6PBJXnJj2qPWpODVrFijEgDL6duCABTj9ZY4Y0xNE6XBtKu7k5rQ9CKt6A1XHMdOns6pbNX6+o62LDExERN04ceZ6m7COpOx6svi5WBPgTEkWDIZzK60yo0IjYBAQ3o6Gw3v4WppiQlDz42nyhYJJsV0vGgMRcuV8ovoVVQG10cDMYJ2a9dfkHDKHjmRkCjPxaID0TwaBefrKdLFYLjzV5chwqVEz8YgHpq7StkfQGefHR399p6kQVmDntw/bk+QahX56EywyWhfFzlvkOQqDhj2gwj2X06YcflcP58pugk8LPwYYRIsDO/1N6hXHequoSJa62rT1SfnztfJ6s0S68TnTmI//5PfiA/feO/LO321jGi/wEW4C0CxoH2siijQipg/2ajBG/++hdyqKRIr0dZ8OTAKWderten9uVPcEhIbmmqz2ahSLyTcezj43L4eIl8eKTICkeqxceKpfzCObOaQaH7BAsiXnvttb9DWJhj/Y16c/iMmT5zpi0eDa68VGlHkVmzZkueEnAWdPzUSaVl6bJujXeOO1Gw+0wef1/XoMGxTimdai8+k0lW11yT8zou/hM65dcI2nraE5DSsrODCQR18L/nKs/JCZ1fUUmxvawC1QNobpJa2roH1smC/Pvsmh/0WVZRJud4GKD+GZA1nlZ+TIp/qvSUfp4yvnymrNTcGNPArgikC/ILJGduzqAi2IynTZ2mScBMejcNQthNzc2WQiKAZJ2QUTPVXmIdTxG6NZMaWuTE4bR33ux58swTT8vq5ats8URqAhxCrqurl5+9+T/y9p5daq4dnxqP1BoXQVDm0An3wqacOnNazpSWyuWrly3BIakAOfPmyfM7nx18FOXmAFzf8GA7Z1ElQ2hYFZ9B1W6CHEER67b3MjQ5Ya6cKJLNkWr7YcJlx3HwiepT8U99OulGNQ8EjOakJqfqIKL0pdmoEx0SNJK0/heBW1xmRqZ8/asvyjeVl85V5sECQ70hC6AEqZKjJXLyk4/CrYaAlrIZzB+FsIRHA1KPtgcELJSC1HfLxs3y6ndetcMkxsTlgWGbpb43GORswHN9HK8WzJ8vmzdsMu688aENslFT4Uc2bpG1q9aqzMJPRbQYSxkR+AZtLTMjy8ycZ1n4Js5lbzXfssEt4BHINFPjkJxd4kjSDs7DAvq8YJEUtGHxwvvl5d952XJ5IjCazFjQLRIOtNcPm48GoAjVKqjQrPRZ8vtf/5Z870+/J8uXLjOXxnXSdqgem3C7+ba0tmnhhRQNUGqlyUlJpuXbtz4lO9W6nnnqGSvbtz2lgl6v1q7yUjrm0bBY9fdjCJdnWvNz8k3dGZxggp/le1amknsNXK2treYqCIJwOg+4ErjnEE2aCJzmoCkIGRe0Y9t22bppqwm8TxfZr303tTSrJbVYXQeC1a2mm8onCUpiqTlzna1l5RJS35kqYOWz2sfRk0elRIOSM38nZD/zMK3XABWpm4DFIGSERj2nBBR+12l8orBhXMPyyV79GIoSitlqkkRSUlqoSF19nQa6aslIy5D0tFm2mJsaSQlCyUpRiM7QFRlgwuOjY25xrji470wcIGTegzCN0749SjYcsAQ4d0DHh5PirlzanpudJ3nZ+aa1WBgazqE+SQJjIRSDjy1grZaQ6C0sh8MbqOJo4OEClJR69IULg076YSO4XWTH8/PyjAfCMTmjvXDpolXk5ImBmnRy8N2p6odJPOiYybodHQ/ceG6RfiE79KrGoXVsHoGK0yfSS0B9Cj4WN6Y/rB9omLMoFpqTnSMZapHUY348hD1TdtruO7i5ANbGa1W4Ge3RYhBlNJByc2JIWzaU1HykAgz7xcTy5nEgnWE7Tgecl7LbBbkFdu/y1Ssq9GvmZzBl4BZ7O7hFEDBLjh+2l0XOVpy181vaIhwnaF4mKT1XaufIukrj4LxQTfblB+MjfNcO/0xscGMtyCuQpYsWW0AjSCE4aBYuzxAgM/R8Me1tTboJaCMZH5krQvODepSmFk2TNcDTFgvGyoZcpYdB4boJ8Th9vqa0pHP4uhp1C1XXqlRzZ8jC+xZqdG4zbZ7G6VhUjAmedobwMeBYYFJkRbxsd+rsafmX138s//CDf5Qfvv4jeeOtn8v//uoN+f6//lB+/B8/sSccugzp7urWsdPMXfkBebf3IHRoZzX0z1TcdPDZ2co7Pe3tNi58peqqcVTq8hjIf5iPhTjf77JGNms0QNVIVhgXioarpE8/hutxGMuXLNOywvxdrfpdNIxdyp6brdlaqtQq4V84/z7lpitNKxyGHQOORFjwTCZdWQmHPbqdRvcuXLwghw4flGLNonh8j8Vgll1KqRDMFqVCPD3wCw6TJMASeABUKH7YgY2nLDk65+X3L5N4pUmM16l+et+hfVJ05ENtqy4lDDaLVNrijW4KhTR6NBD4unqwOC/hMrrnO8d1GCZcNyESiiWF98uMGWk2eR7lVFw4rxx0jgp1gZltxcXzxoETfPSDtmPBL3hy9Tmz5qhvC5qfI5WG0vAcjCBF4Az19ciqZSvkhZ3PD77d2D9A5McP66Yoe+BM+Xp9rW02mskiR54VIKSFBQs1WZkrNxobrB0bePBwkVy8ctn6oiDYGs1SyVRrtN/W1hbVziFW4QcpcnVNtT3t5sVEjk7ByLqDbzl6JuXd4DsPCPfqDu/Zv9t2apVmUDuU7+GL39v3vvqYRHl8yzabvL/DzwJ9O/NBW6prr6mQalQ4nhZFR0faQ8isjNlqxp6/o3//GLTnhAvfSR8AfzctdZp9jqxLOa/KUFpeao+jFhYsGjxGdHVxg2xqm6b2lp1pIUkgoI01NgyEujCFqamp6kLihtetr68fwH/64SbEoQVPfTmoIFpv27zNspRjHx2TMxpw1qxYrfn0AuvQdUq78cCNcTvQJ/4PUNc/xljt/XNxGLuuV59bt7uv//cuKCYyrga74W6XCi5AsHOrV662M9umpmY5dvKY+V/eWUhNTpGK8xUW/V27iYAxXPBwxf8aE4U+3ULcd/9vf1t/m5FwdRkPNzc0rsc2xu6LjR3e32h9uf5GIugem7hJuwXQCSVXo+1zTz9rwYt3c9/b+7793cKm9ZskKiZafddBbeW91OH6GA/cOH6MFRBHzml8oL4nDD/84/q/TxSuret/tH5Mc/2V/HA7SIa2cd1XZLEGubPlZbK/6IDVX7poiWrbgJQpdwTjnShtRxtvJEbWc/2P1tZfl09PK71TM3ed9uOd43hAX05+oyHQ3Nw8wIPH28FNiui8a88u+eT0KVm76gF760Znbsd6U5UBTDS4fdkRaGhoGEjVSHc7OOECIioH0AeLD9qrS888udNOhzxtGfI7/Hbt/JpzLyFw8+bNAZ4n3Q4Ih4IJUKBmxcog3t79jrqMdDuGG/mKKLjXhDkSgbq6uoHp06cP07CxwH3qIWDAu1K/evctJfG1ynm3ysNrH/Ie+oU3A+DzCLjjPTX7MiHQ3t4+QF78WYIdCYRM4cjvyIkj9iIdz7r4wxP/3/eixW5TKPcSAm1tbSZcFv55BQzIWD44uNee3q5Rbvzg6gcHT7Hod6J9fxkQaGpqGuBZ/+eHJ2CnlJerLkvRkWJ7arCwYIEsXbzEEo57UcCDPvc3CXJvUueauut2mM2hCf/+wr0G09zPYguT+HyY/Bfx7iBGPSyfxG8Gk8K9YxD5f/KQNPuJqPiyAAAAAElFTkSuQmCC'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Add_TextChanged({
		$OKButtonneu.Visible = ($objTextboxFirma.text -ne "")
		})

	$objFormcsvneu.Controls.Add($objTextboxFirma)

	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Firma umbenennen"
	$OKButtonneu.Name = "Firma umbenennen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			#[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			#Prüfen, ob Firma neu
			$X= $csv | ? Firma -eq $FirmaNeu 
			if ($X.count -eq 0){
				#Anfügen einer Zeile in CSV
				$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
				copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
				[String]$FirmaNeu = $objTextboxFirma.text.Trim()

				$Protokoll =  $Script:AppName
				$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
				$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
				$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
				$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
				$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
				$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
				$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
				$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Firma umbenannt von "+ $uFirma +" :"
				$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
				$Protokoll = $Protokoll +$nL + "-------------------"

				$csvneu = $csv | Where-Object{($_.Firma -ne $uFirma) }
				$csvneuK = $csv | Where-Object{($_.Firma -eq $uFirma) }
				Foreach ($Vorlage in $csvneuK){
					$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$Vorlage.Konfiguration; Parameter=$Vorlage.Parameter;Wert=$Vorlage.Wert}
				}
		
				$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

				$utf8 = New-Object System.Text.utf8encoding
#				Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

				$Protokoll | out-file -filepath $LogFile
                $ok = $false
				#CSV_bearbeiten $FirmaNeu $KonfNeu
                $FirmaNeu
			}Else{
				[void][System.Windows.Forms.MessageBox]::Show("Firma existiert schon!","Fehler",0)
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}

Function CSV_Firma_kopieren ($uFirma)
{
#Braucht man wohl nicht
}
Function CSV_Firma_loeschen ($uFirma)
{
#Braucht man wohl nicht
}
Function CSV_Konfiguration_kopieren ($uFirma, $uKonfiguration)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Konfiguration " + $uKonfiguration + " kopieren"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.Add_TextChanged({
		$OKButtonneu.Visible = ($objTextboxKonfiguration.text -ne "")
		})
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)


	#Beschreibung eingeben
	$objlabelInfo = New-Object System.Windows.Forms.Label
	$objlabelInfo.Location = New-Object System.Drawing.Size(20,80)
	$objlabelInfo.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelInfo.Text = "Beschreibung:"
	$objFormcsvneu.Controls.Add($objlabelInfo)
	
	$objTextboxInfo = New-Object System.Windows.Forms.Textbox
	$objTextboxInfo.Location = New-Object System.Drawing.Size(120,80)
	$objTextboxInfo.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxInfo.Text = ""
	$objFormcsvneu.Controls.Add($objTextboxInfo)

	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Konfiguration anlegen"
	$OKButtonneu.Name = "Konfiguration anlegen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			#Prüfen, ob Konfiguration neu
			$X= $csv | ? Firma -eq $FirmaNeu | ? Konfiguration -eq $KonfNeu
			if ($X.count -eq 0){
				#Anfügen einer Zeile in CSV
				$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
				copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
				[String]$FirmaNeu = $objTextboxFirma.text.Trim()
				[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()

				$Protokoll =  $Script:AppName
				$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
				$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
				$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
				$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
				$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
				$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
				$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
				$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Neue Konfiguration kopiert von "+ $uKonfiguration +" :"
				$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
				$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "-------NEU---------"
				$csvneu = $csv | Where-Object{($_.Firma -ne $FirmaNeu) -or ($_.Konfiguration -ne $KonfNeu)}
				$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="INFO";Wert=$objTextboxInfo.Text.trim()  }
				$csvneuK = $csv | Where-Object{($_.Firma -eq $uFirma) -and ($_.Konfiguration -eq $uKonfiguration)}
				Foreach ($Vorlage in $csvneuK){
					IF ($Vorlage.Parameter -ne "INFO") {
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter=$Vorlage.Parameter;Wert=$Vorlage.Wert}
					}
				}
				$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $FirmaNeu) -and ($_.Konfiguration -eq $KonfNeu)}| Sort -Property Firma,Konfiguration,Parameter,Wert
				foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
				$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

				$utf8 = New-Object System.Text.utf8encoding
#				Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

				$Protokoll | out-file -filepath $LogFile
                $ok = $false
				#CSV_bearbeiten $FirmaNeu $KonfNeu
                $KonfNeu
			}Else{
				[void][System.Windows.Forms.MessageBox]::Show("Konfiguration existiert schon!","Fehler",0)
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}

Function CSV_Konfiguration_umbenennen ($uFirma, $uKonfiguration)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Konfiguration " + $uKonfiguration + " umbenennen"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.text = $uKonfiguration
	$objTextboxKonfiguration.Add_TextChanged({
		$OKButtonneu.Visible = ($objTextboxKonfiguration.text -ne "")
		})
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)


	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Konfiguration umbenennen"
	$OKButtonneu.Name = "Konfiguration umbenennen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			#Prüfen, ob Konfiguration neu
			$X= $csv | ? Firma -eq $FirmaNeu | ? Konfiguration -eq $KonfNeu
			if ($X.count -eq 0){
				#Anfügen einer Zeile in CSV
				$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
				copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
				[String]$FirmaNeu = $objTextboxFirma.text.Trim()
				[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()

				$Protokoll =  $Script:AppName
				$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
				$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
				$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
				$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
				$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
				$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
				$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
				$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "Konfiguration umbenannt von "+ $uKonfiguration +" :"
				$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
				$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
				$Protokoll = $Protokoll +$nL + "-------------------"
				$Protokoll = $Protokoll +$nL + "-------NEU---------"
				$csvneu = $csv | Where-Object{($_.Firma -ne $uFirma) -or ($_.Konfiguration -ne $uKonfiguration)}
				$csvneuK = $csv | Where-Object{($_.Firma -eq $uFirma) -and ($_.Konfiguration -eq $uKonfiguration)}
				Foreach ($Vorlage in $csvneuK){
					$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter=$Vorlage.Parameter;Wert=$Vorlage.Wert}
				}
				$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $FirmaNeu) -and ($_.Konfiguration -eq $KonfNeu)}| Sort -Property Firma,Konfiguration,Parameter,Wert
				foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
				$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

				$utf8 = New-Object System.Text.utf8encoding
#				Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

				$Protokoll | out-file -filepath $LogFile
                $ok = $false
				#CSV_bearbeiten $FirmaNeu $KonfNeu
                $KonfNeu
			}Else{
				[void][System.Windows.Forms.MessageBox]::Show("Konfiguration existiert schon!","Fehler",0)
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}

Function CSV_Konfiguration_loeschen ($uFirma, $uKonfiguration)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,180)
	$objFormcsvneu.Text = "Konfiguration " + $uKonfiguration + " löschen"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.text = $uKonfiguration
	$objTextboxKonfiguration.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)


	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Konfiguration löschen"
	$OKButtonneu.Name = "Konfiguration löschen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $true
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			#Prüfen, ob Konfiguration neu
			#Anfügen einer Zeile in CSV
			$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
			copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()

			$Protokoll =  $Script:AppName
			$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
			$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
			$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
			$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
			$Protokoll = $Protokoll +$nL + "-------------------"
			$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
			$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
			$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
			$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
			$Protokoll = $Protokoll +$nL + "-------------------"
			$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
			$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
			$Protokoll = $Protokoll +$nL + "-------------------"
			$Protokoll = $Protokoll +$nL + "Konfiguration gelöscht "+ $uKonfiguration +" :"
			$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
			$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
			$Protokoll = $Protokoll +$nL + "-------------------"
			$Protokoll = $Protokoll +$nL + "-------ALT---------"
			$csvneu = $csv | Where-Object{($_.Firma -ne $uFirma) -or ($_.Konfiguration -ne $uKonfiguration)}
			$csvalt = $csv | Where-Object{($_.Firma -eq $uFirma) -and ($_.Konfiguration -eq $uKonfiguration)}| Sort -Property Firma,Konfiguration,Parameter,Wert
			foreach($Z in $csvalt){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
			$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

			$utf8 = New-Object System.Text.utf8encoding
#			Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

			$Protokoll | out-file -filepath $LogFile
			$ok = $false
			#CSV_bearbeiten $FirmaNeu $KonfNeu
			$True
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}


Function CSV_Konfiguration_von_Benutzer ($uFirma)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

	$objFormcsvneu =  New-Object System.Windows.Forms.Form
	$objFormcsvneu.StartPosition = "CenterScreen"
	$objFormcsvneu.Size = New-Object System.Drawing.Size(800,250)
	$objFormcsvneu.Text = "Neue Konfiguration aus Beispielbenutzer erstellen" 

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsvneu.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsvneu.Controls.Add($objlabelFirma)
	
	$objTextboxFirma = New-Object System.Windows.Forms.Textbox
	$objTextboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objTextboxFirma.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxFirma.Text = $uFirma
	$objTextboxFirma.Enabled = $false
	$objFormcsvneu.Controls.Add($objTextboxFirma)

	#Neuer erste Konfigurationname eingeben
	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objFormcsvneu.Controls.Add($objlabelKonfiguration)
	
	$objTextboxKonfiguration = New-Object System.Windows.Forms.Textbox
	$objTextboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objTextboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxKonfiguration.text = ""
	$objTextboxKonfiguration.Add_TextChanged({
		$OKButtonneu.Visible = (($objTextboxKonfiguration.text -ne "") -and ($objTextboxUNC.text -ne ""))
		})
	$objFormcsvneu.Controls.Add($objTextboxKonfiguration)

	
	#Beschreibung eingeben
	$objlabelInfo = New-Object System.Windows.Forms.Label
	$objlabelInfo.Location = New-Object System.Drawing.Size(20,80)
	$objlabelInfo.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelInfo.Text = "Beschreibung:"
	$objFormcsvneu.Controls.Add($objlabelInfo)
	
	$objTextboxInfo = New-Object System.Windows.Forms.Textbox
	$objTextboxInfo.Location = New-Object System.Drawing.Size(120,80)
	$objTextboxInfo.Size = New-Object System.Drawing.Size(260,20)
	$objTextboxInfo.Text = ""
	$objFormcsvneu.Controls.Add($objTextboxInfo)

	#Benutzer eingeben
	$objlabelUNC = New-Object System.Windows.Forms.Label
	$objlabelUNC.Location = New-Object System.Drawing.Size(20,110)
	$objlabelUNC.Size = New-Object System.Drawing.Size(500,20)
	#$objlabelFirma.Visible = $false
	$objlabelUNC.Text = "DistinguishedName Beispielbenutzer:"
	$objFormcsvneu.Controls.Add($objlabelUNC)
	
	$objTextboxUNC = New-Object System.Windows.Forms.Textbox
	$objTextboxUNC.Location = New-Object System.Drawing.Size(20,140)
	$objTextboxUNC.Size = New-Object System.Drawing.Size(600,20)
	$objTextboxUNC.Text = ""
	$objTextboxUNC.Add_TextChanged({

		$OKButtonneu.Visible = (($objTextboxKonfiguration.text -ne "") -and ($objTextboxUNC.text -ne ""))
		})
	$objFormcsvneu.Controls.Add($objTextboxUNC)


	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,170)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Konfiguration erstellen"
	$OKButtonneu.Name = "Konfiguration erstellen"
	$OKButtonneu.DialogResult = "OK"
	$OKButtonneu.Visible = $false
	#$OKButtonFertig.Add_Click({})
	$objFormcsvneu.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormcsvneu.ShowDialog()
		if ($objFormcsvneu.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::WaitCursor
			[String]$FirmaNeu = $objTextboxFirma.text.Trim()
			[String]$KonfNeu = $objTextboxKonfiguration.Text.Trim()
			[String]$Beispiel = $objTextboxUNC.Text.Trim()
			[String]$InfoNeu = $objTextboxInfo.Text.Trim()
			
			$error.Clear()
			$Dom=""
			$Dom=Finde_Domain $Beispiel
			$DC=""
			$DC=Finde_DC($Dom)
			
			Try { 
				$uBeispiel = get-aduser $Beispiel -Server $Dom  -Properties SamaccountName,Displayname,UserprincipalName, MemberOf,mail,StreetAddress,l,st,PostalCode,Company,department,Title,HomeDirectory,ProfilePath,Homedrive,scriptPath
			}
			catch{$ERR= $error[0].Exception}
			if ($Error){
				[void][System.Windows.Forms.MessageBox]::Show("Benutzer nicht gefunden","Fehler",0)
				$error.Clear()
			}else{
				#Prüfen, ob Konfiguration neu
				$X= $csv | ? Firma -eq $FirmaNeu | ? Konfiguration -eq $KonfNeu
				if ($X.count -eq 0){
					#Anfügen einer Zeile in CSV
					$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
					copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung

					$Protokoll =  $Script:AppName
					$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
					$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
					$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
					$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
					$Protokoll = $Protokoll +$nL + "-------------------"
					$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
					$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
					$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
					$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
					$Protokoll = $Protokoll +$nL + "-------------------"
					$Protokoll = $Protokoll +$nL + "Änderung"+ $Konfigdatei
					$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
					$Protokoll = $Protokoll +$nL + "-------------------"
					$Protokoll = $Protokoll +$nL + "Konfiguration erstellt aus Beispielbenutzer:"
					$Protokoll = $Protokoll +$nL + $Beispiel
					$Protokoll = $Protokoll +$nL + "Firma: " + $FirmaNeu
					$Protokoll = $Protokoll +$nL + "Konfiguration: " +  $KonfNeu
					$Protokoll = $Protokoll +$nL + "-------------------"
					$Protokoll = $Protokoll +$nL + "-------NEU---------"
					$csvneu = $csv 
#INFO
					if($InfoNeu){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="INFO";Wert=$InfoNeu}}
#ParentOU
					$ParentOU="OU="+($Beispiel -split ',OU=',2)[1]
					$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="OU";Wert=$ParentOU}
#DOM
					if($DOM){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="DOMAIN";Wert=$DOM}}
#DC
					if($DC){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="DC";Wert=$DC}}
#SAMIDMASK
					$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="SAMIDMASK";Wert="%SAMID%"}
#USERDISPLAYMASK
					IF($uBeispiel.displayName){
						$display = "%Nachname%, %Vorname% ("+ (($uBeispiel.displayName).split('(',2))[1]
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="USERDISPLAYMASK";Wert=$display}
					}
#GROUPS
					$Gs=$uBeispiel.MemberOf
					ForEach($G in $Gs){
						IF ($G -like "CN*"){
							$GDom = Finde_Domain $G
							$Gsamid = (get-adgroup -identity "$G" -Server $GDom).SAMAccountName
							if ($Dom.ToLower() -ne $GDom.ToLower()){
								$Geintrag = ($GDom.split('.',2))[0]+ "\" + $Gsamid 
								}else{
								$Geintrag = $Gsamid 
								}
								$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="GROUPS";Wert=$Geintrag}
							}
						}
#EXCHANGESERVER immer
					$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="EXCHANGESERVER";Wert="svhd-ex01x.srh.de"}
#MAILMASK
					if($uBeispiel.Mail){
						If ($uBeispiel.Mail -like "*extern*") {
							$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="EMAILADRESSEMASK";Wert="%Vorname%.%Nachname%.extern@srh.de"}
						}Else{
							$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="EMAILADRESSEMASK";Wert="%Vorname%.%Nachname%@srh.de"}
						}
#ADFELDERUPN
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="UserPrincipalName;%Email%"}
					}
#HOME
					if ($uBeispiel.Homedirectory) {
						$HMask = $uBeispiel.Homedirectory -replace($uBeispiel.SamAccountName,"%SAMID%")
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="HOME";Wert=$HMask}
						$a1,$a2,$a3,$a4,$a5 = $HMask.split("\")
						if($a5){}Else{$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="HOMEFREIGABEPFADLOKAL";Wert="Hier müsste noch was rein oder anderen Pfad für HOME"}}
						}
#PROFIL
					if ($uBeispiel.ProfilePath) {
						$PMask = $uBeispiel.ProfilePath -replace($uBeispiel.SamAccountName,"%SAMID%")
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="PROFIL";Wert=$PMask}
						}
#HOMEDRIVE
					if($uBeispiel.Homedrive){
						$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="HOMEDRIVE";Wert=$uBeispiel.Homedrive}
						$a1,$a2,$a3,$a4 = $HMask.split("")
						}

#Skript
					if($uBeispiel.scriptPath){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="scriptPath;"+ $uBeispiel.scriptPath}}

#ADFELDERBEschreibung
					if($uBeispiel.Description){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="description;"+ $uBeispiel.Description}}
#ADFELDERFirma
					if($uBeispiel.company){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="company;"+ $uBeispiel.company}}
#ADFELDERdivision
					if($uBeispiel.division){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="division;"+ $uBeispiel.division}}
#ADFELDERAbteilung
					if($uBeispiel.department){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="department;"+ $uBeispiel.department}}
#ADFELDEROrt
					if($uBeispiel.l){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="l;"+ $uBeispiel.l}}
#ADFELDERStrasse
					if($uBeispiel.streetAddress){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="streetAddress;"+ $uBeispiel.streetAddress}}
#ADFELDERSt
					if($uBeispiel.st){$csvneu += New-Object PSObject -Property @{Firma=$FirmaNeu;Konfiguration=$KonfNeu; Parameter="ADFELDER";Wert="st;"+ $uBeispiel.st}}

					$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $FirmaNeu) -and ($_.Konfiguration -eq $KonfNeu)}| Sort -Property Firma,Konfiguration,Parameter,Wert
					foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
					$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 

					$utf8 = New-Object System.Text.utf8encoding
#					Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

					$Protokoll | out-file -filepath $LogFile
					$ok = $false
					#CSV_bearbeiten $FirmaNeu $KonfNeu
					$KonfNeu
				}Else{
					[void][System.Windows.Forms.MessageBox]::Show("Konfiguration existiert schon!","Fehler",0)
				}
			}
			$objFormcsvneu.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormcsvneu.Close()

}

Function OU_bearbeiten ($uOU)
{
	
	$objFormOU =  New-Object System.Windows.Forms.Form
	$objFormOU.StartPosition = "CenterScreen"
	$objFormOU.Size = New-Object System.Drawing.Size(800,180)
	$objFormOU.Text = "OU bearbeiten"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormOU.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objlabelOU = New-Object System.Windows.Forms.Label
	$objlabelOU.Location = New-Object System.Drawing.Size(20,20)
	$objlabelOU.Size = New-Object System.Drawing.Size(30,20)
	#$objlabelFirma.Visible = $false
	$objlabelOU.Text = "OU:"
	$objFormOU.Controls.Add($objlabelOU)
	
	$objTextboxOU = New-Object System.Windows.Forms.Textbox
	$objTextboxOU.Location = New-Object System.Drawing.Size(50,18)
	$objTextboxOU.Size = New-Object System.Drawing.Size(720,18)
	$objTextboxOU.Text = $uOU
    $OUOK = pruefe_OU $uOU
	if($OUOK -eq 0){$objTextboxOU.BackColor = "LightPink"}
	$objTextboxOU.Add_TextChanged( {
		$OUOK = pruefe_OU ($objTextboxOU.Text.ToString())
		If ($OUOK -eq 1){
		    
			    $objTextboxOU.BackColor = "white"
			    $OKButtonneu.Visible = $true
		    }else{
			    $objTextboxOU.BackColor = "LightPink"
			    $OKButtonneu.Visible = $false
		    }
		})	
	
	$objFormOU.Controls.Add($objTextboxOU)


	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "OU eintragen"
	$OKButtonneu.Name = "OU eintragen"
	$OKButtonneu.DialogResult = "OK"
	if(($OUOK) -eq 0){$OKButtonneu.Visible = $false}
	#$OKButtonFertig.Add_Click({})
	$objFormOU.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormOU.ShowDialog()
		if ($objFormOU.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$ok = $false
			#CSV_bearbeiten $FirmaNeu $KonfNeu
			$objTextboxOU.Text.ToString()
			$objFormOU.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormOU.Close()

}
Function Gruppe_bearbeiten ($uGruppe,$DOmUser)
{
	
	$objFormGruppe =  New-Object System.Windows.Forms.Form
	$objFormGruppe.StartPosition = "CenterScreen"
	$objFormGruppe.Size = New-Object System.Drawing.Size(800,180)
	$objFormGruppe.Text = "Gruppe bearbeiten"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormGruppe.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

	
	#Neuer Firmaname eingeben
		
	$objLabelGruppe = New-Object System.Windows.Forms.Label
	$objLabelGruppe.Location = New-Object System.Drawing.Size(20,20)
	$objLabelGruppe.Size = New-Object System.Drawing.Size(50,20)
	#$objlabelFirma.Visible = $false
	$objLabelGruppe.Text = "Gruppe:"
	$objFormGruppe.Controls.Add($objLabelGruppe)
	
	$objTextboxGruppe = New-Object System.Windows.Forms.Textbox
	$objTextboxGruppe.Location = New-Object System.Drawing.Size(70,18)
	$objTextboxGruppe.Size = New-Object System.Drawing.Size(700,18)
	$objTextboxGruppe.Text = $uGruppe
		$Eintrag = pruefe_Gruppe ($objTextboxGruppe.Text.ToString()) $DOmUser
		If ($Eintrag -eq ""){$objTextboxGruppe.BackColor = "LightPink"}
	$objTextboxGruppe.Add_TextChanged({
		$Eintrag = pruefe_Gruppe ($objTextboxGruppe.Text.ToString()) $DOmUser
		If ($Eintrag -eq ""){
				$objTextboxGruppe.BackColor = "LightPink"
				$OKButtonneu.Visible = $false
			}else{
				$objTextboxGruppe.BackColor = "white"
				$OKButtonneu.Visible = $true
			}
		})	
	
	$objFormGruppe.Controls.Add($objTextboxGruppe)


	$OKButtonneu = New-Object System.Windows.Forms.Button
	$OKButtonneu.Location = New-Object System.Drawing.Size(20,110)
	$OKButtonneu.Size = New-Object System.Drawing.Size(150,23)
	$OKButtonneu.Text = "Gruppe eintragen"
	$OKButtonneu.Name = "Gruppe eintragen"
	$OKButtonneu.DialogResult = "OK"
	if($Eintrag -eq ""){$OKButtonneu.Visible = $false}
	#$OKButtonFertig.Add_Click({})
	$objFormGruppe.Controls.Add($OKButtonneu)


	$ok = $true
	While ( $ok)
	{
		[void]$objFormGruppe.ShowDialog()
		if ($objFormGruppe.DialogResult -ne "OK"){
			$ok = $false
		}Else{
			$ok = $false
			#CSV_bearbeiten $FirmaNeu $KonfNeu
			$Eintrag = pruefe_Gruppe ($objTextboxGruppe.Text.ToString()) $DOmUser
			$Eintrag
            $objFormGruppe.Cursor=[System.Windows.Forms.Cursors]::NormalCursor
		}
	}
	[void]$objFormGruppe.Close()

}


Function CSV_bearbeiten ($uFirma, $uKonfiguration)
{

	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
	$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
    [string]$LogFile = $Script:Path + "\LOG\CSVAendderung"+$datum + "log.txt"

# Ausgewählte Konfiguration zur Ansicht ordnen ahnhand ConfigSchema.csv
	$KonfigSchemadatei = $Script:Path + ".\ConfigSchema.csv"
	$CSVFelder=Import-Csv $KonfigSchemadatei -Encoding Default -Delimiter ";"


	$objFormcsv =  New-Object System.Windows.Forms.Form
	$objFormcsv.StartPosition = "CenterScreen"
#	$objFormcsv.Size = New-Object System.Drawing.Size(800,500)
	$objFormcsv.Size = New-Object System.Drawing.Size(1200,700)
	$objFormcsv.Text = "Konfigurationsdatei bearbeiten"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormcsv.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())


	$objDataGridViewCSV = New-Object System.Windows.Forms.DataGridView
	$objDataGridViewCSV.Location = New-Object System.Drawing.Size(20,80)
	$objDataGridViewCSV.Size = New-Object System.Drawing.Size(1140,520)
	$objContextMenuStripA = New-Object System.Windows.Forms.ContextMenuStrip
	$objDataGridViewCSV.Visible = $true
	$objDataGridViewCSV.ColumnCount = 3
	$objDataGridViewCSV.ColumnHeadersVisible = $true
    $objDataGridViewCSV.AutoSize = $false
    $objDataGridViewCSV.AllowUserToAddRows=$false
    $objDataGridViewCSV.AllowUserToOrderColumns=$false
    $objDataGridViewCSV.AllowUserToResizeColumns =$false
    #$objDataGridViewCSV.AllowSorting = $false
    $objDataGridViewCSV.ReadOnly = $false
	$objDataGridViewCSV.Columns[0].Name = "Parameter"
    $objDataGridViewCSV.Columns[0].ReadOnly = $true
	$objDataGridViewCSV.Columns[1].Name = "Wert"
	$objDataGridViewCSV.Columns[2].Name = "Hilfe"
    $objDataGridViewCSV.Columns[2].ReadOnly = $true
    $objDataGridViewCSV.ContextMenuStrip = $objContextMenuStripA
    #$objDataGridViewCSV.add_CellBeginEdit({
    $objDataGridViewCSV.add_Click({
        $Funktion = $objDataGridViewCSV.CurrentRow.Cells[0].Value
		$Wert = $objDataGridViewCSV.CurrentRow.Cells[1].Value
        IF (($Funktion -eq "OU") -or ($Funktion -eq "DOMAIN") -or ($Funktion -eq "DC")){
			ForEach ($Row in $objDataGridViewCSV.Rows){If ($Row.Cells[0].value -eq "OU"){$CurrentOU = $Row.Cells.value[1]}}
            $EingabeOU = OU_bearbeiten $CurrentOU
			if ($EingabeOU){
				$EingabeDom = Finde_Domain $EingabeOU
				$EingabeDC = finde_DC $EingabeDom
				ForEach ($Row in $objDataGridViewCSV.Rows){If ($Row.Cells[0].value -eq "OU"){
					$Row.Cells[1].value=$EingabeOU
					$Row.Cells[0].Style.BackColor="White"
					$Row.Cells[1].Style.BackColor="White"
					}}
				ForEach ($Row in $objDataGridViewCSV.Rows){If ($Row.Cells[0].value -eq "DOMAIN"){
					$Row.Cells[1].value=$EingabeDom
					$Row.Cells[0].Style.BackColor="White"
					$Row.Cells[1].Style.BackColor="White"
					}}
				ForEach ($Row in $objDataGridViewCSV.Rows){If ($Row.Cells[0].value -eq "DC"){
					$Row.Cells[1].value=$EingabeDC
					$Row.Cells[0].Style.BackColor="White"
					$Row.Cells[1].Style.BackColor="White"
					}}
	            }
	        }
        IF ($Funktion -eq "GROUPS"){
			ForEach ($Row in $objDataGridViewCSV.Rows){If ($Row.Cells[0].value -eq "DOMAIN"){$CurrentDOM = $Row.Cells.value[1]}}
			$EingabeGruppe = Gruppe_bearbeiten $Wert $CurrentDOM
			if ($EingabeGruppe){
				$objDataGridViewCSV.CurrentRow.Cells[1].Value = $EingabeGruppe
				$objDataGridViewCSV.CurrentRow.Cells[0].Style.BackColor="White"
				$objDataGridViewCSV.CurrentRow.Cells[1].Style.BackColor="White"
				}

			}
		})
	$objFormcsv.Controls.Add($objDataGridViewCSV)

	$objlabelFirma = New-Object System.Windows.Forms.Label
	$objlabelFirma.Location = New-Object System.Drawing.Size(20,20)
	$objlabelFirma.Size = New-Object System.Drawing.Size(100,20)
	#$objlabelFirma.Visible = $false
	$objlabelFirma.Text = "Firma:"
	$objFormcsv.Controls.Add($objlabelFirma)


	$objContextMenuStripFirma = New-Object System.Windows.Forms.ContextMenuStrip
	$objContextMenuStripFirma.items.Add("Neue Firma").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$Neu=CSV_Neue_Firma
		If ($Neu){
			[void] $objComboboxFirma.Items.Clear()
			$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
			$Firmenliste = $csv | select-object Firma | sort firma -Unique
			foreach($f in $Firmenliste)
				{
				[void] $objComboboxFirma.Items.Add($f.firma)
				if ($f.firma -eq $Neu){$objComboboxFirma.SelectedIndex = $objComboboxFirma.items.Count -1}
				}
			}
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})
	#$objContextMenuStripFirma.items.Add("Kopieren").add_Click({[System.Windows.Forms.MessageBox]::Show("Hier passiert noch nichts","Baustelle",0)})
	$objContextMenuStripFirma.items.Add("Firma umbenennen").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$Neu=CSV_Firma_umbenennen $uFirma
        If ($Neu){
            [void] $objComboboxFirma.Items.Clear()
		    $csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		    $Firmenliste = $csv | select-object Firma | sort firma -Unique
		    foreach($f in $Firmenliste)
			    {
			    [void] $objComboboxFirma.Items.Add($f.firma)
			    if ($f.firma -eq $Neu){$objComboboxFirma.SelectedIndex = $objComboboxFirma.items.Count -1}
			    }
            }
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})
    #$objContextMenuStripFirma.items.Add("Löschen").add_Click({[System.Windows.Forms.MessageBox]::Show("Hier passiert noch nichts","Baustelle",0)})
    
	$objContextMenuStripKonfiguration =  New-Object System.Windows.Forms.ContextMenuStrip
	$objContextMenuStripKonfiguration.items.Add("Neue Konfiguration").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$Neu = CSV_Neue_Konfiguration $uFirma
        If ($Neu){
    		[void] $objComboboxKonfiguration.Items.Clear()
	    	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		    $Konfigurationliste = $csv | ? Firma -eq $uFirma  | select-object Konfiguration | sort Konfiguration -Unique  
    		foreach($C in $Konfigurationliste)
	    		{
		    	[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
			    if ($c.Konfiguration -eq $Neu){$objComboboxKonfiguration.SelectedIndex = $objComboboxKonfiguration.items.Count -1}
                }
			}
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})
	$objContextMenuStripKonfiguration.items.Add("Konfiguration kopieren").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$uKonfiguration = $objComboboxKonfiguration.selecteditem.ToString() 
		$Neu = CSV_Konfiguration_kopieren $uFirma $uKonfiguration
        If ($Neu){
			[void] $objComboboxKonfiguration.Items.Clear()
    		$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	    	$Konfigurationliste = $csv | ? Firma -eq $uFirma  | select-object Konfiguration | sort Konfiguration -Unique  
		    foreach($C in $Konfigurationliste)
			    {
    			[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
	    		if ($c.Konfiguration -eq $Neu){$objComboboxKonfiguration.SelectedIndex = $objComboboxKonfiguration.items.Count -1}
		    	}
            }
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})

	$objContextMenuStripKonfiguration.items.Add("Konfiguration von Beispiel").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$Neu = CSV_Konfiguration_von_Benutzer $uFirma
        If ($Neu){
    		[void] $objComboboxKonfiguration.Items.Clear()
	    	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		    $Konfigurationliste = $csv | ? Firma -eq $uFirma  | select-object Konfiguration | sort Konfiguration -Unique  
    		foreach($C in $Konfigurationliste)
	    		{
		    	[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
			    if ($c.Konfiguration -eq $Neu){$objComboboxKonfiguration.SelectedIndex = $objComboboxKonfiguration.items.Count -1}
                }
			}
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})


	$objContextMenuStripKonfiguration.items.Add("Konfiguration umbenennen").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$uKonfiguration = $objComboboxKonfiguration.selecteditem.ToString() 
		$Neu = CSV_Konfiguration_umbenennen $uFirma $uKonfiguration
        If ($Neu){
    		[void] $objComboboxKonfiguration.Items.Clear()
	    	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		    $Konfigurationliste = $csv | ? Firma -eq $uFirma  | select-object Konfiguration | sort Konfiguration -Unique  
		    foreach($C in $Konfigurationliste)
			    {
    			[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
	    		if ($c.Konfiguration -eq $Neu){$objComboboxKonfiguration.SelectedIndex = $objComboboxKonfiguration.items.Count -1}
		    	}
            }
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})
    $objContextMenuStripKonfiguration.items.Add("Konfiguration löschen").add_Click({
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::WaitCursor 
		$uFirma = $objComboboxFirma.selecteditem.ToString() 
		$uKonfiguration = $objComboboxKonfiguration.selecteditem.ToString() 
		$geloescht = CSV_Konfiguration_loeschen $uFirma $uKonfiguration
		if ($geloescht){
			[void] $objComboboxKonfiguration.Items.Clear()
			$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
			$Konfigurationliste = $csv | ? Firma -eq $uFirma  | select-object Konfiguration | sort Konfiguration -Unique  
			if ($Konfigurationliste.count -eq 0){ 
				[void] $objComboboxFirma.Items.Clear()
				$Firmenliste = $csv | select-object Firma | sort firma -Unique
				foreach($f in $Firmenliste)
					{
					[void] $objComboboxFirma.Items.Add($f.firma)
					}
				$objComboboxFirma.SelectedIndex = 0
				}Else{
				foreach($C in $Konfigurationliste)
					{
					[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
					}
				$objComboboxKonfiguration.SelectedIndex = 0
				}
			}
		$objFormcsv.Cursor=[System.Windows.Forms.Cursors]::NormalCursor 
		})

	$objComboboxFirma = New-Object System.Windows.Forms.Combobox
	$objComboboxFirma.Location = New-Object System.Drawing.Size(120,20)
	$objComboboxFirma.Size = New-Object System.Drawing.Size(260,20)
	#$objComboboxFirma.Visible = $false
	#$objComboboxFirma.Text = $Firma
	$objComboboxFirma.Height = 200
	$objComboboxFirma.DropDownStyle = 2

    $objComboboxFirma.ContextMenuStrip = $objContextMenuStripFirma
	$objComboboxFirma.Add_SelectedIndexChanged(
		{
       	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		$objComboboxKonfiguration.Visible = $true
		$objListbox.Visible = $true
		$objlabelKonfiguration.Visible = $true
		$OKButton.Visible = $true
		[void] $objComboboxKonfiguration.Items.Clear()
		$Konfigurationliste = $csv | ? Firma -eq $objComboboxFirma.selecteditem.ToString()  | select-object Konfiguration | sort Konfiguration -Unique  
		#$objlabelFirma.Text = $objComboboxFirma.selecteditem.ToString()
		foreach($C in $Konfigurationliste)
			{
			[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
			}
		$objComboboxKonfiguration.SelectedIndex=0
		})
	$objFormcsv.Controls.Add($objComboboxFirma)

	$objlabelKonfiguration = New-Object System.Windows.Forms.Label
	$objlabelKonfiguration.Location = New-Object System.Drawing.Size(20,50)
	$objlabelKonfiguration.Size = New-Object System.Drawing.Size(100,20)
	$objlabelKonfiguration.Text = "Konfiguration:"
	$objlabelKonfiguration.Visible = $true
	$objFormcsv.Controls.Add($objlabelKonfiguration)

	$objComboboxKonfiguration = New-Object System.Windows.Forms.Combobox
	$objComboboxKonfiguration.Location = New-Object System.Drawing.Size(120,50)
	$objComboboxKonfiguration.Size = New-Object System.Drawing.Size(260,20)
	$objComboboxKonfiguration.Height = 200
	$objComboboxKonfiguration.Visible = $true
	$objComboboxKonfiguration.DropDownStyle = 2
	$objComboboxKonfiguration.ContextMenuStrip = $objContextMenuStripKonfiguration
	#$objComboboxKonfiguration.Text = $Konfiguration
	$objFormcsv.Controls.Add($objComboboxKonfiguration)
	$objComboboxKonfiguration.Add_SelectedIndexChanged(
		{
		[void] $objDataGridViewCSV.Rows.Clear()
		[void] $objContextMenuStripA.items.Clear()
       	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"

		$Liste = $csv | ? Firma -eq $objComboboxFirma.selecteditem.ToString() | ? Konfiguration -eq $objComboboxKonfiguration.selecteditem.ToString() | select-object Parameter,Wert  


        #xliste ergänzen mit INfos aus csvFelder und Sortieren nach Ordnung
		[array]$Result=@()
		$CSVFelder|ForEach-object{
			If ($_.Ordnung  -match '^[0-9]+$'){
				$i=0
				foreach($X in  $Liste)
					{
					If($X.Parameter -eq $_.Name)
						{
						$I++
						$result+=New-Object PSObject -Property @{Parameter=$X.Parameter.trim();Wert=$X.Wert.trim();Ordnung=[INT]$_.Ordnung;Pflicht=$_.Pflicht;Multi=$_.Multi;MaxZeichen=$_.MaxZeichen;Hilfe=$_.Hilfe;Neu=0}
						}
					}
				If ($_.Pflicht -eq 1 -and $I -eq 0) 
					{
					$result+=New-Object PSObject -Property @{Parameter=$_.Name.trim();Wert=$_.Vorgabe;Ordnung=[INT]$_.Ordnung;Pflicht=$_.Pflicht;Multi=$_.Multi;MaxZeichen=$_.MaxZeichen;Hilfe=$_.Hilfe;Neu=1}
					}ELSE{
					If (($_.Pflicht -eq 0 -and $I -eq 0) -or $_.Multi -eq 1)
						{
						$objContextMenuStripA.items.Add($_.Menu).add_Click({
							foreach ($y in $CSVFelder){
								if ($Y.Menu -eq $this.text){
									$R= $objDataGridViewCSV.Rows.Add($y.Name,$y.Vorgabe,$y.Hilfe)
									$objDataGridViewCSV.Rows[$R].Cells[0].Style.BackColor="LightBlue"
									$objDataGridViewCSV.Rows[$R].Cells[1].Style.BackColor="LightPink"
									$objDataGridViewCSV.CurrentCell = $objDataGridViewCSV.Rows[$R].Cells[1]
									if($y.Name -ne "GROUPS"){$objDataGridViewCSV.BeginEdit($true)}
									}
								}
							})
						}

					}
				}ELSE{
					$objContextMenuStripA.items.Add($_.Menu).add_Click({
					foreach ($y in $CSVFelder){
						if ($Y.Menu -eq $this.text){
							$R= $objDataGridViewCSV.Rows.Add($y.Name,$y.Vorgabe,$y.Hilfe)
							$objDataGridViewCSV.Rows[$R].Cells[0].Style.BackColor="LightBlue"
							$objDataGridViewCSV.Rows[$R].Cells[1].Style.BackColor="LightPink"
							$objDataGridViewCSV.CurrentCell = $objDataGridViewCSV.Rows[$R].Cells[1]
							if($y.Name -ne "GROUPS"){$objDataGridViewCSV.BeginEdit($true)}
							}
						}
					})
				}
		    } 
		$Liste =$result | Sort -Property Ordnung,Wert
		$UserDom=""
		foreach($Z in $Liste){If ($Z.Parameter -eq "DOMAIN" ){$UserDom=$Z.Wert}}
		foreach($Z in $Liste){
		    $Row=$objDataGridViewCSV.Rows.Add($Z.Parameter,$Z.Wert,$Z.Hilfe)
            if ($Z.Neu){
                $objDataGridViewCSV.Rows[$Row].Cells[0].Style.BackColor="Lightblue"
                $objDataGridViewCSV.Rows[$Row].Cells[1].Style.BackColor="LightPink"
            }Else{
                If ($Z.Pflicht -eq 1 -and $Z.Wert -eq "")
                    {
                    $objDataGridViewCSV.Rows[$Row].Cells[1].Style.BackColor="LightPink"
                    }
                If ($Z.Parameter -eq "OU" )
                    {
					if ((pruefe_OU($Z.Wert)) -eq 0)
						{
						$objDataGridViewCSV.Rows[$Row].Cells[1].Style.BackColor="LightPink"
						}
					}
				If (($Z.Parameter -eq "GROUPS" ) -and $UserDom)
					{
					if ((pruefe_Gruppe $Z.Wert $UserDom) -eq "")
						{
						$objDataGridViewCSV.Rows[$Row].Cells[1].Style.BackColor="LightPink"
						}
					}
 			}
        }
		$objDataGridViewCSV.AutoResizeColumns()
        $objFormcsv.Show()
		})
    
    [void] $objComboboxFirma.Items.Clear()
    
	$Firmenliste = $csv | select-object Firma | sort firma -Unique
	foreach($f in $Firmenliste)
		{
		[void] $objComboboxFirma.Items.Add($f.firma)
        if ($f.firma -eq $uFirma){$objComboboxFirma.SelectedIndex = $objComboboxFirma.items.Count -1}
 		}
	[void] $objComboboxKonfiguration.Items.Clear()
	$Konfigurationliste = $csv | ? Firma -eq $Firma  | select-object Konfiguration | sort Konfiguration -Unique  
	foreach($C in $Konfigurationliste)
		{
     	[void] $objComboboxKonfiguration.Items.Add($c.Konfiguration)
		if ($c.Konfiguration -eq $uKonfiguration){$objComboboxKonfiguration.SelectedIndex = $objComboboxKonfiguration.items.Count -1}
		}

	$OKButtonFertig = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
#	$OKButtonFertig.Location = New-Object System.Drawing.Size(100,420)
	$OKButtonFertig.Location = New-Object System.Drawing.Size(100,620)
	$OKButtonFertig.Size = New-Object System.Drawing.Size(120,23)
	$OKButtonFertig.Text = "Sichern"
	$OKButtonFertig.Name = "Sichern"
	$OKButtonFertig.DialogResult = "OK"
	$OKButtonFertig.Visible = $false
	$OKButtonFertig.Add_Click({
		$OKButtonFertig.Enabled = $false
		$KonfigdateiSicherung = $Script:Path + "\Alt\DialogConfig"+$datum + ".csv"
		$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
		copy-item -path $Konfigdatei -Destination $KonfigdateiSicherung
		$Protokoll =  $Script:AppName
		$Protokoll = $Protokoll +$nL + "Version: " + $Script:AppVersion
		$Protokoll = $Protokoll +$nL +  "Autor: " + $Script:AppAuthor
		$Protokoll = $Protokoll +$nL + "Firma: " + $Script:Company
		$Protokoll = $Protokoll +$nL + "Versionsdatum: " + $Script:ReleaseDate
		$Protokoll = $Protokoll +$nL + "-------------------"
		$Protokoll = $Protokoll +$nL + "Skript: " + $PSCommandPath
		$Protokoll = $Protokoll +$nL + "Ausgeführt: " + $Datum
		$Protokoll = $Protokoll +$nL + "durch " + $env:UserDomain + "\"+ $env:UserName
		$Protokoll = $Protokoll +$nL + "auf " + $env:ComputerName
		$Protokoll = $Protokoll +$nL + "-------------------"
		$Protokoll = $Protokoll +$nL + "Änderung "+ $Konfigdatei
		$Protokoll = $Protokoll +$nL + "Sicherung "+ $KonfigdateiSicherung
		$Protokoll = $Protokoll +$nL + "-------------------"
		$Protokoll = $Protokoll +$nL + "Geänderte Konfiguration:"
		$Protokoll = $Protokoll +$nL + $objComboboxFirma.selecteditem.ToString()
		$Protokoll = $Protokoll +$nL + $objComboboxKonfiguration.selecteditem.ToString()
		$Protokoll = $Protokoll +$nL + "-------------------"
		$Protokoll = $Protokoll +$nL + "-------ALT---------"
		$csvaltconfig = $csv | Where-Object{($_.Firma -eq $objComboboxFirma.selecteditem.ToString()) -and ($_.Konfiguration -eq $objComboboxKonfiguration.selecteditem.ToString())}
		foreach($Z in $csvaltconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}

		$csvneu = $csv | Where-Object{($_.Firma -ne $objComboboxFirma.selecteditem.ToString()) -or ($_.Konfiguration -ne $objComboboxKonfiguration.selecteditem.ToString())} #| select-object Firma,Konfiguration,Parameter,Wert  
		foreach ($row in $objDataGridViewCSV.Rows)
			{
			$csvneu += New-Object PSObject -Property @{Firma=$objComboboxFirma.selecteditem.ToString();Konfiguration=$objComboboxKonfiguration.selecteditem.ToString(); Parameter=$row.Cells[0].value.trim();Wert=$row.Cells[1].value.trim()  }
			}
		$Protokoll = $Protokoll +$nL + "-------------------"
		$Protokoll = $Protokoll +$nL + "-------NEU---------"

		$csvneuconfig = $csvneu | Where-Object{($_.Firma -eq $objComboboxFirma.selecteditem.ToString()) -and ($_.Konfiguration -eq $objComboboxKonfiguration.selecteditem.ToString())}| Sort -Property Firma,Konfiguration,Parameter,Wert
		foreach($Z in $csvneuconfig){$Protokoll = $Protokoll +$nL + """"+ $Z.Parameter + """ = """ +$Z.Wert + """"}
		
		$csvneu | Sort -Property Firma,Konfiguration,Parameter,Wert|Select-Object Firma,Konfiguration,Parameter,Wert |export-csv ($Konfigdatei)  -Encoding default -delimiter ';' -NoTypeInformation 



	    $utf8 = New-Object System.Text.utf8encoding
#		Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "Anlegeskript Konfigurationsänderung" -body $Protokoll -SmtpServer svhd-relay.srh.de

		$Protokoll | out-file -filepath $LogFile
        })
	$objFormcsv.Controls.Add($OKButtonFertig)


	$OKButtonFertig.Visible = $true
	$objFormcsv.Visible=$false

    [void]$objFormcsv.ShowDialog()
	[void]$objFormcsv.Close()

}





Function Benutzerpruefen ($uName, $uVorname, $uPersonalnummer)
{
#Personalnummer suchen (ob Benutzer schon angelegt das kommt später)
# Wenn Benutzer gefunden
	# Benutzer korrigieren oder nichts machen

# sonst 
	# Nach Vor und Nachnamen in SRH-Forest suchen
	# Wenn gefunden
		#Nachfragen bzw. bzw. LOGfile
		# Wenn neu dann wie sonst

	$bBenutzeranlegen = $false
	$Suche_VorNachnameinSRHForest = Get-ADUser -server svhd-dc06.srh.de:3268 -Filter "(sn -eq '$uName') -and (givenname -eq '$uVorname')" 
	If($Suche_VorNachnameinSRHForest -eq $Null) {
        #$Suche_VorNachnameinSRHForest= @("Namen nicht im Forest gefunden!")
		$bBenutzeranlegen = $true
	}else{
		if ($DoppelterNameAnlegen -eq "TRUE") {
			$bBenutzeranlegen = $true
		}ELSE{
			IF ($DoppelterNameAnlegen -eq "FALSE"){
			}ELSE{
				$objFormNamegefunden =  New-Object System.Windows.Forms.Form
				$objFormNamegefunden.StartPosition = "CenterScreen"
#				$objFormNamegefunden.Size = New-Object System.Drawing.Size(800,500)
				$objFormNamegefunden.Size = New-Object System.Drawing.Size(800,700)
				$objFormNamegefunden.Text = "SRH Benutzer mit gleichem Namen gefunden"
		
$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAAFcAAAA9CAYAAADYp/VQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAhdEVYdENyZWF0aW9uIFRpbWUAMjAxOTowMzoyOSAwODoxNTozOO7qzQ4AABWaSURBVHhe7ZxpcJXndcfPvdoltLEICYlFGzIgzL54YQlgG7yAcRwvTRvHaZJOF7v90Dbth9b91g/tTGeapZO09Uynk6bt2EkTx3gBs1pCrLYBISTEKiQkIYH29Urq+Z33PtIrWcKSHWaC0d/z+N77vs96nrP8z/O+IjCgkEncEQTDn5O4A5gU7h3EpHDvICaFewcxKdw7iEnh3kEE+vv7vxAboy2luaVZys6XSUtbq2SmZ8rMtJmSnJgkMdEx4Zr3Hr6QcAOBgJVbTbdkz4EP5FDJh9LV3SWxMTGSNj1NCvILZPmS5TI3a65ERkRYG7cZ9wImLFxXNxgMmmCvXLsq7+/bLecqzpkAo6OjRfuU3lCvdPd0SygUkoT4BFm0oFA2PLBO5s6ea+39Y7rv9DcaPuv+byvG5XMHpE8X2Bf+NaSxVTXX5N0P3pUzZWckKirKBAuCEUH9HW0uISIiUuJi481FBFX4CIrCBjihsVEReo9PVwIBrwzdQ/PvLuFOQHO9haE8CLa9o112H9gjhw5/KFGRUSrMSK0RkP6Bfunr65POzk4T8NqVa2TjwxtlWupUa387oOk3Gm9Ie3u7CZW+2JRpqdMlUsdgm8c3198OjFu41KGwaEx+X9F+2XtwnwS0aXRMtCdY1UYEpD3K/QsL5ZGNm2VWela4hyH09PZKVXWVnC47LeXny+XilUvS0tIi0ar9ESrEIJYR1F3Uvjt0k3LmzpPndn5NCu8r/PIKF41FuB+d/lh27XlHmjSQYfoIQruRrq4ucw0bHlwv69W/xsfHh1t7wI0cPXHUWEVtXZ0MaJu4uDhrE6H9Yhxsks0n/L1T+5wxfbps27JVFi9YPLjJdwPGFK7zqyNxva5W3t69S86WlZrw/IJNUhPeuuUxWbN8dbi2h/LKCg1678vFy5dMMCZM9aMR6ptNmPpfUP2rzYMh9cNd61Utj4mNlUc2bJaH1jx0VwnXApp/wk47+bzRcEOOf3xCrlRdsXsAVlChwopWuuVMt7u7W6ZPmyY7Hn9qmGBraq/Lz37+3/Jv//nvUnnxgsSo+5iSkKDaHq0+1AtgtolhAdtmhuXmNtbcUG+PdCrFu9sQ1lynqd5FgtWJT07Knv0fSFraDHn68R2SlZFlZv3OnnelQv1krGoT6OzqNNPetnmraZYD2orruHL1imkqAQ9NdAGvu7tHenp6BikbGtqnPht/6/neSN2ASIlWH4yP3rz+K/LVp54x9nG3aK4J177oopxQ4a0112skOTlZnnj0cdmyfrMKJCQHDx/SZGGvCQfNY9H43Ec3PiLrHnjYOkRQRUeLdWP2aDDqUBoWp/40wtqQYLCDiVMSNdBlSH5OrmTPy5ZZMzM18fA2y6HhZoMGuotSeemClKoLysvOk+3btsvUlNS7S7gIBK56oPigCRUB9Pf164Jy5cnHnjDiX3ejzjTxzNkzpqnazhKElctWymObHlXKlGwdFh87LG+/v8uoWFxcrAmio6NDP0XycnPlgVVrZX5ugSSpgMcLNr1btXyKJiPw6btFuOZzL1+5bLTqkn4y+VjVxv7+PkmfmS5zsuZYRbToklKmSMxSlb2zs0tmZ86WVSpcBItmFx8t0qTiPenW4EYK3NPTa1QqLzdPXv2DV+SVb/+JrFyyclCwCIlNGln6+tVF9PXad+qQ4aGxLkm5WxDs0WBxq7VJQirMhLh4Ey48NVVJf3raTHMXoKGhURpv3jRfGFITRysXL1wk2XOy7f4p1ei9Hx6QtrY2idQ+cAGJiVNk55M75Vsvviy583Ks3jCBDoT0d79eDTv7MAISoeMOnUXgUihO2HcLgn1q/q0tbWa6pK1EbswdE0xJTrFK+L/GpkbTHMTA/YK8AilU3gk4Xyg5UaLCb7QghBmnpaVpANpp5wlQNidUv3A8IULBPGG7e2woLMFf3CZ/GvBibxM+VcJpu/vtMNZ1P/z3blfPD1fPlWBIza+to9UiN4vgIi4hKSlJUtQUwdWqKrlWfc0ifp/emz51ugq20D5hC5+c+VjOV1Za4EJIuIqXX/ymLCootPZusNHAQkX6w7x3iJ754Re2/553XbdIlcK1H1aCyjoiKN5v19ZZBr8pbn5uLozj2ow2roM3/pAC+NtY3zdv3RzYtfsdOaksIT4hXoXjmeGKZcuNBeBPCVLmS5XPcm+xprawCIR7tvys0bNr16tNowsXLJLtW7dLhvprM/3+UHgRnpmPhHfPmzi8+pOzpyw17tW+8O2wkuSkFEmbkSb5yhhwVW6jaIdb0zUYc8GlASyhVd0T4oKZQOcSp0yxAySH0TbczYX4wT3OM1gvtcggWY+/HsVdQ6D+dlyPhHd293ZLj/LNeHrRmzSKi441mgWTaG1rlT4Wq3UjoyIkc1amCZZgdf5CpVyrqbaFFOTPly0btphg3cSDwUj7HA1ugjca62V/0X5NjY+br8YCcBeASWItbNxjmx6TnU/ssOuu/yq1qP/b9UudR4XRPm1oa+A2XzmJ6wv1mdXl5ebL5nWblALm2bhgpIAbbzXKW+/9WkqOH9H+Yo31kM5/bcezqpWRNh/a0B6aCDOqvFhpCRX8fJP2v0WzSTbaVuCp9dBg3EjUVBbuSVrLUwY0JKSTzEibNRjEKi6Wy+ny05ZBzVTNeliTCAIXE3A7Cuhz5CKcYKtV49986xey/9AhrSMmIDYKd9PW3mbuCmEzRy/4De8vNSXFzh5oF68BGYXA79OHzUHrcbBEe2jk6z99XQ4cPmhB2cHf35SEKXaCF8+ZR5SyE93kgI7vncp58wZYOJaQoNYeqRvHuMSk+PjYQVbjqYd6IfUeJn2G8AuCxXV2dNruo/Y8vpk9yzvpqrl+3UpUdJQUqqtwAc4JzmHkbwcCH4dAnDnAnc0Edeili5fJH337D+Vv//Jv5Lsvf8dcFO3r1W3wGMn6CqBBfZb1cdYbUOFxHSHOnT1HHlyzVlYsXaFWlGHuzHiyCo7vR48flfLz53QGzGlobm7d+E0EC+2EliI4/wYAm4KVoESGN9+OXiOH6KIqrMpXG2F6JA4DuttRuvPOf/WGNE0Nqa/V6wkJCXaGwM6gcVeVJfSrQBYVLDL+6vySfxK3A+3LysskpP6SdvnKh1/57h9rMHxJ7teNYhOXFS6Vbzz3e/LPf/9P8tLzv2uLBX66xvwpaOMMnd8mTZVfePoFeemFb8hfvPLn8td/9lcaJxaronRLjPJvTL9Kx4ZLh+Wqn56QmQcuCFnwHTqJdfjh6iK6SA2m3kOAftX2BPXtSbZ+imkuOxNjJkBL8TRIOwbtStEoNJ6iQcHRs7r6erleW2vBBlqGnx0v3OTQwnZNkTErJoow52TOsYmxMFf4bU801OxHJhKk2PhFtBfL4oCeRbo++GRu9G1arqWrq1uaWlsGXYOjZoC1s94u3QgUKjYmzpTKD/qkEHNa29oH58lGpKR4mSoIRmg0xiSjmHRY4ey0ywfbUe0MH5OkOwM6utqtZGlwm5M1265NFLABRsIM+c5iRoMTlCv8dmhrb5dW9c2AexwokdE5UJVC/EBrWQdUs1ezR7QT+K3gVnOTxpgWM3HTRuXoLrV38GJUUELaR6+6GwYgX0BJ8fsOwUjlgQnqi9CekNEmlHlIuMQQZyIcFcbGxtiONTQ22v18jcCZqhVuNycC5+Ppn3GxhuraGtvMT83Dp13AaT+aC6PBJXnJj2qPWpODVrFijEgDL6duCABTj9ZY4Y0xNE6XBtKu7k5rQ9CKt6A1XHMdOns6pbNX6+o62LDExERN04ceZ6m7COpOx6svi5WBPgTEkWDIZzK60yo0IjYBAQ3o6Gw3v4WppiQlDz42nyhYJJsV0vGgMRcuV8ovoVVQG10cDMYJ2a9dfkHDKHjmRkCjPxaID0TwaBefrKdLFYLjzV5chwqVEz8YgHpq7StkfQGefHR399p6kQVmDntw/bk+QahX56EywyWhfFzlvkOQqDhj2gwj2X06YcflcP58pugk8LPwYYRIsDO/1N6hXHequoSJa62rT1SfnztfJ6s0S68TnTmI//5PfiA/feO/LO321jGi/wEW4C0CxoH2siijQipg/2ajBG/++hdyqKRIr0dZ8OTAKWderten9uVPcEhIbmmqz2ahSLyTcezj43L4eIl8eKTICkeqxceKpfzCObOaQaH7BAsiXnvttb9DWJhj/Y16c/iMmT5zpi0eDa68VGlHkVmzZkueEnAWdPzUSaVl6bJujXeOO1Gw+0wef1/XoMGxTimdai8+k0lW11yT8zou/hM65dcI2nraE5DSsrODCQR18L/nKs/JCZ1fUUmxvawC1QNobpJa2roH1smC/Pvsmh/0WVZRJud4GKD+GZA1nlZ+TIp/qvSUfp4yvnymrNTcGNPArgikC/ILJGduzqAi2IynTZ2mScBMejcNQthNzc2WQiKAZJ2QUTPVXmIdTxG6NZMaWuTE4bR33ux58swTT8vq5ats8URqAhxCrqurl5+9+T/y9p5daq4dnxqP1BoXQVDm0An3wqacOnNazpSWyuWrly3BIakAOfPmyfM7nx18FOXmAFzf8GA7Z1ElQ2hYFZ9B1W6CHEER67b3MjQ5Ya6cKJLNkWr7YcJlx3HwiepT8U99OulGNQ8EjOakJqfqIKL0pdmoEx0SNJK0/heBW1xmRqZ8/asvyjeVl85V5sECQ70hC6AEqZKjJXLyk4/CrYaAlrIZzB+FsIRHA1KPtgcELJSC1HfLxs3y6ndetcMkxsTlgWGbpb43GORswHN9HK8WzJ8vmzdsMu688aENslFT4Uc2bpG1q9aqzMJPRbQYSxkR+AZtLTMjy8ycZ1n4Js5lbzXfssEt4BHINFPjkJxd4kjSDs7DAvq8YJEUtGHxwvvl5d952XJ5IjCazFjQLRIOtNcPm48GoAjVKqjQrPRZ8vtf/5Z870+/J8uXLjOXxnXSdqgem3C7+ba0tmnhhRQNUGqlyUlJpuXbtz4lO9W6nnnqGSvbtz2lgl6v1q7yUjrm0bBY9fdjCJdnWvNz8k3dGZxggp/le1amknsNXK2treYqCIJwOg+4ErjnEE2aCJzmoCkIGRe0Y9t22bppqwm8TxfZr303tTSrJbVYXQeC1a2mm8onCUpiqTlzna1l5RJS35kqYOWz2sfRk0elRIOSM38nZD/zMK3XABWpm4DFIGSERj2nBBR+12l8orBhXMPyyV79GIoSitlqkkRSUlqoSF19nQa6aslIy5D0tFm2mJsaSQlCyUpRiM7QFRlgwuOjY25xrji470wcIGTegzCN0749SjYcsAQ4d0DHh5PirlzanpudJ3nZ+aa1WBgazqE+SQJjIRSDjy1grZaQ6C0sh8MbqOJo4OEClJR69IULg076YSO4XWTH8/PyjAfCMTmjvXDpolXk5ImBmnRy8N2p6odJPOiYybodHQ/ceG6RfiE79KrGoXVsHoGK0yfSS0B9Cj4WN6Y/rB9omLMoFpqTnSMZapHUY348hD1TdtruO7i5ANbGa1W4Ge3RYhBlNJByc2JIWzaU1HykAgz7xcTy5nEgnWE7Tgecl7LbBbkFdu/y1Ssq9GvmZzBl4BZ7O7hFEDBLjh+2l0XOVpy181vaIhwnaF4mKT1XaufIukrj4LxQTfblB+MjfNcO/0xscGMtyCuQpYsWW0AjSCE4aBYuzxAgM/R8Me1tTboJaCMZH5krQvODepSmFk2TNcDTFgvGyoZcpYdB4boJ8Th9vqa0pHP4uhp1C1XXqlRzZ8jC+xZqdG4zbZ7G6VhUjAmedobwMeBYYFJkRbxsd+rsafmX138s//CDf5Qfvv4jeeOtn8v//uoN+f6//lB+/B8/sSccugzp7urWsdPMXfkBebf3IHRoZzX0z1TcdPDZ2co7Pe3tNi58peqqcVTq8hjIf5iPhTjf77JGNms0QNVIVhgXioarpE8/hutxGMuXLNOywvxdrfpdNIxdyp6brdlaqtQq4V84/z7lpitNKxyGHQOORFjwTCZdWQmHPbqdRvcuXLwghw4flGLNonh8j8Vgll1KqRDMFqVCPD3wCw6TJMASeABUKH7YgY2nLDk65+X3L5N4pUmM16l+et+hfVJ05ENtqy4lDDaLVNrijW4KhTR6NBD4unqwOC/hMrrnO8d1GCZcNyESiiWF98uMGWk2eR7lVFw4rxx0jgp1gZltxcXzxoETfPSDtmPBL3hy9Tmz5qhvC5qfI5WG0vAcjCBF4Az19ciqZSvkhZ3PD77d2D9A5McP66Yoe+BM+Xp9rW02mskiR54VIKSFBQs1WZkrNxobrB0bePBwkVy8ctn6oiDYGs1SyVRrtN/W1hbVziFW4QcpcnVNtT3t5sVEjk7ByLqDbzl6JuXd4DsPCPfqDu/Zv9t2apVmUDuU7+GL39v3vvqYRHl8yzabvL/DzwJ9O/NBW6prr6mQalQ4nhZFR0faQ8isjNlqxp6/o3//GLTnhAvfSR8AfzctdZp9jqxLOa/KUFpeao+jFhYsGjxGdHVxg2xqm6b2lp1pIUkgoI01NgyEujCFqamp6kLihtetr68fwH/64SbEoQVPfTmoIFpv27zNspRjHx2TMxpw1qxYrfn0AuvQdUq78cCNcTvQJ/4PUNc/xljt/XNxGLuuV59bt7uv//cuKCYyrga74W6XCi5AsHOrV662M9umpmY5dvKY+V/eWUhNTpGK8xUW/V27iYAxXPBwxf8aE4U+3ULcd/9vf1t/m5FwdRkPNzc0rsc2xu6LjR3e32h9uf5GIugem7hJuwXQCSVXo+1zTz9rwYt3c9/b+7793cKm9ZskKiZafddBbeW91OH6GA/cOH6MFRBHzml8oL4nDD/84/q/TxSuret/tH5Mc/2V/HA7SIa2cd1XZLEGubPlZbK/6IDVX7poiWrbgJQpdwTjnShtRxtvJEbWc/2P1tZfl09PK71TM3ed9uOd43hAX05+oyHQ3Nw8wIPH28FNiui8a88u+eT0KVm76gF760Znbsd6U5UBTDS4fdkRaGhoGEjVSHc7OOECIioH0AeLD9qrS888udNOhzxtGfI7/Hbt/JpzLyFw8+bNAZ4n3Q4Ih4IJUKBmxcog3t79jrqMdDuGG/mKKLjXhDkSgbq6uoHp06cP07CxwH3qIWDAu1K/evctJfG1ynm3ysNrH/Ie+oU3A+DzCLjjPTX7MiHQ3t4+QF78WYIdCYRM4cjvyIkj9iIdz7r4wxP/3/eixW5TKPcSAm1tbSZcFv55BQzIWD44uNee3q5Rbvzg6gcHT7Hod6J9fxkQaGpqGuBZ/+eHJ2CnlJerLkvRkWJ7arCwYIEsXbzEEo57UcCDPvc3CXJvUueauut2mM2hCf/+wr0G09zPYguT+HyY/Bfx7iBGPSyfxG8Gk8K9YxD5f/KQNPuJqPiyAAAAAElFTkSuQmCC'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormNamegefunden.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

				$objLabelNamegefunden = New-Object System.Windows.Forms.Label
				$objLabelNamegefunden.Location = New-Object System.Drawing.Size(50,20)
				$objLabelNamegefunden.Size = New-Object System.Drawing.Size(500,100)
				$objLabelNamegefunden.Text = "Name: " + $uName + "    Vorname: " + $uVorname + "`r`n" +  " im Forest schon " + $Suche_VorNachnameinSRHForest.count + "mal angelegt." + "`r`n`r`n"+ "Bitte prüfen, ob die Person bereits angelegt ist!" + "`r`n`r`n"+ "Kein Konto anlegen für die gleiche Person!"
				$objFormNamegefunden.Controls.Add($objLabelNamegefunden)
		

				$objListboxNamegefunden = New-Object System.Windows.Forms.Listbox
				$objListboxNamegefunden.Location = New-Object System.Drawing.Size(50,150)
				$objListboxNamegefunden.Size = New-Object System.Drawing.Size(700,20)
				$objListboxNamegefunden.Visible = $true
				#$objListboxNamegefunden.SelectionMode = "Single"
#				$objListboxNamegefunden.Height = 250
				$objListboxNamegefunden.Height = 450
				[void] $objListboxNamegefunden.Items.Clear()
				$objFormNamegefunden.Controls.Add($objListboxNamegefunden)

				$OKNamegefunden = New-Object System.Windows.Forms.Button
#				$OKNamegefunden.Location = New-Object System.Drawing.Size(100,420)
				$OKNamegefunden.Location = New-Object System.Drawing.Size(100,620)
				$OKNamegefunden.Size = New-Object System.Drawing.Size(125,23)
				$OKNamegefunden.Text = "Trotzdem anlegen"
				$OKNamegefunden.Name = "Trotzdem anlegen"
				$OKNamegefunden.DialogResult = "OK"
				$OKNamegefunden.Visible = $true
				$OKNamegefunden.Add_Click( {$bBenutzeranlegen = $true
									$objFormNamegefunden.Close()
									})
				$objFormNamegefunden.Controls.Add($OKNamegefunden)
		
				$CancelNamegefunden = New-Object System.Windows.Forms.Button
#				$CancelNamegefunden.Location = New-Object System.Drawing.Size(600,420)
				$CancelNamegefunden.Location = New-Object System.Drawing.Size(600,620)
				$CancelNamegefunden.Size = New-Object System.Drawing.Size(125,23)
				$CancelNamegefunden.Text = "Abbrechen"
				$CancelNamegefunden.Name = "Abbrechen"
				$CancelNamegefunden.DialogResult = "Cancel"
				$CancelNamegefunden.Visible = $true
				#Die folgende Zeile ordnet dem Click-Event die Schlie?n-Funktion f??as Formular zu
				$CancelNamegefunden.Add_Click({$objFormNamegefunden.Close()})
				$objFormNamegefunden.Controls.Add($CancelNamegefunden)
		
				foreach ($fName in $Suche_VorNachnameinSRHForest) {
					[Void] $objListboxNamegefunden.Items.Add($fname.distinguishedname)
					}
				$bBenutzeranlegen = ($objFormNamegefunden.ShowDialog() -eq "OK")
	
			}
		}
	}
	$bBenutzeranlegen
	Return  $Suche_VorNachnameinSRHForest
}

function Variablenersetzen($Text){


$ReplaceMap = New-Object -TypeName System.Collections.Hashtable
$ReplaceMap['%Nachname%'] = $Name
$ReplaceMap['%Vorname%'] = $Vorname
$ReplaceMap['%Firma%'] = $Firma
$ReplaceMap['%Bereich%'] = $Konfiguration
$ReplaceMap['%Konfiguration%'] = $Konfiguration
$ReplaceMap['%Ablaufdatum%'] = $Endedatum
$ReplaceMap['%Email%'] = $Script:Email
$ReplaceMap['%PNR%'] = $Personalnummer
$ReplaceMap['%ID%'] = $Personalnummer
$ReplaceMap['%SAMID%'] = $sSamid

$ReplaceMap.Keys | % {$Text = $Text.Replace($_, $ReplaceMap[$_])}
$Text
}

function Synchronisieren($SyncBatch)
{
	#$Command = "$PSCommandPath\$SyncBatch"
	$Out = .\starte_manuelle_repl_SRH.bat
	$Out
}
<#
function Replikation($DC)
{
 
 repadmin /syncall $DC (Get-ADDomain -Server $dc).DistinguishedName /eP

}
#>
function Replikation($DC)
{
 
# repadmin /syncall $DC (Get-ADDomain -Server $dc).DistinguishedName /eP
#    if ($DC){
    if ($false){
        $TempfileOUt = $env:TEMP + "\AnmeldeSkriptRout.txt"
     $Tempfilerr = $env:TEMP + "\AnmeldeSkriptRerror.txt"
      $A = "/syncall " + $DC + " " + (Get-ADDomain -Server $dc).DistinguishedName + " /eP"
      $P= Start-Process -FilePath "repadmin" -ArgumentList $A -Wait -WindowStyle Hidden -RedirectStandardOutput $TempfileOUT -RedirectStandardError $Tempfilerr -passthru
      $content =Get-Content $TempfileOUt -Encoding string
      $Content
    }
}
 


function Umlauteersetzen($Text){

$ReplaceMap = New-Object -TypeName System.Collections.Hashtable
$ReplaceMap['Ä'] = 'Ae'
$ReplaceMap['Ö'] = 'Oe'
$ReplaceMap['Ü'] = 'Ue'
$ReplaceMap['ä'] = 'ae'
$ReplaceMap['ö'] = 'oe'
$ReplaceMap['ü'] = 'ue'
$ReplaceMap['ß'] = 'ss'
$ReplaceMap['é'] = 'e'
$ReplaceMap['è'] = 'e'
$ReplaceMap['ê'] = 'e'
$ReplaceMap['ó'] = 'o'
$ReplaceMap['ò'] = 'o'
$ReplaceMap['ô'] = 'o'
$ReplaceMap['á'] = 'a'
$ReplaceMap['à'] = 'a'
$ReplaceMap['â'] = 'a'
$ReplaceMap['ú'] = 'u'
$ReplaceMap['ù'] = 'u'
$ReplaceMap['û'] = 'u'
$ReplaceMap['í'] = 'i'
$ReplaceMap['ì'] = 'i'
$ReplaceMap['î'] = 'i'
$ReplaceMap['ý'] = 'y'
$ReplaceMap['ý'] = 'y'
$ReplaceMap['`'] = ''
$ReplaceMap['´'] = ''
$ReplaceMap[''''] = ''
$ReplaceMap['^'] = ''

$ReplaceMap.Keys | % {$Text = $Text.Replace($_, $ReplaceMap[$_])}
$Text
}

Function FuerSAMIDKorrigieren($TextSamid){

	$TextSamid = Variablenersetzen $TextSamid
	$TextSamid = Umlauteersetzen $TextSamid
	$TextSamid = $TextSamid.Replace(" ","")
	$TextSamid = $TextSamid.Replace("-","")
$TextSamid
}

Function AdresseKorrigieren($strWort){

	$AdresseKorrigiert = Variablenersetzen $strWort
	$AdresseKorrigiert = Umlauteersetzen $AdresseKorrigiert
	$AdresseKorrigiert = $AdresseKorrigiert.Replace(' ', '')
	$AdresseKorrigiert
}

Function ADFeldschreiben ($NewADUserLDAP,$Feld,$Value){
		$Ergebnis = "$Feld = ""$Value"" setzen"
		$error.Clear()

	Try { 
			$NewADSIUser=[ADSI]($NewADUserLDAP)
			[Void] $NewADSIUser.PUT($Feld,$Value)
			[Void] $NewADSIUser.setinfo()
		}
	catch{$ERR= $error[0].Exception}
		if ($Error){
			$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
			$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
            $Script:FehlernachAnlegen = $TRUE
			$error.Clear()
		}else{
			$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich geschrieben"
			}
			$Ergebnis
}

Function Mailboxanlegen($User, $DC ,$Connection, $Adresse)
{
	$Ergebnis = "Postfach anlegen für " + $User + " mit Adresse " + $Adresse
	$error.Clear()
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ("http://" + $Connection + "/PowerShell/")
	Import-PSSession $Session -CommandName enable-mailbox
	Try { enable-mailbox -Identity $User -domaincontroller $DC -PrimarySmtpAddress $Adresse}
	catch{$ERR= $error[0].Exception}
	$ERR= $error[0].Exception
	if ($Error){
		$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
		$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
        $Script:FehlernachAnlegen = $TRUE
		$error.Clear()
	}else{
		$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich erstellt"
		#Setze hier globale Variable für späteren eventuellen Gebrauch UPN=Mail
		$Script:Email = $Adresse
	}
	
	Remove-PSSession $Session
    $Ergebnis
}

Function Mailboxanlegenremote($User, $DC ,$Connection, $Adresse, $Adresseremote)
{
	$Ergebnis = "Postfach anlegen für " + $User + " mit Adresse " + $Adresse
	$error.Clear()
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ("http://" + $Connection + "/PowerShell/")
	Import-PSSession $Session -CommandName Enable-RemoteMailbox,Set-RemoteMailbox
	Try { 
		Enable-RemoteMailbox -Identity $User -PrimarySmtpAddress $Adresse -RemoteRoutingAddress $Adresseremote
		Set-RemoteMailbox -Identity $User -EmailAddresses @{Add=$Adresseremote}
		}
	catch{$ERR= $error[0].Exception}
	$ERR= $error[0].Exception
	if ($Error){
		$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
		$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
        $Script:FehlernachAnlegen = $TRUE
		$error.Clear()
	}else{
		$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich erstellt"
		#Setze hier globale Variable für späteren eventuellen Gebrauch UPN=Mail
		$Script:Email = $Adresse
	}
	
	Remove-PSSession $Session
    $Ergebnis
}

Function Mailkontaktanlegen($User, $DC ,$Connection, $Adresse)
{
	$Ergebnis = "Emailkontakt anlegen für " + $User + " mit Adresse " + $Adresse
	$error.Clear()
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ("http://" + $Connection + "/PowerShell/")
	Import-PSSession $Session -CommandName enable-mailuser
	Try { enable-mailuser -Identity $User -domaincontroller $DC -ExternalEmailAddress $Adresse}
	catch{$ERR= $error[0].Exception}
	if ($Error){
		$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
		$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
        $Script:FehlernachAnlegen = $TRUE
		$error.Clear()
	}else{
		$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich erstellt"
	}
	Remove-PSSession $Session
	$Ergebnis
}


Function Add-NTFSRechte ($Berechtigter, $Pfad, $Rechte)
{

	#$Ergebnis1 = "Rechte vorher"
	#$Ergebnis1
	$acl = Get-Acl $Pfad
	#Get-Acl $Pfad | Select-Object -ExpandProperty Access 

	### change SAMAccount and permissions
	$permission1 = "$Berechtigter","$Rechte", "ContainerInherit, ObjectInherit", "None", "Allow"

	### keep fingers away below
	$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission1
	$acl.SetAccessRule($accessRule)
	$acl | Set-Acl $Pfad
	Set-Acl $Pfad $acl
}

Function Heimatverzeichnisanlegen ($User, $UserDomain, $Homepath, $Homepathlokal)

{	
	$Ergebnis = "Ordner für " +$UserDomain + "\" + $User + " anlegen und Berechtigungen setzen"
	$Ergebnis = $Ergebnis + "´r´n" +   "Heimatverzeichnis: " + $Homepath
	$error.Clear()

	If ($Homepathlokal){
        #Freigabe Remote auf Server erstellen
		$error.Clear()
 		Try { 
            $leer1,$leer2,$Server,$Freigabe,$Rest = $Homepath.split("\")
            If ($Freigabe){
				# Das mit den Freigaben ist nur auf alten Servern deshalb über WMI
				#leider wird hier nicht so schön protokolliert
				New-Item -Path (("\\" + $Server + "\" + $Homepathlokal+"\"+$Freigabe).Replace(":","$")) -ItemType directory
				$share = Get-WmiObject Win32_Share -List -ComputerName $Server
				$share.create(($Homepathlokal+"\"+$Freigabe), $Freigabe, 0)
				.\setacl.exe -on "\\$Server\$Freigabe" -ot shr -actn ace -ace "n:jeder;p:full"
				$Ergebnis = $Ergebnis + "´r´n" +   "Berechtigung auf Heimatverzeichnis setzen"
				<#      so würde es auf einem neuen Server funktionieren        
				    Enter-PSSession -computername $Server
				    if(-not ($error)){
						New-Item -Path ($Homepathlokal + "\" + $Freigabe) -ItemType directory
						New-SmbShare ($Homepathlokal + "\" + $Freigabe) -Name $Freigabe -FullAccess "Everyone"
		    			exit-pssession 
			    	}#>
            }
		}
		catch{$ERR= $error[0].Exception}
		
		if ($Error){
			$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
			$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
			$Script:FehlernachAnlegen = $TRUE
			$error.Clear()

		}else{
			$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich erstellt"
			#
			#Jetzt hier noch NTFS-Berechtigungen erstellen
			Try { Add-NTFSRechte ($UserDomain + '\' + $User) (("\\" + $Server + "\" + $Homepathlokal+"\"+$Freigabe).Replace(":","$")) 'FullControl'}
			catch{$ERR= $error[0].Exception}
			if ($Error){
				$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
				$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
				$Script:FehlernachAnlegen = $TRUE
				$error.Clear()
			}else{
				$Ergebnis = $Ergebnis + "´r´n" + "Berechtigung gesetzt"
			}
		}	
		
	}Else{
		#Ordner erstellen (keine Freigabe erstellen)	
		Try { New-Item -Path $Homepath -ItemType directory}
		catch{$ERR= $error[0].Exception}
		if ($Error){
			$Ergebnis = $Ergebnis + "´r´n" + "Fehlgeschlagen - Fehlermeldung:"
			$Ergebnis = $Ergebnis + "´r´n" + $error[0].Exception
            $Script:FehlernachAnlegen = $TRUE
			$error.Clear()
		}else{
			$Ergebnis = $Ergebnis + "´r´n" + "Erfolgreich erstellt"
			#Jetzt hier noch NTFS-Berechtigungen erstellen
			$Ergebnis = $Ergebnis + "´r´n" +   "Berechtigung auf Heimatverzeichnis setzen"
			.\setacl.exe -on "$Homepath" -ot file -actn ace -ace "n:$UserDomain\$User;p:full"
			#WSHShell.run "cmd /c SetACL.exe -on """ & strHomePfad & """ -ot file -actn ace -ace ""n:"& strDomainname &"\" & strSAMID & ";p:"& strRechteHome & """>>" & strLogfileexterneProgramme,2,True
			
#			$Ergebnis = $Ergebnis + "´r´n" +   "Add-NTFSRechte ($UserDomain + '\' + $User) $Homepath 'FullControl'"
#			#10 Versuche die Berechtigung zu setzen
#			$iVersuch = 0
#			$iVersuchMAX = 35
#			While( $iVersuch -LT $iVersuchMAX){
#				$iVersuch = $iVersuch + 1
#				Try { Add-NTFSRechte ($UserDomain + '\' + $User) $Homepath 'FullControl'}
#				catch{$ERR= $error[0].Exception}
#				if ($Error){
#					$Ergebnis = $Ergebnis + "´r´n" + [string]$iVersuch +".Versuch Fehlgeschlagen - Fehlermeldung:"
#					$Ergebnis = $Ergebnis + "´r´n" + $ERR
#					$error.Clear()
#					#Warte hier ein paar Sekunden, Probleme bei NTFS-Berechtigungen setzen
#					Start-Sleep -s 30
#				}else{
#					$Ergebnis = $Ergebnis + "´r´n" + "Berechtigungnen im " + [string]$iVersuch + ". Versuch erfolgreich erstellt"
#					$iVersuch = $iVersuchMAX
#				}
#			}
		}
	}
	$Ergebnis	
}

function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}
function Get-password($AnzahlKlein,$AnzahlGross,$AnzahlZahl,$AnzahlZeichen)
{
$password = Get-RandomCharacters -length $AnzahlKlein -characters 'abcdefghikmnoprstuvwxyz'
$password += Get-RandomCharacters -length $AnzahlGross -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length $AnzahlZahl -characters '1234567890'
#$password += Get-RandomCharacters -length $AnzahlZeichen -characters '!"§$%&/()=?}][{@#*+'
#$password += Get-RandomCharacters -length $AnzahlZeichen -characters '!"§$%&/()=?#*+'
$password += Get-RandomCharacters -length $AnzahlZeichen -characters '!§$&()#*'

$password = Scramble-String $password
 
$password
}


Function Benutzeranlegen ($uName, $uVorname, $uPersonalnummer, $uEndedatum, $uFirma, $uKonfiguration, $uExterneMail, $uBenutzerpruefen, $uTicketID, $uInfoMailAdresse)
{
	#$Konfigdatei = ".\DialogConfig.csv"
	$csv = Import-Csv $Konfigdatei -Encoding Default -Delimiter ";"
	$xListe = $csv | ? Firma -eq $uFirma | ? Konfiguration -eq $uKonfiguration | select-object Parameter,Wert  
	$Datum = Get-Date -Format "dd.MM.yyyy-HH-mm-ss"
	[string]$LogFile = $Script:Path + "\LOG\" + $uname + $uvorname +$datum + "log.txt"

	# Benutzeranlegen
        # Synchronieren
		# neue SAMID finden (Schleife Erzeugen - prüfen SRH-Forest und SRHK-Forest)
		# Benutzer mit Werte anlegen
		# Synchronieren
		# Homelaufwerk anlegen
		# Profil anlegen(normalerweise nicht)
		# Mailkonto hinzufügen
		# UPN = Mail
		# Passwort setzen
		# aktivieren
	
	$objFormFertig =  New-Object System.Windows.Forms.Form
	$objFormFertig.StartPosition = "CenterScreen"
#	$objFormFertig.Size = New-Object System.Drawing.Size(800,500)
	$objFormFertig.Size = New-Object System.Drawing.Size(800,700)
	$objFormFertig.Text = "SRH Benutzer anlegen"

$iconBase64      = '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'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)
$objFormFertig.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())


	$objlabelNameFertig = New-Object System.Windows.Forms.Label
	$objlabelNameFertig.Location = New-Object System.Drawing.Size(50,20)
	$objlabelNameFertig.Size = New-Object System.Drawing.Size(200,20)
	$objlabelNameFertig.Text = "Name: " + $uName
	$objFormFertig.Controls.Add($objlabelNameFertig)

	$objlabelVornameFertig = New-Object System.Windows.Forms.Label
	$objlabelVornameFertig.Location = New-Object System.Drawing.Size(50,50)
	$objlabelVornameFertig.Size = New-Object System.Drawing.Size(200,20)
	$objlabelVornameFertig.Text = "Vorname: " + $uVorname
	$objFormFertig.Controls.Add($objlabelVornameFertig)

	$objlabelPersonalnummerFertig = New-Object System.Windows.Forms.Label
	$objlabelPersonalnummerFertig.Location = New-Object System.Drawing.Size(400,20)
	$objlabelPersonalnummerFertig.Size = New-Object System.Drawing.Size(200,20)
	$objlabelPersonalnummerFertig.Text = "Personalnummer: " + $uPersonalnummer
	$objFormFertig.Controls.Add($objlabelPersonalnummerFertig)

	#Datum des Austritts (dd.mm.yyyy, leer wenn unbegrenzt g??g):
	$objlabelEndedatumFertig = New-Object System.Windows.Forms.Label
	$objlabelEndedatumFertig.Location = New-Object System.Drawing.Size(400,50)
	$objlabelEndedatumFertig.Size = New-Object System.Drawing.Size(200,20)
	$objlabelEndedatumFertig.Text = "Datum des Austritts: " + $uEndedatum
	$objFormFertig.Controls.Add($objlabelEndedatumFertig)

	
	$objListboxFertig = New-Object System.Windows.Forms.Listbox
	$objListboxFertig.Location = New-Object System.Drawing.Size(50,80)
	$objListboxFertig.Size = New-Object System.Drawing.Size(700,20)
	$objListboxFertig.Visible = $true
	$objListboxFertig.SelectionMode = "MultiExtended"
#	$objListboxFertig.Height = 250
	$objListboxFertig.Height = 450
	[void] $objListboxFertig.Items.Clear()

	[Void] $objListboxFertig.Items.Add( $Script:AppName)
	[Void] $objListboxFertig.Items.Add("Version: " + $Script:AppVersion)
	[Void] $objListboxFertig.Items.Add( "Autor: " + $Script:AppAuthor)
	[Void] $objListboxFertig.Items.Add("Firma: " + $Script:Company)
	[Void] $objListboxFertig.Items.Add("Versionsdatum: " + $Script:ReleaseDate)
	[Void] $objListboxFertig.Items.Add("-------------------")
	[Void] $objListboxFertig.Items.Add("Skript: " + $PSCommandPath)
	[Void] $objListboxFertig.Items.Add("Ausgeführt: " + $Datum)
	[Void] $objListboxFertig.Items.Add("durch " + $env:UserDomain + "\"+ $env:UserName)
	[Void] $objListboxFertig.Items.Add("auf " + $env:ComputerName)
	[Void] $objListboxFertig.Items.Add("-------------------")
	[Void] $objListboxFertig.Items.Add("Benutzer soll angelegt werden")
	[Void] $objListboxFertig.Items.Add("Nachname: " + $uName)
	[Void] $objListboxFertig.Items.Add("Vorname: " + $uVorname)
	if ($uPersonalnummer){ [Void] $objListboxFertig.Items.Add("Personalnummer: " + $uPersonalnummer)}
	if ($uEndedatum){ [Void] $objListboxFertig.Items.Add("Endedatum: " + $uEndedatum)}
	if ($uExterneMail){ [Void] $objListboxFertig.Items.Add("Externer Mailkontakt: " + $uExterneMail)}
	[Void] $objListboxFertig.Items.Add("-------------------")


	If ($uBenutzerpruefen.count -gt 1){
		[Void] $objListboxFertig.Items.Add("Es wurden Benutzer mit dem gleichen Namen im Forest gefunden:")
		foreach ($fEintrag in $uBenutzerpruefen) {
			if ($fEintrag -ne $true){
				[Void] $objListboxFertig.Items.Add($fEintrag.distinguishedname)
			}
		}
		[Void] $objListboxFertig.Items.Add("Benutzer wird auf Anwenderwunsch dennoch angelegt!")
	}else {	[Void] $objListboxFertig.Items.Add("Es wurden keine Benutzer mit dem gleichen Namen im Forest gefunden")}
	
	[Void] $objListboxFertig.Items.Add("-------------------")
	[Void] $objListboxFertig.Items.Add("Verwende Konfiguration:")
	[void] $objListboxFertig.Items.Add($Konfigdatei)
	[void] $objListboxFertig.Items.Add($uFirma)
	[void] $objListboxFertig.Items.Add($uKonfiguration)
	[Void] $objListboxFertig.Items.Add("-------------------")
	$objFormFertig.Controls.Add($objListboxFertig)

	$objlabelTicketID = New-Object System.Windows.Forms.Label
	$objlabelTicketID.Location = New-Object System.Drawing.Size(50,560)
	$objlabelTicketID.Size = New-Object System.Drawing.Size(120,40)
	$objlabelTicketID.Text = "Ticket-ID für Infomail:"
    $objlabelTicketID.Visible = $false
	$objFormFertig.Controls.Add($objlabelTicketID)

	$objTextBoxTicketID = New-Object System.Windows.Forms.TextBox
	$objTextBoxTicketID.Location = New-Object System.Drawing.Size(200,560)
	$objTextBoxTicketID.Size = New-Object System.Drawing.Size(150,20)
	$objTextBoxTicketID.Text = $uTicketID
    $objTextBoxTicketID.Visible = $false
	$objFormFertig.Controls.Add($objTextBoxTicketID)

	$objlabelInfoAdr = New-Object System.Windows.Forms.Label
	$objlabelInfoAdr.Location = New-Object System.Drawing.Size(400,560)
	$objlabelInfoAdr.Size = New-Object System.Drawing.Size(120,40)
	$objlabelInfoAdr.Text = "Infomail an (Bei Fehlermaldung nicht an Kunden):"
    $objlabelInfoAdr.Visible = $false
	$objFormFertig.Controls.Add($objlabelInfoAdr)

	$objTextBoxInfoAdr = New-Object System.Windows.Forms.TextBox
	$objTextBoxInfoAdr.Location = New-Object System.Drawing.Size(550,560)
	$objTextBoxInfoAdr.Size = New-Object System.Drawing.Size(200,20)
	$objTextBoxInfoAdr.Text = $uInfoMailAdresse
    $objTextBoxInfoAdr.Visible = $false
	$objFormFertig.Controls.Add($objTextBoxInfoAdr)


	$OKButtonFertig = New-Object System.Windows.Forms.Button
	# Die nächsten beiden Zeilen legen die Position und die Größe des Buttons fest
#	$OKButtonFertig.Location = New-Object System.Drawing.Size(100,420)
	$OKButtonFertig.Location = New-Object System.Drawing.Size(100,620)
	$OKButtonFertig.Size = New-Object System.Drawing.Size(120,23)
	$OKButtonFertig.Text = "OK"
	$OKButtonFertig.Name = "OK"
	$OKButtonFertig.DialogResult = "OK"
	$OKButtonFertig.Visible = $false
	$OKButtonFertig.Add_Click({
		$OKButtonFertig.Enabled = $false
		$uInfoMailAdresse = $objTextBoxInfoAdr.Text.Trim()
		$uTicketID = $objTextBoxTicketID.Text.Trim()
		$OKButtonFertig.Text = "Replikation"
		$ErgebnisRepl = Replikation $strDC
		if ($uInfoMailAdresse) {
			$OKButtonFertig.Text = "Infomail"
#			Send-MailMessage -to $uInfoMailAdresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "$uTicketID - Benutzerkonto für $uVorname $uName ist angelegt" -body $Kundeninfotext -SmtpServer svhd-relay.srh.de
			}
		if ($Script:FehlernachAnlegen) {
			$OKButtonFertig.Text = "Fehlermeldungsmail"
#			Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de"  -encoding $utf8 -Subject "$uTicketID - Fehler beim Anlegen von $uVorname $uName" -Attachments $LogFile -body $Anmerkung -SmtpServer svhd-relay.srh.de
			}
		$objFormFertig.Close()
        })
	$objFormFertig.Controls.Add($OKButtonFertig)

    [void]$objFormFertig.Show()


	#Variablen zur Benutzeranlage initialisieren
	#strRootSearch = ""
	$strContext = ""
	# Gruppen mit einem Dynamischen Array
	$iGroups = 0
	$arrGroups = [System.Collections.ArrayList]@()
	# ADFELDER mit einem Dynamischen Array
	$iADFelder = 0
	$arrADFelder = [System.Collections.ArrayList]@()
	$strDC = ""
	$strReplicateBAT = ""
	$strDomain = ""
	$strHome = ""
	$strprofil = ""
	$strHomeMask = ""
	$strprofilMask = ""
	$strHomeDrive = ""
	$strSAMIDMask = "%SAMID%"
	$strUSERdisplayMask = ""
	$strRechteHome = ""
	$strHomeFreigabePfadlokal = ""
	$strEMAILMask= ""
	$strExchangeServer = ""
	$strUserDeskMask = ""
	$strPwd  = ""
	$iAnteilNachname  = 6
	$iAnteilVorname  = 2
	$iAktiv = 1
	$strSMTPAddress = ""
	$strAddsmtpAddress = ""

#	$ID = ""
#	$strNachname = ""
#	$strVorname = ""
#	$strBereich = ""
#	$strAblaufdatum = ""
#	$strKartennummer = ""
#	$strDistinguishedName = ""

	#Parameter setzen
	[void] $objListboxFertig.Items.Add("Setze Parameter:")

	foreach($Z in $XListe)
		{
		[void] $objListboxFertig.Items.Add($Z.Parameter + " = " + $Z.Wert)
		switch ( $Z.Parameter.ToUpper().Trim() )
			{
			#"ROOTSEARCH"{ $strRootSearch = $Z.Wert.Trim()}
			"OU" { $strContext = $Z.Wert.Trim()}
			"GROUPS" { $arrGroups.Add($Z.Wert.Trim())}
			"ADFELDER" { $arrADFelder.Add($Z.Wert.Trim())}
			"DC" { $strDC = $Z.Wert.Trim()}
			"SAMIDMASK" { $strSAMIDMask = $Z.Wert.Trim()}
			"DOMAIN" { $strDomainname = $Z.Wert.Trim()}
			"HOME" { $strHomeMask = $Z.Wert.Trim()}
			"PROFIL" { $strprofilMask = $Z.Wert.Trim()}
			"HOMEDRIVE" { $strHomeDrive = $Z.Wert.Trim()}
			"USERDISPLAYMASK" { $strUSERdisplayMask = $Z.Wert.Trim()}
			"EMAILADRESSEMASK" { $strEMAILMask = $Z.Wert.Trim()}
			"EMAILADRESSEMASKREMOTE" { $strEMAILMaskRemote = $Z.Wert.Trim()}
			"RECHTEHOME" { $strRechteHome = $Z.Wert.Trim()}
			"HOMEFREIGABEPFADLOKAL" { $strHomeFreigabePfadlokal = $Z.Wert.Trim()}
			"EXTERNEMAILADRESSE" { $strExterneMail = $Z.Wert.Trim()}
			"EXCHANGESERVER" { $strExchangeServer = $Z.Wert.Trim()}
			"BESCHREIBUNGSMASK" { $strUserDeskMask = $Z.Wert.Trim()}
			"PASSWORT" { 
				$strPwd = $Z.Wert.Trim()
				$RND,[INT]$Pklein,[INT]$Pgross,[INT]$Pzahl,[INT]$Pzeichen = $strPwd.split("\")
				if ($Rnd.ToUpper() -eq "RND") {$strPwd = get-password $Pklein $Pgross $Pzahl $Pzeichen}
			}
			"ANTEILNACHNAME" { $iAnteilNachname = [int]$Z.Wert.Trim()}
			"ANTEILVORNAME" { $iAnteilVorname = [int]$Z.Wert.Trim()}
			"AKTIV" { $iAktiv = [int]$Z.Wert}
			}
		}

	[void] $objListboxFertig.Items.Add("---------")
    [void] $objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$true)
    [void] $objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$false)



	# neue SAMID finden (Schleife Erzeugen - prüfen SRH-Forest und SRHK-Forest)
	$bSAMIDgefunden = $False
    $iSamid = 2
	If ($iAnteilNachname -GT (FuerSAMIDKorrigieren($uName)).Length){$iAnteilNachname=(FuerSAMIDKorrigieren($uName)).Length}
	If ($iAnteilVorname -GT (FuerSAMIDKorrigieren($uVorname)).Length){$iAnteilVorname=(FuerSAMIDKorrigieren($uVorname)).Length}
    $sSamid = (FuerSAMIDKorrigieren($uName)).Substring(0,$iAnteilNachname) +  (FuerSAMIDKorrigieren($uVorname)).Substring(0,$iAnteilVorname)
    $sSamid = $strSAMIDMask.Replace("%SAMID%",$sSamid)
	While( !$bSAMIDgefunden) {
	    $Suche_SAMIDSRHForest = Get-ADUser -server svhd-dc06.srh.de:3268 -Filter "(samAccountName -eq '$sSamid')" 
	    If($Suche_SAMIDSRHForest -eq $Null) {
#    		$Suche_SAMIDSRHKForest = Get-ADUser -server svhd-dc1.srhk.srh.de:3268 -Filter "(samAccountName -eq '$sSamid')"
#            If($Suche_SAMIDSRHKForest -eq $Null){
                $bSAMIDgefunden = $true
#            }
            
        }
        if (!$bSAMIDgefunden)
        {$sSamid=((FuerSAMIDKorrigieren($uName)).Substring(0,$iAnteilNachname) + (FuerSAMIDKorrigieren($uVorname)).Substring(0,$iAnteilVorname)).Substring(0,($iAnteilNachname + $iAnteilVorname - ([string]$iSamid).Length))+([string]$iSamid)
        $sSamid = $strSAMIDMask.Replace("%SAMID%",$sSamid)
		$iSamid++}
    }
    

	# Benutzer mit Werte anlegen
     [void] $objListboxFertig.Items.Add("Benutzerkonto $sSamid wird angelegt")
     $objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$true)
     $objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$false)
     $sDiplayname = Variablenersetzen $strUSERdisplayMask
     [void] $objListboxFertig.Items.Add("New-ADUser -Name $sDiplayname -SamAccountName $sSamid -Surname $uName -GivenName $uVorname -DisplayName $sDiplayname -Server $strDC -Path $strContext ")
     $error.Clear()
     Try {New-ADUser -Name $sDiplayname -SamAccountName $sSamid -Surname $uName -GivenName $uVorname -DisplayName $sDiplayname -Server $strDC -Path $strContext }
     catch{$ERR= $error[0].Exception}
     if ($Error){
        $objListboxFertig.Items.Add("---------")
        $objListboxFertig.Items.Add("Benutzer konnte nicht angelegt werden Fehlermeldung:")
        $objListboxFertig.Items.Add($error[0].Exception)
        $objListboxFertig.Items.Add("---------")
		$Script:FehlernachAnlegen = $TRUE
        $error.Clear()
		$Script:Ausgabezeile = "$uName;$uVorname;$uFirma;$uKonfiguration;;;;;Benutzer konnte nicht angelegt werden"
		$Anmerkung = "Erstellt mit " + $Script:AppName
		$Anmerkung = $Anmerkung + $nL + "Version: " + $Script:AppVersion
		$Anmerkung = $Anmerkung + $nL + "Autor: " + $Script:AppAuthor
		$Anmerkung = $Anmerkung + $nL + "Firma: " + $Script:Company
		$Anmerkung = $Anmerkung + $nL + "Versionsdatum: " + $Script:ReleaseDate
		$Anmerkung = $Anmerkung + $nL + "-------------------"
		$Anmerkung = $Anmerkung + $nL + "Skript: " + $PSCommandPath
		$Anmerkung = $Anmerkung + $nL + "Logfile: " + $LogFile
		$Anmerkung = $Anmerkung + $nL + "Fehler am " + $Datum
		$Anmerkung = $Anmerkung + $nL + "durch " + $env:UserDomain + "\"+ $env:UserName
		$Anmerkung = $Anmerkung + $nL + "auf " + $env:ComputerName
		$Anmerkung = $Anmerkung + $nL + "Fehlermeldung:"
		$Anmerkung = $Anmerkung + $nL + $error[0].Exception

# Mehr infos zu Fehler über
# $error[0] | format-list * -force

     }Else{
		$NewADUser = Get-ADUser -Identity $sSamid -Server $strDC
		$objListboxFertig.Items.Add("Benutzer angelegt: " + $NewADUser.DistinguishedName)
        $objListboxFertig.Items.Add("---------")
		
	#UPN erstmal mit SamaccountName falls Postfachanlgelegt dann UPN = Email (erst zu einem Späteren Zeitpunkt wenn UPN in der SRH umgestellt wird)
		$ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) "userPrincipalName" ($sSamid + "@" + $strDomainname)
		$ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
		$objListboxFertig.Items.Add("---------")

	# AD-Replikation
        
		$ErgebnisRepl = Replikation $strDC
		$ErgebnisRepl -split('´r´n') | %{if($_ -ne '') {$objListboxFertig.Items.Add($_)}}
		$objListboxFertig.Items.Add("---------")
		$objFormFertig.Show
        
		
	# Mail 
		If ($strExchangeserver){
			If ($uExterneMail){
				#$ErgebnisMailkontakt = Mailkontaktanlegen $sSamid $strDC $strExchangeserver $uExterneMail
				$ErgebnisMailkontakt = Mailkontaktanlegen $NewADUser.DistinguishedName $strDC $strExchangeserver $uExterneMail
				$ErgebnisMailkontakt -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
				$objListboxFertig.Items.Add("---------")
				$objFormFertig.Show
			}ELSEif($strEMAILMask)
                {
				$EmailadresseNeu = AdresseKorrigieren ($strEMAILMask)
				$bMailgefunden = $FALSE
				[Int]$iEmail = 2
				#Suchenob eindeutig
				While( !$bMailgefunden) {
					$Suche_MAILSRHForest = Get-ADUser -server svhd-dc06.srh.de:3268 -Filter "(proxyAddresses -eq 'smtp:$EmailadresseNeu')" 
					If($Suche_MAILSRHForest -eq $Null) {
						$bMailgefunden = $true
						if ($strEMAILMaskRemote) {
							$strEMAILMaskRemote = AdresseKorrigieren ($strEMAILMaskRemote)
							$ErgebnisMailbox = Mailboxanlegenremote $NewADUser.DistinguishedName $strDC $strExchangeserver $EmailadresseNeu $strEMAILMaskRemote
							$ErgebnisMailbox -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
							$objListboxFertig.Items.Add("---------")
							$objFormFertig.Show
						}Else{
							#$ErgebnisMailbox = Mailboxanlegen $sSamid $strDC $strExchangeserver $EmailadresseNeu
							$ErgebnisMailbox = Mailboxanlegen $NewADUser.DistinguishedName $strDC $strExchangeserver $EmailadresseNeu
							$ErgebnisMailbox -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
					  
							$objListboxFertig.Items.Add("---------")
							$objFormFertig.Show
						}
					}Else{
						$EmailadresseNeu=AdresseKorrigieren ($strEMAILMask.Replace('%Nachname%','%Nachname%' + [string]$iEmail))
						$iEmail++
					}
				}
			}
		}
	# Homelaufwerk 
        If ($strHomeMask){
		    #Pfad in AD eintragen
		    $ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) "Homedirectory" (Variablenersetzen $strHomeMask)
		    $ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
		    $objListboxFertig.Items.Add("---------")
		    $ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) "HomeDrive" ($strHomeDrive)
		    $ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
		    $objListboxFertig.Items.Add("---------")
		    #Pfad anlegen
			$ErgebnisHomeanlegen = Heimatverzeichnisanlegen $sSamid $strDomainname  (Variablenersetzen $strHomeMask) $strHomeFreigabePfadlokal
			if (-not ($ErgebnisHomeanlegen.Contains( "SetACL finished successfully."))){
				$Script:FehlernachAnlegen = $TRUE
				$ErgebnisHomeanlegen = $ErgebnisHomeanlegen + "´r´n" +   "Berechtigung auf Heimatverzeichnis fehlgeschlagen"
				}Else{$ErgebnisHomeanlegen = $ErgebnisHomeanlegen + "´r´n" +   "Berechtigung auf Heimatverzeichnis erfolgreich gesetzt"}
			$ErgebnisHomeanlegen -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
			$objListboxFertig.Items.Add("---------")
			$objFormFertig.Show
		}
	# Profil
        If ($strprofilMask){ 
		    #Pfad in AD eintragen
			$ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) "profilePath" (Variablenersetzen $strprofilMask)
			$ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
			$objListboxFertig.Items.Add("---------")
			#Pfad anlegen(normalerweise nicht)
		}
	# Passwort setzen
		if ($strPwd){
			$error.Clear()
			Try {  Set-ADAccountPassword -Identity $sSamid -server $strDC -NewPassword (ConvertTo-SecureString -AsPlainText $strPwd -force) -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon $True }
			catch{$ERR= $error[0].Exception}
			if ($Error){
				$objListboxFertig.Items.Add("Kennwort konnte nicht gesetzt werden:")
				$objListboxFertig.Items.Add($error[0].Exception)
				$objListboxFertig.Items.Add("---------")
				$Script:FehlernachAnlegen = $TRUE
				$error.Clear()
			}Else{
				$objListboxFertig.Items.Add("Initialkennwort gesetzt, muss bei der ersten Anmeldung geändert werden: " + $strPwd )
				$objListboxFertig.Items.Add("---------")
				$error.Clear()
			}
		}

	# aktivieren
		if ($iAktiv -eq 1){
			Try {  Enable-ADAccount -Identity $sSamid -server $strDC }
			catch{$ERR= $error[0].Exception}
			if ($Error){
				$objListboxFertig.Items.Add("Benutzer konnte nicht aktiviert werden:")
				$objListboxFertig.Items.Add($error[0].Exception)
				$objListboxFertig.Items.Add("---------")
				$Script:FehlernachAnlegen = $TRUE
				$error.Clear()
			}Else{
				$objListboxFertig.Items.Add("Benutzer ist aktiviert: " + $sSamid )
				$objListboxFertig.Items.Add("---------")
				$error.Clear()
			}
		}

	# Endedatum setzen
		if ($uEndedatum){
			$objListboxFertig.Items.Add("Eintragen der Ablaufdatum " + $uEndedatum + " bei " + $sSamid)
			Try{$Ablaufdatum = ((get-date $uEndedatum).AddDays(1)).ToString("dd.MM.yyyy 00:00:00")}
			catch{$ERR= $error[0].Exception}
			if ($Error){
				$objListboxFertig.Items.Add("Gültiges Datum im Format dd.MM.yyyy angeben!")
				$objListboxFertig.Items.Add("Datum wird nicht gesetzt")
				$objListboxFertig.Items.Add("---------")
				$Script:FehlernachAnlegen = $TRUE
				$error.Clear()
			}Else{
				Try{Set-ADAccountExpiration -Identity $sSamid -server $strDC -DateTime $Ablaufdatum}
				catch{$ERR= $error[0].Exception}
				if ($Error){
					$objListboxFertig.Items.Add("Datum konnte nicht gesetzt werden:")
					$objListboxFertig.Items.Add($error[0].Exception)
					$objListboxFertig.Items.Add("---------")
					$Script:FehlernachAnlegen = $TRUE
					$error.Clear()
				}Else{
					$objListboxFertig.Items.Add("Datum ist eingetragen" )
					$objListboxFertig.Items.Add("---------")
					$error.Clear()
				}
			}

		}
		# Gruppen hinzufügen
		ForEach($Gruppenzuweisung in $arrGroups){
			Try {If (($Gruppenzuweisung -Split(',DC=')).count -gt 1) {
				#Gruppe mit DistiguishedName angegeben
					$GServer = ""
					$Gruppenzuweisung -split(',dc=') | %{if( -not($_ -like "??=*")){$GServer=$Gserver+"."+$_}}
					$GServer = $Gserver.Substring(1)
					#Add-ADGroupMember -Identity (Get-AdGroup $Gruppenzuweisung -Server $Gserver) -Members $NewADUser.DistinguishedName -Server $strDC
					Add-ADGroupMember $Gruppenzuweisung -Server $Gserver -Members (get-ADuser -Identity $sSamid -Server $strDC)
				} ElseIf (($Gruppenzuweisung.Split('\')).count -eq 1) {
				#Gruppe nur mit Namen angegeben (Also wohl selbe Domäne)
					Add-ADGroupMember -Identity $Gruppenzuweisung -Members $NewADUser.DistinguishedName -Server $strDC
				} ElseIf (($Gruppenzuweisung.Split('\')).count -eq 2){
				#Gruppe mit xxx\Gruppe angegeben
					$Gserver= ($Gruppenzuweisung.Split("\"))[0]
					$Gruppe = ($Gruppenzuweisung.Split("\"))[1]
					Add-ADGroupMember $Gruppe -Server $Gserver -Members (get-ADuser -Identity $sSamid -Server $strDC)
				} Else {
				#Gruppe falsch angegeben
					$objListboxFertig.Items.Add("Gruppe im falschen Format: " + $Gruppenzuweisung )
					$objListboxFertig.Items.Add("---------")

				}
			}
				#zuvor nur innerhalb der Domäne mit 
				#Add-ADGroupMember -Identity $Gruppenzuweisung -Members $NewADUser.DistinguishedName -Server $strDC
			catch{$ERR= $error[0].Exception}

			if ($Error){
				$objListboxFertig.Items.Add("Benutzer konnte nicht in "+ $Gruppenzuweisung + " aufgenommen werden - Fehlermeldung:")
				$objListboxFertig.Items.Add($error[0].Exception)
				$objListboxFertig.Items.Add("---------")
				$Script:FehlernachAnlegen = $TRUE
				$error.Clear()
			}Else{
				$objListboxFertig.Items.Add("Benutzer ist jetzt in Gruppe: " + $Gruppenzuweisung )
				$objListboxFertig.Items.Add("---------")
				$error.Clear()
			}
		}

	# AD felder setzen
		ForEach($ADfeldzuweisung in $arrADFelder){ 
			$Feldname =''
			$Feldwert =''
			$Feldname,$Feldwert = $ADfeldzuweisung.split(';')
			$Feldname = $Feldname.Trim() 
			$Feldwert = Variablenersetzen($Feldwert.Trim())

			if ($Feldname){
				$ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) $Feldname $Feldwert
				$ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
				$objListboxFertig.Items.Add("---------")
				$objFormFertig.Show
			}
		}

<#
    $objListboxFertig.Items.Add("Info für Kunden")
    $objListboxFertig.Items.Add("********************")
    $objListboxFertig.Items.Add("Name: " + $uName)
    $objListboxFertig.Items.Add("Vorname: " + $Vorname )
    $objListboxFertig.Items.Add("********************")
    $objListboxFertig.Items.Add("Domäne: " + $strDomainname)
    $objListboxFertig.Items.Add("Anmeldename: " + $sSamid)
    $objListboxFertig.Items.Add("Kennwort: " + $strPwd)
    $objListboxFertig.Items.Add("Kennwort muss bei der ersten Anmeldung geändert werden!")
	IF ($EmailadresseNeu){
		$objListboxFertig.Items.Add("********************")
		$objListboxFertig.Items.Add("E-mail: " + $EmailadresseNeu)
		}
	$objListboxFertig.Items.Add("---------")
#>
    $Kundeninfotext = "Neues Benutzerkonto ist angelegt:"
    $Kundeninfotext = $Kundeninfotext + $nL + "********************"
    $Kundeninfotext = $Kundeninfotext + $nL + "Name: " + $uName
    $Kundeninfotext = $Kundeninfotext + $nL + "Vorname: " + $uVorname 
    $Kundeninfotext = $Kundeninfotext + $nL + "********************"
    $Kundeninfotext = $Kundeninfotext + $nL + "Domäne: " + $strDomainname
    $Kundeninfotext = $Kundeninfotext + $nL + "Anmeldename: " + $sSamid
    $Kundeninfotext = $Kundeninfotext + $nL + "Kennwort: " + $strPwd
    $Kundeninfotext = $Kundeninfotext + $nL + "Kennwort muss bei der ersten Anmeldung geändert werden!"
    $Kundeninfotext = $Kundeninfotext + $nL + "********************"
	
	IF ($EmailadresseNeu){
		IF($Script:Email){
			$Kundeninfotext = $Kundeninfotext + $nL + "E-mail: " + $Script:Email
			$Script:Ausgabezeile = "$uName;$uVorname;$uFirma;$uKonfiguration;$strDomainname;$sSamid;$strPwd;$Script:Email"
		}
		Else{
			$Kundeninfotext = $Kundeninfotext + $nL + "E-mail: Postfach " + $EmailadresseNeu + "konnte nicht erstellt werden"
			$Script:Ausgabezeile = "$uName;$uVorname;$uFirma;$uKonfiguration;$strDomainname;$sSamid;$strPwd;Fehler beim Postfach anlegen:$EmailadresseNeu"
		}
	}Else{
		$Script:Ausgabezeile = "$uName;$uVorname;$uFirma;$uKonfiguration;$strDomainname;$sSamid;$strPwd;"
	}
	if ($Script:FehlernachAnlegen) {
		$Script:Ausgabezeile=$Script:Ausgabezeile+";Fehler beim Anlegen aufgetreten"
	}Else{
		$Script:Ausgabezeile=$Script:Ausgabezeile+";OK"
	}
	
	$Kundeninfotext -split($nL) | %{$objListboxFertig.Items.Add($_)}
	$objListboxFertig.Items.Add("---------")

	

		
	# Info-Feld mit Erstellungdaten füllen
	$Anmerkung = "Erstellt mit " + $Script:AppName
	$Anmerkung = $Anmerkung + $nL + "Version: " + $Script:AppVersion
	$Anmerkung = $Anmerkung + $nL + "Autor: " + $Script:AppAuthor
	$Anmerkung = $Anmerkung + $nL + "Firma: " + $Script:Company
	$Anmerkung = $Anmerkung + $nL + "Versionsdatum: " + $Script:ReleaseDate
	$Anmerkung = $Anmerkung + $nL + "-------------------"
	$Anmerkung = $Anmerkung + $nL + "Skript: " + $PSCommandPath
	$Anmerkung = $Anmerkung + $nL + "Logfile: " + $LogFile
	$Anmerkung = $Anmerkung + $nL + "Benutzer erstellt am " + $Datum
	$Anmerkung = $Anmerkung + $nL + "durch " + $env:UserDomain + "\"+ $env:UserName
	$Anmerkung = $Anmerkung + $nL + "auf " + $env:ComputerName

	$ErgebnisADFeldschreiben = ADFeldschreiben ("LDAP://" + $strDC + "." + $strDomainname + "/" + $NewADUser.DistinguishedName) "adminDescription" $Anmerkung
    $ErgebnisADFeldschreiben -split('´r´n') | %{$objListboxFertig.Items.Add($_)}
	$objListboxFertig.Items.Add("---------")
    }

	$Protokoll = ""
	foreach ($Zeile in $objListboxFertig.Items){
		$Protokoll = $Protokoll +$nL + $Zeile.ToString()
	}
	$Protokoll | out-file -filepath $LogFile

	if ($Script:FehlernachAnlegen) {
		$objListboxFertig.Items.Add("Es sind Fehler nach dem Anlegen des Benutzers augetreten!")
		$objListboxFertig.Items.Add("Informationen im Logfile.")
		$objListboxFertig.Items.Add("---------")
		$objListboxFertig.BackColor = "LightPink"
		$OKButtonFertig.Text = "OK - Logfile!"
		$OKButtonFertig.BackColor = "LightPink"
	}
	$objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$true)
	$objListboxFertig.SetSelected(($objListboxFertig.Items.Count)-1,$false)
	$objTextBoxTicketID.Visible = $true
	$objlabelTicketID.Visible = $true
	$objTextBoxInfoAdr.Visible = $true
	$objlabelInfoAdr.Visible = $true
	$OKButtonFertig.Visible = $true
	$objFormFertig.Visible=$false

	$utf8 = New-Object System.Text.utf8encoding
	#$ASCII = New-Object System.Text.ASCIIEncoding

    If ($Script:manuellerAblauf){
		[Void] $objFormFertig.ShowDialog()
		[Void] $objFormFertig.Close()
        [Void] $objFormFertig.Dispose()
	}Else{
		[Void] $objFormFertig.Close()
        [Void] $objFormFertig.Dispose()
		if ($uInfoMailAdresse) {
#			Send-MailMessage -to $uInfoMailAdresse -from "BenutzerAnlegeSkript@srh.de" -encoding $utf8 -Subject "$uTicketID - Benutzerkonto für $uVorname $uName ist angelegt" -body $Kundeninfotext -SmtpServer svhd-relay.srh.de
			}

		if ($Script:FehlernachAnlegen) {
#			Send-MailMessage -to $Fehlermailadresse -from "BenutzerAnlegeSkript@srh.de"  -encoding $utf8 -Subject "$uTicketID - Fehler beim Anlegen von $uVorname $uName" -Attachments $LogFile -body $Anmerkung -SmtpServer svhd-relay.srh.de
			}
		If ($Ausgabeliste){$Script:Ausgabezeile| Add-content $Ausgabeliste}
	}
}


function Finde_DomainDC($OU)
{
 	#Domain (Domain) bestimmen
	$Domain = ""
	$OU -split(',dc=') | %{if( -not($_ -like "??=*")){$Domain=$Domain+",DC="+$_}}
	$Domain = $Domain.Substring(1)
    $Domain
}

#$U=get-aduser $env:UserName -server $env:UserDomain -property memberOF 
#foreach($M in $U.MemberOf){if ($M -like "CN=BOperatorAnlegeskript*"){$Script:AdminAblauf=$true}}
$Script:AdminAblauf=$true
If($Eingabeliste){
	$Benutzer = Get-Content $Eingabeliste -Encoding:string | convertfrom-csv -delimiter ";" 

	Foreach($B in $Benutzer ){ 
		$Vorname = $B.Vorname 
		$Name = $B.Name 
		$Firma = $B.Firma 
		$Konfiguration = $B.Konfiguration 
		$Personalnummer = $B.Personalnummer
		$Endedatum = $B.Endedatum
		$ExterneMail = $B.ExterneMail
		Main
	}
}Else{
	Main
	$Script:Ausgabezeile
}