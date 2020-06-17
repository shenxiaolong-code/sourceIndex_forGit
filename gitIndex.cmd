::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong(xlshen2002@hotmail.com,xlshen@126.com)
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
cls
rem call gitIndex.cmd "%LocalProjectSrcPath%" "%pdbFilePathOrPdbFolderPath%"
::@set EchoEnable=1
::@set EchoCmd=%~nx0
::@set _Debug=1
@if {%EchoEnable%}=={1} ( @echo on ) else ( @echo off )
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo. & @echo [Enter %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

call :processInput  %*
call :config
call :process.pdb
goto :End

::[DOS_API:Help]Display help information
:Help
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

:process.pdb
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set "template_srcsrv=%tempDir%\_template_srcsrv.ini"
call :process.pdb.initSrcsrvIni "%template_srcsrv%"
if defined pdbDir   call :process.pdb.dir "%pdbDir%"
if defined pdbFile  call :process.pdb.one "%pdbFile%"
goto :eof

:process.pdb.dir
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set "PdbList=%tempDir%\_pdbFileList.txt"
dir/s/b "%~1\*.pdb" > "%PdbList%"
for /f  "usebackq tokens=*" %%i in ( ` type "%PdbList%"  ` ) do call :process.pdb.one "%%~i"
goto :eof

:process.pdb.initSrcsrvIni
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
:: j:\bld_12.6\thirdparty\external\boost_1_56_0\boost\bind\bind.hpp*commitID*/thirdparty/external/boost_1_56_0/boost/bind/bind.hpp
if exist "%~f1" del /f/q "%~f1"
(
@echo SRCSRV: ini ------------------------------------------------
@echo VERSION=1
@echo INDEXVERSION=2
@echo VERCTRL=git
@echo DATETIME=%date% %time%
@echo SRCSRV: variables ------------------------------------------
@echo GIT_EXTRACT_TARGET=%%targ%%\gitsrc\%%fnbksl%%^(%%var3%%^)\%%var2%%\%%fnfile%%^(%%var1%%^)
@echo GIT_EXTRACT_CMD=cmd /c gitFetchFile.cmd "%%var2%%:%%var3%%" "%%GIT_EXTRACT_TARGET%%"
rem @echo GIT_EXTRACT_CMD=cmd.exe /c if not exist "%%GIT_EXTRACT_TARGET%%\.." md "%%GIT_EXTRACT_TARGET%%\.." ^&^& call git.exe -C "%%localGitRepo%%" show  "%%var2%%:%%var3%%" ^> "%%GIT_EXTRACT_TARGET%%"
@echo SRCSRVTRG=%%GIT_extract_target%%
@echo SRCSRVCMD=%%GIT_extract_cmd%%
@echo SRCSRV: source files ---------------------------------------
) > %~f1
goto :eof

:process.pdb.one
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call :pdb.needSrcIndex "%~fs1" _bNeedNextAction
if defined _bNeedNextAction call :pdb.doSrcIndex "%~fs1"
goto :eof

:pdb.needSrcIndex
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call :pdb.needSrcIndex.bySrcNum %*
if not defined %~2 goto :eof
goto :eof

:pdb.needSrcIndex.bySrcNum
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call set %~2=
set _tmpSrcNum=
for /f "usebackq tokens=1" %%i in ( ` srctool.exe  "%~fs1" -r -u ^| find /i "%srcRootDir%" /c ` ) do set _tmpSrcNum=%%i
if not {"%_tmpSrcNum%"}=={"0"} call set %~2=1
goto :eof


:pdb.doSrcIndex
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
echo [%time%] Git source index for "%~1" ....
set "_tmpRawSrc=%tempDir%\%~n1_raw.txt"
call :pdb.doSrcIndex.readRawSrc "%~fs1" "%_tmpRawSrc%"

if not exist "%_tmpRawSrc%" (
echo Fail to source index for "%~nx1"
goto :eof
)

set "_tmpSrcsrvSkipped=%tempDir%\%~n1_skipped.txt"
set "_tmpSrcsrvIni=%tempDir%\%~n1_indexed.ini"
call :pdb.doSrcIndex.generateSrcsrv "%_tmpRawSrc%"
if exist "%_tmpSrcsrvIni%"  call :pdb.doSrcIndex.writeBack "%~fs1" "%_tmpSrcsrvIni%"
echo  [%time%] Done to Git source index for "%~1"
echo.
goto :eof

:pdb.doSrcIndex.writeBack
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
pdbstr.exe -w -p:"%~fs1" -i:"%~fs2" -s:srcsrv
goto :eof

:pdb.doSrcIndex.generateSrcsrv
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
copy /a/y "%template_srcsrv%" "%_tmpSrcsrvIni%" 1>nul
for /F "usebackq tokens=*" %%i in ( ` type  "%~fs1" ` ) do call :pdb.doSrcIndex.generateSrcsrv.oneLine "%%i"
@echo SRCSRV: end ------------------------------------------------ >> "%_tmpSrcsrvIni%"
goto :eof

:pdb.doSrcIndex.generateSrcsrv.oneLine
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call set "_tmpTypeList=%%sourceIndexTypes:;%~x1;=%%"
if not {"%_tmpTypeList%"}=={"%sourceIndexTypes%"} call :pdb.doSrcIndex.generateSrcsrv.oneFile %*
goto :eof

:pdb.doSrcIndex.generateSrcsrv.oneFile
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
:: j:\bld_12.6\thirdparty\external\boost_1_56_0\boost\bind\bind.hpp*commitID*/thirdparty/external/boost_1_56_0/boost/bind/bind.hpp
set _tmpGitFilePath=
for /F "usebackq tokens=*" %%i in ( ` dir/s/b "%~1" ` ) do call set "_tmpGitFilePath=%%i"

call :getCaseSensitiveePath _tmpGitFilePath "%_tmpGitFilePath%"

call :gitTool.gitfileVer "%_tmpGitFilePath%" _tmpFileVer
if not defined _tmpFileVer (
rem @echo Fails to get file repo version for "%~1", it might be not git version controlled.
goto :eof
)
call set _tmpGitFileTailPath=%%_tmpGitFilePath:%srcRootDir%\=%%
call set _tmpGitFileTailPath=%_tmpGitFileTailPath:\=/%
call echo %_tmpGitFilePath%*%_tmpFileVer%*%_tmpGitFileTailPath%>> "%_tmpSrcsrvIni%"
goto :eof

:pdb.doSrcIndex.readRawSrc
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
srctool.exe  "%~fs1" -r -u | find /i "%srcRootDir%" > "%~fs2"
goto :eof

:gitTool.gitfileVer
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set %~2=
for /F "usebackq tokens=*" %%i in ( ` git.exe -C "%srcRootDir%" log -1 --pretty^=format:%%H "%~1" ` ) do call set %~2=%%i
if not defined %~2 echo [NoGitVer] git.exe -C "%srcRootDir%" log -1 --pretty^=format:%%H "%~1" >> "%_tmpSrcsrvSkipped%"
goto :eof

:getCaseSensitiveePath
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not exist "%~fs2" goto :eof
for /f "usebackq tokens=4" %%i in ( ` fsutil file queryfileid "%~fs2" ` ) do set fileID=%%i
if defined _Debug echo fileID=%fileID%
for /f "usebackq tokens=*" %%i in ( ` fsutil file queryFileNameById %~d2 %fileID% ` ) do set "filePath=%%i"
if defined _Debug echo filePath=%filePath%
set "%~1=%filePath:*\\?\=%"
goto :eof

:processInput
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call :verify.path "%~2"
set "_tmpAttrib=%~a2"
if      {"%_tmpAttrib:~0,1%"}=={"d"}    set "pdbDir=%~2"    & set pdbFile=
if not  {"%_tmpAttrib:~0,1%"}=={"d"}    set "pdbFile=%~2"   & set pdbDir=
call :getCaseSensitiveePath srcRootDir "%~1"
call :verify.path "%srcRootDir%"

if not defined tempDir set "tempDir=%~dp0cache"
if exist "%tempDir%" rd /s/q "%tempDir%"
md "%tempDir%"
call :verify.path "%tempDir%"
goto :eof

:getCaseSensitiveePath
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not exist "%~fs2" goto :eof
for /f "usebackq tokens=4" %%i in ( ` fsutil file queryfileid "%~fs2" ` ) do set fileID=%%i
if defined _Debug echo fileID=%fileID%
for /f "usebackq tokens=*" %%i in ( ` fsutil file queryFileNameById %~d2 %fileID% ` ) do set "filePath=%%i"
if defined _Debug echo filePath=%filePath%
set "%~1=%filePath:*\\?\=%"
goto :eof

:config
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not defined sourceIndexTypes set "sourceIndexTypes=;.h;.hpp;.inl;.c;.cc;.cpp;.cxx;.txt;.res;"
call :config.setPath
goto :eof

:verify.path
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not exist "%~1" (
@echo can't find "%~1"
exit 
)
goto :eof

:config.setPath
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call "%~dp0userLocalPathConfig.bat"
where pdbstr.exe 1>nul 2>nul || (
echo can't find necessary tools path.
echo please check file "%~dp0userLocalPathConfig.bat"
exit /b 2
)
goto :eof

:End
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [Leave %~nx0] commandLine: %0 %* & @echo.