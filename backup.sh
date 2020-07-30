#!/bin/bash

# -------- required inputs --------

# name of server screen, has to be the same in both start.sh and stop.sh
screen_name=MinecraftServer
# directory of the minecraft server and this file
out_dir=../backups
# specify world name to backup, for more backup files add them below at XX
world_name="world"

# run script with nostop parameter to avoid server stop

# ###############################################

# ###############################################

# directory for the backups, path does not have to exist
# dir=/home/user/MinecraftServer
# enter the working directory
# cd "$dir" || exit 1

# send save-all to server, fails if not running
echo "Send save-all to server.."
screen -drx "$screen_name" -X stuff "$(printf "save-all\r")"
sleep 15s
echo "..done"

if [ "$1" != "nostop" ]
then
  # attempt server stop, if fail, exit script
  echo "Attempting server stop.."
  /bin/bash stop.sh " for a backup" || exit 2
  echo "..done"
fi

# saving date and time
echo "Requseting current date and time.."
date_var=$(date +"%Y-%m-%d_%H-%M")
echo "$date_var"
echo "..done"

# creating new folder for backup
echo "Preparing backup location.."
mkdir -p "$out_dir"/"$date_var"
echo "..done"

# copy files, standard is just the world, for more files add them here witht the same syntax
echo "Copying files.."
cp -r "$world_name" "$out_dir"/"$date_var"/ || exit 3
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# examples:
# cp -r world_the_end "$out_dir"/"$date_var"/ || exit 3
# cp -r world_nether "$out_dir"/"$date_var"/ || exit 3
# cp -r plugins/CoreProtect/database.db "$out_dir"/"$date_var"/ || exit 3
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
echo "..done"

# enter out_dir
cd "$out_dir" || exit 1

# compress backup
echo "Compressing backup.."
tar cfzv "${date_var}".tar.gz "$date_var" || exit 3
echo "..done"

# remove folder
echo "Cleaning up.."
rm -rf "$date_var"
echo "..done"

# copy to latest
echo "Creating latest file.."
rm "latest.tar.gz" || echo "Latest file did not exist."
cp "${date_var}".tar.gz "latest.tar.gz" || exit 3
echo "..done"

cd "$dir" || exit 1

if [ "$1" != "nostop" ]
then
  echo "Starting server.."
  /bin/bash start.sh || exit 4
  echo "..done"
fi

exit 0

# ###############################################

# ###############################################


# -------- exit codes --------
#
# --- code 0 ---
# Backup created successfully.
#
# --- code 1 ---
# Could not enter one of the directories, probably insufficient permissions.
#
# --- code 2 ---
# Error stopping server.
#
# --- code 3 ---
# Could not copy or compress backup, probably insufficient disk space.
#
# --- code 4 ---
# Could not start server.
