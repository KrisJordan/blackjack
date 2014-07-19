module KrisJordan::Blackjack
  class Hand
    include Comparable 

    attr_reader :chips, :cards

    def initialize(cards = Array.new, chips = 0)
      @cards = cards
      @chips = chips
      freeze
    end

    def length
      @cards.length
    end

    def bet(chips)
      Hand.new @cards, @chips + chips
    end

    def dealt(card)
      Hand.new (@cards.dup + [card]), @chips
    end

    def split new_cards
      (0...new_cards.length).map do |i|
        Hand.new([@cards[i]],@chips)
            .dealt(new_cards[i])
      end
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

    def to_s
      if @cards.length > 0
        @cards.map{ |c| c.to_s }.join() + ":" + value.to_s
      else
        ""
      end
    end

    def pretty_print
      cards.map{|c|c.pretty_print}.join " "
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
