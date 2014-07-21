module KrisJordan::Blackjack::Event

  class DoubleDown < Base
    KEY = 'd'

    def initialize card
      @card = card
      freeze
    end

    def prompt
      " [D]ouble down"
    end

    def describe round
      "#{round.player.name} doubled down #{round.hand.pretty_print} #{@card.pretty_print}."
    end

    def transform round
      round.change_deck(round.deck.take(@card))
           .change_player(round.player.put_in(round.hand.chips))
           .change_hand(
              round.hand
                   .bet(round.hand.chips)
                   .dealt(@card))
           .next_turn
    end

    def to_json
      [@card]
    end
  end

end
