#!/bin/bash

#Additional security checks (to be ran by the previously created security menu file(s))

function checks() {
	if [[ $2 != $3 ]]
	then

		echo -e "\nThe $1 is not secure.\nThe setting should be: $2, \nthe current setting is $3.\nFix: $4.\n"

	else

		echo -e "\nThe $1 is in a secure state.\nCurrent setting: $3.\n"

	fi
}

# Check that IP forwarding is disabled
ipfrd=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf  | cut -d '=' -f 2 )
checks "IP forwarding" "0" "${ipfrd}" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward =1\nto\nnet.ipv4.ip_forward=0.\nThen run:\n sysctl -w"

# Check that ICMP redirects are not accepted
icmpr=$(grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | awk ' { print $3 } ' )
checks "ICMP Redirects" "0" "${icmpr}"

# Check that permissions on /etc/cron/tab are configured
crontab=$(systemctl is-enabled cron | awk ' { print $1 } ' )
checks "Cron Tab" "enabled" "${crontab}" "Run:\nchown root:root /etc/crontab\nThen run:\nchmod og-rwx /etc/crontab"

# Check that permissions on /etc/cron.hourly are configured
cronhrly=$(stat /etc/cron.hourly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Cron Hourly" "( 0/ root) ( 0/ root)" "${cronhrly}" "Run:\nchown root:root /etc/cron.hourly\nThen run:\nchmod og-rwx /etc/cron.hourly"

# Check that permissions on /etc/cron.daily are configured
crondly=$(stat /etc/cron.daily | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Cron Daily" "( 0/ root) ( 0/ root)" "${crondly}" "Run:\nchown root:root /etc/cron.daily\nThen run:\nchmod og-rwx /etc/cron.daily"

# Check that permissions on /etc/cron.weekly are configured
cronwkly=$(stat /etc/cron.weekly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Cron Weekly" "( 0/ root) ( 0/ root)" "${cronwkly}" "Run:\nchown root:root /etc/cron.weekly\nThen run:\nchmod og-rwx /etc/cron.weekly"

# Check that permissions on /etc/cron.monthly are configured
cronmntly=$(stat /etc/cron.monthly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Cron Monthly" "( 0/ root) ( 0/ root)" "${cronmntly}" "Run:\nchown root:root /etc/cron.monthly\nThen run:\nchmod og-rwx /etc/cron.monthly"

# Check that permissions on /etc/passwd are configured
passwd1=$(stat /etc/passwd | awk -F'[(/]' 'NR ==4 { print $2 } ' )
passwd2=$(stat /etc/passwd | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Passwords" "0644 ( 0/ root) ( 0/ root)" "${passwd1} ${passwd2}" "Run:\nchown root:root /etc/passwd\n Then run:\n chmod 644 /etc/passwd"

#Check that permissions on /etc/shadow are configured
shadow1=$(stat /etc/shadow | awk -F'[(/]' 'NR ==4 { print $2 } ' )
shadow2=$(stat /etc/shadow | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Shadow" "0640 ( 0/ root) ( 42/ shadow)" "${shadow1} ${shadow2}" "Run:\nchown root:shadow /etc/shadow\nThen run:\n chmod o-rwx,g-wx /etc/shadow"

# Check that permissions on /etc/group are configured
group1=$(stat /etc/group | awk -F'[(/]' 'NR ==4 { print $2 } ' )
group2=$(stat /etc/group | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Group" "0644 ( 0/ root) ( 0/ root)" "${group1} ${group2}" "Run:\nchown root:root /etc/group\nThen run:\nchmod 644 /etc/group"

# Check that permissions on /etc/gshadow are configured
gshadow1=$(stat /etc/gshadow | awk -F'[(/]' 'NR ==4 { print $2 } ' )
gshadow2=$(stat /etc/gshadow | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Gshadow" "0640 ( 0/ root) ( 42/ shadow)" "${gshadow1} ${gshadow2}" "Run:\nchown root:shadow /etc/gshadow\nThen run:\nchmod o-rwx,g-rw /etc/gshadow"

# Check that permissions on /etc/passwd- are configured
passwd3=$(stat /etc/passwd- | awk -F'[(/]' 'NR ==4 { print $2 } ' )
passwd4=$(stat /etc/passwd- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "Passwords-" "0644 ( 0/ root) ( 0/ root)" "${passwd3} ${passwd4}" "Run:\nchown root:root /etc/passwd-\n Then run:\nchmod u-x,go-wx /etc/passwd-"

# Check that permissions on /etc/shadow- are configured
shadow3=$(stat /etc/shadow- | awk -F'[(/]' 'NR ==4 { print $2 } ' )
shadow4=$(stat /etc/shadow- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "shadow-" "0640 ( 0/ root) ( 42/ shadow)" "${shadow3} ${shadow4}" "Run:\nchown root:shadow /etc/shadow-\nThen run:\n chmod o-rwx,g-rw /etc/shadow-"

# Check that permissions on /etc/group- are configured
group3=$(stat /etc/group- | awk -F'[(/]' 'NR ==4 { print $2 } ' )
group4=$(stat /etc/group- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "group-" "0644 ( 0/ root) ( 0/ root)" "${group3} ${group4}" "Run:\nchown root:root /etc/group-\nThen run:\n chmod u-x,go-wx /etc/group-"

# Check that permissions on /etc/gshadow- are configured
gshadow3=$(stat /etc/gshadow- | awk -F'[(/]' 'NR ==4 { print $2 } ' )
gshadow4=$(stat /etc/gshadow- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "gshadow-" "0640 ( 0/ root) ( 42/ shadow)" "${gshadow3} ${gshadow4}" "Run:\nchown root:shadow /etc/gshadow-\n Then run:\nchmod o-rwx,g-rw /etc/gshadow-"

# Ensure there are no lecacy + entries in /etc/passwd
legentrs=$(grep '^+:' /etc/passwd)
checks "Legacy + entries for /etc/passwd" "" "${legentrs}" "Remove any legacy '+' entries from /etc/passwd"

# Ensure there are no lecacy + entries in /etc/shadow
legentrsshdw=$(grep '^+:' /etc/shadow)
checks " Legacy + entries for /etc/shadow" "" "${legentrsshdw}" "Remove any legacy '+' entries from /etc/shadow"

# Ensure there are no lecacy + entries in /etc/group
legentrsgrp=$(grep '^+:' /etc/group)
checks "Legacy + entries for /etc/group" "" "${legentrsgrp}" "Remove any legacy '+' entries from /etc/group"

# Ensure root is the only UID 0 account
ruid=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 } ' )
checks "Root UID" "root" "${ruid}" "Remove any other users, besides root, that have a UID of 0."
