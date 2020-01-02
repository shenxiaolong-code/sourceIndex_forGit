::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong((xlshen@126.com))
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
cls
::@set EchoEnable=1
::@set EchoCmd=1
::@set _Debug=1
@if {%EchoEnable%}=={1} ( @echo on ) else ( @echo off )
if {%EchoCmd%}=={1} @echo. & @echo [Enter %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

call :processInput  %*
call :config
call :process.pdb.dir "%pdbDir%"
goto :End

::[DOS_API:Help]Display help information
:Help
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call tools_miscellaneous.bat DisplayHelp "%~f0"
goto :eof

::[DOS_API:Test]Test DOS API in this script file
:Test
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
echo.
@echo [%~nx0] Run test case [%0 %*]

echo.
echo test call :Help
call :Help

echo.
goto :eof

:process.pdb.dir
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
set "template_srcsrv=%tempDir%\_template_srcsrv.ini"
call :process.pdb.initSrcsrvIni "%template_srcsrv%"
set "PdbList=%tempDir%\_pdbFileList.txt"
dir/s/b "%pdbDir%\*.pdb" > "%PdbList%"
for /f  "usebackq tokens=*" %%i in ( ` type "%PdbList%"  ` ) do call :process.pdb.one "%%i"
goto :eof

:process.pdb.initSrcsrvIni
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
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
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call :pdb.needSrcIndex "%~fs1" _bNeedNextAction
if defined _bNeedNextAction call :pdb.doSrcIndex "%~fs1"
goto :eof

:pdb.needSrcIndex
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call :pdb.needSrcIndex.bySrcNum %*
if not defined %~2 goto :eof
goto :eof

:pdb.needSrcIndex.bySrcNum
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call set %~2=
set _tmpSrcNum=
for /f "usebackq tokens=1" %%i in ( ` srctool.exe  "%~fs1" -r -u ^| find /i "%srcRootDir%" /c ` ) do set _tmpSrcNum=%%i
if not {"%_tmpSrcNum%"}=={"0"} call set %~2=1
goto :eof


:pdb.doSrcIndex
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
echo [%time%] source index for "%~1" ....
set "_tmpRawSrc=%tempDir%\%~n1_raw.txt"
call :pdb.doSrcIndex.readRawSrc "%~fs1" "%_tmpRawSrc%"

if not exist "%_tmpRawSrc%" (
echo Fail to source index for "%~nx1"
goto :eof
)

set "_tmpSrcsrvIni=%tempDir%\%~n1_indexed.ini"
call :pdb.doSrcIndex.generateSrcsrv "%_tmpRawSrc%"
if exist "%_tmpSrcsrvIni%"  call :pdb.doSrcIndex.writeBack "%~fs1" "%_tmpSrcsrvIni%"
echo [%time%] Done to source index for "%~1"
echo.
goto :eof

:pdb.doSrcIndex.writeBack
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
pdbstr.exe -w -p:"%~fs1" -i:"%~fs2" -s:srcsrv
goto :eof

:pdb.doSrcIndex.generateSrcsrv
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
copy /a/y "%template_srcsrv%" "%_tmpSrcsrvIni%" 1>nul
for /F "usebackq tokens=*" %%i in ( ` type  "%~fs1" ` ) do call :pdb.doSrcIndex.generateSrcsrv.oneLine "%%i"
@echo SRCSRV: end ------------------------------------------------ >> "%_tmpSrcsrvIni%"
goto :eof

:pdb.doSrcIndex.generateSrcsrv.oneLine
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call set "_tmpTypeList=%%sourceIndexTypes:;%~x1;=%%"
if not {"%_tmpTypeList%"}=={"%sourceIndexTypes%"} call :pdb.doSrcIndex.generateSrcsrv.oneFile %*
goto :eof

:pdb.doSrcIndex.generateSrcsrv.oneFile
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
:: j:\bld_12.6\thirdparty\external\boost_1_56_0\boost\bind\bind.hpp*commitID*/thirdparty/external/boost_1_56_0/boost/bind/bind.hpp
set _tmpGitFilePath=
for /F "usebackq tokens=*" %%i in ( ` dir/s/b "%~1" ` ) do call set "_tmpGitFilePath=%%i"

set "_tmpFile=%~1"
call :gitTool.gitfileVer "%_tmpGitFilePath%" _tmpFileVer
if not defined _tmpFileVer (
rem @echo Fails to get file repo version for "%_tmpFile%", it might be not git version controlled.
goto :eof
)
call set _tmpGitFilePath=%%_tmpGitFilePath:%srcRootDir%\=%%
call set _tmpGitFilePath=%_tmpGitFilePath:\=/%
call echo %~1*%_tmpFileVer%*%%_tmpGitFilePath:%srcRootDir%\=%%>> "%_tmpSrcsrvIni%"
goto :eof

:pdb.doSrcIndex.readRawSrc
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
srctool.exe  "%~fs1" -r -u | find /i "%srcRootDir%" > "%~fs2"
goto :eof

:gitTool.gitfileVer
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
set %~2=
for /F "usebackq tokens=*" %%i in ( ` git.exe -C "%srcRootDir%" log -1 --pretty^=format:%%h "%~1" ` ) do call set %~2=%%i
goto :eof

:processInput
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
set "pdbDir=%~2"
call :verify.path "%pdbDir%"
set "srcRootDir=%~1"
call :verify.path "%srcRootDir%"

set "tempDir=%~dp0srcIndex"
if exist "%tempDir%" rd /s/q "%tempDir%"
md "%tempDir%"
call :verify.path "%tempDir%"
goto :eof

:config
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
set "sourceIndexTypes=;.h;.hpp;.inl;.c;.cc;.cpp;.cxx;.txt;.res;"
call :config.setPath
goto :eof

:verify.path
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
if not exist "%~1" (
@echo can't find "%~1"
exit 
)
goto :eof

:config.setPath
if {%EchoCmd%}=={1} @echo [%~nx0] commandLine: %0 %*
call "%~dp0initEnv.bat"
where pdbstr.exe || (
echo can't find necessary tools path.
echo please check file "%~dp0initEnv.bat"
exit /b 2
)
goto :eof

:End
if {%EchoCmd%}=={1} @echo [Leave %~nx0] commandLine: %0 %* & @echo.