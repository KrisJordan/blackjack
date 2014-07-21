module KrisJordan::Blackjack::Event

  class Base
    KEY = nil

    def transform round
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
