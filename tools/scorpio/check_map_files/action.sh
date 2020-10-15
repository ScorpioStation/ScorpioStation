#!/usr/bin/env bash
# check_map_files.sh
# Verify the project map files are solid

PROJECT_ROOT="$PWD"
cd tools/scorpio/check_map_files
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
