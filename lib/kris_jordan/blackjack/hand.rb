module KrisJordan::Blackjack
  class Hand
    include Comparable 

    def initialize(cards = Array.new)
      @cards = cards
      freeze
    end

    def length
      @cards.length
    end

    def take(card)
      Hand.new @cards.dup + [card]
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

    def <=>(deck)
      value <=> deck.value
    end

    def blackjack?
      length == 2 and value == 21
    end

    def can_hit?
      length >= 2 and value < 21
    end

    def can_split?
      length == 2 and @cards[0].value == @cards[1].value
    end

    def can_double_down?
    end

    def bust?
      length > 0 and value == 0
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
