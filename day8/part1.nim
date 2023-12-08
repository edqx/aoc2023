import std/[os, strutils, tables]

type Instruction = tuple[ name: string, left: string, right: string ]

var fileData = readFile paramStr 1
var lines = fileData.split '\n'

var directions = lines[0]
var dirI = 0

var instructions = initTable[string, Instruction]()
for i in (2..<len lines):
    var name = lines[i][0..2]
    instructions[name] = ( name, lines[i][7..9], lines[i][12..14] );

var start = instructions["AAA"]
var num = 0
while start.name != "ZZZ":
    start = instructions[if directions[dirI] == 'L': start.left else: start.right]
    dirI = (dirI + 1) mod len directions
    num += 1

echo num