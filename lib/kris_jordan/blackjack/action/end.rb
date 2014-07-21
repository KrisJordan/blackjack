module KrisJordan::Blackjack::Action

  class End < Base
    def transition round
      raise "This should never get called."
    end
  end

end
