module KrisJordan::Blackjack
  class Player

    attr_reader :name, :chips

    def initialize(name, chips)
      @name  = name
      @chips = chips
      freeze
    end

    def put_in chips
      Player.new @name, @chips - chips
    end

    def pay_out chips
      Player.new @name, @chips + chips
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
