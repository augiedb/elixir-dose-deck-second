defmodule CardTest do
  use ExUnit.Case

  test "Test Suit, Rank, Points return values" do
    card = Card.new rank: 'Jack', suit: 'Clubs', points: 10
    assert(card.rank == 'Jack')
    assert(card.suit == 'Clubs')
    assert(card.points == 10)
  end


end

