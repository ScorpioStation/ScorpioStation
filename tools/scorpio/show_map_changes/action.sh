#!/usr/bin/env bash
# show_map_changes.sh
# Generate images to highlight map changes, if any

# what does git look like from inside CI?
git status

# can we pull docker images?
docker pull scorpiostation/spacemandmm:latest
