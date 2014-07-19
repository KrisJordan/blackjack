module KrisJordan::Blackjack::State

  class Betting
    def self.prompt deck, player, hand, dealer_hand
      if hand != dealer_hand
        chips = 0
        until chips > 0 and chips <= player.chips
          puts "#{player.name}, you have #{player.chips} chips."
          puts "How many would you like to bet?"
          begin
            chips = $stdin.gets.chomp.to_i
          rescue
            exit
          end
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

    def describe round
      # No description
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

    def describe round
      "#{round.player.name} puts in #{@amount} chips."
    end
  end

end
