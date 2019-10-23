@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: move_package_cache.cmd
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

set TargetDRIVE=G:\
set "TargetDIRName=Package Cache"
if not "%1"=="" (
 set TargetDRIVE=%1
)
if not exist %TargetDRIVE% (
 echo invalid target drive ^(was: "%TargetDRIVE%"^)^, exiting
 goto Failed
)
set TargetDIR=%TargetDRIVE%%TargetDIRName%
if not exist "%TargetDIR%" (
 mkdir "%TargetDIR%"
 if %ERRORLEVEL% NEQ 0 (
  echo failed to mkdir "%TargetDIR%"^, exiting
  set RC=%ERRORLEVEL%
  goto Failed
 )
 echo created "%TargetDIR%"^, continuing
)

set "PackageCacheDIR=%SystemDrive%\ProgramData\Package Cache"
if not exist "%PackageCacheDIR%" (
 echo invalid directory ^(was: "%PackageCacheDIR%"^)^, continuing
 goto Link
)

::xcopy /B /E /G /H /K /O /Q /R /X /Y %PackageCacheDIR% "%TargetDIR%"
xcopy /B /E /G /H /K /Q /R /Y "%PackageCacheDIR%" "%TargetDIR%" >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo failed to xcopy^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)
rmdir /S /Q "%PackageCacheDIR%" >NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
 echo failed to rmdir^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)

:Link
set MkLinkCMD=mklink
%MkLinkCMD% /D "%PackageCacheDIR%"^ "%TargetDIR%"
if %ERRORLEVEL% NEQ 0 (
 echo failed to mklink^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)

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

