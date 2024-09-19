If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
  Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
  Exit	
}

# remove scheduled tasks
$tasks = Get-ScheduledTask -TaskPath '*'

foreach ($task in $tasks) {
    if ($task.TaskName -ne 'SvcRestartTask' -and $task.TaskName -ne 'MsCtfMonitor') {
        # if the task isn't 'SvcRestartTask' or 'MsCtfMonitor', stop it and unregister it
        Stop-ScheduledTask -TaskName $task.TaskName -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction SilentlyContinue
    }
}
