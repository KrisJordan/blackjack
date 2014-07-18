module KrisJordan::Blackjack::State

  class Playing
    def self.prompt deck, player, hand, dealer_hand
      if hand === dealer_hand
        if hand.value < 17
          HitAction.new deck.random_card
        else
          StandAction.new
        end
      else
        unless hand.bust?
          options = []
          options << StandAction.new
          options << HitAction.new(deck.random_card) if hand.can_hit?

          action = nil
          until action != nil
            puts ""
            puts "Player #{player.name} you have"
            puts hand.cards.map{|c|c.pretty_print}.join " "
            puts "You can: "
            options.each { |o| puts o.print }
            input = gets.chomp
            action = options.find { |o| o.class::KEY == input.downcase }
          end
          action
        else
          StandAction.new
        end
      end
    end
  end

  class HitAction
    KEY = 'h'

    def initialize card
      @card = card
    end

    def print
      " [H]it"
    end

    def transition round
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
    end
  end

  class StandAction
    KEY = 's'

    def transition round
      round.next_turn
    end

    def print
      " [S]tand"
    end
  end

end
