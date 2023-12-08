import std/[os, strutils, sequtils, tables]

proc gcd(a, b: int): int =
    if b == 0: return a
    gcd(b, a mod b)

proc lcm(a, b: int): int =
    if a > b:
        return (int)(a / gcd(a,b)) * b
    else:
        return (int)(b / gcd(a,b)) * a

type Instruction = tuple[ name: string, left: string, right: string ]

var fileData = readFile paramStr 1
var lines = fileData.split '\n'

var directions = lines[0]
var dirI = 0

var instructions = initTable[string, Instruction]()
for i in (2..<len lines):
    var name = lines[i][0..2]
    instructions[name] = ( name, lines[i][7..9], lines[i][12..14] );

var paths = instructions.values.toSeq.filter proc (x: Instruction): bool = x.name.endsWith "A"
var pathsNum = newSeq[int](len paths)
for i, path in paths:
    var start = paths[i]
    while not start.name.endsWith "Z":
        start = instructions[if directions[dirI] == 'L': start.left else: start.right]
        dirI = (dirI + 1) mod len directions
        pathsNum[i] += 1

var total = pathsNum[0]
for i in (1..<len pathsNum):
    total = lcm(total, pathsNum[i])

echo total