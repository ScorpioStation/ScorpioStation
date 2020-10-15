#!/usr/bin/env bash
# check_json_files.sh
# Verify the project JSON files are valid

PROJECT_ROOT="$PWD"
cd tools/scorpio/check_json_files
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
