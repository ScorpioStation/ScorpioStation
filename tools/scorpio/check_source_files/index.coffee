# index.coffee
# Verify the project source files have Linux line endings

BAD_GLOB_RE = /^\/*var\//

fs = require "fs"
glob = require "glob"
path = require "path"

files = []
files = files.concat glob.sync "**/*.dm", {cwd: process.argv[2]}
files = files.concat glob.sync "**/*.dme", {cwd: process.argv[2]}
files = files.concat glob.sync "**/*.dmm", {cwd: process.argv[2]}

process.stdout.write "There are #{files.length} source files to check\n"
process.exitCode = 0

for file in files
    filePath = path.join process.argv[2], file
    text = fs.readFileSync filePath, {encoding: "utf8"}

    if text.indexOf("\r\n") isnt -1
        process.stdout.write "ERROR: File '#{file}' contains Windows line endings\n"
        process.exitCode = 1

    if not text.endsWith "\n"
        process.stdout.write "ERROR: File '#{file}' does not end with a Linux newline\n"
        process.exitCode = 1

    if BAD_GLOB_RE.test text
        process.stdout.write "ERROR: File '#{file}' contains an unmanaged global variable\n"
        process.exitCode = 1

if process.exitCode is 0
    process.stdout.write "All source files have Linux line endings\n"
