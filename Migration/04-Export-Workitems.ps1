## Variables
$BackupRoot = "F:\<<path to scripts\\Migration\WorkitemBackup\"
$CollectionUrl = New-Object System.Uri("http://<<your TFS instance>>:8080/tfs/<<Collection>>/")

Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

## Paths
$WitAdmin = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\WitAdmin.exe"
$TeamExplorerPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\"


Join-Path $TeamExplorerPath "Microsoft.TeamFoundation.Client.dll" | % {Add-Type -path $_}
Join-Path $TeamExplorerPath "Microsoft.TeamFoundation.Common.dll" | % {Add-Type -path $_}
Join-Path $TeamExplorerPath "Microsoft.TeamFoundation.WorkItemTracking.Client.dll" | % {Add-Type -path $_}

$tfs = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]::GetTeamProjectCollection($CollectionUrl)
$tfs.EnsureAuthenticated()

# Get Team Project
$cssService = $tfs.GetService("Microsoft.TeamFoundation.Server.ICommonStructureService3")
$store = $tfs.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])

$projectbackup = $BackupRoot 
& $WitAdmin exportgloballist /collection:$CollectionUrl /f:"$projectbackup\globallist.xml"

foreach ($projInfo in $store.Projects)
{

    Write-Output "Exporting " $projInfo.Name
    $projectbackup = "$BackupRoot\$($projInfo.Name)"

    if (!(Test-Path -Path $projectbackup )) { New-Item -ItemType directory -Path $projectbackup }
    foreach ($witd in $projInfo.WorkItemTypes)
    {
        Write-Output "      witexport " $witd.Name
        & $WitAdmin exportwitd /collection:$CollectionUrl /p:"$($projInfo.Name)" /n:"$($witd.Name)" /f:"$projectbackup\$($witd.Name).xml"
    }

    & $WitAdmin exportcategories /collection:$CollectionUrl /p:"$($projInfo.Name)" /f:"$projectbackup\Categories.xml"
    & $WitAdmin exportprocessconfig /collection:$CollectionUrl /p:"$($projInfo.Name)" /f:"$projectbackup\ProcessConfiguration.xml"

}

Stop-Transcript