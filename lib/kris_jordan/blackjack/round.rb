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

    STATES = [:betting, :dealing, :dealing, :playing, :collecting, :over]

    def initialize(players=Array.new)
      @deck    = Deck.new + Deck.new
      @players = players  + [Dealer.new]
      @hands   = @players.length.times.map { [ Hand.new ] }
      @turn    = RoundTurn.new self
    end

    def next
      player  = @turn.player
      hand    = @turn.hand
      case @turn.state
      when :betting
        next_bet player, hand
      when :dealing
        next_deal player, hand
      when :playing
        next_play player, hand
      when :collecting
        next_collect player, hand
      else
        return false
      end
    end

    def next_bet player, hand
      # For now, jump straight to dealing
      # Round.new @players, @deck, :dealing
      { command: :bet, amount: 0 }
    end

    def next_deal player, hand
      { command: :deal, card: @deck.random_card }
    end
    
    def next_play player, hand
      puts hand
      unless hand.bust?
        case player.play hand
        when :hit
          { command: :hit, card: @deck.random_card }
        when :stand
          { command: :stand }
        end
      else
        { command: :stand }
      end
    end

    def next_collect player, hand
      { command: :collect, amount: 0 }
    end

    def bet amount
      puts 'bet'
      @turn.next
    end

    def deal card
      puts 'deal'
      @deck = @deck.take card
      @turn.set_hand @turn.hand.dealt card
      @turn.next
    end

    def hit card
      puts 'play'
      @deck = @deck.take card
      @turn.set_hand @turn.hand.dealt card
    end

    def stand
      puts 'play'
      @turn.next
    end

    def collect amount
      puts 'collect'
      @turn.next
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
