Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

# runas /user:domain\username sqlcmd.exe -S MYSQLSERVER
 
$SQLServer = "your SQL SERVER"
$DBName = "Tfs_databasename"
$BackupFilePath = "F:\Temp\Tfs_databasename_data.bak"

## Run the FileList to inspect the backup file
$SQL_FileList = @"
GO
RESTORE FILELISTONLY FROM
 DISK = '{0}'
GO
"@ -f $BackupFilePath

 Invoke-Sqlcmd -ServerInstance $SQLServer -Database "master" -Query $SQL_FileList


## Run the Restore
$SQL_Restore = @"
GO
RESTORE DATABASE {0} FROM
 DISK = '{1}' 
WITH REPLACE,  STATS = 10, RECOVERY, 
	MOVE '{0}' TO 'F:\DATA\{0}.mdf',
	MOVE '{0}_log' TO 'F:\LOG\{0}_log.ldf'
GO
"@ -f $DBName, $BackupFilePath

Invoke-Sqlcmd -ServerInstance $SQLServer -Database "master" -Query $SQL_Restore -QueryTimeout 0

Write-Host "Done"

Stop-Transcript