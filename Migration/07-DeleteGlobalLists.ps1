$Collection = "http://<<your TFS instance>>:8080/tfs/<<Collection>>/"


$WITAdminPath = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\WitAdmin.exe"
$globalListFilePath = ".\WorkitemBackup\globallist.xml"

Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

### MAIN Logic ###
[xml]$globalLists = Get-Content $globalListFilePath
$globalLists.GLOBALLISTS.GLOBALLIST | Foreach-Object {
  
    $GlobalListName = $_.name

    &"$WITAdminPath" destroygloballist /collection:"$Collection" /n:"$GlobalListName" /noprompt
}

# List the remaining lists
&"$WITAdminPath" ListGlobalList /collection:"$Collection"

Stop-Transcript