import std/strutils
import std/os

proc is_integer(c: char): bool =
    c >= '0' and c <= '9';

proc get_line_calibration_value_str(line: string): string =
    if (len line) == 0: return "0"
    for i in 0..<len line:
        var c = line[i]
        if is_integer c:
            result &= c;
            break;
    for i in countdown(len(line) - 1, 0):
        var c = line[i]
        if is_integer c:
            result &= c;
            break;

proc get_calibration_value_total(lines: seq[string]): int =
    for line in lines: result += parseInt get_line_calibration_value_str line

var file_data = readFile paramStr 1
echo get_calibration_value_total file_data.split '\n'