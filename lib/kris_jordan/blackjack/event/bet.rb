module KrisJordan::Blackjack::Event

  class Bet < Base
    def initialize amount
      @amount = amount
      freeze
    end

    def transform round
      round.set_player { |player| player.put_in @amount }
           .set_hand   { |hand|   hand.bet @amount }
           .next_turn
    end

    def describe round
      "#{round.player.name} puts in #{@amount} chips."
    end

    def args
      [@amount]
    end
  end

end
