#!/usr/bin/env bash
# check_file_endings.sh
# Verify the project source files end with a Linux newline

PROJECT_ROOT="$PWD"
cd tools/scorpio/check_file_endings
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
