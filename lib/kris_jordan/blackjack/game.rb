require 'json'

module KrisJordan::Blackjack

  class Game

    attr_accessor :players, :deck, :round

    def initialize starting_chips, starting_players, decks_per_round
      initialize_chips starting_chips
      initialize_players starting_players
      initialize_deck decks_per_round
      @round = Round.new @deck, @players
    end

    # Interactive event loop prompts the player for input.
    # Inputs generate events.
    # Events are written to the write-ahead log, printed, and handled.
    def play(resume=false)
      GameJournal.begin(self) unless resume
      while @players.count > 1 and event = @round.prompt
        GameJournal.write event
        narrate event.describe @round
        handle event
      end
      GameJournal.clear
      puts "\nGame over, thanks for playing!\n\n"
    end

    # Given an `Event` the game's `@round` is transformed to its next
    # state by the event. After a round completes, players without chips
    # are removed from `@players` and a new round begins.
    def handle event
      unless event.is_a? Event::End
        @round   = event.transform @round
      else
        @players = @round.players.select { |p| p.dealer? or p.chips > 0 }
        @round   = Round.new @deck, @players
      end
    end

    def to_json
      [ @starting_chips, @starting_players, @decks_per_round ]
    end

    private

    def narrate description
      puts "\n#{description}" if description
    end

    def initialize_chips starting_chips
      if starting_chips < 1
        @starting_chips = 1
      else
        @starting_chips   = starting_chips
      end
    end

    def initialize_players starting_players
      if starting_players < 1
        @starting_players = 1
      else
        @starting_players = starting_players
      end
      @players = starting_players
                  .times
                  .map {|n| Player.new("Player #{n+1}", @starting_chips)} +
                  [Dealer.new]
    end

    def initialize_deck decks_per_round
      if decks_per_round <= 1
        @decks_per_round  = 2
      else
        @decks_per_round  = decks_per_round
      end 
      @deck             = Deck.new * @decks_per_round

    end

  end
end
