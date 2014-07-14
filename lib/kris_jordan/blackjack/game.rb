module KrisJordan::Blackjack
  class Game
    def self.play
      chips   = 100
      players = [Player.new(chips)]
      round   = Round.new players
      while round.next
        true
      end
    end
  end
end
