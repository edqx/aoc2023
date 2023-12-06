import std/[os, strutils, sequtils]

proc parseIntegersWhitespace(x: string): seq[int] = x.splitWhitespace().map proc (y: string): int = parseInt y

let fileData = readFile paramStr 1
let lines = fileData.split '\n'
let times = parseIntegersWhitespace lines[0][10..<len lines[0]]
let distances = parseIntegersWhitespace lines[1][10..<len lines[1]]
var total = 0
for i, time in times:
    let distance = distances[i]
    if total == 0: total = 1
    total *= len (0..time).toSeq.filter proc (x: int): bool = x * (time - x) > distance

echo total