defmodule GameTest do
  use ExUnit.Case

  test "Game Over/Win if hand is empty" do
    d = Deck.create()
    assert( Game.take_turn([], d, d) == "Win")
  end

  test "Game Over/Lose if draw is empty before the player's hand" do
    d = Deck.create()
    assert( Game.take_turn(d, d, []) == "Lose")
  end

  test "Show correct top card on discard stack" do
    deck = Deck.create()
    {discard, deck} = Deck.deal_card(deck)
    top_card = Game.top_discard_card([discard])
    assert( top_card == discard ) # not empty set

    {new_card, _draw} = Deck.deal_card(deck)
    new_discards = Game.top_discard_card([new_card] ++ [discard])
    assert( new_discards == new_card )
  end

  test "Find a hand's points total" do
    c_1 = Card.new rank: 'Jack', suit: 'Clubs', points: 10
    c_2 = Card.new rank: 5,      suit: 'Hearts', points: 5
    
    hand = [c_1, c_2]
    assert( Game.hand_value(hand) == 15 )
  end

  # This is one ridiculously long test, checking way too much stuff along the way.
  # Like most such testing, it's done to help ME feel comfortable with my own code
  # and with Elixir's libraries and functionalities.  At some point down the road, 
  # I'll likely delete a chunk of this.
  test "Play a card successfully" do
    draw = Deck.create()
    {hand, draw} = Deck.deal_hand(draw, 5)
    assert(length(hand)    == 5         )
    assert(length(draw)    == 52 - 5    )
    {discard, draw} = Deck.deal_hand(draw, 1)
    assert(length(draw)    == 52 - 5 - 1)
    assert(length(discard) == 1         )
    {hand, draw} = Deck.pick_up_card(draw, hand)
    assert(length(hand)    == 6)
    assert(length(draw)    == 52 - 5 - 1 - 1 )
    card = Card.new rank: 'Jack', suit: 'Diamonds'
    hand = hand ++ [card] # Hacky, but want to test that a specific card can be played
    assert(length(hand) == 7)
    {discard, hand} = Game.play_card(card, hand, discard)
    assert(Enum.member?(discard, card) )
    assert(length(discard) == 2)
    assert(Enum.member?(hand, card) == :false )
    assert(length(hand)    == 6)
  end

  test "Find a correct match to a rank and suit" do
    c_1 = Card.new rank: 'Jack', suit: 'Clubs'
    c_2 = Card.new rank: 5,      suit: 'Hearts'
    hand = [c_1, c_2]
    c_rank = Card.new rank: 'Jack', suit: 'Diamonds'
    assert( Deck.is_a_match(hand, c_rank) == c_1 )
    c_suit = Card.new rank: 'Ace', suit: 'Clubs'
    assert( Deck.is_a_match(hand, c_suit) == c_1 )
    c_suit = Card.new rank: 'Ace', suit: 'Diamonds'
    assert( Deck.is_a_match(hand, c_suit) == Card.new )
  end

#  test "Take a turn with one card" do
#    draw = Deck.create()
#    discard = Deck.deal_hand(draw, 1)
#    {hand, draw} = Deck.deal_hand(draw, 5)
#    draw = Deck.deal_hand(draw, 1)
#    {new_hand, new_draw} = Deck.pick_up_card(draw, hand)
#    Game.take_turn(new_hand, discard, new_draw)
#  end

end
