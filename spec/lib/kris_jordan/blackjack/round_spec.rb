require 'spec_helper'

Round = KrisJordan::Blackjack::Round
RoundTurn = KrisJordan::Blackjack::RoundTurn

describe RoundTurn do
  describe "#next" do
    it "progresses through states without hands" do
      round   = Round.new
      turn  = RoundTurn.new round
      expect(turn.state).to eq :betting
      turn.next
      expect(turn.state).to eq :dealing
      turn.next
      expect(turn.state).to eq :dealing
      turn.next
      expect(turn.state).to eq :playing
      turn.next
      expect(turn.state).to eq :collecting
    end
  end
end

describe Round do

  describe ".new" do
    it "should construct without players" do
      expect(Round.new).to_not eq nil
    end
  end

  #describe "#next_state" do
  #  context "when :betting" do
  #    it "should skip betting state for time being" do
  #      round = Round.new.next_state
  #      expect(round.state).to eq :dealing
  #    end
  #  end

  #  context "when :dealing" do
  #    it "should deal a single card to the dealer" do
  #      round = Round.new([], nil, :dealing).next_state
  #      expect(round.state).to eq :dealing
  #    end
  #  end
  #end
  

end
