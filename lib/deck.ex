defmodule Deck do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Deck.Supervisor.start_link
  end

  # Create Deck  
  def create do
    lc rank inlist ['Ace',2,3,4,5,6,7,8,9,10,'Jack','Queen','King'], 
        suit inlist ['Hearts','Clubs','Diamonds','Spades'], 
    do: Card.new rank: rank, suit: suit, points: init_points(rank)
  end

  def shuffle(deck) do
    deck |> Enum.shuffle
  end

  def init_points(points) when points in 2..10, do: points
  def init_points(points) when points == 'Ace', do: 1
  def init_points(_), do: 10 

  # Deal cards

  def deal_hand(deck, number_of_cards_in_a_hand) do
    Enum.split(deck, number_of_cards_in_a_hand)
  end

  def deal_card(deck) do
    [single_card|rest_of_deck] = deck
    {single_card, rest_of_deck}
  end

  def pick_up_card(draw, hand) do
    [new_card | new_draw ] = draw
    #{new_card, new_draw} = deal_hand(draw, 1)
    {hand ++ [new_card], new_draw}
  end
  
  def is_a_match(hand, card_to_match) when is_list(card_to_match) do
    card_to_match = card_to_match |> Enum.first
    card_compare = fn(x) -> (card_to_match.suit == x.suit) or (card_to_match.rank === x.rank ) end
    Enum.find(List.flatten(hand), Card.new, card_compare)
  end

  def is_a_match(hand, card_to_match) do
    card_compare = fn(x) -> (card_to_match.suit == x.suit) or (card_to_match.rank === x.rank ) end
    Enum.find(List.flatten(hand), Card.new, card_compare)
  end

end
