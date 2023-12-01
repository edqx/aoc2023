import std/strutils
import std/sequtils
import std/os

var natural_count = @[ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ]

proc is_integer(c: char): bool =
    c >= '0' and c <= '9';

proc to_string(c: char): string =
    result &= c

proc parse_number(str: string, i: int, j: int = i): int =
    if j > len(str) - 1: return -1
    var full = str[i..j]
    if len(full) > 5: return -1
    for k, num in natural_count:
        if len(num) == len(full) and num == full: return k
        if len(full) > len(num): continue
        var parsed = parse_number(str, i, j + 1)
        if parsed != -1: return parsed
    return -1

proc get_all_numbers(str: string): seq[int] =
    var i = 0
    while i < len(str):
        if is_integer str[i]:
            result.add parseInt to_string str[i]
            i += 1
            continue
        var num = parse_number(str, i)
        if num != -1:
            i += len natural_count[num]
            result.add num
        else:
            i += 1

proc get_calibration_value(nums: seq[int]): int =
    if len(nums) == 0: return 0
    return parseInt($nums[0] & $nums[len(nums) - 1])

var file_data = readFile paramStr 1
var lines = file_data.split '\n'
var total = 0
for i, line in lines:
    echo $((i / len lines) * 100), "% done"
    var val = get_calibration_value get_all_numbers line
    echo "- ", line, " ", val, " ", get_all_numbers line, " (", i, ")"
    total += val

echo total

