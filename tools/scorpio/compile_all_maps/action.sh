#!/usr/bin/env bash
# compile_all_maps.sh
# Prepare each map to be compiled by GitHub CI

PROJECT_ROOT="$PWD"
cp paradise.dme ci-scorpio.dme
cd tools/scorpio/compile_all_maps
npm ci
node_modules/.bin/coffee index.coffee "$PROJECT_ROOT"
