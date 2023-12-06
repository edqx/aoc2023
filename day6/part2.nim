import std/[os, strutils]

proc parseIntegersWhitespace(x: string): int = parseInt x.splitWhitespace().join("")

let fileData = readFile paramStr 1
let lines = fileData.split '\n'
let time = parseIntegersWhitespace lines[0][10..<len lines[0]]
let distance = parseIntegersWhitespace lines[1][10..<len lines[1]]
var total = 0
for x in (0..time):
    if x * (time - x) > distance: total += 1

echo total