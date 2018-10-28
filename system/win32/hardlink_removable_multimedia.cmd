@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: hardlink_removable_multimedia.cmd
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

set LinkDIR="%USERPROFILE%\My Documents\My Music\removable"
@rem set LinkDIR="%USERPROFILE%\media"
if not "%1"=="" (
 set LinkDIR=%1
)
if exist %LinkDIR% (
 echo invalid link directory ^(was: "%LinkDIR%"^)^, exiting
 goto Failed
)
echo setting link ^(was: %LinkDIR%^)^, continuing

@rem if not exist "%TargetDIR%" (
@rem  mkdir "%TargetDIR%"
@rem  if %ERRORLEVEL% NEQ 0 (
@rem   echo failed to mkdir "%TargetDIR%"^, exiting
@rem   set RC=%ERRORLEVEL%
@rem   goto Failed
@rem  )
@rem  echo created "%TargetDIR%"^, continuing
@rem )

set MultimediaDRIVE=H:
set target_is_set=0
if not "%2"=="" (
 set MultimediaDRIVE=%2
 set target_is_set=1
)
if not exist %MultimediaDRIVE% (
 echo invalid removable drive ^(was: "%MultimediaDRIVE%"^)^, exiting
 goto Failed
)

set "MultimediaDIR=%MultimediaDRIVE%"
if %target_is_set%==0 (
 set "MultimediaDIR=%MultimediaDRIVE%\audio"
)
if not exist "%MultimediaDIR%" (
 echo invalid media directory ^(was: "%MultimediaDIR%"^)^, exiting
 goto Failed
)
echo linking directory ^(was: "%MultimediaDIR%"^)^, continuing

@rem ::xcopy /B /E /G /H /K /O /Q /R /X /Y %PackageCacheDIR% "%TargetDIR%"
@rem xcopy /B /E /G /H /K /Q /R /Y "%PackageCacheDIR%" "%TargetDIR%" >NUL 2>&1
@rem if %ERRORLEVEL% NEQ 0 (
@rem  echo failed to xcopy^, exiting
@rem  set RC=%ERRORLEVEL%
@rem  goto Failed
@rem )
@rem rmdir /S /Q "%PackageCacheDIR%" >NUL 2>&1
@rem if %ERRORLEVEL% NEQ 0 (
@rem  echo failed to rmdir^, exiting
@rem  set RC=%ERRORLEVEL%
@rem  goto Failed
@rem )

:Link
@rem set MkLinkCMD=mklink
@rem %MkLinkCMD% /D "%LinkDIR%" "%MultimediaDIR%"
@rem set MkLinkCMD=fsutil
@rem %MkLinkCMD% hardlink create "%LinkDIR%" "%MultimediaDIR%"
set MkLinkCMD=linkd
%MkLinkCMD% %LinkDIR% %MultimediaDIR%
if %ERRORLEVEL% NEQ 0 (
 echo failed to %MkLinkCMD% ^(was: "%LinkDIR% --> %MultimediaDIR%"^)^, exiting
 set RC=%ERRORLEVEL%
 goto Failed
)
echo linked %LinkDIR% --> %MultimediaDIR%

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

