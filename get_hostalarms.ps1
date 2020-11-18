$alarmMgr = Get-View AlarmManager

$output = @()
Get-VMHost | Where-Object { $_.ExtensionData.TriggeredAlarmState } | % {
    $vmhost = $_
    $vmhost.ExtensionData.TriggeredAlarmState | % {
        $obj = {} | Select-Object hostname, alarminfo
        $alarmView = Get-View $_.Alarm
        $obj.hostname = $vmhost.name
        $obj.alarminfo = $alarmView.Info.Name
        $output += $obj
    }
}
$output
