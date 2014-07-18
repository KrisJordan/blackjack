module KrisJordan::Blackjack::State

  class Dealing
    def self.prompt deck, player, hand, dealer_hand
      card = deck.random_card
      if hand.length == 1
        puts ""
        if hand === dealer_hand
          puts "Dealer"
          puts "#{hand.cards[0].pretty_print} #{" ?? ".on_white}"
        else
          puts "Player #{player.name}"
          puts "#{hand.cards[0].pretty_print} #{card.pretty_print}"
        end
      end
      DealAction.new card
    end
  end

  class DealAction
    def initialize card
      @card = card
    end

    def transition round
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
           .next_turn
    end
  end

end
