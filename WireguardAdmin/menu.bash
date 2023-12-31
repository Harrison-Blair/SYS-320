#!/bin/bash

# Storyline: Menu for admin, VPN, and Security funcxtions

function invalid_opt() {
	echo ""
	echo "Invalid Option"
	echo ""
	sleep 2
}


function menu() {

	# Clears the screen at the start of the menu (makes it look nice)
	clear

	echo ""
	echo " * * * MAIN MENU * * * "
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	echo ""
	read -p "Please enter a choice from above: " choice

	case "$choice" in

		1) admin_menu
		;;
		2) security_menu
		;;
		3) exit 0
		;;
		*)
			invalid_opt

			# Call the main menu
			menu
		;;
	esac

}

function admin_menu() {

	clear
	echo ""
	echo " * * * ADMIN MENU * * * "
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	echo ""
	read -p "Please enter a choice from above: " choice

	case "$choice" in

		L|l) ps -ef |less
		;;
		N|n) netstat -an --inet |less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
		;;

	esac
admin_menu
}

function vpn_menu() {
	clear
	echo ""
	echo " * * * VPN MENU * * * "
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	echo ""
	read -p "Please enter a choice from above: " choice

	case "$choice" in
	
		A|a)
			bash peer.bash
			tail -6 wg0.conf |less
		;;
		D|d) 
			echo ""
			read -p "What is the name of the user you would like to delete?" user_name
			bash manage-users.bash -d -u $(user_name)
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*)
			invalid_opt
		;;
	esac
vpn_menu
}

function security_menu() {
	clear
	echo ""
	echo " * * * SECURITY MENU * * * "
	echo "[O]pen Network Sockets"
	echo "[U]ID"
	echo "[C]heck the last 10 logged in users"
	echo "[L]ogged in users"
	echo "[B]lock list menu"
	echo "[P]revious menu (admin menu)"
        echo "[M]ain menu"
	echo "[E]xit"
	echo ""
	read -p "Please enter a choice from above: " choice

	case "$choice" in
		O|o) netstat -1 |less
		;;
		U|u) cat /etc/passwd | grep "x:0" | less
		;;
		C|c) lest -n 10 |less
		;;
		L|l) who |less
		;;	
		P|p) admin_menu
                ;;
                B|b) block_menu
                ;;
                M|m) menu
                ;;
                E|e) exit 0
                ;;
                *)
                        invalid_opt
                ;;
	esac
security_menu
}

function block_menu() {
	clear
	echo ""icnfmp
	echo " * * * BLOCK LIST MENU * * * "
	echo "[D]ownload or update threatlist"
	echo "[I]P Tables"
	echo "[C]isco"
	echo "[N]etscreen"
	echo "[F]irewall (Windows)"
	echo "[M]acOS"
	echo "[P]arse Cisco"
	echo "[B]ack"
	echo "[E]xit"
	echo ""
	read -p "Please enter a choice from above: " choice
	
	case "$choice" in
	D|d) bash parse-threat.bash
	;;
	I|i) bash parse-threat.bash -i
	;;
	C|c) bash parse-threat.bash -c
	;;
	N|n) bash parse-threat.bash -n
	;;
	F|f) bash parse-threat.bash -f
	;;
	M|m) bash parse-threat.bash -m
	;;
	P|p) bash parse-threat.bash -p
	;;
	B|b) security_menu
	;;
	E|e) exit 0
	;;
	*)
		invalid_opt
	;;
	esac
block_menu
}
# Call the main function
menu
