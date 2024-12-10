$server = "SVHD-DC34.edu.srh.de"

Remove-ADGroup -Identity BL_SVNGDBBWNMF2_BBWPlacement_HeidelbergBewerbercenterind -server $server -Confirm:$false
Remove-ADGroup -Identity BS_SVNGDBBWNMF2_BBWPlacement_HeidelbergBewerbercenterind -server $server -Confirm:$false

