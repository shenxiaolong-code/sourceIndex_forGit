set "LocalTestProject=D:\sourceCode\jabberGit128"
set "manyPdbFileDir=%LocalTestProject%\products\jabber-win\src\jabber-client\jabber-build\Win32\bin\Release"
set "onePdbFileDir=%LocalTestProject%\products\jabber-win\src\jabber-client\jabber-tests\Win32\bin\Release\plugins\SelfCareTab"


:: ******************************** verify path ********************************************************
if not exist "%onePdbFileDir%" (
echo pdb file is not geneated. below path is copied to your clipboard.
echo path : %onePdbFileDir%
echo %onePdbFileDir% | clip
pause
)

set "tempDir=%~dp0Cache"