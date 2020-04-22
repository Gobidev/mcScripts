#!/bin/bash

# -------- required inputs --------

screen_name=MinecraftServer	# name of server screen, has to be the same in stop.sh
jar_name=server.jar		# executable jar file that starts the server
ram_m=2000			# max. RAM in MB dedicated to the server
dir=/home/user/MinecraftServer	# directory where this file is located (has to be the same as the server)


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
