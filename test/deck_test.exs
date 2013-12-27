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

  test "Game Over/Lose if discards or deck empty out before the player hand" do
    d = Deck.create()
    assert( Game.take_turn(d, [], d) == "Lose")
    assert( Game.take_turn(d, d, []) == "Lose")
  end

end
