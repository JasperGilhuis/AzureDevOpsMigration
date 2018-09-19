Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

$import = gc import.json | ConvertFrom-Json

$import.Source = @{ Properties = @{ ConnectionString = "Data Source=<<YOUR PUBLIC IP TO THE DATABASE>>;Initial Catalog=<<YOUR COLLECITON>>;Integrated Security=False;User ID=tfsmigratorimport;Password=<<YOUR COMPLEX PASSWORD>>;Encrypt=True;TrustServerCertificate=True"  }}
$import.Target.AccountName = "<<DESIRED AzureDevOps Project>>"
$import.Properties.ImportType = "DryRun" #or ProductionRun
# $import.Source.PSObject.Properties.Remove('Location')
# $import.Source.PSObject.Properties.Remove('Files')

$import | ConvertTo-Json | sc import.json

Stop-Transcript