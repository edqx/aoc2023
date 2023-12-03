import std/strutils
import std/os

type Schematic = object
    data: string
    dimensions: tuple[width: int, height: int]

proc create_schematic(data: var string): Schematic =
    var schematic_lines = data.split '\n'
    return Schematic(data: data, dimensions: ( width: len schematic_lines[0], height: len schematic_lines ))

proc get_data_position(schematic: var Schematic, i, j: int): int =
    j * (schematic.dimensions.width + 1) + i

proc get_character(schematic: var Schematic, i, j: int): char =
    if i < 0 or i >= schematic.dimensions.width: return '.'
    if j < 0 or j >= schematic.dimensions.height: return '.'
    schematic.data[schematic.get_data_position(i, j)]

proc is_integer(c: char): bool = c >= '0' and c <= '9'

proc expand_number(schematic: var Schematic, i, j: int): int =
    var first = i
    # find start of number
    while true:
        if not is_integer get_character(schematic, first - 1, j):
            break
        first -= 1
    var last = i
    while true:
        if not is_integer get_character(schematic, last + 1, j):
            break
        last += 1
    return parseInt schematic.data[schematic.get_data_position(first, j)..schematic.get_data_position(last, j)]

proc get_number_vertical(schematic: var Schematic, above: bool, i, j: int, check: var int): int =
    var d = if above: 1 else: -1
    result = 1
    if is_integer schematic.get_character(i, j + d):
        check += 1
        return schematic.expand_number(i, j + d)
    if is_integer schematic.get_character(i - 1, j + d):
        check += 1
        result *= schematic.expand_number(i - 1, j + d)
    if is_integer schematic.get_character(i + 1, j + d):
        check += 1
        result *= schematic.expand_number(i + 1, j + d)

proc get_number_horizontal(schematic: var Schematic, right: bool, i, j: int, check: var int): int =
    var d = if right: 1 else: -1
    if is_integer schematic.get_character(i + d, j):
        check += 1
        return schematic.expand_number(i + d, j)
    if is_integer schematic.get_character(i + d, j):
        check += 1
        return schematic.expand_number(i + d, j)
    return 1

proc sum_engine_schematic_gears(schematic: var Schematic): int =
    for j in 0..<schematic.dimensions[1]:
        var i = 0
        while i < schematic.dimensions[0]:
            var c = schematic.get_character(i, j)
            if c == '*':
                var check = 0
                var top = schematic.get_number_vertical(true, i, j, check)
                var left = schematic.get_number_horizontal(false, i, j, check)
                var right = schematic.get_number_horizontal(true, i, j, check)
                var bottom = schematic.get_number_vertical(false, i, j, check)
                if check == 2:
                    result += top * left * right * bottom
            i += 1

var fileData = readFile paramStr 1
var schematic = create_schematic fileData
echo schematic.sum_engine_schematic_gears()

