import std/strutils
import std/os

proc get_next_number(str: var string, last: bool): int =
    var i = 0
    result = -1
    while i < len str:
        if not last and result != -1: return result
        if str[i] >= '0' and str[i] <= '9':
            result = ord(str[i]) - ord('0')
            i += 1
            continue
        var j = 0
        while i + j < len(str) and j <= 5:
            var r = str[i..(i + j)]
            case r:
                of "one": result = 1
                of "two": result = 2
                of "three": result = 3
                of "four": result = 4
                of "five": result = 5
                of "six": result = 6
                of "seven": result = 7
                of "eight": result = 8
                of "nine": result = 9
                else:
                    j += 1
                    continue
            if not last: return result
            break
        i += 1

var file_data = readFile paramStr 1
var lines = file_data.split '\n'
var total = 0
for i in 0..(len(lines) - 1):
    var line = lines[i]
    var num1 = get_next_number(line, false)
    var num2 = get_next_number(line, true)
    var comb = num1 * 10 + num2
    total += comb

echo total