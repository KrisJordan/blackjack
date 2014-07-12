module KrisJordan::Blackjack
  class Deck
    
    def initialize(cards = Array.new) 
      if cards.length == 0
        cards = Card::SUITS.map {
                  |suit| Card::RANKS.map { 
                    |rank| Card.new rank, suit
                  }
                }.flatten
      end
      @cards  = cards
      @random = Random.new
      freeze
    end

    def cards 
      @cards.dup
    end

    def random_card
      @cards[(@random.rand * @cards.length).floor]
    end

    def take(card)
      index = @cards.index card
      raise "Card not in deck" if index == nil
      new_cards = @cards.dup
      new_cards.slice! index
      Deck.new new_cards
    end

    def +(deck)
      Deck.new(@cards + deck.cards)
    end

  end
end
