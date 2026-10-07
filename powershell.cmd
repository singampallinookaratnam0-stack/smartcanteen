@echo off
set "PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0;%PATH%"
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile %*
