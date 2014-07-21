module KrisJordan::Blackjack::State

  class Dealing
    Deal = KrisJordan::Blackjack::Event::Deal
    def self.prompt deck, player, hand, dealer_hand
      Deal.new deck.random_card
    end
  end

end
