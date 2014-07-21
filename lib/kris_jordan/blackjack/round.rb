module KrisJordan::Blackjack
  # An immutable representation of a round of blackjack at one point in time.
  class Round

    attr_reader :deck, :players, :hands, :turn

    STATES = [
      State::Betting,
      State::Dealing,
      State::Dealing,
      State::Playing,
      State::Paying,
      State::Ending
    ]

    def initialize(deck, players, hands=Array.new, turn=TurnIterator.new)
      @deck    = deck

      raise "Last player must be the dealer" if players[-1].class != Dealer
      @players = players

      if hands.length == players.length
        @hands = hands
      else
        @hands = players.length.times.map{[Hand.new]}
      end

      @turn = turn

      freeze
    end

    # Delegate control to the round's State for the next Event.
    def prompt
      STATES[@turn.state].prompt @deck, player, hand, dealer_hand
    end

    # Mutations are copy-on-write
    def next_turn
      Round.new @deck, @players, @hands, @turn.next(self)
    end
    
    def change_deck deck
      Round.new deck, @players, @hands, @turn
    end

    def change_player player
      players = @players.dup
      players[@turn.player] = player
      Round.new @deck, players, @hands, @turn
    end

    def change_hand hand
      hands = @hands.dup
      hands[@turn.player] = hands[@turn.player].dup
      hands[@turn.player][@turn.hand] = hand
      Round.new @deck, @players, hands, @turn
    end

    def split_hand new_hands
      hands        = @hands.dup
      hands[@turn.player] = hands[@turn.player].dup
      hands[@turn.player][@turn.hand..@turn.hand] = new_hands
      Round.new @deck, @players, hands, @turn
    end

    # Accessors based on current turn
    def player
      @players[@turn.player]
    end

    def dealer_hand
      @hands[@players.length-1][0]
    end

    def hand
      @hands[@turn.player][@turn.hand]
    end


  end
end
