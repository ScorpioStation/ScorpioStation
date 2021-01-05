#!/usr/bin/env bash
# run_unit_tests.sh
# Prepare a build to run unit tests

# remove the config and data directories from the .dockerignore file
sed -i '/\/config/d' .dockerignore
sed -i '/\/data/d' .dockerignore

# add the flag to trigger unit tests
rm -f ci-scorpio.dme
echo "#define CIBUILDING" >> ci-scorpio.dme
cat paradise.dme >> ci-scorpio.dme

# copy the example configuration into the config directory
cp config/example/* config/.
