module KrisJordan::Blackjack
  class GameJournal
    JOURNAL_FILE = '.blackjack.aof'

    def self.in_progress?
      File.exist? JOURNAL_FILE
    end

    def self.resumed_game
      game = nil
      File.open(JOURNAL_FILE, "r") do |file|
        index = 0
        file.each_line do |line|
          object = unmarshall(JSON[line])
          if index == 0
            game = object
          else
            game.take object
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
    
    def self.write action
      open('.blackjack.aof','a') do |f| 
        json = action.to_json
        json[:timestamp] = Time.now
        f.puts JSON.generate json
      end
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

    def self.clear
      file = '.blackjack.aof'
      if File.exist? file
        File.delete('.blackjack.aof')
      end
    end

  end
end
