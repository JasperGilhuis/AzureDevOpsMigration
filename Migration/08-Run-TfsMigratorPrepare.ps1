
$collection = "http://<<your new import instance>>:8080/tfs/<<collection>>/"
$name = "<<your tennant>>.onmicrosoft.com"
$region = "WEU" # or other preferred region

Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

&"F:\TFSmigrator\TfsMigrator.exe" prepare /collection:$collection /tenantDomainName:$name /accountRegion:$region

Stop-Transcript