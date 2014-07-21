module KrisJordan::Blackjack::Event

  class End < Base
    def transform round
      raise "This should never get called."
    end
  end

end
