cls
$the_ip = read-host -Prompt "Please enter the IP for the SSH server : "

# Login to SSH Server
New-SSHSession -ComputerName $the_ip -Credential (Get-Credential sys320)

While ($True) {
    #Prompt for user
    $the_cmd = read-host -Prompt "Please enter a command : "

    #Run Command on remote SSH Server
    (Invoke-SSHCommand -index 0 $the_cmd).Output
}

cls

echo "Removing Session..."
sleep 2
Remove-SSHSession -SessionId 0
echo "Session Removed."


