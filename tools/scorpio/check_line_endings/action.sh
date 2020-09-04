#!/usr/bin/env bash
# check_line_endings.sh
# Verify the project source files have Linux line endings

PROJECT_ROOT="$PWD"
cd tools/scorpio/check_line_endings
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
