module KrisJordan::Blackjack::Event

  class Bet < Base
    def initialize amount
      @amount = amount
      freeze
    end

    def transform round
      round.change_player(round.player.put_in(@amount))
           .change_hand(round.hand.bet(@amount))
           .next_turn
    end

    def describe round
      "#{round.player.name} puts in #{@amount} chips."
    end

    def to_json
      [@amount]
    end
  end

end
