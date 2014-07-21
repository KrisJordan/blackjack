module KrisJordan::Blackjack::Action

  class Base
    KEY = nil

    def transition round
      round
    end

    def prompt 
    end

    def describe round
    end

    def to_json
      { classname: self.class.name, args: [] }
    end
  end

end
