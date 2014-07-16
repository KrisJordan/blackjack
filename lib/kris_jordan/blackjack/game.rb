module KrisJordan::Blackjack
  class Game

    def self.play

      chips    = 100
      decks    = 2
      deck     = (decks-1)
                 .times
                 .map{Deck.new}
                 .reduce(Deck.new){ |pile,deck| pile+deck }

      @players = [Player.new(chips), Dealer.new]

      @round   = Round.new deck, @players

      while action = @round.next_action
        @round = action.transition @round
      end

    end

    def unmarshal
      Object::const_get("KrisJordan::Blackjack::State::BetAction").send(:new,*[0])
    end

  end
end
