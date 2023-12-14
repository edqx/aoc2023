import std/[os, strutils, tables]

type Direction = enum North, East, South, West
type Platform = tuple[str: string, width, height: int]

proc rollRockOnce(platform: var Platform, ai: var int, bi: int): bool =
    if platform.str[bi] == '#' or platform.str[bi] == 'O': return false
    swap(platform.str[ai], platform.str[bi])
    ai = bi
    return true

proc rollRocks(platform: var Platform, direction: Direction): void =
    case direction:
        of North:
            for i, _ in platform.str:
                if platform.str[i] != 'O': continue
                var y = i
                while y > platform.width and platform.rollRockOnce(y, y - platform.width - 1):
                    continue
        of East:
            for i in countdown(platform.width - 1, 0, 1):
                for j in countup(0, platform.height - 1, 1):
                    var y = j * (platform.width + 1) + i
                    if platform.str[y] != 'O': continue
                    while (y mod (platform.width + 1)) != (platform.width - 1) and platform.rollRockOnce(y, y + 1):
                        continue
        of South:
            for i in countdown(platform.str.len - 1, 0, 1):
                if platform.str[i] != 'O': continue
                var y = i
                while y < platform.height * platform.width - 1 and platform.rollRockOnce(y, y + platform.width + 1):
                    continue
        of West:
            for i in countup(0, platform.width - 1, 1):
                for j in countup(0, platform.height - 1, 1):
                    var y = j * (platform.width + 1) + i
                    if platform.str[y] != 'O': continue
                    while (y mod (platform.width + 1)) != 0 and platform.rollRockOnce(y, y - 1):
                        continue

proc rollRocksCycle(platform: var Platform): void =
    platform.rollRocks North
    platform.rollRocks West
    platform.rollRocks South
    platform.rollRocks East

var platformStr = readFile paramStr 1
var width = platformStr.find '\n'
var height = int platformStr.len / width
var platform = Platform (platformStr, width, height)

var memo = initTable[string, int]();
var numCycles = 1000000000
var period = numCycles
var offset = 0

for i in 1..numCycles:
    rollRocksCycle platform
    if memo.hasKey platform.str:
        offset = memo[platform.str]
        period = i - memo[platform.str]
        break
    memo[platform.str] = i

var delta = offset + ((numCycles - offset) mod period)
for (key, val) in memo.pairs:
    if val == delta:
        platform.str = key
        break

var total = 0
for i, ch in platform.str:
    if ch != 'O': continue
    total += height - (int i / (width + 1))

echo total