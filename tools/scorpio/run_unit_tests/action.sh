#!/usr/bin/env bash
# run_unit_tests.sh
# Prepare a build to run unit tests

# remove the config and data directories from the .dockerignore file
sed -i '/\/config/d' .dockerignore
sed -i '/\/data/d' .dockerignore

# add the flag to trigger unit tests
echo "#define TRAVISBUILDING" >> ci-scorpio.dme
echo paradise.dme >> ci-scorpio.dme

# copy the example configuration into the config directory
cp config/example/* config/.
