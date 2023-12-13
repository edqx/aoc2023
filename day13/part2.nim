import std/[os, math, strutils]

proc getHorizontalLineOfReflection(str: string, diff: int): int =
    var width = str.find '\n'
    var height = int floor str.len() / (width + 1)
    var maxj = 0
    result = 0
    for i in 1..height:
        if i == diff: continue
        var j = 0
        var flag = false
        var used_smudge = false
        while i - j >= 1 and i + j <= height:
            for k in 0..<width:
                if str[(i - j - 1) * (width + 1) + k] != str[(i + j) * (width + 1) + k]:
                    if not used_smudge and diff != -1:
                        used_smudge = true
                        continue
                    flag = true
                    break
            if flag:
                break
            j += 1
        if not flag and j > maxj:
            result = i
            maxj = j
        
proc getVerticalLineOfReflection(str: string, diff: int): int =
    var width = str.find '\n'
    var height = int floor str.len() / (width + 1)
    var maxj = 0
    result = 0
    for i in 1..<width:
        if i == diff: continue
        var j = 0
        var flag = false
        var used_smudge = false
        while i - j >= 1 and i + j < width:
            for k in 0..height:
                if str[k * (width + 1) + (i - j - 1)] != str[k * (width + 1) + (i + j)]:
                    if not used_smudge and diff != -1:
                        used_smudge = true
                        continue
                    flag = true
                    break
            if flag:
                break
            j += 1
        if not flag and j > maxj:
            result = i
            maxj = j

let allNotesStr = readFile paramStr 1
let allNotes = allNotesStr.split "\n\n"
var total = 0
for notes in allNotes:
    var vertical1 = getVerticalLineOfReflection(notes, -1)
    var vertical2 = getVerticalLineOfReflection(notes, vertical1)
    total += vertical2
    var horizontal1 = getHorizontalLineOfReflection(notes, -1)
    var horizontal2 = getHorizontalLineOfReflection(notes, horizontal1)
    total += horizontal2 * 100

echo total