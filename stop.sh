#!/bin/bash

# -------- required inputs --------

screen_name=MinecraftServer	# name of server screen, has to be the same in start.sh


# ###############################################

# ###############################################


# check for running server
echo "Checking for running server.."
check_screen=$(screen -ls | grep "$screen_name")

if [ "$check_screen" == "" ]
then
	echo "No running server found! Exiting.."
	exit 1
else
  echo "Server found at '$check_screen'."

  # send message to online players
  echo "Notifying players.."
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 30s!\r")"
  echo "Message 1 sent"
  sleep 15s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 15s!\r")"
  echo "Message 2 sent"
  sleep 5s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 10s!\r")"
  echo  "Message 3 sent"
  sleep 5s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 5s!\r")"
  echo  "Message 4 sent"
  sleep 2s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 3s!\r")"
  echo  "Message 5 sent"
  sleep 1s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 2s!\r")"
  echo  "Message 6 sent"
  sleep 1s
  screen -drx "$screen_name" -X stuff "$(printf "say The server will shut down in 1s!\r")"
  echo  "Message 7 sent"
  sleep 1s
  echo "..done"

  echo "Shutting down server.."
  screen -drx $screen_name -X stuff "$(printf "stop\r")"
  echo "..done, testing in 60s"
  sleep 60s

  # checking if server did not stop
  echo "Checking for running server.."
  check_screen=$(screen -ls | grep "$screen_name")
  if [ "$check_screen" != "" ]
  then
    echo "Server could not be stopped."
    exit 2
  else
    echo "Server stopped successfully."
    exit 0
  fi
fi

# ###############################################

# ###############################################


# -------- exit codes --------
#
# --- code 0 ---
# Server stopped successfully.
#
# --- code 1 ---
# No running server was found
#
# --- code 2 ---
# An error occoured while stopping the server.
