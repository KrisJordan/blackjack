module KrisJordan::Blackjack::Event

  class Bust < Base
    def describe round
      "#{round.player.name} busts."
    end
  end

end
