#Storyline: Create the incident response toolkit outlined in the week-11 assignment
function generateReport() {
    cls
    $myDir = Read-Host -Prompt "Please indicate the directory you would like the output to be placed [or press q to exit]: "

    if ($myDir -match "^[qQ]$") {
        break
    }

    #Get running processes & output to file
    Get-Process | Select-Object ProcessName, ID, Path | Export-Csv -Path "$myDir\RunningProcesses.csv"

    #Get all registered services and the path to the executable controlling the service (you'll need to use WMI).
    Get-WmiObject -Class Win32_Service | Select-Object Name, PathName, Path | Export-Csv -Path "$myDir\RegisteredServices.csv"

    #All TCP network sockets
    Get-NetTCPConnection -State Listen | Select LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Export-Csv -Path "$myDir\TCPNetworkSockets.csv"

    #All user account information (you'll need to use WMI)
    Get-WmiObject -Class Win32_UserAccount | Export-Csv -Path "$myDir\UserAccountInfo.csv"

    #All NetworkAdapterConfiguration information.
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path "$myDir\NetworkAdapterConfig.csv"

    #Saves the list of items in the Appdata folder, as well as when it was last modified
    Get-ChildItem -Path $Env:APPDATA | Export-Csv "$myDir\Appdata.csv"

    #Copies the Powershell event log and saves it to the folder
    Copy-Item -Path "C:\Windows\System32\Winevt\Logs\Windows PowerShell.evtx" -Destination "$myDir"

    #Copies the System Event log and saves it to the folder
    Copy-Item -Path "C:\Windows\System32\Winevt\Logs\System.evtx" -Destination "$myDir"

    #Copies the Security log to the folder
    Copy-Item -Path "C:\Windows\System32\Winevt\Logs\Security.evtx" -Destination "$myDir"

    #Gets checksums of all files in the directory
    Get-ChildItem -path "$myDir\*" | Get-FileHash | Export-Csv "$myDir\checksum.csv"

    #Zip the folder
    Compress-Archive -LiteralPath "$myDir" -DestinationPath "C:\Users\champuser\Desktop\IncidentReport.zip"

    Get-FileHash -Path "C:\Users\champuser\Desktop\IncidentReport.zip" | Export-Csv "C:\Users\champuser\Desktop\IncidentReportChecksum.csv"

    generateReport
}

generateReport