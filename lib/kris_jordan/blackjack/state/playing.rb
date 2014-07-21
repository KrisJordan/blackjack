module KrisJordan::Blackjack::State

  class Playing
    Hit         = KrisJordan::Blackjack::Event::Hit
    Stand       = KrisJordan::Blackjack::Event::Stand
    Bust        = KrisJordan::Blackjack::Event::Bust
    Split       = KrisJordan::Blackjack::Event::Split
    DoubleDown  = KrisJordan::Blackjack::Event::DoubleDown

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
          options << Split.new(deck.random_card, deck.random_card) if hand.can_split? player
          options << DoubleDown.new(deck.random_card) if hand.can_double_down? player

          event = nil
          until event != nil
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
            event = options.find { |o| o.class::KEY == input.downcase }
          end
          event
        end
      end
    end
  end

end
