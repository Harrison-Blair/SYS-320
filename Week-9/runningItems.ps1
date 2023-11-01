# Storyline: Export your list of running processes and running services on your system into separate files.
 
 Get-Process | Select-Object ProcessName, ID, Path | Export-Csv -Path "C:\users\champuser\Desktop\RunningProcesses.csv"

 Get-Service | Where {$_.Status -eq "Running"} | Select-Object DisplayName, Name, ServiceName | Export-Csv -Path "C:\users\champuser\Desktop\RunningServices.csv"