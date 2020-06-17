::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong(xlshen2002@hotmail.com,xlshen@126.com)
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).

rem usage:
rem configure Proecjt : properties -> Configuration Properties -> Build Events -> Post-Build Event : Command Line
rem projectPostEvent_gitSourceIndex.bat "$(ProjectDir)" "$(OutDir)$(TargetName).pdb" "$(Configuration)" "$(OutputType)" "$(Platform)"
rem for example :
rem c:\gitkits\projectPostEvent_gitSourceIndex.bat "D:\Local_Temp\MiniMPL\msvc\vs2015\MiniMPL\" "D:\Local_Temp\MiniMPL\msvc\vs2015\..\..\output\Core_vs2015\Release\bin\UT_MiniMPL.pdb" "Release" "exe" "Win32"
echo.
echo %0 %*
if not {"%~3"}=={""} if not {"%~3"}=={"Release"} echo you should source index only for release version. skip Git source index for current %~3 build. & goto :eof

set "ProjectDir=%~1"
set "pdbFile=%~fs2"
if not exist "%pdbFile%" echo Not existed pdb file '%pdbFile%' , skiping Git source index. & goto :eof
if exist "%ProjectDir%" for /f "usebackq tokens=*" %%1 in ( ` git -C "%ProjectDir%." rev-parse --show-toplevel  ` ) do cd /d "%%~1"
call "%~dp0gitIndex.cmd" "%cd%" "%pdbFile%"