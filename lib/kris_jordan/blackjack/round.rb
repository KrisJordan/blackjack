module KrisJordan::Blackjack

  class TurnIterator
    attr_reader :state, :player, :hand

    def initialize(state=0, player=0, hand=0)
      @state  = state
      @player = player
      @hand   = hand
      freeze
    end

    def next(round)
      next_hand = @hand + 1
      if next_hand < round.hands[@player].length
        TurnIterator.new @state, @player, next_hand
      else
        next_player = @player + 1
        if next_player < round.players.length
          TurnIterator.new @state, next_player
        else
          next_state = @state + 1
          if next_state < Round::STATES.length
            TurnIterator.new next_state
          else
            false
          end
        end
      end
    end

  end


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
    
    def start_message
      puts "=== New Round ==="
      # puts "Balances: "
      # (0...players.count-1).each do |player|
      #   puts " Player #{player+1}: #{@players[player].chips} chips"
      # end
    end

  end
end
