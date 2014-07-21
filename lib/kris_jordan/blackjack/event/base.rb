module KrisJordan::Blackjack::Event

  # Events are immutable objects which act as a transformer on
  # rounds. Given a round, #transform returns a new round as effected
  # by the event.
  class Base
    KEY = nil

    # Given a `Round` return transformed `Round'`
    def transform round
      # Most subclasses will override this, but there are a
      # few events which are no-ops and transform simply by
      # moving to the next turn in the round. We'll include
      # that here for convenience.
      round.next_turn
    end

    # For playing rounds, #prompt returns a string indicating
    # the key to press to generate this event.
    def prompt 
    end

    # Humanized string output for gameplay to describe the event
    # which just happened.
    def describe round
    end

    # Return the arguments needed to reconstruct the Event.
    # Used for serialization in the write-ahead log.
    def args
      []
    end
  end

end
