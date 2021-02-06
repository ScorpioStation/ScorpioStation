#!/usr/bin/env bash
# show_map_changes.sh
# Generate images to highlight map changes, if any

# what does the file system look like inside CI?
echo "pwd"
pwd
echo "ls -l"
ls -l

# what does git look like from inside CI?
echo "git status"
git status
echo "git log"
git log --pretty=oneline | head -15

# let's see what's changed in our PR branch...
echo "git diff master"
git diff master --name-only

# let's generate a map for Emerald...
echo "generate image using Docker"
docker pull scorpiostation/spacemandmm:latest
docker create --name delete_me scorpiostation/spacemandmm:latest
docker cp delete_me:/spacemandmm/target/release/dmm-tools dmm-tools
./dmm-tools minimap _maps/map_files/emerald/emerald.dmm
