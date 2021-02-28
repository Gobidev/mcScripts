#!/bin/bash

# this script checks wether the server is running. If it is not but it is supposed to,
# it will be started

server_status=$(cat status)

if [ "$server_status" = "stopped" ]
then
    echo "Server is supposed to be stopped. Exiting.."
    exit 0
else
    echo "Checking for running server.."
    check_screen=$(screen -ls | grep "$screen_name")
    echo "..done"

    if [ "$check_screen" != "" ]
    then
	    echo "Server is already running at '$check_screen'! Exiting.."
	    exit 0
    else
	    echo "No running server found and should be running, starting.."
        /bin/bash start.sh
    fi
fi
