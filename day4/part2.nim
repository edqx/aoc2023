import std/tables
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
            result += 1

var fileData = readFile paramStr 1
var cards = fileData.split '\n'
var card_counts = initTable[int, int]()
for i, card in cards:
    var num = card_counts.getOrDefault(i, 1)
    card_counts[i] = num
    var score = get_card_score (card.split ":")[1]
    for j in 1..score:
        if card_counts.hasKey(i + j): card_counts[i + j] += num
        else: card_counts[i + j] = num + 1

var total = 0
for num in card_counts.values:
    total += num

echo total