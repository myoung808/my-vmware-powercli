Function Enable-vCpuHotAdd($vm){
    $vmview = Get-vm $vm | Get-View
    $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $extra = New-Object VMware.Vim.optionvalue
    $extra.Key="vcpu.hotadd"
    $extra.Value="true"
    $vmConfigSpec.extraconfig += $extra
    $vmview.ReconfigVM($vmConfigSpec)
}
