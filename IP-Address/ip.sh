#!/bin/bash

# Run 'ip addr' command and filter the output to get just IP addresses
ip_addr_output=$(ip addr | grep -Eo 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}')

# Display the filtered IP address
echo "$ip_addr_output"
