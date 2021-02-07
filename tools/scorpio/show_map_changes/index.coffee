# index.coffee
# Parse dmm-tools output to generate images showing map changes

fs = require "fs"
readline = require "readline"

DIFF_TILE_RE = /different tile: \((\d+), (\d+), (\d+)\)/

ENCODING_UTF8 =
    encoding: "utf8"

inputFile = null

maxX = 1
maxY = 1
maxZ = 1
minX = 255
minY = 255
minZ = 255

parseInputLine = (input) ->
    result = DIFF_TILE_RE.exec input
    return if not result?
    x = parseInt result[1], 10
    y = parseInt result[2], 10
    z = parseInt result[3], 10
    maxX = Math.max x, maxX
    maxY = Math.max y, maxY
    maxZ = Math.max z, maxZ
    minX = Math.min x, minX
    minY = Math.min y, minY
    minZ = Math.min z, minZ

readLines = ->
    return new Promise (resolve, reject) ->
        rl = readline.createInterface
            input: fs.createReadStream inputFile, ENCODING_UTF8
        rl.on "close", ->
            return resolve true
        rl.on "error", ->
            return reject error
        rl.on "line", (input) ->
            line = parseInputLine input

do ->
    # process the input captured from dmm-tools diff-maps
    inputFile = process.argv[2]
    await readLines()
    # bail if there is bad multi-z mojo going on
    if minZ isnt maxZ
        process.exit 1
    # otherwise output the coordinates
    process.stdout.write "#{minX},#{minY}\n#{maxX},#{maxY}\n"
