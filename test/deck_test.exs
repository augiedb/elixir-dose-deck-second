defmodule DeckTest do
  use ExUnit.Case

  test "52 cards in a deck" do
    assert ( length(Deck.create()) == 52 )
  end

  test "Giving the right point value to a card" do
    assert( Deck.init_points('Ace')   == 1)
    assert( Deck.init_points(2)       == 2)
    assert( Deck.init_points(10)      == 10)
    assert( Deck.init_points(5)       == 5)
    assert( Deck.init_points('Jack')  == 10)
    assert( Deck.init_points('Queen') == 10)
    assert( Deck.init_points('King')  == 10)
  end

  test "13 Heart Cards in a deck" do
    deck = Deck.create()
    assert( Deck.count_suit(deck, 'Hearts') == 13 )
    assert( Deck.count_suit(deck, 'Clubs') == 13 )
    assert( Deck.count_suit(deck, 'Diamonds') == 13 )
    assert( Deck.count_suit(deck, 'Spades') == 13 )
  end

  test "4 of each number in a deck" do
    deck = Deck.create()
    assert( Deck.count_rank(deck, 9)      == 4)
    assert( Deck.count_rank(deck, 5)      == 4)
    assert( Deck.count_rank(deck, 'Jack') == 4)
    assert( Deck.count_rank(deck, 'King') == 4)
    assert( Deck.count_rank(deck, 'Ace')  == 4)
  end

  test "Deal a hand of 5 cards" do
    deck = Deck.create()
    assert( length(deck) == 52 )
    {hand, deck} = Deck.deal_hand(deck, 5)
    assert( length(deck) == 47 )
    assert( length(hand) == 5 )
  end

  test "Pick Up Card from Deck" do
    d = Deck.create()
    {h, d} = Deck.deal_hand(d, 5)
    assert( length(d) == 47 )
    {h, d} = Deck.pick_up_card(d, h)
    assert( length(d) == 46 )
    assert( length(h) == 6 )
  end
end



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

  test "Pick up a card successfully" do
    draw = Deck.create()
    {hand, draw} = Deck.deal_hand(draw, 5)
    {new_hand, new_draw} = Deck.pick_up_card(draw, hand)
    assert( length(new_hand) == length(hand) + 1 )
    assert( length(new_draw) == length(draw) - 1 )
  end

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
    assert( Enum.member?(discard, card) )
    assert(length(discard) == 2)
    assert( Enum.member?(hand, card) == false )
    assert(length(hand)    == 6)
 end

#17   def play_card(card, hand, discard) do
 #16     hand_new = hand -- [card]
 # 15     discard_new = discard ++ [card]
 #  14     {discard_new, hand_new}
 #   13   end



  test "Find a correct match to a rank and suit" do
    c_1 = Card.new rank: 'Jack', suit: 'Clubs'
    c_2 = Card.new rank: 5,      suit: 'Hearts'
    hand = [c_1, c_2]
    c_rank = Card.new rank: 'Jack', suit: 'Diamonds'
    assert( Game.is_a_match(hand, c_rank) == c_1 )
    c_suit = Card.new rank: 'Ace', suit: 'Clubs'
    assert( Game.is_a_match(hand, c_suit) == c_1 )
    c_suit = Card.new rank: 'Ace', suit: 'Diamonds'
    assert( Game.is_a_match(hand, c_suit) == 0 )
  end



#  test "Take a turn with one card" do
#    draw = Deck.create()
#    discard = Deck.deal_hand(draw, 1)
#    {hand, draw} = Deck.deal_hand(draw, 5)
#    draw = Deck.deal_hand(draw, 1)
#    {new_hand, new_draw} = Deck.pick_up_card(draw, hand)
#    Game.take_turn(new_hand, discard, new_draw)
#  end

#  test "Drawn card matches a card in the player's hand" do
#    hand = Deck.create()
#    card_to_match = Enum.first(hand)
#    assert( Game.is_a_match(hand, card_to_match) == true )
#  end

end
