@ECHO OFF
REM ***********************************************************
REM * Script to synchronize FTP accounts across all agent nodes
REM *
REM * May 2012 - Robert Stinnett, Initial Version
REM * August 2019 - Github Release
REM *
REM ***********************************************************
REM * INSTRUCTIONS FOR USE:
REM * Run as multi-node job to pick up all eligible FTP boxes. 
REM * The base install location must be the same (standard).
REM * This job will copy FTP data/PGP data/SFTP data files from
REM * %MASTER_NODE% to local nodes.
REM **********************************************************
@ECHO ON
SET FTP_MASTER=WINBATCHM15P
SET BACKUP_DIR_MASTER=\\network\unc\goes\here\%COMPUTERNAME%
SET TIMESTAMP=%date:~-4%%date:~4,2%%date:~7,2%%time:~0,2%%time:~3,2%%time:~6,2%
SET BACKUP_DIR=%BACKUP_DIR%\%TIMESTAMP%
SET CTM_LOCAL_DIR=C:\Program Files\BMC Software\CONTROL-M Agent\Default\CM\AFT\data
SET CTM_REMOTE_DIR=\\%FTP_MASTER%\c$\Program Files\BMC Software\CONTROL-M Agent\Default\CM\AFT\data



REM *** Skip master node ***

IF %COMPUTERNAME%==%FTP_MASTER% GOTO ALL-GOOD

REM **********************************************************
REM * Back files up in case of rollback
REM **********************************************************
REM ****  Robert"s Note:  This needs to be a version control
REM ****  system!
REM **********************************************************

dir %BACKUP_DIR% >nul  
if errorlevel 1 (
   mkdir %BACKUP_DIR_MASTER%
)

mkdir %BACKUP_DIR%

ECHO CTM_LOCAL_DIR = %CTM_LOCAL_DIR%
ECHO BACKUP_DIR = %BACKUP_DIR%
SET RUN_CMD=xcopy /v /r /e /y  "%CTM_LOCAL_DIR%" "%BACKUP_DIR%"\

ECHO COMMAND = %RUN_CMD%

%RUN_CMD%
IF %ERRORLEVEL% NEQ 0 GOTO BACKUP-FAILED

REM ******* Move new files over **************

xcopy /v /r /e /y "%CTM_REMOTE_DIR%"\accounts.xml "%CTM_LOCAL_DIR%"
IF %ERRORLEVEL% NEQ 0 GOTO ROLLBACK-END

xcopy /v /r /e /y "%CTM_REMOTE_DIR%"\known_hosts "%CTM_LOCAL_DIR%"
IF %ERRORLEVEL% NEQ 0 GOTO ROLLBACK-END

xcopy /v /r /e /y "%CTM_REMOTE_DIR%"\keys "%CTM_LOCAL_DIR%"
IF %ERRORLEVEL% NEQ 0 GOTO ROLLBACK-END

xcopy /v /r /e /y "%CTM_REMOTE_DIR%"\pgp_templates.dat "%CTM_LOCAL_DIR%"
IF %ERRORLEVEL% NEQ 0 GOTO ROLLBACK-END

GOTO ALL-GOOD

:ROLLBACK-END
REM *** This routine fires if an error was detected and rolls back changes.
ECHO **ERROR** Problem moving new files out.  Rolling back files from %BACKUP_DIR% !
xcopy /v /r /e /y  %BACKUP_DIR% "%CTM_LOCAL_DIR%"
IF %ERRORLEVEL% NEQ 0 GOTO ROLLBACK-FAILURE

exit 50

:BACKUP-FAILED
ECHO **ERROR** File backup and/or commit error. Deployment of files stopped (no changes made).

exit 70

:ROLLBACK-FAILURE
ECHO **ERROR** Rollback failed!  Node may be unusable!

exit 80

:ALL-GOOD
ECHO **SUCCESS** Files succesfully deployed from %FTP_MASTER% to %COMPUTERNAME%

exit 0
