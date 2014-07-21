module KrisJordan::Blackjack::Event

  class Win < Base
    def initialize reason, amount
      @reason = reason
      @chips = amount
    end

    def describe round
      "#{round.player.name} wins by #{@reason}, receives #{@chips} chips."
    end

    def transform round
      round.set_player { |player| player.pay_out @chips }
           .next_turn
    end

    def args
      [@reason, @chips]
    end
  end

end
