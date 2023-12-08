import std/strutils
import std/sequtils
import std/os

type Round = ( int, int, int )

proc parse_as_round(round: string, limits: Round): bool =
    var hands = round.split ", "
    for hand in hands:
        var parts = hand.split ' '
        if parts[1] == "red" and parseInt(parts[0]) > limits[0]: return false
        if parts[1] == "green" and parseInt(parts[0]) > limits[1]: return false
        if parts[1] == "blue" and parseInt(parts[0]) > limits[2]: return false
    return true

proc parse_as_game(game: string, limits: Round): int =
    var parts = game.split ": " 
    var rounds = parts[1].split "; "
    return if rounds.all (proc(round: string): bool = round.parse_as_round limits):
        parseInt (parts[0].split ' ')[1] else: 0

var fileData = readFile paramStr 1
var games = file_data.split '\n'
var limits = ( red: 12, green: 13, blue: 14 )
var gameIdTotal = 0
for game in games:
    gameIdTotal += game.parse_as_game limits

echo gameIdTotal