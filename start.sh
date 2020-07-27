#!/bin/bash

# -------- required inputs --------

# name of server screen, has to be the same in stop.sh and backup.sh
screen_name=MinecraftServer
# executable jar file that starts the server
jar_name=server.jar
# max. RAM in MB dedicated to the server
ram_m=2000
# directory where this file is located (has to be the same as the server)
dir=/home/user/MinecraftServer


# ###############################################

# ###############################################


# enter the working directory
cd "$dir" || exit 1

# check for running server
echo "Checking for running server.."
check_screen=$(screen -ls | grep "$screen_name")
echo "..done"

if [ "$check_screen" != "" ]
then
	echo "Server is already running at '$check_screen'! Exeting.."
	exit 2
else
	echo "No running server found, starting.."
	screen -AmdS "$screen_name" java -Xms${ram_m}M -Xmx${ram_m}M -jar $jar_name nogui

	# check if screen is running after 5s
	sleep 5s
	check_screen=$(screen -ls | grep $screen_name)
	if [ "$check_screen" != "" ]
	then
		echo "Server started successfully!"
		exit 0
	else
		echo "Server could not be started."
		exit 3
	fi
fi

# ###############################################

# ###############################################


# -------- exit codes --------
# 
# --- code 0 ---
# No server was running and server was started.
#
# --- code 1 ---
# Working directory could not be accessed.
#
# --- code 2 ---
# Server was already running.
# 
# --- code 3 ---
# Server was not running but could not be started.
