import std/strutils
import std/sequtils
import std/os

type MapHeader = tuple[source: string, destination: string]
type Mapping = tuple[ sourceN: int, destinationN: int, rangeN: int ]

proc get_map_name(map_header: string): MapHeader =
    var splitHyphen = map_header[0..^6].split '-'
    return ( splitHyphen[0], splitHyphen[2] )

proc get_mapping(line: string): Mapping =
    var splitSpace = line.split ' '
    return ( parseInt splitSpace[1], parseInt splitSpace[0], parseInt splitSpace[2] )

proc find_map_by_name(fileLines: var seq[string], name: string): (bool, MapHeader, seq[Mapping]) =
    for i, line in fileLines:
        if not line.endsWith "map:": continue
        result[1] = get_map_name line
        if result[1].source == name:
            result[0] = true
            var j = i + 1
            while true:
                if j >= len fileLines: return
                if isEmptyOrWhitespace fileLines[j]: return
                result[2].add get_mapping fileLines[j]
                j += 1
    return (false, ( "", "" ), @[])

proc get_maps(fileLines: var seq[string], start: string): seq[( MapHeader, seq[Mapping] )] =
    var ( found, header, mappings ) = fileLines.find_map_by_name start
    while found:
        result.add (header, mappings)
        ( found, header, mappings ) = fileLines.find_map_by_name header.destination

proc get_map_by_name(maps: seq[( MapHeader, seq[Mapping] )], name: string): ( MapHeader, seq[Mapping] ) =
    for map in maps:
        if map[0].source == name:
            return map

proc get_mappings(mappings: seq[Mapping], iStartN: int, iRangeN: int): seq[tuple[startN: int, rangeN: int]] =
    var final: seq[( int, int )] = @[]
    var stack = @[( iStartN, iRangeN )]
    while len(stack) > 0:
        var found = false
        var (startN, rangeN) = stack[0]
        stack.delete(0)
        for mapping in mappings:
            if (startN + rangeN > mapping.sourceN and startN < mapping.sourceN + mapping.rangeN) or (mapping.sourceN + mapping.rangeN > startN and mapping.sourceN < startN + rangeN):
                found = true
                if startN >= mapping.sourceN and rangeN <= mapping.rangeN:
                    final.add ( mapping.destinationN + (startN - mapping.sourceN), rangeN )
                    continue
                if startN < mapping.sourceN:
                    stack.add ( startN, mapping.sourceN - startN )
                    rangeN = rangeN - (mapping.sourceN - startN)
                    startN = mapping.sourceN
                if startN + rangeN > mapping.sourceN + mapping.rangeN:
                    stack.add ( mapping.sourceN + mapping.rangeN, startN + rangeN - mapping.sourceN - mapping.rangeN )
                    rangeN = mapping.sourceN + mapping.rangeN - startN
                if rangeN > 0:
                    final.add ( mapping.destinationN + (startN - mapping.sourceN), rangeN )
        if not found:
            final.add ( startN, rangeN )
    return final

var fileData = readFile paramStr 1
var lines = fileData.split '\n'

var seeds = (lines[0][7..^1].split ' ').map proc (x: string): int = parseInt x
var lowest_location = high(int)
var maps = lines.get_maps "seed"
var i = 0
while i < len seeds:
    var seedStartN = seeds[i]
    var seedRangeN = seeds[i + 1]
    var ( mapHeader, mappings ) = maps.get_map_by_name "seed"
    var newRanges = mappings.get_mappings(seedStartN, seedRangeN)
    while mapHeader.destination != "location":
        ( mapHeader, mappings ) = maps.get_map_by_name mapHeader.destination
        var newNewRanges = newRanges.map proc (x: tuple[startN: int, rangeN: int]): seq[tuple[startN: int, rangeN: int]] = mappings.get_mappings(x.startN, x.rangeN)
        newRanges = @[]
        for ranges in newNewRanges:
            for krange in ranges:
                newRanges.add krange
    for krange in newRanges:
        if krange.startN < lowest_location:
            lowest_location = krange.startN
    i += 2

echo lowest_location

