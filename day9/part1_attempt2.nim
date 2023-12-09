import std/[os, strutils, sequtils]

proc getDiff(numbers: seq[int]): seq[int] =
    for i in (1..<len numbers): result.add numbers[i] - numbers[i - 1]

proc generateNextElement(numbers: seq[int]): int =
    var diff = getDiff numbers
    numbers[numbers.high] + (if diff.any(proc(x: int): bool = x != 0): generateNextElement diff else: 0)

var fileData = readFile paramStr 1
var lines = fileData.split '\n'
echo lines.foldl(a + generateNextElement b.splitWhitespace.map parseInt, 0)