module KrisJordan::Blackjack::Action

  class Skip < Base
    def transition round
      round.next_turn
    end
  end

end
