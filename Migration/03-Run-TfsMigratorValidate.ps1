Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$collection = "http://<<your TFS instance>>:8080/tfs/<<collection>>/"

&"F:\TFSmigrator\TfsMigrator.exe" validate /collection:$collection

Stop-Transcript