#!/usr/bin/env bash
# check_source_files.sh
# Verify the project source files have Linux line endings

PROJECT_ROOT="$PWD"
cd tools/scorpio/check_source_files
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
