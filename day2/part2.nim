import std/strutils
import std/os

type Round = ( int, int, int )

proc parse_as_round(round: string, limits: var Round): void =
    var hands = round.split ", "
    for hand in hands:
        var parts = hand.split ' '
        case parts[1][0]:
            of 'r':
                if parseInt(parts[0]) > limits[0]: limits[0] = parseInt(parts[0])
            of 'g':
                if parseInt(parts[0]) > limits[1]: limits[1] = parseInt(parts[0])
            of 'b':
                if parseInt(parts[0]) > limits[2]: limits[2] = parseInt(parts[0])
            else: discard

proc parse_as_game(game: string, limits: var Round): void =
    var parts = game.split ": " 
    var rounds = parts[1].split "; "
    for round in rounds:
        round.parse_as_round limits

var fileData = readFile paramStr 1
var games = file_data.split '\n'
var totalPower = 0
for game in games:
    var limits = ( 0, 0, 0 )
    game.parse_as_game limits
    totalPower += limits[0] * limits[1] * limits[2]

echo totalPower