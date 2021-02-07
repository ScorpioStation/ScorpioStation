#!/usr/bin/env bash
# show_map_changes.sh
# Generate images to highlight map changes, if any

# install some packages
sudo apt-get install -y imagemagick optipng pngcrush

# obtain what the maps look like at origin/master
git fetch --depth=1 --no-auto-gc --no-recurse-submodules --progress --prune origin +refs/heads/master:refs/remotes/origin/master

# see if any maps changed on our PR branch
MAPS=$(git diff --name-only origin/master | grep .dmm)
if [ -z "$MAPS" ]; then
    echo "No maps have been changed."
    exit 0
fi

# since we have changes, let's grab a map generation tool
docker pull scorpiostation/spacemandmm:latest
docker create --name delete_me scorpiostation/spacemandmm:latest
docker cp delete_me:/spacemandmm/target/release/dmm-tools dmm-tools
#docker rm delete_me
chmod +x dmm-tools

# set up Node.js for parsing diff-maps output
cp tools/scorpio/show_map_changes/package.json .
cp tools/scorpio/show_map_changes/package-lock.json .
npm ci

# for each map we've detected changes with
index=0
for map in $MAPS; do
    # increment index; 1-based, just like BYOND ¯\_(ツ)_/¯
	((index++))
    # tell the log what we're up to
    echo ""
    echo "Processing $index: $map"
    # get the origin/master and PR versions of the map
    git show origin/master:$map >1.dmm
    git show HEAD:$map >2.dmm
    # determine the size of the changed section
    ./dmm-tools diff-maps 1.dmm 2.dmm >dmm.diff
    MIN_MAX=$(node_modules/.bin/coffee tools/scorpio/show_map_changes/index.coffee dmm.diff)
    arr=($MIN_MAX)
    # generate some map images and compare them
    ./dmm-tools minimap --disable random --min ${arr[0]} --max ${arr[1]} -o artifacts --pngcrush 1.dmm
    ./dmm-tools minimap --disable random --min ${arr[0]} --max ${arr[1]} -o artifacts --pngcrush 2.dmm
    convert -compare artifacts/1-1.png artifacts/2-1.png artifacts/diff.png
    pngcrush -ow artifacts/diff.png
    # TODO: renamery
    ls -alrt artifacts
done
