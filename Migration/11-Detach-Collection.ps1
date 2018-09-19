Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$tfsconfig = "C:\Program Files\Microsoft Team Foundation Server 2018\Tools\TfsConfig.exe"
 
& $tfsconfig collection /detach /collectionName:"<<collection>>" /continue

Stop-Transcript