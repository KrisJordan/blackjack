# CLI Blackjack

## Features

- Multiple players
- Quitting and resuming play by replaying an append-only write-ahead log
- Splitting
- Doubling down
- Variable # of decks
- Variable # of starting chips

## Playing

### Requirements

- Ruby 1.9+
- Bundler

### Install

1. `git clone`
1. `bundle install`

### Play

`./blackjack`

### Command-line Options

`./blackjack --players=1 --decks=2 --chips=100`

`players` sets # of players in the game.

`decks` sets # of decks in each round.

`chips` sets # of chips each player starts with.

### "Pausing" a Game

Break out of / pause a game at any point by interrupting
with `Ctrl+C`.

### Resuming Game

To resume a game, rerun `./blackjack` in the same directory
and press `y`.

## Organizational Notes

The architecture of this project began with a few first principles,
largely as an exercise to try them in a Ruby codebase:

 - **Immutability** - All objects, with the exception of the top-level
 `Game` object, are immutable. All write accessors are copy-on-write.

 - **Event-driven** - When state needs to change, an `Event` is emitted
 to the `Game`. The game then handles the `Event` by executing its `#transform`
 method. The `Event#transform` method accepts a `Round` and returns a new,
 transformed `Round` as effected by the `Event`. In essence:
 `Event#transform(Round) -> Round'`

 - **Write-ahead log** - A nice side-effect of an event-driven
 architecture is that events can be logged to an append-only file and easily
 replayed to return a game to any state. The write-ahead log for this game
 is stored in your current working directory under `.blackjack.aof`. Its format
 is a simple, JSON serialization, whose first serializes the top-level
 of a `Game` and subsequent lines are `Event` objects transforming the game's
 state.

## License

(The MIT License)

Copyright © 2014 Kris Jordan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
