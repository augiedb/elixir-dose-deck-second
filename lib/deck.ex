defrecord Card, suit: nil, rank: nil, points: nil

defmodule Deck do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Deck.Supervisor.start_link
  end

  def create do
    lc rank inlist ['Ace',2,3,4,5,6,7,8,9,10,'Jack','Queen','King'], 
        suit inlist ['Hearts','Clubs','Diamonds','Spades'], 
    do: Card.new rank: rank, suit: suit, points: init_points(rank)
  end

  def init_points(points) when points > 1 and points < 11, do: points
  def init_points(points) when points == 'Ace', do: 1
  def init_points(_), do: 10

  def count_suit(deck, suit_name) do
    Enum.count(deck, fn(x) -> x.suit == suit_name end)
  end

  def count_rank(deck, rank) do
    Enum.count(deck, fn(x) -> x.rank == rank end)
  end

  def deal_hand(deck, number_of_cards_in_a_hand) do
    Enum.split(deck, number_of_cards_in_a_hand)
  end

  def pick_up_card(deck, hand) do
    {new_card, deck} = deal_hand(deck, 1)
    {hand ++ new_card, deck}
  end
end

defmodule Game do

  def play_a_game do

    deck = Deck.create()
    {hand, deck} = Deck.deal_hand(deck, 5)
    {card, deck} = Deck.deal_hand(deck, 1)
    results = take_turn(hand, card, deck)
    IO.puts "The final results is a " + results

  end


  def take_turn([], _discard, _draw) do
    "Win" 
  end

  def take_turn(_hand, [], _draw) do
    "Lose" 
  end

  def take_turn(_hand, _discard, []) do
    "Lose" 
  end

  def take_turn(hand, discard, draw) do

    # Play a card in user's hand that matches the discard
    # Is a rank or value matches or you have a Crazy Eight, play the card
    # Function to be written

    # Take the next turn
    {discard, draw} = Deck.deal_hand(draw, 1)
    take_turn(hand, discard, draw)   

  end

end
