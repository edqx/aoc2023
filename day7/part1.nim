import std/[os, strutils, sequtils]

var cardScores = @[ 'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2' ]
type DeckKindBid = tuple[deck: string, kind: int, bid: int]

proc countOccurances(deck: string, card: char): int =
    for card2 in deck:
        if card2 == card: result += 1
        
proc findPredicate[T](s: seq[T], pred: proc(x: T, idx: int): bool): int =
    for i, x in s:
        if pred(x, i):
            return i
    return -1

proc getKind(deck: string): int =
    var cardCounts = deck.toSeq.map proc (card: char): int = countOccurances(deck, card)
    if cardCounts[0] == 5: return 7
    if cardCounts[0] == 4 or cardCounts[1] == 4: return 6
    if (cardCounts[0] == 3 or cardCounts[1] == 3 or cardCounts[2] == 3) and (cardCounts[0] == 2 or cardCounts[1] == 2 or cardCounts[2] == 2 or cardCounts[3] == 2):
        return 5
    if cardCounts[0] == 3 or cardCounts[1] == 3 or cardCounts[2] == 3: return 4
    var first2 = cardCounts.findPredicate proc(x: int, idx: int): bool = x == 2
    var second2 = cardCounts.findPredicate proc(x: int, idx: int): bool = x == 2 and deck[idx] != deck[first2]
    if first2 != -1 and second2 != -1: return 3
    if first2 != -1: return 2
    return 1

proc getCardScore(card: char): int =
    return cardScores.find card

proc cmp(deck1: DeckKindBid, deck2: DeckKindBid): int =
    if deck1.kind > deck2.kind:
        return 1
    elif deck1.kind < deck2.kind:
        return -1
    for i, card in deck1.deck:
        var score1 = getCardScore card
        var score2 = getCardScore deck2.deck[i]
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
                deckKindBids[j].swap(deckKindBids[j + 1])
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

echo total