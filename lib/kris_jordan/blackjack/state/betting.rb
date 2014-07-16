module KrisJordan::Blackjack::State

  class Betting
    def self.prompt deck, player, hand, dealer_hand
      if hand != dealer_hand
        BetAction.new player.bet hand
      else
        SkipAction.new
      end
    end
  end

  class SkipAction
    def transition round
      round.next_turn
    end
  end

  class BetAction
    def initialize amount
      @amount = amount
    end

    def transition round
      puts "Bet #{@amount}"
      round.change_player(round.player.put_in(@amount))
           .change_hand(round.hand.bet(@amount))
           .next_turn
    end
  end

end
