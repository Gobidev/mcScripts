#!/bin/bash

# -------- required inputs --------

# name of server screen, has to be the same in stop.sh and backup.sh
screen_name=MinecraftServer
# executable jar file that starts the server
jar_name=fabric-server-launch.jar
#jar_name=paper.jar
# max. RAM in MB dedicated to the server, recommended is 1000-1500M less than your physical memory
ram_m=4000
# specify if you want to use aikar flags
aikar_flags=n


# ###############################################

# ###############################################


echo "running" > status

# directory where this file is located (has to be the same as the server)
dir=../
# enter the working directory
cd "$dir" || exit 1

# check for running server
echo "Checking for running server.."
check_screen=$(screen -ls | grep "$screen_name")
echo "..done"

if [ "$check_screen" != "" ]
then
	echo "Server is already running at '$check_screen'! Exiting.."
	exit 2
else
	echo "No running server found, starting.."

	if [ $aikar_flags == "n" ]
	then
		echo "Running without Aikar flags"
		screen -AmdS "$screen_name" java -Xms${ram_m}M -Xmx${ram_m}M -jar $jar_name nogui
	else
		if [ $ram_m -lt 12000 ]
		then
	  		echo "Xmx is less than 12G, running default Aikar flags"
	  		screen -AmdS "$screen_name" java -Xms${ram_m}M -Xmx${ram_m}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
			-XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
			-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 \
			-XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \
			-XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
			-XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs \
			-Daikars.new.flags=true -jar $jar_name nogui
  		else
			echo "Xmx is greater than 12G, running modified Aikar flags"
			screen -AmdS "$screen_name" java -Xms${ram_m}M -Xmx${ram_m}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
			-XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
			-XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 \
			-XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 \
			-XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
			-XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs \
			-Daikars.new.flags=true -jar $jar_name nogui
  		fi
	fi

	# check if screen is running after 1s
	sleep 1s
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
