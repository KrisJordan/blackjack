require 'spec_helper'

Hand = KrisJordan::Blackjack::Hand
Card = KrisJordan::Blackjack::Card

describe Hand do

  describe ".new" do
    it "should instantiate with no arguments" do
      hand = Hand.new
      expect( hand.length ).to eq 0
    end

    it "should instantiate with a card" do
      hand = Hand.new( Card.new(:ace,:club) )
      expect( hand.length ).to eq 1
    end
    
    it "should instantiate with multiple cards" do
      hand = Hand.new( Card.new(:ace,:club), Card.new(:ace,:spade) )
      expect( hand.length ).to eq 2
    end
  end

  describe "#possible_values" do
    it "should sum non-face cards" do
      hand = Hand.new( Card.new(2,:club), Card.new(2,:club) )
      expect(hand.possible_values).to eq [4]
    end

    it "should sum face cards" do
      hand = Hand.new( Card.new(:jack,:club), Card.new(:jack,:club) )
      expect(hand.possible_values).to eq [20]
    end

    it "should sum up to 21" do
      hand = Hand.new(
        Card.new(:jack,:club),
        Card.new(9,:club),
        Card.new(2,:club)
      )
      expect(hand.possible_values).to eq [21]
    end

    it "should filter everything over 21" do
      hand = Hand.new(
        Card.new(:jack,:club),
        Card.new(9,:club),
        Card.new(3,:club)
      )
      expect(hand.possible_values).to eq []
    end

    it "should permute aces" do
      hand = Hand.new(
        Card.new(:ace, :club),
        Card.new(2,    :club)
      )
      expect(hand.possible_values).to eq [3,13]
    end

    it "should permute double aces" do
      hand = Hand.new(
        Card.new(:ace, :club),
        Card.new(:ace, :spade)
      )
      expect(hand.possible_values).to eq [2,12]
    end

    it "should permute triple aces" do
      hand = Hand.new(
        Card.new(:ace, :club),
        Card.new(:ace, :spade),
        Card.new(:ace, :diamond)
      )
      expect(hand.possible_values).to eq [3,13]
    end
  end

  describe "#value" do
    it "should sum non-face cards" do
      hand = Hand.new( Card.new(2,:club), Card.new(2,:club) )
      expect(hand.value).to eq 4
    end

    it "should select the highest possible value when there is an ace" do
      hand = Hand.new( Card.new(2,:club), Card.new(:ace,:club) )
      expect(hand.value).to eq 13
    end

    it "should select the highest possible value when there are two aces" do
      hand = Hand.new(
        Card.new(:ace,  :club),
        Card.new(:ace,  :spade),
        Card.new(10,    :club),
        Card.new(9,     :club)
      )
      expect(hand.value).to eq 21
    end

    it "should be zero on a bust" do
      hand = Hand.new(
        Card.new(:jack,:club),
        Card.new(9,:club),
        Card.new(3,:club)
      )
      expect(hand.value).to eq 0
    end
  end

  describe "#blackjack?" do
    it "should be false under" do
      hand = Hand.new( Card.new(2,:club), Card.new(2,:club) )
      expect(hand.blackjack?).to eq false
    end

    it "should be false over" do
      hand = Hand.new( 
        Card.new(:jack,:club),
        Card.new(9,:club),
        Card.new(3,:club)
      )
      expect(hand.blackjack?).to eq false
    end

    it "should be false when 21 with more than two cards" do
      hand = Hand.new(
        Card.new(:ace,  :club),
        Card.new(:ace,  :spade),
        Card.new(10,    :club),
        Card.new(9,     :club)
      )
      expect(hand.blackjack?).to eq false
    end

    it "should be true with an ace and a face" do
      hand = Hand.new( Card.new(:ace,:club), Card.new(:king,:club) )
      expect(hand.blackjack?).to eq true
    end
  end

  describe "#split?" do
    it "should be false with two cards of matching value" do
      expect(Hand.new( Card.new(2,:club), Card.new(3,:club) ).split?).to eq false
    end

    it "should be false with more than two matching cards" do
      expect(Hand.new(
        Card.new(2,:club),
        Card.new(2,:club),
        Card.new(2,:club)
      ).split?).to eq false
    end

    it "should be true with two cards of matching value" do
      expect(Hand.new( Card.new(2,:club), Card.new(2,:spade) ).split?)
        .to eq true
    end

    it "should be true with two face cards that match" do
      expect(Hand.new( Card.new(:queen,:club), Card.new(:king,:spade) ).split?)
        .to eq true
    end

    it "should be true with two aces" do
      expect(Hand.new( Card.new(:ace,:club), Card.new(:ace,:spade) ).split?)
        .to eq true
    end

    it "should be true with a face card and a 10" do
      expect(Hand.new( Card.new(10,:club), Card.new(:jack,:heart) ).split?)
        .to eq true
    end
  end

end
