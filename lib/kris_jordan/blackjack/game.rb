require 'json'

module KrisJordan::Blackjack
  class Game

    JOURNAL_FILE = '.blackjack.aof'

    attr_accessor :players, :deck, :round

    def self.in_progress?
      File.exist? JOURNAL_FILE
    end

    def self.resume
      game = nil
      File.open(JOURNAL_FILE, "r") do |file|
        index = 0
        file.each_line do |line|
          object = unmarshall(JSON[line])

          if index == 0
            game = object
          else
            unless object.is_a? State::EndAction
              game.round   = object.transition game.round
              game.players = game.round.players.select { |p| p.dealer? or p.chips > 0 }
            else
              game.round = Round.new game.deck, game.players
            end
          end
          index += 1
        end
      end
      game
    end

    def self.unmarshall(obj)
      classname = obj["classname"]
      args      = obj["args"].map do |arg| 
        if arg.is_a? Hash
          self.unmarshall(arg)
        else
          arg
        end
      end
      Object::const_get(classname).send(:new,*args)
    end

    def initialize starting_players, starting_chips, decks_per_round

      if starting_chips < 1
        @starting_chips = 1
      else
        @starting_chips   = starting_chips
      end

      if starting_players < 1
        @starting_players = 1
      else
        @starting_players = starting_players
      end
      @players = starting_players
                  .times
                  .map {|n| Player.new("Player #{n+1}", @starting_chips)} +
                  [Dealer.new]

      if decks_per_round <= 1
        @decks_per_round  = 2
      else
        @decks_per_round  = decks_per_round
      end 
      @deck             = Deck.new * @decks_per_round

      @round            = Round.new @deck, @players

    end

    def play(resume=false)
      new_journal unless resume
      while @players.count > 1 do
        while action = @round.next_action
          write_journal action
          narrate action.describe @round
          unless action.is_a? State::EndAction
            @round   = action.transition @round
            @players = @round.players.select { |p| p.dealer? or p.chips > 0 }
          else
            @round = Round.new @deck, @players
          end
        end
      end
      clear_journal
      puts "\nGame over, thanks for playing!\n\n"
    end

    def unmarshal
      Object::const_get("KrisJordan::Blackjack::State::BetAction").send(:new,*[0])
    end

    def to_json
      { classname: self.class.name, args: [
          @starting_players,
          @starting_chips,
          @decks_per_round
      ] }
    end

    def narrate description
      puts "\n#{description}" if description
    end

    def new_journal
      clear_journal
      write_journal self
    end
    
    def clear_journal
      file = '.blackjack.aof'
      if File.exist? file
        File.delete('.blackjack.aof')
      end
    end

    def write_journal action
      open('.blackjack.aof','a') do |f| 
        json = action.to_json
        json[:timestamp] = Time.now
        f.puts JSON.generate json
      end
    end

  end
end
