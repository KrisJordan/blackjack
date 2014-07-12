require "spec_helper"

Deck = KrisJordan::Blackjack::Deck
Card = KrisJordan::Blackjack::Card

describe Deck do
  describe ".new" do
    context "without arguments" do
      before :each do
        @deck = Deck.new
      end

      it "should create a full deck" do
        expect( @deck.cards.length ).to eq 52
      end

      it "should create unique cards" do
        expect( @deck.cards.uniq.length ).to eq 52
      end
    end

    context "with cards" do
      it "should initialize a deck with cards argument" do
        expect( Deck.new([Card.new(:ace, :heart)]).cards.length ).to eq 1
      end
    end
  end

  describe "#random_card" do
    before :each do
      @deck = Deck.new
    end
    it "should return a card in the deck" do
      100.times do
        expect( @deck.cards.include?(@deck.random_card) ).to eq true
      end
    end
  end

  describe "#take" do
    before :each do
      @deck = Deck.new
      @twos = Deck.new [Card.new(2,:club), Card.new(2,:club)]
    end

    it "should take a card out of the deck" do
      expect( @deck.take(@deck.cards.first).cards.length ).to eq 51
    end

    it "should take only one equivalent cards out of the deck" do
      expect( @twos.take(@twos.cards.first).cards.length ).to eq 1
    end

    it "should raise when card does not exist in deck" do
      expect{ @twos.take(Card.new(3,:club)) }.to raise_error
    end
  end

  describe "#+" do
    it "should combine two decks" do
      expect( (Deck.new + Deck.new).cards.length ).to eq 104
    end

    it "should return a new deck" do
      decks = [ Deck.new, Deck.new ]
      new_deck = decks[0] + decks[1]
      decks.each do |deck|
        expect(new_deck.object_id).to_not eq deck.object_id
      end
    end
  end
end
