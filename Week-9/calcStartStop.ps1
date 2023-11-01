# Storyline: Write a program that can start and stop the Windows Calculator only using Powershell and using only the process name for the Windows Calculator (to start and stop it).

Start-Process -FilePath C:\Windows\system32\win32calc.exe

Start-Sleep 3

$calcProcess = Get-Process | where {$_.Path -eq "C:\Windows\system32\win32calc.exe"} | Select -ExpandProperty ID

Stop-Process -Id $calcProcess