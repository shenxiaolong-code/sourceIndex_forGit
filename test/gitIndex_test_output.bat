
cd /d "%~dp0"

where srctool.exe 2>nul || call "%~dp0..\initEnv.bat"
set localGitRepo=D:\sourceCode\jabberGit129
set pdbFile=D:\sourceCode\jabberGit129\products\jabber-win\src\jabber-client\jabber-tests\Win32\bin\Release\plugins\SelfCareTab_test\SelfCareTab.pdb
srctool.exe -n %pdbFile%
pdbstr -r -p:%pdbFile% -s:srcsrv