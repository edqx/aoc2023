import std/[os, strutils, sequtils, decls]

type Lens = tuple[label: string, focalLength: int]

proc parseInt(ch: char): int = parseInt ""&ch
proc hash(str: string): int = str.foldl(((a + ord(b)) * 17) mod 256, 0)

proc findPredicate[T](s: seq[T], pred: proc(x: T): bool): int =
    for i, x in s:
        if pred(x): return i
    return -1

var boxes = newSeq[seq[Lens]](256)
var instructions = (readFile paramStr 1).split(',')
for instruction in instructions:
    var opIdx = max(instruction.find '=', instruction.find '-')
    var label = instruction[0..<opIdx]
    var operation = instruction[opIdx]
    var box {.byaddr.} = boxes[hash label]
    var existingLens = box.findPredicate proc(lens: Lens): bool = lens.label == label
    case operation:
        of '=':
            var focalLength = parseInt instruction[opIdx + 1]
            if existingLens == -1:
                box.add Lens (label, focalLength)
            else:
                box[existingLens].focalLength = focalLength
        of '-':
            if existingLens != -1: box.delete existingLens
        else: raise Exception.newException "waah"

var total = 0
for i, box in boxes:
    for j, lens in box:
        total += (i + 1) * (j + 1) * lens.focalLength
echo total