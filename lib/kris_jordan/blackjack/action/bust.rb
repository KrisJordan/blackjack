module KrisJordan::Blackjack::Action

  class Bust < Base
    def describe round
      "#{round.player.name} busts."
    end
  end

end
