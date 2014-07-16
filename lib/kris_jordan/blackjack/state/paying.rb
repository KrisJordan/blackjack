module KrisJordan::Blackjack::State

  class Paying
    def self.prompt deck, player, hand
      PayAction.new 0
    end
  end

  class PayAction
    def initialize amount
      @amount = amount
    end

    def transition round
      puts "Paying"
      round.next_turn
    end
  end

end
