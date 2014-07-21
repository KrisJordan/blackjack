module KrisJordan::Blackjack

  # GameJournal is a naive singleton that handles writing
  # game events to an append-only, write-ahead log file and 
  # recreating a game by replying events from the file.
  #
  # The first line of the log contains the `Game` object serialized.
  # Subsequent lines are serialized `Event` objects that transform
  # the state of the game.
  #
  # TODO: Implement compaction at end of rounds.
  class GameJournal
    JOURNAL_FILE = '.blackjack.aof'

    def self.in_progress?
      File.exist? JOURNAL_FILE
    end

    # Create a game with the first line, 
    def self.resumed_game
      game = nil
      File.open(JOURNAL_FILE, "r") do |file|
        index = 0
        file.each_line do |line|
          object = unmarshal(JSON[line])
          if index == 0
            # The first line contains the game settings
            game = object
          else
            # Subsequent lines are Events
            event = object # TODO: remove
            game.handle event
          end
          index += 1
        end
      end
      game
    end

    def self.begin game
      clear
      write game
    end
    
    def self.write object
      open('.blackjack.aof','a') do |f| 
        f.puts JSON.generate marshal object
      end
    end

    def self.marshal object
      case object.class.name
      when "String", "Symbol", "Fixnum", "Array"
        object
      else
        {
          classname: object.class.name,
          args:      object.to_json.map { |o| marshal o },
          timestamp: Time.now
        }
      end
    end

    def self.unmarshal(obj)
      classname = obj["classname"]
      args      = obj["args"].map do |arg| 
        if arg.is_a? Hash
          self.unmarshal(arg)
        else
          arg
        end
      end
      Object::const_get(classname).send(:new,*args)
    end

    def self.clear
      file = '.blackjack.aof'
      if File.exist? file
        File.delete('.blackjack.aof')
      end
    end

  end
end
