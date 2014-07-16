module KrisJordan::Blackjack
  class Player
    def initialize(chips)
      @chips = chips
      freeze
    end

    def put_in chips
      Player.new @chips - chips
    end

    def pay_out chips
      Player.new @chips + chips
    end

    def bet hand
      puts "How much?"
      gets.chomp.to_i
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
