module KrisJordan::Blackjack
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

    # Mutations are copy-on-write as rounds are immutable
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

    def next_action
      STATES[@turn.state].prompt @deck, player, hand, dealer_hand
    end

    def next_turn
      Round.new @deck, @players, @hands, @turn.next(self)
    end
    
  end
end
