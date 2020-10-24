# index.coffee
# Prepare each map to be compiled by GitHub CI

CANONICAL_MAP_LIST = [
    "cyberiad.dm"
    "delta.dm"
    "emerald.dm"
    "metastation.dm"
]

fs = require "fs"
glob = require "glob"
path = require "path"

mapsPath = path.join process.argv[2], "_maps"
files = glob.sync "**/*.dm", {cwd: mapsPath}
files = files.filter (x) -> x isnt "__MAP_DEFINES.dm"

process.stdout.write "There are #{files.length} maps to prepare\n"
process.exitCode = 0

for file in files
    if file not in CANONICAL_MAP_LIST
        process.stdout.write "ERROR: Map '#{file}' has not been added to the CANONICAL_MAP_LIST\n"
        process.exitCode = 1

# read the project's own DME
dmePath = path.join process.argv[2], "ci-scorpio.dme"
dmeText = fs.readFileSync dmePath, {encoding: "utf8"}

# prepare a DME with Cyberiad as the map
cyberiadPath = path.join process.argv[2], "ci-cyberiad.dme"
dmeCyberiad = dmeText.replace '#include "_maps\\emerald.dm"', '#include "_maps\\cyberiad.dm"'
dmeCyberiad = dmeCyberiad.replace '#include "code\\game\\area\\emerald_areas.dm"', '#include "code\\game\\area\\ss13_areas.dm"'
fs.writeFileSync cyberiadPath, dmeCyberiad

# prepare a DME with Delta as the map
deltaPath = path.join process.argv[2], "ci-delta.dme"
dmeDelta = dmeText.replace '#include "_maps\\emerald.dm"', '#include "_maps\\delta.dm"'
dmeDelta = dmeDelta.replace '#include "code\\game\\area\\emerald_areas.dm"', '#include "code\\game\\area\\ss13_areas.dm"'
fs.writeFileSync deltaPath, dmeDelta

# prepare a DME with Emerald as the map
emeraldPath = path.join process.argv[2], "ci-emerald.dme"
fs.writeFileSync emeraldPath, dmeText

# prepare a DME with MetaStation as the map
metastationPath = path.join process.argv[2], "ci-metastation.dme"
dmeMetastation = dmeText.replace '#include "_maps\\emerald.dm"', '#include "_maps\\metastation.dm"'
dmeMetastation = dmeMetastation.replace '#include "code\\game\\area\\emerald_areas.dm"', '#include "code\\game\\area\\ss13_areas.dm"'
fs.writeFileSync metastationPath, dmeMetastation

if process.exitCode is 0
    process.stdout.write "All maps have been prepared\n"
