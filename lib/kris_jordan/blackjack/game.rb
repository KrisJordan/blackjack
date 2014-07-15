module KrisJordan::Blackjack
  class Game
    def self.play
      chips    = 100
      @players = [Player.new(chips)]
      @round   = Round.new @players
      while command = @round.next
        dispatch command
      end
    end

    def self.dispatch command
      puts "dispatch"
      puts command.to_h
      case command[:command]
      when :bet
        @round.bet command[:amount]
      when :deal
        @round.deal command[:card]
      when :hit
        @round.hit command[:card]
      when :stand
        @round.stand
      when :collect
        @round.collect command[:amount]
      else
        puts command[:type]
      end
    end
  end
end
