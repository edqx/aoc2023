import std/[os, sets, sequtils]

type Direction = enum Up, Down, Left Right
type Beam = tuple[i, j: int, dir: Direction ]
type Grid = tuple[chars: seq[seq[char]], energized: HashSet[Beam]]

proc processBeam(grid: var Grid, beam: Beam): seq[Beam] =
    if beam in grid.energized:  return
    grid.energized.incl beam
    case beam.dir:
        of Up:
            if beam.j == 0: return
            case grid.chars[beam.i][beam.j - 1]:
                of '-':
                    return @[Beam (beam.i, beam.j - 1, Left), Beam (beam.i, beam.j - 1, Right)]
                of '\\':
                    return @[Beam (beam.i, beam.j - 1, Left)]
                of '/':
                    return @[Beam (beam.i, beam.j - 1, Right)]
                else: return @[ Beam (beam.i, beam.j - 1, Up) ]
        of Down:
            if beam.j == grid.chars[beam.i].len - 1: return
            case grid.chars[beam.i][beam.j + 1]:
                of '-':
                    return @[Beam (beam.i, beam.j + 1, Left), Beam (beam.i, beam.j + 1, Right)]
                of '\\':
                    return @[Beam (beam.i, beam.j + 1, Right)]
                of '/':
                    return @[Beam (beam.i, beam.j + 1, Left)]
                else: return @[ Beam (beam.i, beam.j + 1, Down) ]
        of Left:
            if beam.i == 0: return
            case grid.chars[beam.i - 1][beam.j]:
                of '|':
                    return @[Beam (beam.i - 1, beam.j, Up), Beam (beam.i - 1, beam.j, Down)]
                of '\\':
                    return @[Beam (beam.i - 1, beam.j, Up)]
                of '/':
                    return @[Beam (beam.i - 1, beam.j, Down)]
                else: return @[Beam (beam.i - 1, beam.j, Left)]
        of Right:
            if beam.i == grid.chars.len - 1: return
            case grid.chars[beam.i + 1][beam.j]:
                of '|':
                    return @[Beam (beam.i + 1, beam.j, Up), Beam (beam.i + 1, beam.j, Down)]
                of '\\':
                    return @[Beam (beam.i + 1, beam.j, Down)]
                of '/':
                    return @[Beam (beam.i + 1, beam.j, Up)]
                else: return @[Beam (beam.i + 1, beam.j, Right)]

proc processBeams(grid: var Grid, beams: var seq[Beam]): void =
    while beams.len > 0:
        var copy = beams;
        beams = @[]
        for beam in copy:
            beams.add grid.processBeam beam

proc getGridChars(str: string): seq[seq[char]] =
    var width = str.find '\n'
    var height = int str.len / width
    for i in 0..<width:
        result.add @[]
        for j in 0..<height:
            result[i].add str[j * (width + 1) + i]

proc newGrid(str: string): Grid =
    return Grid (getGridChars str, initHashSet[Beam]() )

var grid = newGrid readFile paramStr 1
var initBeam = Beam (-1, 0, Right)
var initBeams = @[ initBeam ]
grid.processBeams initBeams
grid.energized.excl initBeam
echo grid.energized.toSeq.map(proc(x: Beam): (int, int) = (x.i, x.j)).deduplicate().len

