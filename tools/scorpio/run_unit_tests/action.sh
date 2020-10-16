#!/usr/bin/env bash
# run_unit_tests.sh
# Prepare a build to run unit tests

# add the flag to trigger unit tests
echo "#define TRAVISBUILDING" >> ci-scorpio.dme
echo paradise.dme >> ci-scorpio.dme

cp config/example/dbconfig.txt config/dbconfig.txt
