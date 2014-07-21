module KrisJordan::Blackjack::State

  class Ending
    def self.prompt deck, player, hand, dealer
      EndAction.new
    end
  end

  class EndAction 
    def transition round
      raise "This should never get called."
    end

    def describe round
      # No description
    end

    def to_json
      []
    end
  end

end
