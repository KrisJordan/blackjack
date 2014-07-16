module KrisJordan::Blackjack::State

  class Playing
    def self.prompt deck, player, hand
      puts hand.to_s
      unless hand.bust?
        case player.play hand
        when :hit
          HitAction.new deck.random_card
        when :stand
          StandAction.new
        end
      else
        StandAction.new
      end
    end
  end

  class HitAction
    def initialize card
      @card = card
    end

    def transition round
      puts "Hit #{@card}"
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
    end
  end

  class StandAction
    def transition round
      puts "Stood"
      round.next_turn
    end
  end

end
