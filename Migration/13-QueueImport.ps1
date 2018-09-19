Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$importfile  = "F:\Repos\Scripts\Migration\import.json"

&"F:\TFSmigrator\TfsMigrator.exe" import /importfile:$importfile

Stop-Transcript