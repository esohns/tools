@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: paf_installer.cmd
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
echo %~dp0 <PortableAppPackage file ^(.paf^)> [<target drive> ^(e.g. D:\^)]
goto Clean_Up

:Begin
if "%1"=="" (
 echo invalid package file, exiting
 goto Usage
)
set PackageFileEXE=%1
if not exist %PackageFileEXE% (
 echo invalid package file ^(was: "%PackageFileEXE%"^)^, exiting
 goto Usage
)
set TargetDRIVE=D:\
set "TargetDIRDefault=Portable"
if not "%2"=="" (
 set TargetDIR=%2
) else (
 set "TargetDIR=%TargetDRIVE%%TargetDIRDefault%"
)
if not exist "%TargetDIR%" (
 mkdir "%TargetDIR%"
 if %ERRORLEVEL% NEQ 0 (
  echo failed to mkdir "%TargetDIR%"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo created "%TargetDIR%"^, continuing
)

::%PackageFileEXE% /AUTOCLOSE=true /HIDEINSTALLER=true /SILENT=true >NUL 2>&1
%PackageFileEXE% /AUTOCLOSE=true /DESTINATION="%TargetDIR%" /HIDEINSTALLER=true /S >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo %PackageFileEXE% failed^, retrying...
 goto Retry
)
echo "%PackageFileEXE%" installed^, congratulations

goto Clean_Up

:Retry
call %0 %1 %2 >&1 2>&1

goto Clean_Up

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

