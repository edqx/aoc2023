# fail

import std/[os, strutils, sets, sequtils]

proc countNumArrangements(conditions: string, numContiguous: seq[int], s: string, ss: var seq[string]): int =
    var str = s;
    if numContiguous.len() == 0:
        return if conditions.find('#') == -1:
            ss.add s
            1
        else: 0

    var lastContiguous = numContiguous[numContiguous.high]
    var lazy = initHashSet[int]()

    for j in countdown(conditions.len() - 1, lastContiguous - 1, 1):
        if conditions[j] == '.':
            continue

        var numContiguousBroken = 1
        for k in countdown(j - 1, 0, 1):
            if (conditions[k] == '?' and k <= j - lastContiguous) or conditions[k] == '.': break
            numContiguousBroken += 1
        var blockStart = j - numContiguousBroken + 1
        for k in countup(j + 1, conditions.len() - 1, 1):
            if conditions[k] == '?' or conditions[k] == '.': break
            numContiguousBroken += 1

        if numContiguousBroken != lastContiguous:
            continue

        if blockStart in lazy:
            continue
        lazy.incl blockStart

        var str2 = str
        for k in (blockStart..<blockStart + numContiguousBroken):
            if str2[k] != '#': str2[k] = '@'
        # echo str2, " at ", j, " for ", conditions, " (", conditions[blockStart..<blockStart + numContiguousBroken], ") for ", numContiguous
        if j <= lastContiguous:
            if numContiguous.len() == 1:
                # echo "|- add"
                result += 1
                ss.add str2
            continue
        if not conditions[blockStart..<blockStart + numContiguousBroken].any(proc(x: char): bool = x != '#'):
            # echo "|- exit early"
            result += conditions[0..<j - lastContiguous].countNumArrangements(numContiguous[0..<len(numContiguous) - 1], str2, ss)
            return
        result += conditions[0..<j - lastContiguous].countNumArrangements(numContiguous[0..<len(numContiguous) - 1], str2, ss)

proc countNumArrangements(record: string): int =
    var parts = record.split ' '
    var numContiguous = (parts[1].split ',').map parseInt
    var ss = newSeq[string]()
    result = parts[0].countNumArrangements(numContiguous, parts[0], ss)
    echo ss

let springRecords = readFile paramStr 1
let lines = springRecords.split '\n'
var total = 0
for record in lines:
    total += countNumArrangements record
echo total