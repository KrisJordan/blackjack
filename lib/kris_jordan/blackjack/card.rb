require 'colorize'

module KrisJordan::Blackjack
  class Card

    attr_reader :rank, :suit

    SUITS   = [ :heart, :diamond, :spade, :club ]

    RANKS   = [ :ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king ]

    def initialize(rank,suit)
      raise "Invalid rank: #{rank}" unless RANKS.include? rank
      @rank = rank
      raise "Invalid suit: #{suit}" unless SUITS.include? suit
      @suit = suit
      freeze
    end

    def ==(other_card)
      @rank == other_card.rank and @suit == other_card.suit
    end

    def value
      case @rank
      when :ace
        [ 1, 11 ]
      when :jack, :queen, :king
        [ 10 ]
      else
        [ @rank ]
      end
    end

    def face
      case @rank
      when :ace
        "A"
      when :jack
        "J"
      when :queen
        "Q"
      when :king
        "K"
      else
        @rank
      end
    end

    def color
      case @suit
      when :heart, :diamond
        :red
      else
        :black
      end
    end

    def symbol
      case @suit
      when :heart
        "♥"
      when :diamond
        "♦"
      when :spade
        "♣"
      else
        "♠"
      end
    end

    def to_s
      " #{face}#{symbol} "
    end

    def pretty_print
      to_s.colorize(color).on_white
    end

  end
end
