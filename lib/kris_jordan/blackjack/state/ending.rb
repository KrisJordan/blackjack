module KrisJordan::Blackjack::State

  class Ending
    End = KrisJordan::Blackjack::Action::End

    def self.prompt deck, player, hand, dealer
      End.new
    end
  end

end
