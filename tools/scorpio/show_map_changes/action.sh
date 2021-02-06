#!/usr/bin/env bash
# show_map_changes.sh
# Generate images to highlight map changes, if any

# what does the file system look like inside CI?
pwd
ls -l

# what does git look like from inside CI?
git status
git log --pretty=oneline | head -15

# let's see what's changed in our PR branch...
git diff master --name-only

# let's generate a map for Emerald...
docker pull scorpiostation/spacemandmm:latest
docker create --name delete_me scorpiostation/spacemandmm:latest
docker cp delete_me:/spacemandmm/target/release/dmm-tools
./dmm-tools minimap /home/pmeade/projects/scorpio-sidecart/_maps/map_files/emerald/emerald.dmm
