require 'spec_helper'

Card = KrisJordan::Blackjack::Card

describe Card do
  
  describe ".new" do
    it "should instantiate for all suits and ranks" do
      Card::SUITS.each do |suit|
        Card::RANKS.each do |rank|
          expect{ Card.new(rank, suit) }.to_not raise_error
        end
      end
    end

    it "should raise exception for invalid suits" do
      expect{ Card.new(Card::RANKS.first, :hearts) }.to raise_error
    end

    it "should raise exception for invalid ranks" do
      expect{ Card.new(1,      Card::SUITS.first) }.to raise_error
      expect{ Card.new(11,     Card::SUITS.first) }.to raise_error
      expect{ Card.new(:joker, Card::SUITS.first) }.to raise_error
    end
  end

  describe "#==" do
    it "should equate different instances of the same rank/suit" do
      expect( Card.new(Card::RANKS.first,Card::SUITS.first) ).to eq Card.new(Card::RANKS.first,Card::SUITS.first)
    end

    it "should not be equivalent for different ranks" do
      expect( Card.new(Card::RANKS.first,Card::SUITS.first) ).to_not eq Card.new(Card::RANKS.last,Card::SUITS.first)
    end

    it "should not be equivalent for different suits" do
      expect( Card.new(Card::RANKS.first,Card::SUITS.first) ).to_not eq Card.new(Card::RANKS.first,Card::SUITS.last)
    end
  end

  describe "#value" do
    it "should return [rank] for non-face cards" do
      (2..10).each do |rank|
        expect( Card.new(rank, Card::SUITS.first).value ).to eq [rank]
      end
    end

    it "should return [10] for face cards" do
      [:jack, :queen, :king].each do |rank|
        expect( Card.new(rank, Card::SUITS.first).value ).to eq [10]
      end
    end

    it "should return [1, 11] for aces" do
      expect( Card.new(:ace, Card::SUITS.first).value ).to eq [1,11]
    end
  end

end
