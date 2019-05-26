@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: remove_build_zombies.cmd
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

set Arguments=/F /T
::set parameter_1=%1
::if not "%parameter_1%"=="" (
:: if "%parameter_1%"=="SET" (
::  set Argument=
:: )
::)

set TaskKillEXE=C:\Windows\system32\taskkill.exe
if exist %TaskKillEXE% goto Next
echo invalid file ^(was: "%TaskKillEXE%"^)^, exiting
goto Failed

:Next
for %%s in ("cl.exe" "MsBuild.exe" "vcpkgsrv.exe") do (
 %TaskKillEXE% /IM %%s !Arguments! >NUL 2>&1
 if %ERRORLEVEL% NEQ 0 (
  echo failed to kill %%s^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo killed %%s...
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

