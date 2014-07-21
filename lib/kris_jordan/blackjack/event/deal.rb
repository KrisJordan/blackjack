module KrisJordan::Blackjack::Event

  class Deal < Base

    def initialize card
      @card = card
    end

    def describe round
      player = round.player

      hand = round.hand
      unless player.dealer? and hand.cards.length == 1
        "#{player.name} dealt #{hand.dealt(@card).pretty_print}"
      else
        "#{player.name} dealt #{hand.pretty_print} #{' ?? '.on_white}"
      end
    end

    def transform round
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
           .next_turn
    end

    def to_json
      [@card]
    end

  end

end
