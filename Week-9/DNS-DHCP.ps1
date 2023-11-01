# Storyline: In the video Part II, I am asking for the DHCP server's IP address and the DNS server IPs for the task you have to complete.

echo "DNS SERVER IPS:"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DNSServerSEarchOrder -ne $null} | select -ExpandProperty DNSServerSearchOrder

echo "DHCP IP:"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.DNSServerSEarchOrder -ne $null} | select -ExpandProperty IPAddress