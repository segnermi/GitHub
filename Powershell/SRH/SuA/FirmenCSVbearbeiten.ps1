#requires -Version 5.0
# =================================================================================
# Beschreibung: Bearbeitung der Firmen CSVs mit PowerShell  
# Erstellt von: Bernd Buchert <bernd.buchert@srh.de>
#               Ralf Serwane <ralf.serwane@srh.de>
# Erstellt am:  08.03.2022
# Geändert am:  11.04.2022
#
# Notizen:      Damit das Skript mit PowerShell 5 und PowerShell 7 läuft, muss
#               diese Datei in UTF-8-BOM kodiert gespeichert werden!
# =================================================================================
#region Namensräume und Standardeinstellungen
using namespace System.Collections
using namespace System.Drawing
using namespace System.IO
using namespace System.Management.Automation
using namespace System.Reflection
using namespace System.Windows.Forms
[void] [Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [Assembly]::LoadWithPartialName('System.Drawing')
Set-StrictMode -Version 'Latest'
$ErrorActionPreference = [ActionPreference]::Continue
$Script:Title = 'Firmen CSVs bearbeiten'
if ($PSEdition -eq 'Desktop') {
    $Script:Encoding = 'Default'
} else {
    $Script:Encoding = 'Latin1'
}
#endregion
#region Klassen und Funktionen
function SelectCsvFile () {
    $data = [PSCustomObject] @{
        Result   = [DialogResult]::Cancel
        Filename = $null
    }
    $csvFilesSearch = @{
        SRH      = '\\svhd-dc05.srh.de\FirmenCSV'
        KLINIKEN = '\\svhd-dc22.kliniken.srh.de\FirmenCSV'
        EDU      = '\\svhd-dc35.edu.srh.de\FirmenCSV'
        SRHK     = '\\svhd-dc12.srhk.srh.de\FirmenCSV'
    }
    $formDateiwahl = [Form]::new()
    $buttonOkOeffnen = [Button]::new()
    $comboBoxCsvFiles = [ComboBox]::new()
    $formDateiwahl.Size = [Size]::new(600, 195)
    $formDateiwahl.Text = $Script:Title
    $formDateiwahl.FormBorderStyle = [FormBorderStyle]::FixedSingle
    $formDateiwahl.MinimizeBox = $false
    $formDateiwahl.MaximizeBox = $false
    if ($csvFilesSearch.Values -like '*Skripte*') {
        $formDateiwahl.Text = 'ACHTUNG: Testmodus'
        $formDateiwahl.BackColor = [Color]::LightCoral
    }
    $buttonOkOeffnen.Location = [Point]::new(490, 120)
    $buttonOkOeffnen.Size = [Size]::new(80, 23)
    $buttonOkOeffnen.Text = 'Öffnen'
    $buttonOkOeffnen.Enabled = $false
    $buttonOkOeffnen.Add_Click({
            $data.Result = [DialogResult]::OK
            $formDateiwahl.Close()
        })
    $comboBoxCsvFiles.Location = [Point]::new(20, 80)
    $comboBoxCsvFiles.Size = [Size]::new(552, 20)
    $comboBoxCsvFiles.Height = 400
    $comboBoxCsvFiles.DropDownStyle = [ComboBoxStyle]::DropDownList
    $comboBoxCsvFiles.Add_SelectedIndexChanged({
            $data.Filename = $comboBoxCsvFiles.Text
            $buttonOkOeffnen.Enabled = $true
        })
    $groupBoxDomain = [GroupBox]::new()
    $groupBoxDomain.Location = [Point]::new(20, 20)
    $groupBoxDomain.Size = [Size]::new(555, 40)
    $groupBoxDomain.text = 'Domäne auswählen'
    $groupBoxDomain.Visible = $true
    $radioButtonLocation = [Point]::new(15, 15)
    foreach ($domain in 'SRH', 'KLINIKEN', 'EDU', 'SRHK') {
        $radioButtonDomain = [RadioButton]::new()
        $radioButtonDomain.Location = $radioButtonLocation
        $radioButtonDomain.Size = [Size]::new(80, 20)
        $radioButtonDomain.Text = $domain
        $radioButtonDomain.Add_CheckedChanged({
                if ($this.Checked) {
                    $comboBoxCsvFiles.Items.Clear()
                    try {
                        # Die Verzeichnisse mit Sicherungen können evtl. umbenannt oder gelöscht werden, um den Filter zu vereinfachen
                        $csvFiles = (Get-ChildItem -Path $csvFilesSearch[$this.Text] -File -Recurse -Filter '*.csv' -Exclude '_*' -ErrorAction Stop).FullName |
                            Where-Object { $_ -notlike '*Sicherung_CSV*' -and $_ -notlike '*Archiv*' -and $_ -notlike '*Aufraeumaktion*' `
                                    -and $_ -notlike '*save_*' -and $_ -notlike '*backup*' -and $_ -notlike '*\Alt\*' }
                        foreach ($csvFile in $csvFiles) {
                            [void] $comboBoxCsvFiles.Items.Add($csvFile)
                        }
                    } catch {
                        [void] [MessageBox]::Show("Kein Zugriff auf '$($csvFilesSearch[$this.Text])' möglich!" , $Script:Title, [MessageBoxButtons]::OK, [MessageBoxIcon]::Stop)
                    }
                }
            })
        $groupBoxDomain.Controls.Add($radioButtonDomain)
        $radioButtonLocation.X += 100
    }
    $formDateiwahl.Controls.Add($comboBoxCsvFiles)
    $formDateiwahl.Controls.Add($buttonOkOeffnen)
    $formDateiwahl.Controls.Add($groupBoxDomain)
    [void] $formDateiwahl.ShowDialog()
    return @(
        $data.Result
        $data.Filename
    )
}
#endregion
$removeBackupAfterDays = 360
$result, $filename = SelectCsvFile
if ($result -eq [DialogResult]::OK) {
    $formMain = [Form]::new()
    $formMain.Size = [Size]::new(800, 600)
    $formMain.Text = $filename
    $formMain.WindowState = [FormWindowState]::Maximized
    $contextMenuStrip = [ContextMenuStrip]::new()
    $dataGrid = [DataGridview]::new()
    $dataGrid.Location = [Size]::new(20, 10)
    $dataGrid.Size = [Size]::new(700, 600)
    $dataGrid.ContextMenuStrip = $contextMenuStrip
    $dataGrid.MultiSelect = $true
    $dataGrid.ColumnHeadersHeightSizeMode = [DataGridViewColumnHeadersHeightSizeMode]::AutoSize
    $dataGrid.SelectionMode = [DataGridViewSelectionMode]::FullRowSelect
    $dataGrid.RowHeadersVisible = $false
    $dataArray = [ArrayList]::new()
    try {
        $csvData = @(Import-Csv -Path $filename -Delimiter ';' -Encoding $Script:Encoding -ErrorAction Stop)
    } catch {
        [void] [MessageBox]::Show('Datei nicht gefunden!' , $Script:Title, [MessageBoxButtons]::OK, [MessageBoxIcon]::Stop)
        Exit
    }
    $dataArray.AddRange($csvData)
    $dataGrid.DataSource = $dataArray
    $dataGrid.Add_CellContextMenuStripNeeded({
            $dataGrid.ClearSelection()
            $dataGrid.Rows[$_.Rowindex].Selected = $true
            $dataGrid.Refresh()
        })
    $dataGrid.Add_VisibleChanged({
            for ($i = 0; $i -lt $dataGrid.ColumnCount; $i++) {
                $dataGrid.Columns[$i].Width = ($dataGrid.Width - 20) / $dataGrid.ColumnCount
            }
        })
    $dataGrid.Add_CellEndEdit({
            $dataGrid[$_.ColumnIndex, $_.RowIndex].Value = $dataGrid[$_.ColumnIndex, $_.RowIndex].Value -replace '"' -replace ';'
        })
    $lineEmpty = @{}
    $columns = ($dataArray[0] | Get-Member -MemberType NoteProperty).Name
    foreach ($column in $columns) {
        $lineEmpty[$column] = ''
    }
    $contextMenuStrip.Items.Add('Neue Zeile').Add_Click({
            $dataArray.Insert($dataGrid.SelectedRows.Index, [PSCustomObject] $lineEmpty)
            $dataGrid.Refresh()
        })
    $contextMenuStrip.Items.Add('Kopiere Zeile').Add_Click({
            $dataArray.Insert($dataGrid.SelectedRows.Index, ($dataArray[$dataGrid.SelectedRows.Index].PSObject.Copy()))
            $dataGrid.Refresh()
        })
    $contextMenuStrip.Items.Add('Entferne Zeile').Add_Click({
            $dataArray.RemoveAt($dataGrid.SelectedRows.Index)
            $dataGrid.Refresh()
        })
    $contextMenuStrip.Items.Add('Auto Spaltenbreite').Add_Click({
            $dataGrid.AutoResizeColumns()
        })
    $contextMenuStrip.Items.Add('Spaltenbreite angleichen').Add_Click({
            For ($i = 0; $i -lt $dataGrid.ColumnCount; $i++) {
                $dataGrid.Columns[$i].Width = ($dataGrid.Width - 20) / $dataGrid.ColumnCount
            }
        })
    $contextMenuStrip.Items.Add('Speichern und Schließen').Add_Click({
            if ([MessageBox]::Show('Wirklich speichern?', $Script:Title, [MessageBoxButtons]::OKCancel, [MessageBoxIcon]::Question) -eq 'OK') {
                try {
                    $timestamp = '_{0:yyyy-MM-dd_HH.mm.ss}' -f (Get-Date)
                    $file = Get-Item $filename -ErrorAction Stop
                    $backupFolder = "$($file.DirectoryName)\Sicherung_CSV"
                    $backupFilename = "$backupFolder\$($file.Name -replace '\.csv$', "$($timestamp).csv")"
                    if (!(Test-Path $backupFolder -ErrorAction SilentlyContinue)) {
                        mkdir $backupFolder
                    }
                    $lock = $false
                    try {
                        $ErrorActionPreferenceBackup = $ErrorActionPreference
                        $ErrorActionPreference = [ActionPreference]::Stop
                        $fileTest = [File]::Open($filename, [FileMode]::Open, [FileAccess]::ReadWrite, [FileShare]::None)
                        $fileTest.Close()
                    } catch {
                        $lock = $true
                    } finally {
                        $ErrorActionPreference = $ErrorActionPreferenceBackup
                    }
                    if (!$lock) {
                        $File.LastWriteTime = (Get-Date)
                        Copy-Item -Path $filename -Destination $backupFilename -ErrorAction Stop
                        ($dataArray | ConvertTo-Csv -Delimiter ';' -NoTypeInformation) -replace '"' |
                            Set-Content -Path $filename -Encoding $Script:Encoding -ErrorAction Stop
                        if ($backupFilesOld = (Get-ChildItem -Path $backupFolder -Filter "$($file.BaseName)_*.csv" -ErrorAction SilentlyContinue) |
                                Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(0 - $removeBackupAfterDays) }) {
                            Remove-Item -Path $backupFilesOld -Force -ErrorAction SilentlyContinue
                        }
                        $formMain.Visible = $false
                        $formMain.Close()
                    } else {
                        [void] [MessageBox]::Show('Die Datei ist gesperrt!' , $Script:Title, [MessageBoxButtons]::OK, [MessageBoxIcon]::Stop)
                    }
                } catch {
                    [void] [MessageBox]::Show('Fehler beim Speichern' , $Script:Title, [MessageBoxButtons]::OK, [MessageBoxIcon]::Stop)
                }
            }
        })
    $contextMenuStrip.items.Add('Schließen ohne zu Speichern').add_Click({
            $formMain.Close()
        })
    $dataGrid.Dock = [DockStyle]::Fill
    $formMain.Controls.Add($dataGrid)
    $formMain.Add_FormClosing({
            param($control, $evt)
            if ($control.Visible) {
                $evt.Cancel = ([MessageBox]::Show('Wirklich nicht speichern?', $Script:Title, [MessageBoxButtons]::OKCancel, [MessageBoxIcon]::Question) -eq 'Cancel')
            }
        })
    [void] $formMain.ShowDialog()
}