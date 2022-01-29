@rem #//%%%FILE%%%//////////////////////////////////////////////////////////////
@rem #// File Name: initialize_prj.cmd
@rem #//
@rem #// arguments: - (git-) project directory (under %LIB_ROOT%)
@rem #//            - (git-) branch name
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
echo usage: %~n0 <project> <branch>
goto Clean_Up

:Begin
if "%1."=="." if "%2."=="." (
 echo invalid argument^, exiting
 goto Print_Usage
)
set PROJECT=%1
set LIBS_ROOT_DIR_DEFAULT=H:\lib
set LIBS_ROOT_DIR=%LIB_ROOT%
if NOT exist "%LIBS_ROOT_DIR%" (
 set LIBS_ROOT_DIR=%LIBS_ROOT_DIR_DEFAULT%
)
if NOT exist "%LIBS_ROOT_DIR%" (
 echo invalid libraries directory ^(was: "%LIBS_ROOT_DIR%"^)^, exiting
 goto Failed
)
set LIB_DIR=%LIBS_ROOT_DIR%\%PROJECT%
if NOT exist "%LIB_DIR%" (
 echo invalid library directory ^(was: "%LIB_DIR%"^)^, exiting
 goto Failed
)
set BRANCH=%2

set GITEXE=%PROGRAMFILES%\Git\cmd\git.exe
@rem set GITEXE=D:\Git\bin\git.exe
if NOT exist "%GITEXE%" (
 echo git not found ^(was: "%GITEXE%"^)^, exiting
 goto Failed
)

@cd /D %LIB_DIR%
"%GITEXE%" checkout %BRANCH% >NUL
if %ERRORLEVEL% NEQ 0 (
 echo failed to check out branch "%BRANCH%" from "%PROJECT%"^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)
echo %~n0%~x0 %1 %2...DONE

goto Clean_Up

:Failed
echo %~n0%~x0 %1 %2...FAILED

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

