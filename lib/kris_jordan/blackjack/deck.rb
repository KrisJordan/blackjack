module KrisJordan::Blackjack
  class Deck
    
    attr_reader :cards

    # Immutable stack of cards.
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
    
    # Return a card at random from the deck
    def random_card
      @cards[(@random.rand * @cards.length).floor]
    end

    # Take a specific card from the deck
    def take(card)
      index = @cards.index card
      raise "Card not in deck" if index == nil
      new_cards = @cards.dup
      new_cards.slice! index
      Deck.new new_cards
    end

    # Combine 2 decks
    def +(deck)
      Deck.new(@cards + deck.cards)
    end

    # Stack n decks together
    def *(n)
       (n-1).times
            .map{self}
            .reduce(self){ |pile,deck| pile+deck }
    end

  end
end
