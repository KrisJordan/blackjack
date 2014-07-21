module KrisJordan::Blackjack::State

  class Betting
    Skip = KrisJordan::Blackjack::Event::Skip
    Bet  = KrisJordan::Blackjack::Event::Bet

    def self.prompt deck, player, hand, dealer_hand
      if hand != dealer_hand
        chips = 0
        until chips > 0 and chips <= player.chips
          puts ""
          puts "#{player.name}, you have #{player.chips} chips."
          puts "How many would you like to bet?"
          begin
            chips = $stdin.gets.chomp.to_i
          rescue Interrupt, NameError
            exit
          end
        end
        Bet.new chips
      else
        Skip.new
      end
    end
  end

end
