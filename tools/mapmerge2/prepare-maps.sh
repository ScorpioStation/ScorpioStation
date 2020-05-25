#!/bin/sh

# change into the _maps directory at the root
cd ../../_maps

# find all the DreamMaker Map files (.dmm) and make backup copies
find . -name *.dmm -exec cp '{}' '{}.backup' \;

# print some nice instructions
echo "All .dmm files in your _maps directories have been backed up"
echo "Now you can make your changes..."
echo "---"
echo "Remember to run mapmerge.sh just before you commit your changes!"
echo "---"
