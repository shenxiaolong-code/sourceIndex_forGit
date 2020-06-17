::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong(xlshen2002@hotmail.com,xlshen@126.com)
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

@echo off
::my local git repo setting.
if {"%USERNAME%"}=={"xiaolosh"} set localGitRepo=D:\sourceCode\jabberGit129
if not defined localGitRepo (
echo localGitRepo environment is not defined.
echo define localGitRepo environment variable point to local git repo.
echo e.g. set localGitRepo=D:\sourceCode\jabberGit129
goto :eof
)

if not exist "%~dp2" md "%~dp2"
git.exe -C "%localGitRepo%" show "%~1" > "%~fs2"

echo type "%~fs2"
type "%~fs2"