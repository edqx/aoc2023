import std/[os, strutils, sequtils]

var cardScores = @[ 'A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J' ]
type DeckKindBid = tuple[deck: string, kind: int, bid: int]

proc countOccurances(deck: string, card: char, countJokers: bool): int =
    for card2 in deck:
        if card2 == card or (countJokers and card2 == 'J'): result += 1
        
proc findPredicate[T](s: seq[T], pred: proc(x: T, idx: int): bool): int =
    for i, x in s:
        if pred(x, i):
            return i
    return -1

proc getKind(deck: string): int =
    var cardCounts = deck.toSeq.map proc (card: char): int = countOccurances(deck, card, false)
    var cardCountsJ = deck.toSeq.map proc (card: char): int = countOccurances(deck, card, true)
    echo deck, ": ", cardCounts, ", ", cardCountsJ
    if cardCountsJ[0] == 5 or cardCountsJ[1] == 5 or cardCountsJ[2] == 5 or cardCountsJ[3] == 5 or cardCountsJ[4] == 5: return 7
    if cardCountsJ[0] == 4 or cardCountsJ[1] == 4 or cardCountsJ[2] == 4 or cardCountsJ[3] == 4 or cardCountsJ[4] == 4: return 6
    if (cardCounts[0] == 3 or cardCounts[1] == 3 or cardCounts[2] == 3 or cardCounts[3] == 3 or cardCounts[4] == 3) and (cardCountsJ[0] == 2 or cardCountsJ[1] == 2 or cardCountsJ[2] == 2 or cardCountsJ[3] == 2 or cardCountsJ[4] == 2):
        return 5
    var idx = cardCountsJ.find 3
    if idx != -1:
        var first3 = deck[idx]
        if cardCountsJ[0] == 3 or cardCountsJ[1] == 3 or cardCountsJ[2] == 3 or cardCountsJ[3] == 3 or cardCountsJ[4] == 3:
            if (cardCounts[0] == 2 and deck[0] != first3) or (cardCounts[1] == 2 and deck[1] != first3) or (cardCounts[2] == 2 and deck[2] != first3) or (cardCounts[3] == 2 and deck[3] != first3) or (cardCounts[4] == 2 and deck[4] != first3):
                return 5
    if cardCountsJ[0] == 3 or cardCountsJ[1] == 3 or cardCountsJ[2] == 3 or cardCounts[3] == 3 or cardCounts[4] == 3: return 4
    var first2 = cardCountsJ.find 2
    var second2 = cardCounts.findPredicate proc(x: int, idx: int): bool = x == 2 and deck[idx] != deck[first2]
    if first2 != -1 and second2 != -1: return 3
    if first2 != -1: return 2
    return 1

proc cmp(deck1: DeckKindBid, deck2: DeckKindBid): int =
    if deck1.kind > deck2.kind:
        return 1
    elif deck1.kind < deck2.kind:
        return -1
    for i, card in deck1.deck:
        var score1 = cardScores.find card
        var score2 = cardScores.find deck2.deck[i]
        if score1 < score2:
            return 1
        elif score1 > score2:
            return -1
    return 0

proc sortCardsOfUniformKind(deckKindBids: var seq[DeckKindBid]): void =
    var done = false
    for i in (1..<len deckKindBids):
        done = true
        for j in (0..<len(deckKindBids) - i):
            let p = cmp(deckKindBids[j], deckKindBids[j + 1])
            if p < 0:
                swap(deckKindBids[j], deckKindBids[j + 1])
                done = false
        if done: break

var fileData = readFile paramStr 1
var lines = fileData.split '\n'
var deckKindBids = lines.map proc(cardBidStr: string): DeckKindBid = (cardBidStr[0..4], getKind cardBidStr[0..4], parseInt cardBidStr[6..<len cardBidStr])
sortCardsOfUniformKind deckKindBids

var total = 0
for rankI, deckKindBid in deckKindBids:
    var rank = deckKindBids.len - rankI
    total += rank * deckKindBid.bid

echo deckKindBids.map(proc(x: DeckKindBid): string = x.deck).join(" > "), "\n", total