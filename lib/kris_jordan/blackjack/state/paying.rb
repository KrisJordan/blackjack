module KrisJordan::Blackjack::State

  class Paying
    Skip = KrisJordan::Blackjack::Event::Skip
    Win = KrisJordan::Blackjack::Event::Win
    Lose = KrisJordan::Blackjack::Event::Lose

    def self.prompt deck, player, hand, dealer_hand
      if player.dealer?
        Skip.new
      else
        if hand.bust?
          Lose.new hand.chips

        elsif hand.blackjack?
          if dealer_hand.blackjack?
            Win.new "push", hand.chips
          else
            Win.new "blackjack", (hand.chips * 2.5).round
          end

        else
          if dealer_hand.bust?
            Win.new "dealer bust", hand.chips * 2
          else
            if hand > dealer_hand
              Win.new "beating dealer", hand.chips * 2
            elsif hand == dealer_hand
              Win.new "push", hand.chips
            else
              Lose.new hand.chips
            end
          end
        end
      end
    end
  end

end
