#!/bin/bash

#Purpose - Make a file to parse threats from an online reasource (download if not found on machine) and then block them on chosen firewall

#A function to download the bad ip's, and to parse them into a format we like

function getBadIPs() {
	wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

	# read the emerging-drop.suricata.rules file and organize it to create the badips.txt file
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badips.txt

	echo ""
	echo "Threat download complete!"
	echo ""
}

if [[ -f badips.txt ]] # Does badips.txt exist?
then #If it does exist
	read -p "badips.txt already exists, would you like to redownload? [Y|N]: " answer
	case "$answer" in
	Y|y)
		echo "redownloading..."
		getBadIPs
	;;
	N|n)
		echo "Continuing without redownloading..."
	;;
	*)
		echo "Invalid response..."
		exit 1
	;;
	esac

else #If it does not exist
	echo "Downloading latest threats..."
	getBadIPs
fi


while getops 'icnfmp' OPTION ; do

	case "$OPTION" in
		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		n) netscreen=${OPTION}
		;;
		f) wfirewall=${OPTION}
		;;
		m) macOS=${OPTION}
		;;
		p) parseCisco=${OPTION}
		;;
		*)
			echo "Invalid response..."
			exit 1
		;;

	esac

done

if [[ ${iptables}  ]]
then
	for eachip in $(cat badips.txt)
	do
		echo "iptables -a input -s ${eachip} -j drop" | tee -a  badips.iptables
	done
	echo ""
	echo "Created IPTables firewall rules @ \"badips.iptables\""
	echo ""
fi

if [[ ${cisco} ]]
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.nocidr
	for eachip in $(cat badips.nocidr)
	do
		echo "deny ip host ${eachip} any" | tee -a badips.cisco
	done
	rm badips.nocidr
	echo ""
	echo 'Created IP Tables for firewall drop rules in file "badips.cisco"'
	echo ""
fi

# Netscreen
if [[ ${netscreen} ]]
then
	for eachip in $(cat badips.txt)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
	done
	echo ""
	echo "Created IP Table for firewall rules @ \"batips.netsh"\"
	echo ""
fi


# Windows Firewall
if [[ ${wfirewall} ]]
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.windowsform
	for eachip in $(cat badips.windowsform)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
	done
	rm badips.windowsform
	echo ""
	echo "Created IPTables for firewall drop rules in file \"badips.netsh\""
	echo ""
fi

# MacOS
if [[ ${macOS} ]]
then
	echo '
	scrub-anchor "com.apple/*"
	nat-anchor "com.apple/*"
	rdr-anchor "com.apple/*"
	dummynet-anchor "com.apple/*"
	anchor "com.apple/*"
	load anchor "com.apple" from "/etc/pf.anchors/com.apple"

	' | tee pf.conf

	for eachip in $(cat badips.txt)
	do
		echo "block in from ${eachip} to any" | tee -a pf.conf
	done
	echo ""
	echo "Created IP tables for firewall drop rules in file \"pf.conf\""
	echo ""
fi

# Parse Cisco
if [[ ${parseCisco} ]]
then
	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
	awk '/domain/ {print}' /tmp/targetedthreats.csv | awk -F \" '{print $4}' | sort -u > threats.txt
	echo 'class-map match-any BAD_URLS' | tee ciscothreats.txt
	for eachip in $(cat threats.txt)
	do
		echo "match protocol http host \"${eachip}\"" | tee -a ciscothreats.txt
	done
	rm threats.txt
	
	echo ""
	echo 'Cisco URL filters file successfully parsed and created at "ciscothreats.txt"'
	echo ""
fi

