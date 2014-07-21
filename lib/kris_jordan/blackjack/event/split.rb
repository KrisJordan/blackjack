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
      round.change_deck(round.deck.take(@first_card).take(@second_card))
           .change_player(round.player.put_in(round.hand.chips))
           .split_hand(round.hand.split([@first_card,@second_card]))
    end

    def args
      [@first_card, @second_card]
    end
  end

end
