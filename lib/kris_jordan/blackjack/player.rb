module KrisJordan::Blackjack
  class Player
    def initialize(chips)
      @chips = chips
    end

    def play hand
      puts hand
      puts "Hit (h) or Stand (s)?"
      move = gets.chomp
      case move
      when "h"
        :hit
      when "s"
        :stand
      end
    end
  end
end
