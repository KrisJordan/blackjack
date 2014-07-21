module KrisJordan::Blackjack::State

  class Playing
    Hit     = KrisJordan::Blackjack::Action::Hit
    Stand   = KrisJordan::Blackjack::Action::Stand
    Bust    = KrisJordan::Blackjack::Action::Bust
    Split   = KrisJordan::Blackjack::Action::Split

    def self.prompt deck, player, hand, dealer_hand
      if hand.value == 0
        Bust.new
      else
        if player.dealer?
          if hand.value >= 17
            Stand.new
          else
            Hit.new deck.random_card
          end
        else
          options = []
          options << Stand.new
          options << Hit.new(deck.random_card) if hand.can_hit?

          if player.chips >= hand.chips
            options << Split.new(deck.random_card, deck.random_card) if hand.can_split?
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
      [@card]
    end
  end

end
