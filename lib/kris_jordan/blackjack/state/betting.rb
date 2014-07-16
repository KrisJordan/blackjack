module KrisJordan::Blackjack::State

  class Betting
    def self.prompt deck, player, hand
      BetAction.new 0
    end
  end

  class BetAction
    def initialize amount
      @amount = amount
    end

    def transition round
      puts "Bet #{@amount}"
      round.next_turn
    end
  end

end
