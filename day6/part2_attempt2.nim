import std/[os, strutils, math]

let fileData = readFile paramStr 1
let lines = fileData.split '\n'
let time = parseFloat lines[0][10..<len lines[0]].splitWhitespace().join ""
let distance = parseFloat lines[1][10..<len lines[1]].splitWhitespace().join ""
echo (int)(ceil((time + sqrt((float32)(time^2 - 4 * distance))) / 2) - ceil((time - sqrt((float32)(time^2 - 4 * distance))) / 2))