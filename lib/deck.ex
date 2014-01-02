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

  def pick_up_card(draw, hand) do
    {new_card, new_draw} = deal_hand(draw, 1)
    {hand ++ [new_card], new_draw}
  end
  
  def is_a_match(hand, card_to_match) do
    Enum.find(hand, 0, fn(x) -> (card_to_match.suit == x.suit) or (card_to_match.rank == x.rank ) end) 
  end

end

defmodule Game do

  # This is where you start the game
  def play_a_game do
    deck = Deck.create()
    {hand, deck} = Deck.deal_hand(deck, 5)
    {discard, deck} = Deck.deal_hand(deck, 1)
    results = take_turn(hand, discard, deck)
    IO.puts "The final results is a " + results
  end

  def top_discard_card(discards) when length(discards) > 1 do
    { _ignore, top_card } = Enum.split(discards, -1)
     top_card    
  end

  def top_discard_card(discards) do
    discards
  end

  def play_card(card, hand, discard) do
    hand_new = hand -- [card]
    discard_new = discard ++ [card]
    {discard_new, hand_new}
  end


#--------- TAKE_TURNS

  def take_turn([], _discard, _draw) do
    "Win" 
  end

  def take_turn(_hand, _discard, []) do
    # TO DO: Problem: This will end the game if the user picks up the last card.
    #        He or she won't have a chance to play the card if it IS a match.
    #        Need to work on that logic.

    # TO DO: Include number of points held in losing hand
    "Lose" 
  end

  def take_turn(hand, discard, draw) do
    # Play a card in user's hand that matches the discard
    # If a rank or value matches or you have a Crazy Eight, play the card

    card_to_match = top_discard_card(discard)

IO.puts length(hand)
IO.puts length(card_to_match)
    card_to_play = Deck.is_a_match(hand, Enum.first(card_to_match))
    if card_to_play == 0 do
      {card, new_draw} = Deck.deal_hand(draw, 1)
      take_turn(hand ++ [card], discard, new_draw)
    else
      {discard, hand} = play_card(card_to_play, hand, discard)

      # Take the next turn
      {discard_card, draw} = Deck.deal_hand(draw, 1)
      take_turn(hand, discard ++ [discard_card], draw)   
    end

  end

end
