module KrisJordan::Blackjack
  class Hand
    include Comparable 

    attr_reader :chips, :cards

    def initialize(cards = Array.new, chips = 0, doubled_down = false)
      @cards = cards
      @chips = chips
      @doubled_down = doubled_down
      freeze
    end

    def length
      @cards.length
    end

    # Copy-on-write mutators

    def bet(chips)
      Hand.new @cards, @chips + chips, @chips > 0
    end

    def dealt(card)
      Hand.new (@cards.dup + [card]), @chips, @doubled_down
    end

    def split new_cards
      (0...new_cards.length).map do |i|
        Hand.new([@cards[i]],@chips)
            .dealt(new_cards[i])
      end
    end

    # Accessors

    # Return the highest possible value
    def value
      values = possible_values
      unless values.empty?
        values.max
      else
        0
      end
    end

    # Return all possible values
    def possible_values
      permute_recur(@cards.map(&:value))
        .uniq
        .select { |value| value <= 21 }
    end

    # Implement for Comparable functionality
    def <=>(deck)
      value <=> deck.value
    end

    # Convenience functions
    def bust?
      length > 0 and value == 0
    end

    def blackjack?
      length == 2 and value == 21
    end

    def can_hit?
      length >= 2 and value < 21 and not @doubled_down
    end

    def can_split? player
      player.chips >= chips and
      length == 2 and 
      @cards[0].value == @cards[1].value
    end

    def can_double_down? player
      player.chips >= chips and
      length == 2 and 
      not @doubled_down and 
      not blackjack?
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

    # Permute all possible values of a hand by recursively
    # travelling to the end of the list of cards, then pushing
    # permutations as we pop back up the stack. Could be done
    # imperatively, but since blackjack hands tend to max out
    # at 5 or 6 cards and only aces generate multiple permutations
    # a simple, recursive permutation is acceptable.
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
