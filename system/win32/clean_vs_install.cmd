@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: clean_vs_install.cmd
@rem #// this script invokes the Microsoft Visual Studio InstallCleanup.exe
@rem #// History:
@rem #//   Date   |Name | Description of modification
@rem #// ---------|-----|-------------------------------------------------------------
@rem #// 20/02/06 | soh | Creation.
@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@echo off
set RC=0
setlocal enabledelayedexpansion
pushd . >NUL 2>&1

set InstallCleanupParameters=-full
set InstallCleanupEXE="C:\Program Files (x86)\Microsoft Visual Studio\Installer\resources\app\layout\InstallCleanup.exe"
if exist %InstallCleanupEXE% goto Next
echo invalid file ^(was: "%InstallCleanupEXE%"^)^, exiting
goto Failed

:Next
@rem echo found InstallCleanup.exe: %InstallCleanupEXE%...

%InstallCleanupEXE% %InstallCleanupParameters%
if !ERRORLEVEL! NEQ 0 (
 echo failed to execute %InstallCleanupEXE%^, exiting
 set RC=!ERRORLEVEL!
 goto Failed
)
goto Clean_Up

:Failed
echo InstallCleanup.exe failed^, exiting

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

