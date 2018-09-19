Start-Transcript -Path (".\Logs\{0}.log" -f $MyInvocation.MyCommand.Name)

& sqlcmd -S . -Q "USE [<<Tfs_CollectionName>>]

CREATE LOGIN tfsmigratorimport WITH PASSWORD = '<<COMPLEXPASSWORD>>'
CREATE USER tfsmigratorimport FOR LOGIN tfsmigratorimport WITH DEFAULT_SCHEMA=[dbo]
EXEC sp_addrolemember @rolename='TFSEXECROLE', @membername='tfsmigratorimport'"

Stop-Transcript
