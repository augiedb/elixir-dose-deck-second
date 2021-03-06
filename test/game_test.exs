defmodule GameTest do
  use ExUnit.Case

  test "Game Over/Win if hand is empty" do
    d = Deck.create()
    assert( Game.take_turn([], d, d) == 0)
  end

  test "Game Over/Lose if draw is empty before the player's hand" do
    {hand, draw} = Deck.deal_hand( Deck.create(), 5 ) 
    {discard, deck} = Deck.deal_card(draw)
    assert( Game.take_turn(hand, discard, []) > 0)
  end

  test "Show correct top card on discard stack" do
    deck = Deck.create()
    {discard, deck} = Deck.deal_card(deck)
    top_card = Game.see_top_discard_card([discard])
    assert( top_card == discard ) # not empty set

    {new_card, _draw} = Deck.deal_card(deck)
    new_discards = new_card
    assert( new_discards == new_card )
  end

  test "Find a hand's points total" do
    c_1 = Card.new rank: 'Jack', suit: 'Clubs', points: 10
    c_2 = Card.new rank: 5,      suit: 'Hearts', points: 5
    
    hand = [c_1, c_2]
    assert( Game.hand_value(hand) == 15 )
  end

#  test "Show hand of cards" do
#    c_1 = Card.new rank: 'Jack', suit: 'Clubs', points: 10
#    c_2 = Card.new rank: 5,      suit: 'Hearts', points: 5
#    hand = [c_1, c_2]
#
#    assert( Game.show_hand(hand) == "1: Jack of Clubs (10)\n2: 5 of Hearts (5)\n")
#  end

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
    {discard, hand} = Game.play_card(card, hand)
    assert(discard == card)
    assert(Enum.member?(hand, card) == :false )
    assert(length(hand)    == 6)
  end


end
