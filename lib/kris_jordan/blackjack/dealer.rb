module KrisJordan::Blackjack
  class Dealer

    def pay_out chips
      self
    end

    def play hand
      if hand.value < 17
        :hit
      else
        :stand
      end
    end

  end
end
