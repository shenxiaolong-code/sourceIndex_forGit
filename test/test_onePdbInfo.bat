
cd /d "%~dp0"

where srctool.exe 2>nul || call "%~dp0..\userLocalPathConfig.bat"

call "%~dp0userLocalPathConfig_test.bat"
set "localGitRepo=%LocalTestProject%"

call set "pdbTestFolder=%~dp0%%manyPdbFileDir:%LocalTestProject%\=%%"
if exist "%pdbTestFolder%" rd /s/q "%pdbTestFolder%"
xcopy /s "%onePdbFileDir%\*.pdb" "%pdbTestFolder%\"

for /f "usebackq tokens=*" %%i in ( ` dir/s/b "%pdbTestFolder%\*.pdb" `  ) do set "onePdbFile=%%i"

srctool.exe -n "%onePdbFile%"
pdbstr -r -p:"%onePdbFile%" -s:srcsrv

echo.
echo Done!
pause