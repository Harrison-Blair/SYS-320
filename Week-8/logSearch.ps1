
$myDir = "C:\Users\champuser\Desktop"

Get-EventLog -list

$readLog = Read-host -Prompt "Please select a log to review from the above list"

$searchTerm = Read-host -Prompt "Please indicate an item you wish to search for"

Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$searchTerm*"} | export-csv -NoTypeInformation -Path "$myDir\securitylogs.csv"