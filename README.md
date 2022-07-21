# SourceIndex_forGit
source index for git repo.  
The current windbg source index suite doesn't support git repo. here one solution is given by DOS script.  
Chinese introduce : https://bbs.pediy.com/thread-263043.htm

# Usage :  
- Syntax:  
  gitIndex.cmd \<sourceCodeDir\> \<pdbFilesDirPath\>  
- example  
  gitIndex.cmd "d:\myProject\newFeature" "d:\myProject\newFeature\output\bin"  
  gitIndex.cmd will make source index for all pdb files under path "d:\myProject\newFeature\output\bin" and update those pdb files.  

- you can refer to the example in the path:  
  https://github.com/shenxiaolong-code/sourceIndex_forGit/blob/master/test/test_pdbDirAll.bat

# Note:  
 - config windbg tool path  
if your windbg tool "srctool.exe" is added to %path%, you needn't do anything , else you need to update the file "userLocalPathConfig.bat"  
below is my windbg x86 path setting:  
where pdbstr.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\srcsrv;%path%"  
where windbg.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86;%path%"  

- you need to prepare one local git repo  
it is used to fetch a single repo file with a specified commit id. (fetched file doesn't overwrite this repo file, see "gitFetchFile.cmd" for detail.)  
e.g.  assume your git repo path is "D:\sourceCode\jabberGit129" , you need to set environment varialbe :  
setx  localGitRepo "D:\sourceCode\jabberGit129"  
this variable is used in "gitFetchFile.cmd" , certain you can edit "gitFetchFile.cmd" directly without puting it into system environments.

- add gitFetchFile.cmd to system search path.  
you need to put gitFetchFile.cmd path in %path%, or copy it into system directory (e.g. C:\windows\system32).  
the debugger will seek to download a specified file with a specified commit ID. (that info comes from source index)

# additional:  
- index slower , debug faster -- use : https://github.com/ShenXiaolong1976/sourceIndex_forGit
- index faster , debug slower -- use : https://github.com/ShenXiaolong1976/sourceIndexLight_forGit
