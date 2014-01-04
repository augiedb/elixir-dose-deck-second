defrecord Card, suit: nil, rank: nil, points: nil do

  def describe(record) do
    "#{record.rank} of #{record.suit} (#{record.points})"
  end

end

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

  def shuffle(deck) do
    deck |> Enum.shuffle
  end

  def init_points(points) when points in 2..10, do: points
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

  def deal_card(deck) do
    {card_list_of_one, rest_of_deck} = Enum.split(deck, 1) 
    single_card = List.flatten(card_list_of_one)
    {single_card, rest_of_deck}
  end

  def pick_up_card(draw, hand) do
    {new_card, new_draw} = deal_hand(draw, 1)
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

  def describe_card(card) when is_list(card) do
    first_card = card |> Enum.first 
    first_card.describe
  end

  def describe_card(card) do
    card.describe
  end

end

defmodule Game do

  # This is where you start the game
  def play_a_game do
    deck = Deck.create() |> Deck.shuffle
    {hand, deck} = Deck.deal_hand(deck, 5)
    {discard, deck} = Deck.deal_card(deck)
    results = take_turn(hand, discard, deck)
    IO.puts "You #{results}"
  end

  def top_discard_card(discards) when length(discards) > 1 do
    { _ignore, top_card } = Enum.split(discards, -1)
    Enum.first top_card    
  end

  def top_discard_card(discards) do
    discards
  end

  def play_card(card, hand, discard) do
    hand = List.flatten hand
    Game.show_hand(hand)
    hand_new = hand -- [card]
    discard_new = discard ++ [card]
    {discard_new, hand_new}
  end

  def show_hand([]) do
    #Nothing
  end

  def show_hand([head|tail]) do
    IO.puts "#{Deck.describe_card(head)}"
    #IO.puts "#{head.describe}"
    show_hand(tail)
  end
  
  def hand_value(hand) do
  IO.puts "------------------"
  show_hand(hand)
    points_list = Enum.map(hand, fn(x) -> x.points end)
    Enum.reduce(points_list, 0, fn(x, acc) -> x + acc end)

#    Enum.reduce(hand, 0, fn(x, acc) -> acc + x.points end)
  end

#--------- TAKE_TURNS

  def take_turn([], _discard, _draw) do
    "Win" 
  end


  def take_turn(hand, discard, []) do
    # TO DO: Problem: This will end the game if the user picks up the last card.
    #        He or she won't have a chance to play the card if it IS a match.
    #        Need to work on that logic.

    # The draw is empty, but the user likely just picked up the last 
    # card and should be allowed to play it, if possible.
    # If it doesn't match, no harm. Just skip over this and end the game.
    card_to_match = Game.top_discard_card(discard)
    card_to_play = Deck.is_a_match(hand, card_to_match)
    if card_to_play.suit != nil do  # MATCH
      IO.puts "#{Deck.describe_card(card_to_match)} MATCHES #{Deck.describe_card(card_to_play)}"
      play_card(card_to_play, hand, discard)
      "Win"
    else
      IO.puts "Length of hand list: #{length(hand)}"
    
      # TO DO: Include number of points held in losing hand
      "Lose"
    end
  end


  def take_turn(hand, discard, draw) do
    # Play a card in user's hand that matches the discard
    # If a rank or value matches or you have a Crazy Eight, play the card

    card_to_match = Game.top_discard_card(discard)
    IO.puts "CARD TO MATCH: #{Deck.describe_card(card_to_match)}"
    IO.puts "NUMBER OF CARDS IN THE DISCARD PILE: #{length(discard)}"
    IO.puts "NUMBER OF CARDS IN THE DRAW    PILE: #{length(draw)}"
    IO.puts "You have #{length(hand)} cards in your hand."
    show_hand(hand)

    card_to_play = Deck.is_a_match(hand, card_to_match)

    if card_to_play.suit == nil do  # NO MATCH
      IO.puts Deck.describe_card(card_to_match)
      IO.puts "Matches NOTHING"
      {card, new_draw} = Deck.deal_card(draw)
      IO.puts "Took 1 from draw, added 1 to hand"
      take_turn(hand ++ [card], discard, new_draw)
    else
      IO.puts Deck.describe_card(card_to_match)
      IO.puts "Matches"
      IO.puts Deck.describe_card(card_to_play)
      {new_discard, new_hand} = play_card(card_to_play, hand, discard)

      take_turn(new_hand, new_discard, draw)   
    end

  end

end
