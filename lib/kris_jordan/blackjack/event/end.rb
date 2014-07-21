module KrisJordan::Blackjack::Event

  class End < Base
    def transition round
      raise "This should never get called."
    end
  end

end
