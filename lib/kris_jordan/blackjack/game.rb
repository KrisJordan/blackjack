require 'json'

module KrisJordan::Blackjack

  class Game

    attr_accessor :players, :deck, :round

    def initialize starting_players, starting_chips, decks_per_round
      initialize_chips starting_chips
      initialize_players starting_players
      initialize_deck decks_per_round
      @round = Round.new @deck, @players
    end

    def play(resume=false)
      GameJournal.begin(self) unless resume
      while event = @round.next_event and @players.count > 1
        GameJournal.write event
        narrate event.describe @round
        handle event
      end
      GameJournal.clear
      puts "\nGame over, thanks for playing!\n\n"
    end

    def handle event
      unless event.is_a? Event::End
        @round   = event.transform @round
      else
        @players = @round.players.select { |p| p.dealer? or p.chips > 0 }
        @round   = Round.new @deck, @players
      end
    end

    def to_json
      [ @starting_players, @starting_chips, @decks_per_round ]
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