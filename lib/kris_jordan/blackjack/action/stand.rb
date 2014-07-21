module KrisJordan::Blackjack::Action
  class Stand < Base

    KEY = 's'

    def prompt
      " [S]tand"
    end

    def describe round
      "#{round.player.name} stands with #{round.hand.pretty_print}."
    end

    def transition round
      round.next_turn
    end

  end
end
