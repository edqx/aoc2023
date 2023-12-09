import std/[os, strutils, sequtils]

proc getSequenceGeneration(numbers: seq[int]): seq[int] =
    var diff: seq[int] = @[]
    for i in (1..<len numbers):
        diff.add numbers[i] - numbers[i - 1]
    if diff.all(proc(x: int): bool = x == 0):
        return @[ numbers[numbers.low], 0 ]
    result.add numbers[numbers.low]
    result.add getSequenceGeneration diff

proc generateRegression(generation: seq[int]): int =
    result = generation[generation.high]
    for i in countdown(len(generation) - 2, 0, 1):
        result = generation[i] - result

var fileData = readFile paramStr 1
var lines = fileData.split '\n'

var total = 0
for line in lines:
    total += generateRegression getSequenceGeneration line.splitWhitespace.map parseInt

echo total