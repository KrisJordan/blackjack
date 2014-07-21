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

    def dealer?
      false
    end
  end
end
