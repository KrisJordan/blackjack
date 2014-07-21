module KrisJordan::Blackjack::Action

  class Base
    KEY = nil

    def transition round
      round.next_turn
    end

    def prompt 
    end

    def describe round
    end

    def to_json
      []
    end
  end

end
