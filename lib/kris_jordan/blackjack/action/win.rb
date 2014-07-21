module KrisJordan::Blackjack::Action

  class Win < Base
    def initialize reason, amount
      @reason = reason
      @chips = amount
    end

    def describe round
      "#{round.player.name} wins by #{@reason}, receives #{@chips} chips."
    end

    def transition round
      round.change_player(round.player.pay_out(@chips))
           .next_turn
    end

    def to_json
      [@reason,@chips]
    end
  end

end
