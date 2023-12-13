import std/[os, math, strutils]

proc getHorizontalLineOfReflection(str: string): int =
    var width = str.find '\n'
    var height = int floor str.len() / (width + 1)
    var maxj = 0
    result = 0
    for i in 1..height:
        var j = 0
        var flag = false
        while i - j >= 1 and i + j <= height:
            var startA = (i - j - 1) * (width + 1)
            var a = str[startA..startA + (width - 1)]
            var startB = (i + j) * (width + 1)
            var b = str[startB..startB + (width - 1)]
            if a != b:
                flag = true
                break
            j += 1
        if not flag and j > maxj:
            result = i
            maxj = j
        
proc getVerticalLineOfReflection(str: string): int =
    var width = str.find '\n'
    var height = int floor str.len() / (width + 1)
    var maxj = 0
    result = 0
    for i in 1..<width:
        var j = 0
        var flag = false
        while i - j >= 1 and i + j < width:
            for k in 0..height:
                if str[k * (width + 1) + (i - j - 1)] != str[k * (width + 1) + (i + j)]:
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
    var vertical = getVerticalLineOfReflection notes
    total += vertical
    var horizontal = getHorizontalLineOfReflection notes
    total += horizontal * 100

echo total