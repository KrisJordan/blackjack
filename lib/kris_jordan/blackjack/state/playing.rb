module KrisJordan::Blackjack::State

  class Playing
    def self.prompt deck, player, hand, dealer_hand
      if hand.value == 0
        BustAction.new
      else
        if player.dealer?
          if hand.value >= 17
            StandAction.new
          elsif hand.value > 0
            HitAction.new deck.random_card
          else
            BustAction.new
          end
        else
          options = []
          options << StandAction.new
          options << HitAction.new(deck.random_card) if hand.can_hit?

          action = nil
          until action != nil
            puts "#{player.name} you have"
            puts hand.cards.map{|c|c.pretty_print}.join " "
            puts "You can: "
            options.each { |o| puts o.prompt }
            begin
              input = $stdin.gets.chomp
            rescue
              exit
            end
            action = options.find { |o| o.class::KEY == input.downcase }
          end
          action
        end
      end
    end
  end

  class HitAction
    KEY = 'h'

    def initialize card
      @card = card
    end

    def prompt 
      " [H]it"
    end

    def describe round
      "#{round.player.name} hits #{round.hand.pretty_print} #{@card.pretty_print}."
    end

    def transition round
      round.change_deck(round.deck.take(@card))
           .change_hand(round.hand.dealt(@card))
    end
  end

  class StandAction
    KEY = 's'

    def prompt
      " [S]tand"
    end

    def describe round
      "#{round.player.name} stands with #{round.hand.pretty_print}."
    end

    def transition round
      round.next_turn
    end
  end

  class BustAction
    def describe round
      "#{round.player.name} busts."
    end

    def transition round
      round.next_turn
    end
  end

end
