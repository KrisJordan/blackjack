module KrisJordan::Blackjack::State

  class Paying

    def self.prompt deck, player, hand, dealer_hand
      if hand === dealer_hand
        PayAction.new hand.chips
      elsif hand > dealer_hand
        PayAction.new hand.chips * 2
      else
        PayAction.new 0
      end
    end
  end

  class PayAction
    def initialize amount
      @chips = amount
    end

    def transition round
      puts "Paying #{@chips}"
      round.change_player(round.player.pay_out(@chips))
      round.next_turn
    end
  end

end
