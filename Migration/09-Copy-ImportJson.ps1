Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$logfolder = gci F:\TfsMigrator\Logs\<<collection>>\* -Directory | select -Last 1
Copy-Item $logfolder\import.json .

Stop-Transcript