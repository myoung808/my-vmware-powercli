Param(
[STRING] $filename,
[STRING] $snapshot_name

)

# read list of VMs from file
$vms = Import-Csv -Path $filename | Select-Object -ExpandProperty name
$total = ($vms | Measure-Object).Count 

$count = 0
Get-VM $vms | % {
    $vm = $_
    $count++
    Write-Progress -Activity "$vm" -Status "$count of $total"
    switch($vm.PowerState) {
        'PoweredOn' {
            # initiate guest OS shutdown

            Shutdown-VMGuest -VM $vm -Confirm:$false

            while((get-vm $vm).PowerState -ne "PoweredOff") {
                Start-Sleep -Seconds 5
            }

            # current month for snapshot name
            #$month = Get-Date -Format MMMM

            # snapshot VMs
            New-Snapshot -VM $vm -Name $snapshot_name


            # initiate power on
            Start-VM -VM $vm

            # wait for VMs to power on
            while((get-vm $vm).PowerState -ne "PoweredOn") {
                Start-Sleep -Seconds 5
            }
        }
    }
}
