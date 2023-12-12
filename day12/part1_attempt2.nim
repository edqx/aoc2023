import std/[os, strutils, sequtils]

proc findLast(str: string, substr: string): int =
    for i in countdown(str.len() - substr.len(), 0, 1):
        if str[i..<i + substr.len()] == substr:
            return i

proc countNumArrangements(conditions: string, numContiguous: seq[int]): int =
    if numContiguous.len() == 0: return if conditions.find('#') == -1: 1 else: 0

    let contiguous = numContiguous[numContiguous.high]
    var j = len(conditions) - contiguous

    if j < 0: return 0

    var hack = findLast(conditions, "#")
    if hack > j:
        for i in countdown(hack, j, 1):
            if conditions[i] == '.':
                return 0
    
    while j >= 0:
        if j + contiguous <= conditions.high:
            if conditions[j + contiguous] == '#': return
        if conditions[j] == '.':
            j -= 1
            continue

        var origin = j
        if j > 0 and conditions[j - 1] == '#':
            var flag = false
            while conditions[j - 1] == '#':
                j -= 1
                if j == 0:
                    flag = true
                    break
            if flag:
                j = origin - 1
                continue

        var k = 1
        while (j + k <= conditions.high) and (conditions[j + k] == '#' or (conditions[j + k] == '?' and (j - origin) + k < contiguous)):
            k += 1
            if j + k == conditions.len():
                break
        if k != contiguous:
            j = origin - 1
            continue
        if j <= 0:
            if numContiguous.len() != 1 or conditions.findLast("#") <= j + k:
                result += "".countNumArrangements numContiguous[0..<numContiguous.len() - 1]
            j -= 1
            continue
        result += conditions[0..<j - 1].countNumArrangements numContiguous[0..<numContiguous.len() - 1]
        j -= 1

proc countNumArrangements(record: string): int =
    var parts = record.split ' '
    var numContiguous = (parts[1].split ',').map parseInt
    parts[0].countNumArrangements numContiguous

let springRecords = readFile paramStr 1
let lines = springRecords.split '\n'
var total = 0
for record in lines:
    total += countNumArrangements record
echo total