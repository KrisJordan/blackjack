module KrisJordan::Blackjack::Event

  class Split < Base
    KEY = 't'

    def initialize first_card, second_card
      @first_card  = first_card
      @second_card = second_card
      freeze
    end

    def prompt
      " Spli[t]"
    end

    def describe round
      "#{round.player.name} split."
    end

    def transform round
      chips = round.hand.chips
      round.set_deck   { |deck|   deck.take(@first_card).take(@second_card) }
           .set_player { |player| player.put_in chips }
           .split_hand { |hand|   hand.split [@first_card, @second_card] }
    end

    def args
      [@first_card, @second_card]
    end
  end

end
