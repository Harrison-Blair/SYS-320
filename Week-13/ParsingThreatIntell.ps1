# Array of threat intel websites
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules', 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')
$myDir = 'C:\SYS-320\Week-13'
# Loop through the URLS for the rules list
foreach ($u in $drop_urls) 
{
    # Extract the filename
    $temp = $u.split("/")
    
    # The last element in the array plucked off is the filename
    $file_name = $temp[-1]

    if (Test-Path $file_name) {

        continue

    } else {
    # Download the rules list
    Invoke-WebRequest -Uri $u -OutFile '$myDir\$file_name'
    
    }
}

# Array containing the filename
$input_paths = @( '.\compromised-ips.txt','.\emerging-botcc.rules')

# Extract the IP addresses.
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list.
Select-String -Path $input_paths -Pattern $regex_drop |
ForEach-Object { $_.Matches } | 
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | Out-File -FilePath "ips-bad.tmp"

# Make IPTables syntax and into a file

$choice = Read-Host -Prompt "Would you like (A)IPtables rules, or (B)Windows Firewall rules?"

switch ( $choice )
{
    A { (Get-Content -Path ".\ips-bad.tmp") | % { $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP" } | Out-File -FilePath "$myDir\iptables.bash" }
    B { (Get-Content -Path ".\ips-bad.tmp") | % { $_ -replace '^','New-NetFirewallRule -DisplayName "Block Bad IP" -Direction Outbound -LocalPort Any -Action Block -RemoteAddress '} | Out-File -FilePath "$myDir\WindowsFirewallRules.ps1" }
}


