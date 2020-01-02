
cd /d "%~dp0"
set testFolder=D:\sourceCode\jabberGit129\products\jabber-win\src\jabber-client\jabber-tests\Win32\bin\Release
if exist "%testFolder%_test" rd /s/q "%testFolder%_test"
xcopy /s "%testFolder%\*.pdb" "%testFolder%_test\"

call "%~dp0..\gitIndex.cmd" "D:\sourceCode\jabberGit129" "%testFolder%_test"