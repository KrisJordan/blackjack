module KrisJordan::Blackjack::Event

  class Lose < Base
    def initialize amount
      @chips = amount
    end

    def describe round
      "#{round.player.name} loses #{@chips} chips."
    end

    def to_json
      [@chips]
    end
  end

end
