
if not exist "%~dp2" md "%~dp2"
set localGitRepo=D:\sourceCode\jabberGit129
git.exe -C "%localGitRepo%" show "%~1" > "%~fs2"

echo type "%~fs2"
type "%~fs2"