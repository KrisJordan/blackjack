module KrisJordan::Blackjack
  class Game

    def self.play players, chips, decks
      puts "New Game Starting"
      puts "================="
      puts " #{players} player(s)"
      puts " #{chips} starting chips"
      puts " #{decks} deck(s), fresh each round"
      puts "================="

      chips    = 100 if chips <= 0

      @players = players.times.map{|n| Player.new("Player #{n+1}", chips)} +
                 [Dealer.new]

      decks    = 2 if decks <= 0
      deck     = Deck.new * decks

      while @players.count > 1 do
        @round   = Round.new deck, @players
        while action = @round.next_action
          log action.describe @round
          @round   = action.transition @round
          @players = @round.players.select { |p| p.dealer? or p.chips > 0 }
        end
      end

      puts "\nGame over, thanks for playing!\n\n"

    end

    def unmarshal
      Object::const_get("KrisJordan::Blackjack::State::BetAction").send(:new,*[0])
    end

    private
    
    def self.log description
      puts description if description != ""
    end

  end
end
