module KrisJordan::Blackjack::State

  class Playing
    Hit = KrisJordan::Blackjack::Action::Hit

    def self.prompt deck, player, hand, dealer_hand
      if hand.value == 0
        BustAction.new
      else
        if player.dealer?
          if hand.value >= 17
            StandAction.new
          elsif hand.value > 0
            Hit.new deck.random_card
          else
            BustAction.new
          end
        else
          options = []
          options << StandAction.new
          options << Hit.new(deck.random_card) if hand.can_hit?

          if player.chips >= hand.chips
            options << SplitAction.new(deck.random_card, deck.random_card) if hand.can_split?
            options << DoubleDownAction.new(deck.random_card) if hand.can_double_down?
          end

          action = nil
          until action != nil
            puts ""
            puts "#{player.name} you have"
            puts hand.cards.map{|c|c.pretty_print}.join " "
            puts "You can: "
            options.each { |o| puts o.prompt }
            begin
              input = $stdin.gets.chomp
            rescue Interrupt, NameError
              exit
            end
            action = options.find { |o| o.class::KEY == input.downcase }
          end
          action
        end
      end
    end
  end

  class DoubleDownAction
    KEY = 'd'

    def initialize card
      @card = card
      freeze
    end

    def prompt
      " [D]ouble down"
    end

    def describe round
      "#{round.player.name} doubled down #{round.hand.pretty_print} #{@card.pretty_print}."
    end

    def transition round
      round.change_deck(round.deck.take(@card))
           .change_player(round.player.put_in(round.hand.chips))
           .change_hand(
              round.hand
                   .bet(round.hand.chips)
                   .dealt(@card))
           .next_turn
    end

    def to_json
      { classname: self.class.name, args: [@card.to_json] }
    end
  end

  class SplitAction
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

    def transition round
      round.change_deck(round.deck.take(@first_card).take(@second_card))
           .change_player(round.player.put_in(round.hand.chips))
           .split_hand(round.hand.split([@first_card,@second_card]))
    end

    def to_json
      { classname: self.class.name, args: [@first_card.to_json,@second_card.to_json] }
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

    def to_json
      { classname: self.class.name, args: [] }
    end
  end

  class BustAction
    def describe round
      "#{round.player.name} busts."
    end

    def transition round
      round.next_turn
    end

    def to_json
      { classname: self.class.name, args: [] }
    end
  end

end
