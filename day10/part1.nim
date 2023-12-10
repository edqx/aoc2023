import std/[os, strutils]

proc getPipes(data: string, width: int, i: int, thisPipe: char): seq[int] =
    case thisPipe:
        of '|':
            if i >= width and (data[i - width - 1] == '|' or data[i - width - 1] == '7' or data[i - width - 1] == 'F' or data[i - width - 1] == 'S'): result.add i - width - 1
            if i < len(data) - width and (data[i + width + 1] == '|' or data[i + width + 1] == 'J' or data[i + width + 1] == 'L' or data[i + width + 1] == 'S'): result.add i + width + 1
        of '-':
            if not (i mod (width + 1) == 0) and data[i - 1] == '-' or data[i - 1] == 'L' or data[i - 1] == 'F' or data[i - 1] == 'S': result.add i - 1
            if not (i mod (width + 1) == width - 1) and (data[i + 1] == '-' or data[i + 1] == 'J' or data[i + 1] == '7' or data[i + 1] == 'S'): result.add i + 1
        of 'L':
            if i >= width and (data[i - width - 1] == '|' or data[i - width - 1] == '7' or data[i - width - 1] == 'F' or data[i - width - 1] == 'S'): result.add i - width - 1
            if not (i mod (width + 1) == width - 1) and (data[i + 1] == '-' or data[i + 1] == 'J' or data[i + 1] == '7' or data[i + 1] == 'S'): result.add i + 1
        of 'J':
            if i >= width and (data[i - width - 1] == '|' or data[i - width - 1] == '7' or data[i - width - 1] == 'F' or data[i - width - 1] == 'S'): result.add i - width - 1
            if not (i mod (width + 1) == 0) and (data[i - 1] == '-' or data[i - 1] == 'L' or data[i - 1] == 'F' or data[i - 1] == 'S'): result.add i - 1
        of '7':
            if i < len(data) - width and (data[i + width + 1] == '|' or data[i + width + 1] == 'J' or data[i + width + 1] == 'L' or data[i + width + 1] == 'S'): result.add i + width + 1
            if not (i mod (width + 1) == 0) and (data[i - 1] == '-' or data[i - 1] == 'L' or data[i - 1] == 'F' or data[i - 1] == 'S'): result.add i - 1
        of 'F':
            if i < len(data) - width and (data[i + width + 1] == '|' or data[i + width + 1] == 'J' or data[i + width + 1] == 'L' or data[i + width + 1] == 'S'): result.add i + width + 1
            if not (i mod (width + 1) == width - 1) and (data[i + 1] == '-' or data[i + 1] == 'J' or data[i + 1] == '7' or data[i + 1] == 'S'): result.add i + 1
        of '.':
            return @[]
        of 'S':
            result.add getPipes(data, width, i, '|')
            result.add getPipes(data, width, i, '-')
        else:
            raise Defect.newException("waah")

proc addTraversedPath(sequence: var seq[int], data: string): void =
    var width = data.find "\n"
    var sPos = data.find 'S'

    var pipes = getPipes(data, width, sPos, data[sPos])
    var lastPos = -1
    while true:
        if len(pipes) == 0: break
        var next = if pipes[0] == lastPos: pipes[1] else: pipes[0]
        lastPos = sPos
        sPos = next
        if data[sPos] == 'S': break
        sequence.add sPos
        pipes = getPipes(data, width, sPos, data[sPos])

var sequence: seq[int] = @[]
sequence.addTraversedPath readFile paramStr 1

echo (len(sequence) + 1) / 2

