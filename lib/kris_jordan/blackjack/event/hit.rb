module KrisJordan::Blackjack::Event

  class Hit < Base
    KEY = 'h'

    def initialize card
      @card = card
      freeze
    end

    def prompt 
      " [H]it"
    end

    def describe round
      "#{round.player.name} hits #{round.hand.pretty_print} #{@card.pretty_print}."
    end

    def transform round
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
    end

    def to_json
      [@card]
    end
  end

end
