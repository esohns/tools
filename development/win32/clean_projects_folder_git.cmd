@rem #//%%%FILE%%%//////////////////////////////////////////////////////////////
@rem #// File Name: clean_project_folders.bat
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
@rem echo usage: %~n0 ^[Debug ^| Release^]
echo usage: %~n0
goto Clean_Up

:Begin
@rem if "%1."=="." (
@rem  echo invalid argument^, exiting
@rem  goto Print_Usage
@rem )
@rem if NOT "%1"=="Debug" if NOT "%1"=="Release" (
@rem  echo invalid argument ^(was: "%1"^)^, exiting
@rem  goto Print_Usage
@rem )
set PROJECTSROOTDIR=D:\projects
if NOT exist "%PROJECTSROOTDIR%" (
 echo invalid directory ^(was: "%PROJECTSROOTDIR%"^)^, exiting
 goto Failed
)
@rem set GITEXE=%PROGRAMFILES%\Git\cmd\git.exe
set GITEXE=D:\Git\bin\git.exe
if NOT exist "%GITEXE%" (
 echo git not found ^(was: "%GITEXE%"^)^, exiting
 goto Failed
)

@rem step1: garbage-collect git projects
@rem        ardrone Arkanoid ATCD libACENetwork libACEStream libCommon olinuxino splot tools yarp
for %%A in (ardrone Arkanoid ATCD libACENetwork libACEStream libCommon olinuxino splot tools yarp) do (
 if NOT exist "%PROJECTSROOTDIR%\%%A" (
  echo invalid git project ^(was: %%A^)^, exiting
  goto Failed
 )
 cd /D "%PROJECTSROOTDIR%\%%A" >NUL
 if %ERRORLEVEL% NEQ 0 (
  echo failed to cd to directory^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo housekeeping %%A...
 "%GITEXE%" gc --aggressive --auto
 if %ERRORLEVEL% NEQ 0 (
  echo failed to housekeep project ^"%%A^"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo housekeeping ^(2^) %%A...
 "%GITEXE%" reflog expire --expire=now --all
 if %ERRORLEVEL% NEQ 0 (
  echo failed to housekeep project ^"%%A^"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo housekeeping ^(3^) %%A...
 "%GITEXE%" repack -ad --quiet
 if %ERRORLEVEL% NEQ 0 (
  echo failed to housekeep project ^"%%A^"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo housekeeping %%A...DONE
 echo pruning %%A...
 "%GITEXE%" gc --aggressive --prune=now --quiet
 if %ERRORLEVEL% NEQ 0 (
  echo failed to prune project ^"%%A^"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo pruning %%A...DONE
)
echo git gc...DONE

@rem step2: 
goto Clean_Up

:Failed
echo git gc...FAILED

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

