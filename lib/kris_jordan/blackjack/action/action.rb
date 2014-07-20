module KrisJordan::Blackjack::Action

  class Action
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
