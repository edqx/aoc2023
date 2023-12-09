import std/[os, strutils, sequtils]

proc getSequenceGeneration(numbers: seq[int]): seq[int] =
    var diff: seq[int] = @[]
    for i in (1..<len numbers):
        diff.add numbers[i] - numbers[i - 1]
    if diff.all(proc(x: int): bool = x == 0):
        return @[ numbers[numbers.high], 0 ]
    result.add numbers[numbers.high]
    result.add getSequenceGeneration diff

var fileData = readFile paramStr 1
var lines = fileData.split '\n'

var total = 0
for line in lines:
    var generateSequence = getSequenceGeneration line.splitWhitespace.map parseInt
    for delta in generateSequence:
        total += delta

echo total