module KrisJordan::Blackjack::Action

  class Skip < Action
    def transition round
      round.next_turn
    end
  end

end
