# Migration Scripts #

Migration Scripts folder contains the scripts to run the migrations.
Scripts are in order of execution. It may not be needed to run all scripts every sequence. If you do another DryRun, attaching the DB and then continue clean / fix you may skip certain files.

The scripts listed below are not applicable to every collection. Some may be needed others are for fixing specific issues with a collection. Stucturely they scripts per collection are similar and that should provide guidance.

Currently the scripts are created for being run on the same machine as the TFS Application Tier is at. This requires installation of Visual Studio 2017 and at least PowerShell available. Visual Studio Code is very convienient to have. Scripts are maintained in a git repository to track the changes.

## *** DISCLAIMER *** ALWAYS CHECK THE SCRIPTS PARAMETERS ##
Be ware that you are doing things that are hard to rollback without restoring the databases.
I strongy advice NOT TO RUN ON ANY OF THESE SCRIPTS PRODUCTION SYSTEM.

They are intended to quickly allow you to fix issues that are raised during the migration.
When re-running scripts unwanted or unintended results may occur.

## Generic Remark ##
In many scripts I use funtionality that is called Transcripting.
Every scripts has a `Start-Transcript .\Logs\X-file.log`.
Each script ends with a `Stop-Transcript` to stop the logging.

_NOTE:_ If you are debugging scripts and stop mid-file, please run a `Stop-Transcript` in that context too. Otherwise the next `Start-Transcript` will fail.

## Disable AD Sync - 00-Disable-ADSync.ps1 ##
This scripts makes sure the TFS Server's user sync service does not run. This prefents unwanted behaviour of remove users from TFS while no AD server is available. This script needs to run only once. With the exception that if you recreate / reinstall the TFS Application Tier on the machine the job would be reinstalled too and therefor become active again. So each Applcation Tier reinstantiate run the script! It will also never hurt you if you run it more often.

## Attach Collection - 01-Attach-Collection.ps1 ##
Uses TFSConfig.exe to attach the collection to the Appliation Tier specified.

## Restore Database - 02-Restore-Database.ps1 ##
This script uses several SQL commands executed through PowerShell against the database to restore the database. It requires the backup files to be in a certain location and defines where the physical files will be placed too.

## Run TfsMigrator Validate - 03-Run-TfsMigratorValidate.ps1 ##
Script runs the TfsMigrator Validate option
Feedback will be shown in the Logs Folder.

## Export Workitems - 04-Export-Workitems.ps1 ##
Script that export workitem types and process xml and global lists definitions.

## Fix Workitems - 05-FixWorkitems.ps1 ##
In the following section several migration scripts are discussed for their purpose. These scripts are often used to provide changes that are required by either the migrator or are a result of failures during import.

## Import Workitems - 06-Import-Workitems.ps1 ###
Generic script that reads the XML definitions based on the actual collection / projecct structure.
This script is "slow", for Simulation Collection expect 10-15 minutes processing.

The script is using WitAdmin.exe commands like importwitd, importcategories and importprocessconfig  
### Delete GlobalLists - 07-DeleteGlobalLists.ps1 ###
This script is here to delete all globallist from the collection.
As input it uses the exported globallist.xml (mind that if you run the process over and over this file may be empty). Globalists cannot be deleted if referenced.

For each of the globallist in the file it uses WitAdmin.exe destroygloballist command to destroy the list.

## TFS Migrator Prepare - 08-Run-TfsMigratorPrepare.ps1 ##
This is a default script that runs the TFS Migrator.
This will execute prepare checks on the collection and if succesfull will generate a JSON template file.

## Copy Generated JSON File - 09-Copy-ImportJson.ps1 ##
When running multiple TFSMirgrator runs, you may get a JSON file generated. You want your latest file to be the one you edit.
This file copies the JSON file from the logs to the root of your script repository. This allows you to save it too.

## Create Migrator User - 10-Create-MigratorUser.ps1 ##
Create a user in the database that Microsoft will use to read in the Azure DB.
May be a good scenaro to change the user and password frequently.

Depending on the scenario the Login / User may allready exist in the database.

## Prepare import.JSON - 11-Prepare-IbmportJson.ps1 ##
This script is here to adjust the JSON file. 
It sets the connecctionstring with the correct specified values.
Holds the name of the Azure DevOps environment it will create, eg.

`$import.Target.AccountName = "Collection"` will result in https://Collection-dryrun.visualstudio.com when the ImportType is DryRun; `$import.Properties.ImportType = "DryRun" `. 

If the ImportType is 'ProductionRun' the VSTS environment would be https://collection.visualstudio.com or now https://dev.azure.com/collection

## Detach Collection - 08-Detach-Collection.ps1 ##
This script is using `TFSConfig collection /detach` command to detach a TFS Application Tiers collection.
This saves opening programs to achieve this.

## QueueImport - 10-QueueImport.ps1 ##
This script sends the prepared JSON file to Microsoft.
If succesful it will report the URL it will create and list a Import ID.
This import ID can be used to provide microsoft insights in logging. 