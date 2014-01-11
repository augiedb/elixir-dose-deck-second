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

  test "Deal a hand of 5 cards" do
    deck = Deck.create()
    assert( length(deck) == 52 )
    {hand, deck} = Deck.deal_hand(deck, 5)
    assert( length(deck) == 47 )
    assert( length(hand) == 5 )
  end

  test "Describe a card in English" do
    c_1 = Card.new rank: 'Jack', suit: 'Clubs',  points: 10
    c_2 = Card.new rank: 5,      suit: 'Hearts', points: 5
    assert(c_1.describe == "Jack of Clubs (10)")
    assert(c_2.describe == "5 of Hearts (5)")
  end

  test "Pick up a card from the draw successfully" do
    draw = Deck.create()
    {hand, draw} = Deck.deal_hand(draw, 5)
    {new_hand, new_draw} = Deck.pick_up_card(draw, hand)
    assert( length(new_hand) == length(hand) + 1 )
    assert( length(new_draw) == length(draw) - 1 )
  end

end
