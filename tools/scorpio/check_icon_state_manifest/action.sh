#!/usr/bin/env bash
# check_icon_state_manifest.sh
# Verify the project contains icon_state listed in a manifest file

echo "PWD: $PWD"
npm ci
node index
