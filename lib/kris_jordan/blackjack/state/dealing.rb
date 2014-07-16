module KrisJordan::Blackjack::State

  class Dealing
    def self.prompt deck, player, hand
      DealAction.new deck.random_card
    end
  end

  class DealAction
    def initialize card
      @card = card
    end

    def transition round
      puts "Dealt #{@card}"
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
           .next_turn
    end
  end

end
