
cd /d "%~dp0"
call "%~dp0userLocalPathConfig_test.bat"

call set "pdbTestFolder=%~dp0%%manyPdbFileDir:%LocalTestProject%\=%%"
if exist "%pdbTestFolder%" rd /s/q "%pdbTestFolder%"
xcopy /s "%manyPdbFileDir%\*.pdb" "%pdbTestFolder%\"

call "%~dp0..\gitIndex.cmd" "%LocalTestProject%" "%pdbTestFolder%"

echo.
echo Done!
pause