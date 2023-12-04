import std/strutils
import std/os

proc get_schematic_character(schematic: var string, schematic_width, schematic_height, i, j: int): char =
    if i < 0 or i >= schematic_width: return '.'
    if j < 0 or j >= schematic_height: return '.'
    schematic[j * (schematic_width + 1) + i]

proc is_integer(c: char): bool = c >= '0' and c <= '9'
proc is_symbol(c: char): bool = c != '.' and not is_integer c

proc is_adjacent_to_symbol(schematic: var string, schematic_width, schematic_height, i, j: int): bool =
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i - 1, j - 1): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i, j - 1): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i + 1, j - 1): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i - 1, j): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i + 1, j): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i - 1, j + 1): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i, j + 1): return true
    if is_symbol get_schematic_character(schematic, schematic_width, schematic_height, i + 1, j + 1): return true
    return false

proc sum_engine_schematic_parts(schematic: var string): int =
    var schematic_lines = schematic.split '\n'
    var schematic_width = len schematic_lines[0]
    var schematic_height = len schematic_lines

    for j in 0..<schematic_height:
        var i = 0
        while i < schematic_width:
            var c = get_schematic_character(schematic, schematic_width, schematic_height, i, j)
            if is_integer c:
                var num_str = ""&c
                var k = i + 1
                while k < schematic_width:
                    var c2 = get_schematic_character(schematic, schematic_width, schematic_height, k, j)
                    if not is_integer c2:
                        break
                    num_str &= c2
                    k += 1
                for l in i..<k:
                    if is_adjacent_to_symbol(schematic, schematic_width, schematic_height, l, j):
                        result += parseInt num_str
                        break
                i += k - i
                continue
            i += 1

var fileData = readFile paramStr 1
echo sum_engine_schematic_parts fileData