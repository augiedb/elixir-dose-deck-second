defmodule Game do

  # Rules to follow:
  #
  # DISCARD stack always puts cards at the beginning of the list

#--------- This is where you start the game
  def play_a_game do
    deck = Deck.create() |> Deck.shuffle |> Deck.shuffle
    {hand, deck} = Deck.deal_hand(deck, 5)
    {discard, deck} = Deck.deal_card(deck)
    results = take_turn(hand, [discard], deck)
    IO.puts "You ended up with #{results}"
    results
  end


#--------- TAKE_TURNS
  def take_turn([], _discard, []) do
    # User played last remaining cards against discards stack
    # when draw stack was already empty.

    # This instance is so ridiculously rare that it'll have to be forced in a test.
    IO.puts "HELLO1"
    0
  end

  def take_turn(hand, discard, []) do

    # The draw is empty, but the user likely just picked up the last 
    # card and should be allowed to play it, if possible.
    # If it doesn't match, no harm. Just skip over this and end the game.
    IO.puts "Draw pile is now empty.  This is the end game portion."

    card_to_match = Game.see_top_discard_card(discard)
    card_to_play = Deck.is_a_match(hand, card_to_match)
    IO.puts "You are trying to match the " <> card_to_match.describe <> " with your hand:"
    Game.show_hand(hand)

    case card_to_play do

      { :no_card } ->    # GAME OVER
        total_points = hand_value(hand)

      _matching_card ->  
        IO.puts card_to_match.describe <> " MATCHES " <>  card_to_play.describe
        #play_matched_card(hand, discard, draw, card_to_play)
        {new_discard, new_hand } = play_card(card_to_play, hand, discard)
        take_turn(new_hand, new_discard, [])
    end

  end

  def take_turn([], _discard, _draw) do
    # Still cards left on draw stack, but user's hand is empty
    IO.puts "YOU WIN!"
    0 
  end

  def take_turn(hand, discard, draw) do
    # Play a card in user's hand that matches the discard
    # If a rank or value matches or you have a Crazy Eight, play the card
    card_to_match = Game.see_top_discard_card(discard)
    IO.puts "TOP OF DISCARD PILE: " <> card_to_match.describe

    # Have to wrap discard up in brackets to treat it as a list.  MAGIC!
    IO.puts "NUMBER OF CARDS IN THE DISCARD PILE: #{length(discard)}"
    IO.puts "NUMBER OF CARDS IN THE DRAW    PILE: #{length(draw)}"
    IO.puts "You have #{length(hand)} cards in your hand. They are:"
    Game.show_hand(hand)

    card_to_play = Deck.is_a_match(hand, card_to_match)

    case card_to_play do

      { :no_card } ->
        IO.puts "#-------------#"
        IO.puts "NO MATCH"
        {card, new_draw} = Deck.deal_card(draw)
        IO.puts "Took 1 from draw, added 1 to hand"
        take_turn(hand ++ [card], discard, new_draw)

      _matching_card ->
        IO.puts card_to_match.describe <> " matches " <> card_to_play.describe
        IO.puts "Place " <> card_to_play.describe <> " onto discards and attempt to match IT next."
        #play_matched_card(hand, discard, draw, card_to_play)
        {new_discard, new_hand} = play_card(card_to_play, hand, discard)
        take_turn(new_hand, new_discard, draw)   
    end
  end

#----------- Not sure where these functions belong

  def see_top_discard_card([top_card | _rest]) do
    top_card 
  end

  def play_card(card, hand, discard) do
    hand_new = hand -- [card]
    discard_new = [card] ++ discard 
    {discard_new, hand_new}
  end

###--------
  def show_hand(list) do
    show_hand(list, 1, "")
  end
  
  defp show_hand([], _, long_string) do
    IO.puts long_string
  end

  defp show_hand([head|tail], acc, long_string) do
    longer_string = long_string <> "#{acc}: " <> head.describe <> "\n"
    show_hand(tail, acc + 1, longer_string)
  end
####-------

  def hand_value(hand) do
    points_list = Enum.map(hand, fn(x) -> x.points end)
    Enum.reduce(points_list, 0, fn(x, acc) -> x + acc end)
  end

end
