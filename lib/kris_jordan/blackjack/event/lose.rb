module KrisJordan::Blackjack::Event

  class Lose < Base
    def describe round
      "#{round.player.name} loses #{round.hand.chips} chips."
    end
  end

end
