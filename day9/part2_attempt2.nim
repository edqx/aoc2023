import std/[os, strutils, sequtils]

proc getDiff(numbers: seq[int]): seq[int] =
    for i in (1..<len numbers): result.add numbers[i] - numbers[i - 1]

proc generateRegression(numbers: seq[int]): int =
    var diff = getDiff numbers
    if diff.any(proc(x: int): bool = x != 0): numbers[numbers.low] - generateRegression diff else: numbers[numbers.low]

var fileData = readFile paramStr 1
var lines = fileData.split '\n'
echo lines.foldl(a + generateRegression b.splitWhitespace.map parseInt, 0)