@echo off

for /f "tokens=3" %%v in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "PROCESSOR_ARCHITECTURE"') do set "PROCESSOR_ARCHITECTURE=%%v"

if %PROCESSOR_ARCHITECTURE%==AMD64 set OSBit=64
if %PROCESSOR_ARCHITECTURE%==EM64T set OSBit=64
if not "%OSBit%" == "64" (
	echo You cannot open this project in the Vivado Design Suite on a 32-bit OS. You must use a 64-bit OS to open this project in the Vivado Design Suite.
	pause
	exit
)

pushd "%~dp0"
setlocal enabledelayedexpansion
set configFileName=environment.ini
set labviewFolderConfigKey=VivadoDesignSuiteInstallationPath
if exist "%configFileName%" (
  for /f "delims=" %%x in (%~dps0%configFileName%) do (set %%x)
  cd /d "VivadoProject"
  "!VivadoDesignSuiteInstallationPath!\bin\vivado.bat" "Top_FPGA_2.xpr"
  if errorlevel 1 ( 
    echo[
    echo The batch file failed to launch the Vivado Design Suite.
    echo Possible reason: The export folder is copied from another computer. 
    echo Solution: Try correcting %labviewFolderConfigKey% in !cd!\%configFileName% or launching the Vivado Design Suite from the right-click menu of the corresponding build specification in LabVIEW.
    echo[
    pause
  )
) else (
  echo Couldn't find !cd!\%configFileName%. 
  echo Possible reason: The export is corrupted.
  echo Solution: Try rebuilding the corresponding build specification in LabVIEW.
  echo[
  pause
)
popd