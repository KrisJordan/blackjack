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

end
