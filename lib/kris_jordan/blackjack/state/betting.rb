module KrisJordan::Blackjack::State

  class Betting
    def self.prompt deck, player, hand, dealer_hand
      if hand != dealer_hand
        chips = 0
        until chips > 0 and chips <= player.chips
          puts ""
          puts "Player #{player.name}, you have #{player.chips} chips."
          puts "How many would you like to bet?"
          chips = gets.chomp.to_i
        end
        BetAction.new chips
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
      round.change_player(round.player.put_in(@amount))
           .change_hand(round.hand.bet(@amount))
           .next_turn
    end
  end

end
