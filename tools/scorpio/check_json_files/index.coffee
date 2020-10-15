# index.coffee
# Verify the project JSON files are valid

fs = require "fs"
glob = require "glob"
path = require "path"

files = glob.sync "**/*.json", {cwd: process.argv[2]}

process.stdout.write "There are #{files.length} JSON files to check\n"
process.exitCode = 0

for file in files
    filePath = path.join process.argv[2], file
    text = fs.readFileSync filePath, {encoding: "utf8"}
    try
        obj = JSON.parse text
    catch e
        process.stdout.write "ERROR: File '#{file}' contains invalid JSON\n"
        process.exitCode = 1

if process.exitCode is 0
    process.stdout.write "All JSON files are valid\n"
