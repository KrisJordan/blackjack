module KrisJordan::Blackjack::State

  class Paying

    def self.prompt deck, player, hand, dealer_hand
      if player.dealer?
        SkipAction.new
      else
        if hand.bust?
          LoseAction.new hand.chips

        elsif hand.blackjack?
          if dealer_hand.blackjack?
            WinAction.new "push", hand.chips
          else
            WinAction.new "blackjack", (hand.chips * 2.5).round
          end

        else
          if dealer_hand.bust?
            WinAction.new "dealer bust", hand.chips * 2
          else
            if hand > dealer_hand
              WinAction.new "beating dealer", hand.chips * 2
            elsif hand == dealer_hand
              WinAction.new "push", hand.chips
            else
              LoseAction.new hand.chips
            end
          end
        end
      end
    end
  end

  class WinAction
    def initialize win, amount
      @win = win
      @chips = amount
    end

    def describe round
      "#{round.player.name} wins by #{@win}, receives #{@chips} chips."
    end

    def transition round
      round.change_player(round.player.pay_out(@chips))
           .next_turn
    end
  end

  class LoseAction
    def initialize amount
      @chips = amount
    end

    def describe round
      "#{round.player.name} loses #{@chips} chips. #{round.player.chips} chips remaining."
    end

    def transition round
      round.next_turn
    end
  end

end
