require 'spec_helper'

Round = KrisJordan::Blackjack::Round
Deck = KrisJordan::Blackjack::Deck
Player = KrisJordan::Blackjack::Player
Dealer = KrisJordan::Blackjack::Dealer

describe Round do

  describe ".new" do
    it "should construct with a deck, a player, and a dealer" do
      deck    = Deck.new
      players = [Player.new(:foo, 1), Dealer.new]
      expect(Round.new deck, players).to_not eq nil
    end

    it "should not construct without dealer" do
      deck    = Deck.new
      players = [Player.new(:foo, 1)]
      expect{Round.new deck, players}.to raise_error
    end
  end

end
