$alarmMgr = Get-View AlarmManager

$filter = New-Object VMware.Vim.AlarmFilterSpec
$filter.Status += [VMware.Vim.ManagedEntityStatus]::red
$filter.TypeEntity = [VMware.Vim.AlarmFilterSpecAlarmTypeByEntity]::entityTypeHost
$filter.TypeTrigger = [VMware.Vim.AlarmFilterSpecAlarmTypeByTrigger]::triggerTypeEvent

$alarmMgr.ClearTriggeredAlarms($filter)
