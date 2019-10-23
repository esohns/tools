@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: cleanmgr.cmd
@rem #//
@rem #// History:
@rem #//   Date   |Name | Description of modification
@rem #// ---------|-----|-------------------------------------------------------------
@rem #// 20/02/06 | soh | Creation.
@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@echo off
set RC=0
setlocal enabledelayedexpansion
pushd . >NUL 2>&1

set Argument=/Sagerun
set parameter_1=%1
if not "%parameter_1%"=="" (
 if "%parameter_1%"=="SET" (
  set Argument=/Sageset
 )
)
set parameter_2=%2
::echo "parameter_2 %parameter_2%"
if "%parameter_2%"=="" (
 set "Argument=!Argument!:1"
) else (
 echo %parameter_2% | findstr /R "^[0-9]+$" >NUL 2>&1
 if %ERRORLEVEL% EQU 0 (
  if !parameter_2! NEQ 0 (
   set "Argument=!Argument!:!parameter_2!"
  )
 )
)
::echo "Argument !Argument!"

set CleanMgrEXE=C:\Windows\system32\cleanmgr.exe
if exist %CleanMgrEXE% goto Next
echo invalid file ^(was: "%CleanMgrEXE%"^)^, exiting
goto Failed

:Next
%CleanMgrEXE% !Argument! >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo failed to clean^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)

:Failed

:Clean_Up
popd
::endlocal & set RC=%ERRORLEVEL%
endlocal & set RC=%RC%
goto Error_Level

:Exit_Code
::echo %ERRORLEVEL% %1 *WORKAROUND*
exit /b %1

:Error_Level
call :Exit_Code %RC%

