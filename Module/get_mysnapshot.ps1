Function get-mysnapshot {
    <#
    .SYNOPSIS
        Script to replace storage views.

    .DESCRIPTION
        Sums the size of all the snapshots for a VM.

    .EXAMPLE
        get-mysnapshot
        list total size of all snapshots for each VMs on the vCenter Server

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    param(
        [switch]$detailed,
        [switch]$sortbyvm,
        [Parameter(ParameterSetName='ByDatastore')]
        [string]$datastore,
        [Parameter(ParameterSetName='ByVM')]
        [string]$vm
    )

    # Get list of VMs with snapshots
    switch($PSCmdlet.ParameterSetName) {
        "ByDatastore" {
            $vm_list = get-vm -datastore (get-datastore $datastore)
        }

        "ByVM" {
            $vm_list = get-vm $vm
        }

        default {
            $vm_list = get-vm
        }
    }

    $grand_total = 0
    $list = @()
    $vm_list | get-view | Where-Object { $_.snapshot -match "Vim" } | % {
        Write-Progress -Activity "Calculating snapshot size:" -Status $_.name
        $name = {} | select-object totalgb, VM, num, Created, Name, Description
        $name.VM = $_.name
        $snaps = @()
        $name.num = 0
        get-snapshot -vm $_.name | % {
            $grand_total += $_.sizegb
            $name.totalgb += $_.sizegb
            $name.num += 1
            if($name.Created -eq "" -or $name.Created -lt $_.Created) {
                $name.Created = $_.Created
                $name.Name = $_.Name
                $name.Description = $_.Description
            }
        }
        $list += $name
    }

    $sortedlist = @()
    if($sortbyvm){
        $sortedlist = $list | Sort-object VM, created
    } else {
        $sortedlist = $list | Sort-Object totalgb, VM, created
    }
    $sortedlist | Select-Object @{n="totalgb";e={if($_.totalgb -notlike ""){[math]::Round($_.totalgb,2)}}}, num, VM, @{n='LastCreated';e={ '{0:MM-dd-yyyy}' -f $_.Created }}, @{n='LastDesc';e= {if($_.Name -match "^VM Snapshot"){ $_.Description } else { $_.Name } } } | Format-Table -AutoSize
    [math]::Round($grand_total,2)
}
