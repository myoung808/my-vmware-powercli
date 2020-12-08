Param(
[STRING] $filename
)

$vms = Import-Csv -Path $filename | Select-Object -ExpandProperty name
get-vm $vms | Start-VM
