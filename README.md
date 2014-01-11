# Deck

This is code created for a tutorial for the ElixirDose.com website.

It is the second part of a series, and I'm writing the code long before I actually write the tutorial.  Let's hope something comes of this.

There are no dependencies.  This code was created with Erlang 16B02 and Elixir 0.11.3-dev

## TODO: 

* Re-arrange the functions so that they're in modules that make sense. 

* Create sensible output to help a user ( or the programmer ) follow the game as it's happening.  This application tests out well, but I won't be 100% sure it's working right until I can see it in action.

## Turn this into an OTP type thing.  Run 1000 games at once. FOR FUN!  And, er, test the logic behind choosing cards to see if minor tweaks give better results.

I've been running it from inside `iex`.  Go with `Games.play_a_game` and let 'er rip.  It's ugly, but it works.
