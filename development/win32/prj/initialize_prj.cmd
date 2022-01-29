@rem #//%%%FILE%%%//////////////////////////////////////////////////////////////
@rem #// File Name: initialize_prj.cmd
@rem #//
@rem #// arguments:
@rem #// History:
@rem #//   Date   |Name | Description of modification
@rem #// ---------|-----|-------------------------------------------------------
@rem #// 12/07/16 | soh | Creation.
@rem #//%%%FILE%%%//////////////////////////////////////////////////////////////

@echo off
set RC=0
setlocal enabledelayedexpansion
pushd . >NUL 2>&1
goto Begin

:Print_Usage
@rem echo usage: %~n0
echo usage: %~n0
goto Clean_Up

:Begin
set PROJECTS_ROOT_DIR_DEFAULT=D:\projects
set PROJECTS_ROOT_DIR=%PRJ_ROOT%
if NOT exist "%PROJECTS_ROOT_DIR%" (
 set PROJECTS_ROOT_DIR="%PROJECTS_ROOT_DIR_DEFAULT%"
)
if NOT exist "%PROJECTS_ROOT_DIR%" (
 echo invalid directory ^(was: "%PROJECTS_ROOT_DIR%"^)^, exiting
 goto Failed
)


for %%A in (Common ACEStream ACENetwork) do (
 echo processing "%%A"...
 if NOT exist "%PROJECTS_ROOT_DIR%\%%A" (
  echo invalid project ^(was: "%%A"^)^, exiting
  goto Failed
 )
 set SCRIPT_FILE=%PROJECTS_ROOT_DIR%\%%A\scripts\%~n0%~x0
 if NOT exist "!SCRIPT_FILE!" (
  echo invalid script file ^(was: "!SCRIPT_FILE!"^)^, exiting
  goto Failed
 )
 "!SCRIPT_FILE!"
 if %ERRORLEVEL% NEQ 0 (
  echo failed to run script "!SCRIPT_FILE!"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo processing "%%A"...DONE
)

goto Clean_Up

:Failed
echo ...FAILED

:Clean_Up
popd
::endlocal & set RC=%ERRORLEVEL%
endlocal & set RC=%RC%
goto Error_Level

:Exit_Code
:: echo %ERRORLEVEL% %1 *WORKAROUND*
exit /b %1

:Error_Level
call :Exit_Code %RC%

