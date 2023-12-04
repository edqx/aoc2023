import std/strutils
import std/sequtils
import std/sets
import std/os

proc get_numbers(numbers: seq[string]): seq[int] =
    return numbers.filter(proc (x: string): bool = not x.isEmptyOrWhitespace()).map(proc (x: string): int = parseInt x)

proc get_card_score(card: string): int =
    var parts = card.split '|'
    var winning_numbers = toHashSet get_numbers parts[0].split ' '
    var our_numbers = get_numbers parts[1].split ' '
    for x in our_numbers:
        if x in winning_numbers:
            if result == 0: result = 1
            else: result *= 2

var fileData = readFile paramStr 1
var cards = fileData.split '\n'
var total = 0
for card in cards:
    total += get_card_score (card.split ":")[1]

echo total