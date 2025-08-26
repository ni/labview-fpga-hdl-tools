:: githubvisible=true
@echo off

for /f "tokens=3" %%v in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "PROCESSOR_ARCHITECTURE"') do set "PROCESSOR_ARCHITECTURE=%%v"

setlocal enabledelayedexpansion
set configFileName=projectsettings.ini

echo "%cd%\%configFileName%"

REM Check if the configuration file exists in the current working directory
if exist "%cd%\%configFileName%" (
  for /f "tokens=1,2 delims==" %%x in ('findstr /r /c:"^VivadoProjectName=" "%cd%\%configFileName%"') do set "VivadoProjectName=%%y"
  for /f "tokens=1,2 delims==" %%x in ('findstr /r /c:"^VivadoToolsPath=" "%cd%\%configFileName%"') do set "VivadoToolsPath=%%y"
  cd /d "VivadoProject"
  echo !VivadoToolsPath!
  start "" "!VivadoToolsPath!\bin\vivado.bat" !VivadoProjectName!.xpr
  if errorlevel 1 ( 
    echo[
    echo The batch file failed to launch the Vivado Design Suite.
    echo[
    pause
  )
) else (
  echo Couldn't find "%cd%\%configFileName%". 
  echo[
  pause
)
