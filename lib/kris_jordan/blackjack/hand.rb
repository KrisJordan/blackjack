module KrisJordan::Blackjack
  class Hand

    def initialize(*cards)
      @cards = cards
    end

    def length
      @cards.length
    end

    def possible_values
      permute_recur(@cards.map(&:value))
        .uniq
        .select { |value| value <= 21 }
    end

    def value
      values = possible_values
      unless values.empty?
        values.max
      else
        0
      end
    end

    def blackjack?
      @cards.length == 2 and value == 21
    end

    def split?
      @cards.length == 2 and @cards[0].value == @cards[1].value
    end

    private

    def permute_recur(list)
      values, *rest = list
      if rest.empty?
        values
      else
        result = []
        permute_recur(rest).each do |permutation|
          values.each do |value|
            result.push(permutation + value)
          end
        end
        result
      end
    end

  end
end
