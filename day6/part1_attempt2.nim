import std/[os, strutils, sequtils, math]

proc parseIntegersWhitespace(x: string): seq[float32] = x.splitWhitespace().map proc (y: string): float32 = parseFloat y

let fileData = readFile paramStr 1
let lines = fileData.split '\n'
let times = parseIntegersWhitespace lines[0][10..<len lines[0]]
let distances = parseIntegersWhitespace lines[1][10..<len lines[1]]
var total = 0
for i, time in times:
    let distance = distances[i]
    var x1 = (time - sqrt((float32)(time^2 - 4 * distance))) / 2
    var x2 = (time + sqrt((float32)(time^2 - 4 * distance))) / 2
    if total == 0: total = 1
    total *= (int)(ceil(x2) - ceil(x1))

echo total

