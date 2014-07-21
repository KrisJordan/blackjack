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
      round.set_deck { |deck| deck.take @card }
           .set_hand { |hand| hand.dealt @card }
    end

    def args
      [@card]
    end
  end

end
