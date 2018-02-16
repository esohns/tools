@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: remove_hiberfil_sys.cmd
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

set Argument=OFF
if "%1" EQU "0" (
 set Argument=ON
)

set PowerCfgEXE=powercfg.exe
if exist %PowerCfgEXE% goto Next
echo invalid file ^(was: "%PowerCfgEXE%"^)^, exiting
goto Failed

:Next
%PowerCfgEXE% /H %Argument% >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo failed to remove hiberfil.sys^, exiting
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

