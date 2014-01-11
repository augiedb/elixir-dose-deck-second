defmodule Game do

  # Rules to follow:
  #
  # DISCARD stack always puts cards at the beginning of the list

  # This is where you start the game
  def play_a_game do
    deck = Deck.create() |> Deck.shuffle
    {hand, deck} = Deck.deal_hand(deck, 5)
    {discard, deck} = Deck.deal_card(deck)
    results = take_turn(hand, [discard], deck)
    IO.puts "You #{results}"
  end

#  def top_discard_card(discards) when length(discards) > 1 do
#    IO.puts "greater than one"
#    [ top_card | _rest_of_discards ] = discards
#    top_card
#  end

  def top_discard_card(discards) do
    [top_card | _rest] = discards
    top_card 
  end

  def play_card(card, hand, discard) do
    hand = List.flatten hand
    Game.show_hand(hand)
    hand_new = hand -- [card]
    discard_new = [card] ++ [discard] 
    {discard_new, hand_new}
  end

  def show_hand(list) do
    show_hand(list, 1)
  end
  
  defp show_hand([], _) do
    #Nothing
  end

  defp show_hand([head|tail], acc) do
    IO.puts "#{acc}: #{Deck.describe_card(head)}"
    #ADB2show_hand(tail, acc + 1)
  end

  def hand_value(hand) do
  IO.puts "------------------"
    #ADB Game.show_hand(hand)
    points_list = Enum.map(hand, fn(x) -> x.points end)
    Enum.reduce(points_list, 0, fn(x, acc) -> x + acc end)
  end

#--------- TAKE_TURNS



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
      {new_discard, new_hand } = play_card(card_to_play, hand, discard)
      take_turn(new_hand, new_discard, [])
    else
      IO.puts "Length of hand list: #{length(hand)}"
    
      # TO DO: Include number of points held in losing hand
      "Lose"
    end
  end

  def take_turn([], _discard, []) do
    # User played last remaining cards against discards stack
    # when draw stack was already empty.
    "Win"
  end

  def take_turn([], _discard, _draw) do
    # Still cards left on draw stack, but user's hand is empty
    "Win" 
  end


  def take_turn(hand, discard, draw) do
    # Play a card in user's hand that matches the discard
    # If a rank or value matches or you have a Crazy Eight, play the card
    card_to_match = Game.top_discard_card(discard)
    IO.puts "CARD TO MATCH: #{Deck.describe_card(card_to_match)}"
    # Have to wrap discard up in brackets to treat it as a list.  MAGIC!
    IO.puts "NUMBER OF CARDS IN THE DISCARD PILE: #{length([discard])}"
    IO.puts "NUMBER OF CARDS IN THE DRAW    PILE: #{length(draw)}"
    IO.puts "You have #{length(hand)} cards in your hand."
    #Game.show_hand(hand)

    card_to_play = Deck.is_a_match(hand, card_to_match)

    if card_to_play.suit == nil do  # NO MATCH
      IO.puts "#-------------#"
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
