module KrisJordan::Blackjack

  class RoundTurn
    def initialize(round, state=0, player=0, hand=0)
      @round  = round
      @state  = state
      @player = player
      @hand   = hand
    end

    def state
      Round::STATES[@state]
    end

    def player
      @round.players[@player]
    end

    def hand
      @round.hands[@player][@hand]
    end

    def set_hand hand
      @round.hands[@player][@hand] = hand
    end

    def next
      player = @round.players[@player]
      hands  = @round.hands[@player]
      next_hand = @hand + 1
      if hands.length > next_hand
        puts "next_hand"
        @hand = next_hand
      else
        puts "next_player"
        @hand = 0
        next_player = @player + 1
        if @round.players.length > next_player
          @player = next_player
        else
          puts "next_state"
          @player = 0
          next_state = @state + 1
          if Round::STATES.length > next_state
            @state = next_state
          else
            false
          end
        end
      end
    end
  end

  class Round

    attr_reader :players, :hands

    STATES = [:betting, :dealing, :dealing, :playing, :collecting]

    def initialize(players=Array.new)
      @deck    = Deck.new + Deck.new
      @players = players  + [Dealer.new]
      @hands   = @players.length.times.map { [ Hand.new ] }
      @turn    = RoundTurn.new self
    end

    def next
      case @turn.state
      when :betting
        next_bet
      when :dealing
        next_deal
      when :playing
        next_play
      when :collecting
      else
        return false
      end
      true
    end

    def next_bet
      # For now, jump straight to dealing
      # Round.new @players, @deck, :dealing
      puts 'bet'
      emit_bet 0
    end

    def next_deal
      puts 'deal'
      emit_deal @deck.random_card
    end
    
    def next_play
      puts 'play'
      player = @turn.player
      hand   = @turn.hand
      puts hand
      unless hand.bust?
        case player.play hand
        when :hit
          emit_hit @deck.random_card
        when :stand
          emit_stand
        end
      else
        emit_stand
      end
    end

    def emit_bet amount
      @turn.next
    end

    def emit_deal card
      @deck = @deck.take card
      @turn.set_hand @turn.hand.dealt card
      @turn.next
    end

    def emit_hit card
      @deck = @deck.take card
      @turn.set_hand @turn.hand.dealt card
    end

    def emit_stand
      @turn.next
    end



    def deal
      2.times do |card|
        @players = @players.map do |player|
          new_player = player
          player.hands.each do |hand|
            new_player = deal_card new_player, hand, @deck.random_card
          end
          new_player
        end
      end
    end

    def to_s
      @players.map do |player|
        player.hands.map do |hand|
          hand.to_s
        end.join " - "
      end.join "\n"
    end

  end
end
