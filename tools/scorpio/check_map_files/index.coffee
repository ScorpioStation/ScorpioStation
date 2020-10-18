# index.coffee
# Verify the project map files are solid

NON_TGM_RE = /\".+\" = \(.+\)/
STEP_XY_RE = /step_[xy]/

fs = require "fs"
glob = require "glob"
path = require "path"

files = glob.sync "**/*.dmm", {cwd: process.argv[2]}

process.stdout.write "There are #{files.length} map files to check\n"
process.exitCode = 0

for file in files
    filePath = path.join process.argv[2], file
    text = fs.readFileSync filePath, {encoding: "utf8"}

    if NON_TGM_RE.test text
        process.stdout.write "ERROR: Map '#{file}' is in BYOND format, not TGM format.\n"
        process.exitCode = 1

    if STEP_XY_RE.test text
        process.stdout.write "ERROR: Map '#{file}' contains step_x/step_y variables.\n"
        process.exitCode = 1

if process.exitCode is 0
    process.stdout.write "All map files are solid\n"
