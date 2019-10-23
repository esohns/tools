@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@rem #// File Name: find_symbol.cmd
@rem #// this script identifies the (import) library containing a @rem #// given symbol in a directory structure
@rem #// History:
@rem #//   Date   |Name | Description of modification
@rem #// ---------|-----|-------------------------------------------------------------
@rem #// 20/02/06 | soh | Creation.
@rem #//%%%FILE%%%////////////////////////////////////////////////////////////////////
@echo off
set RC=0
setlocal enabledelayedexpansion
pushd . >NUL 2>&1

set DumpBinParameters=/EXPORTS
set FindParameters=/C

set DumpBinEXE="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\dumpbin.exe"
if exist %DumpBinEXE% goto Next
echo invalid file ^(was: "%DumpBinEXE%"^)^, exiting
goto Failed

:Next
@rem echo found dumpbin.exe: %DumpBinEXE%...
set FindEXE="C:\Windows\System32\find.exe"
if exist %FindEXE% goto Next_2
echo invalid file ^(was: "%FindEXE%"^)^, exiting
goto Failed

:Next_2
@rem echo found find.exe: %FindEXE%...
set TempFileTXT="%TMP%\dumpbin.txt"
if exist %TempFileTXT% (
 del %TempFileTXT%
@rem  if !ERRORLEVEL! NEQ 0 (
@rem   echo failed to delete %TempFileTXT%^, exiting
@rem   set RC=!ERRORLEVEL!
@rem   goto Failed
@rem  )
@rem echo cleared %TempFileTXT%...
)

for /R "%cd%" %%a in (*.lib) do (
@rem echo testing "%%a"...

 %DumpBinEXE% %DumpBinParameters% "%%a" >%TempFileTXT%
 if !ERRORLEVEL! NEQ 0 (
  echo failed to execute %DumpBinEXE%^, exiting
  set RC=!ERRORLEVEL!
  goto Failed
 )

 %FindEXE% %FindParameters% "%1" %TempFileTXT% >NUL
 if !ERRORLEVEL! EQU 0 (
  echo found "%1" in "%%a"^, exiting
  goto Clean_Up
 )
)

:Failed
echo symbol "%1" not found^, exiting

:Clean_Up
@rem del %TempFileTXT%
@rem if !ERRORLEVEL! EQU 0 (
@rem  echo cleared %TempFileTXT%...
@rem )

popd
::endlocal & set RC=%ERRORLEVEL%
endlocal & set RC=%RC%
goto Error_Level

:Exit_Code
::echo %ERRORLEVEL% %1 *WORKAROUND*
exit /b %1

:Error_Level
call :Exit_Code %RC%

