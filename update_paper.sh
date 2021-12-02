#!/bin/bash

# This script looks for the newest papermc build of a given version in the v2 api
# and replaces paper.jar with it

minecraft_version="1.18"

echo "Looking for builds for minecraft version $minecraft_version.."
newest_paper_build="$(curl -s https://papermc.io/api/v2/projects/paper/versions/$minecraft_version/ | jq '.builds[-1]')"
if [ "$newest_paper_build" = "" ]; then
    echo "No paper builds found for minecraft version $minecraft_version, exiting.."
    exit 1
else
    echo "Found newest build $newest_paper_build"
    
    # back up old paper version
    mv -v paper.jar paper-old.jar
    # download new paper build to paper.jar
    echo "Downloading build.."
    wget -O paper.jar "https://papermc.io/api/v2/projects/paper/versions/$minecraft_version/builds/$newest_paper_build/downloads/paper-$minecraft_version-$newest_paper_build.jar"
    echo "Done"
fi