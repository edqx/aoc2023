import std/[os, strutils]

proc applyGravityToRock(platform: var string, i: int): void =
    if platform[i] != 'O': return

    var width = platform.find '\n'
    var y = i
    while y > width:
        var below = platform[y - width - 1]
        if below == '#' or below == 'O': break
        swap(platform[y - width - 1], platform[y])
        y -= width + 1

proc applyGravityToPlatform(platform: var string): void =
    for i, _ in platform: platform.applyGravityToRock i

var platform = readFile paramStr 1
platform.applyGravityToPlatform()
var width = platform.find '\n'
var height = int platform.len / width
var total = 0
for i, ch in platform:
    if ch != 'O': continue
    total += height - (int i / (width + 1))

echo total