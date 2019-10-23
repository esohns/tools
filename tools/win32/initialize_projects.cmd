@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: initialize_projects.cmd
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

goto Begin

:Usage
echo %~dp0 <projects root directory ^(D:\\projects^)>
goto Clean_Up

:Begin
@rem commands
@rem *NOTE*: setx.exe can be installed from the Windows XP CD (look in /SUPPORT)
@rem         it is part of Windows 7 by default
set setxEXE="%ProgramFiles%\Support Tools\setx.exe"
if not exist %setxEXE% (
 echo setx not found ^(was %setxEXE%^)^, exiting
 goto Failed
)

@rem commandline arguments
set ProjectsRootDIR="D:\projects"
if not "%1"=="" (
 set ProjectsRootDIR=%1
)

@rem mkdir
if not exist "%ProjectsRootDIR%" (
 mkdir "%ProjectsRootDIR%"
 if %ERRORLEVEL% NEQ 0 (
  echo failed to mkdir "%ProjectsRootDIR%"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo created "%ProjectsRootDIR%"^, continuing
)

set LibDIR="C:\lib"
if not exist "%LibDIR%" (
 mkdir "%LibDIR%"
 if %ERRORLEVEL% NEQ 0 (
  echo failed to mkdir "%LibDIR%"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo created "%LibDIR%"^, continuing
)

@rem set environment variables
%setxEXE% PROJECTS_ROOT %ProjectsRootDIR%
if %ERRORLEVEL% NEQ 0 (
 echo setx PROJECTS_ROOT failed^, exiting
 goto Failed
)
echo PROJECTS_ROOT set^, congratulations

%setxEXE% LIB_ROOT %LibDIR%
if %ERRORLEVEL% NEQ 0 (
 echo setx LIB_ROOT failed^, exiting
 goto Failed
)
echo LIB_ROOT set^, congratulations

goto Clean_Up

:Failed
set RC=1

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

