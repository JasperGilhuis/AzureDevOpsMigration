# Load Settings JSON
$userDataFile = $PSScriptRoot + "\Config.json"
$userParameters = Get-Content -Path $userDataFile | ConvertFrom-Json

## Replace to correct TFS URL ("root")
$CollectionURL = "http://<<your TFS instance>>:8080/tfs/" 

Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$assemblyPath = "C:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\TFSJobAgent"
Add-Type -Path "$assemblyPath\Microsoft.TeamFoundation.Client.dll"
Add-Type -Path "$assemblyPath\Microsoft.TeamFoundation.Common.dll"
Add-Type -Path "$assemblyPath\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
Add-Type -Path "$assemblyPath\Microsoft.TeamFoundation.VersionControl.Client.dll"

# Check your TFS URL
$TFSConfigurationServer = New-Object Microsoft.TeamFoundation.Client.TfsConfigurationServer(New-Object System.Uri($CollectionURL))
$TFSJobService = $TFSConfigurationServer.GetService([Microsoft.TeamFoundation.Framework.Client.ITeamFoundationJobService])

Write-Host "Waiting for TFS" -NoNewline
do {
    try {
        $TFSConfigurationServer.Connect([Microsoft.TeamFoundation.Framework.Common.ConnectOptions]::None)
        $connect = $true
    } catch {
        Write-Host "." -NoNewLine
    }
} 
while (!($connect))

<#
Team Foundation Server Periodic Identity Synchronization
544dd581-f72a-45a9-8de0-8cd3a5f29dfe
#>

foreach($Job in $TFSJobService.QueryJobs())
{
    if($Job.JobId -eq "544dd581-f72a-45a9-8de0-8cd3a5f29dfe") { break }
}

$CurrentJobState = $Job.EnabledState
$NewState = [Microsoft.TeamFoundation.Framework.Common.TeamFoundationJobEnabledState]::FullyDisabled
$Job.EnabledState = $NewState
$TFSJobService.UpdateJob($Job)

Stop-Transcript