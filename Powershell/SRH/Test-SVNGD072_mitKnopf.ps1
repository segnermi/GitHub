<# 
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Test                            = New-Object system.Windows.Forms.Form
$Test.ClientSize                 = New-Object System.Drawing.Point(376,234)
$Test.text                       = "Test SVNGD072"
$Test.TopMost                    = $false
$Test.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#4a90e2")

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 238
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(61,150)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Test"
$Button1.width                   = 233
$Button1.height                  = 89
$Button1.Anchor                  = 'top,bottom,left'
$Button1.location                = New-Object System.Drawing.Point(65,50)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',14)
$Button1.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#f8e71c")
$Button1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#000000")

$Test.controls.AddRange(@($TextBox1,$Button1))


#region Logic 

#endregion

[void]$Test.ShowDialog()




for ($i = 0; $i -lt 5; $i++){
    write-host ""
}

$server = "svngd072.srhk.srh.de"
if (Test-Connection $server -quiet){
   write-host "$server ist erreichbar" -ForegroundColor Green 

}
else {
    write-host "$server ist nicht erreichbar" -ForegroundColor red
}

Start-Sleep 12