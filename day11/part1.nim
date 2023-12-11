import std/[ os, strutils, sequtils, sets, math ]

proc getUniverseExpansionsImpl(universe: string): (seq[int], seq[int]) =
    var width = universe.find '\n'
    var height: int = (int)(universe.len() / (width + 1))
    let emptyLine = '.'.repeat width

    var j = 0
    while j < height:
        if universe[j * (width + 1)..j * (width + 1) + (width - 1)] == emptyLine:
            result[1].add j
        j += 1
    var i = 0
    while i < width:
        var flag = true
        for j in (0..height):
            if universe[j * (width + 1) + i] != '.':
                flag = false
                break
        if flag:
            result[0].add i
        i += 1

proc getUniverseExpansionsSet(universe: string): (HashSet[int], HashSet[int]) =
    var ( setI, setJ ) = getUniverseExpansionsImpl universe
    return ( setI.toHashSet, setJ.toHashSet )

proc getAllGalaxies(universe: string): seq[int] =
    for i, c in universe:
        if c == '#': result.add i
    
proc generateGalaxyPairs(galaxies: seq[int]): seq[(int, int)] =
    for i in galaxies:
        for j in galaxies:
            if i == j: continue
            result.add if i > j: (i, j) else: (j, i)
    result = result.toHashSet.toSeq

let universe = readFile paramStr 1
let universeExpansions = getUniverseExpansionsSet universe
let galaxies = getAllGalaxies universe
let pairs = generateGalaxyPairs galaxies

let width = universe.find '\n'

var totalDistance = 0
for (a, b) in pairs:
    var ai = a mod (width + 1)
    var aj = (int)floor(a / (width + 1))
    var bi = b mod (width + 1)
    var bj = (int)floor(b / (width + 1))
    var mini = min(ai, bi)
    var minj = min(aj, bj)
    var maxi = max(ai, bi)
    var maxj = max(aj, bj)
    var di = maxi - mini
    var dj = maxj - minj
    for i in (mini..maxi):
        if i in universeExpansions[0]: di += 1
    for j in (minj..maxj):
        if j in universeExpansions[1]: dj += 1
    var dist = di + dj
    totalDistance += dist

echo totalDistance