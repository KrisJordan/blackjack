module KrisJordan::Blackjack::Action

  class Base
    def transition round
      round
    end

    def describe round
    end

    def to_json
      { classname: self.class.name, args: [] }
    end
  end

end
