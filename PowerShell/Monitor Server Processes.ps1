<#  This just lists the processes running with CPU and Memory every 30 seconds #>

$computerToMonitor = "<enter server name>"

while ($true)
{
invoke-command -ComputerName $computerToMonitor `
-ScriptBlock {`
    $cores = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
    
        Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | 
        Where-Object {$_.Name -notmatch "^(idle|_total)$" -and $_.PercentProcessorTime -gt -1} |
        select-object -property @{Name = "ServerName"; Expression = {$_.PSComputerName}}, Name, @{Name = "CPU"; Expression = {($_.PercentProcessorTime/$cores)}}, @{Name = "PID"; Expression = {$_.IDProcess}}, @{"Name" = "Memory(MB)"; Expression = {[int]($_.WorkingSetPrivate/1mb)}} 
        
} | sort-object -Property CPU -Descending | Format-Table -Autosize -Property ServerName, Name, CPU, "Memory(MB)" 
Start-Sleep -Seconds 30
}
