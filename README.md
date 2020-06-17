# SourceIndex_forGit
source index for git repo.  
current windbg source index suite doesn't support git repo. here one solution is given by DOS script.

# Usage :  
Syntax:  
gitIndex.cmd \<sourceCodeDir\> \<pdbFilesDirPath\>  
.E.g  
gitIndex.cmd "d:\myProject\newFeature" "d:\myProject\newFeature\output\bin"  
gitIndex.cmd will make source index for all pdb files under path "d:\myProject\newFeature\output\bin" and update those pdb files.  

you can refer to example in path :test/gitIndex_test.bat  

# Note:  
 - config windbg tool path  
if your windbg tool "srctool.exe" is added to %path%, you needn't do anything , else you need to update the file "userLocalPathConfig.bat"  
below is my windbg x86 path setting:  
where pdbstr.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\srcsrv;%path%"  
where windbg.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86;%path%"  

- you need to repare one local git repo  
it is used to fetch single repo file with specified commit id. (fetched file dones't overwrite this repo file , see "gitFetchFile.cmd" for detail.)  
e.g.  assume your git repo path is "D:\sourceCode\jabberGit129" , you need to set environment varialbe :  
set "localGitRepo=D:\sourceCode\jabberGit129"  
this variable is used in "gitFetchFile.cmd" , certain you can edit "gitFetchFile.cmd" directly without puting it into system environments.

- add gitFetchFile.cmd to system search path.  
you need to put gitFetchFile.cmd path in %path%, or copy it into system directory (e.g. C:\windows\system32).  
debugger will seek it to download specified file with specified commit ID. (those info comes from source index)


