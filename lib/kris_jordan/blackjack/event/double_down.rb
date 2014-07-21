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
      chips = round.hand.chips
      round.set_deck   { |deck|   deck.take @card }
           .set_player { |player| player.put_in chips }
           .set_hand   { |hand|   hand.bet(chips).dealt(@card) }
           .next_turn
    end

    def args
      [@card]
    end
  end

end
