require 'spec_helper'

Hand   = KrisJordan::Blackjack::Hand
Card   = KrisJordan::Blackjack::Card
Player = KrisJordan::Blackjack::Player

describe Hand do

  before do
    @an_empty_hand   = Hand.new

    # pairs
    @a_pair_of_2s   = Hand.new([Card.new(2,:club), Card.new(2,:spade)])
    @a_pair_of_10s  = Hand.new([Card.new(10,:club), Card.new(10,:spade)])
    @a_pair_of_aces = Hand.new([Card.new(:ace,:heart), Card.new(:ace,:diamond)])
    @triple_aces  = Hand.new([
      Card.new(:ace,:heart),
      Card.new(:ace,:diamond),
      Card.new(:ace,:spade)])

    # 2 cards, different values
    @a_2_and_a_3   = Hand.new([Card.new(2,:club), Card.new(3,:spade)])
    @a_king_and_a_queen = Hand.new([
      Card.new(:king,:club),
      Card.new(:queen,:club)])
    @a_king_and_a_10 = Hand.new([Card.new(:king,:club), Card.new(10,:club)])
    @an_ace_and_a_2   = Hand.new([Card.new(:ace,:heart), Card.new(2,:diamond)])

    @blackjack = Hand.new([Card.new(10,:club), Card.new(:ace,:club)])
    @twentyone = Hand.new([
      Card.new(:jack,:club),
      Card.new(9,:club),
      Card.new(2,:club)
    ])

    @bust      = Hand.new([
      Card.new(:jack,:club),
      Card.new(9,:club),
      Card.new(3,:club)
    ])

  end

  describe ".new" do
    it "should instantiate with no arguments" do
      expect( @an_empty_hand.length ).to eq 0
    end

    it "should instantiate with cards" do
      expect( @a_pair_of_2s.length ).to eq 2
    end
  end

  describe "#dealt" do
    before :each do
      @start_hand  = @an_empty_hand
      @new_hand    = @start_hand.dealt Card.new :jack, :heart
    end

    it "should return a new instance" do
      expect(@new_hand.object_id).to_not eq @start_hand.object_id
    end

    it "should add a card to the new instance" do
      expect(@new_hand.length).to eq 1
    end
  end

  describe "#bet" do
    before :each do
      @start_hand  = @an_empty_hand
      @new_hand    = @start_hand.bet 1
    end

    it "should return a new instance" do
      expect(@new_hand.object_id).to_not eq @start_hand.object_id
    end

    it "should add a chip to the new instance" do
      expect(@new_hand.chips).to eq 1
    end
  end

  describe "#possible_values" do
    it "should sum non-face cards" do
      expect(@a_pair_of_2s.possible_values).to eq [4]
    end

    it "should sum face cards" do
      expect(@a_king_and_a_queen.possible_values).to eq [20]
    end

    it "should sum up to 21" do
      expect(@twentyone.possible_values).to eq [21]
    end

    it "should filter everything over 21" do
      expect(@bust.possible_values).to eq []
    end

    it "should permute aces" do
      expect(@an_ace_and_a_2.possible_values).to eq [3,13]
    end

    it "should permute double aces" do
      expect(@a_pair_of_aces.possible_values).to eq [2,12]
    end

    it "should permute triple aces" do
      expect(@triple_aces.possible_values).to eq [3,13]
    end
  end

  describe "#value" do
    it "should sum non-face cards" do
      expect(@a_pair_of_2s.value).to eq 4
    end

    it "should select the highest possible value when there is an ace" do
      expect(@an_ace_and_a_2.value).to eq 13
    end

    it "should select the highest possible value when there are two aces" do
      expect(@triple_aces.value).to eq 13
    end

    it "should be zero on a bust" do
      expect(@bust.value).to eq 0
    end
  end

  describe "#<=>" do
    it "should return -1 for lesser hands" do
      expect( @a_pair_of_2s <=> @a_2_and_a_3 ).to eq -1
    end

    it "should return 0 for equivalent hands" do
      expect( @a_pair_of_10s <=> @a_king_and_a_10 ).to eq 0
    end

    it "should return 1 for greater hands" do
      expect( @blackjack <=> @a_pair_of_10s ).to eq 1
    end

    it "should return -1 for busts" do
      expect( @bust <=> @a_pair_of_2s ).to eq -1
    end
  end

  describe "#bust?" do
    it "should be false without any cards" do
      expect(@an_empty_hand.bust?).to eq false
    end

    it "should be false under 21" do
      expect(@a_pair_of_10s.bust?).to eq false
    end

    it "should be false at 21" do
      expect(@blackjack.bust?).to eq false
    end

    it "should be true above 21" do
      expect(@bust.bust?).to eq true
    end
  end

  describe "#blackjack?" do
    it "should be false under 21" do
      expect(@a_pair_of_2s.blackjack?).to eq false
    end

    it "should be false over 21" do
      expect(@bust.blackjack?).to eq false
    end

    it "should be false when 21 with more than two cards" do
      expect(@twentyone.blackjack?).to eq false
    end

    it "should be true with an ace and a face" do
      expect(@blackjack.blackjack?).to eq true
    end
  end

  describe "#can_hit?" do
    it "should be false with blackjack" do
      expect(@blackjack.can_hit?)
        .to eq false
    end
    
    it "should be true with two cards that do not equal 21" do
      expect(@a_pair_of_10s.can_hit?)
        .to eq true
    end
  end

  describe "#can_split?" do
    before :each do
      @rich_player = Player.new :foo, 10
      @poor_player = Player.new :foo, 0
    end

    it "should be false with two cards of matching value" do
      expect(@a_2_and_a_3.can_split? @rich_player).to eq false
    end

    it "should be false with more than two matching cards" do
      expect(@triple_aces.can_split? @rich_player).to eq false
    end

    it "should be true with two cards of matching value" do
      expect(@a_pair_of_2s.can_split? @rich_player).to eq true
    end

    it "should be true with two face cards that match" do
      expect(@a_king_and_a_queen.can_split? @rich_player).to eq true
    end

    it "should be true with two aces" do
      expect(@a_pair_of_aces.can_split? @rich_player).to eq true
    end

    it "should be true with a face card and a 10" do
      expect(@a_king_and_a_10.can_split? @rich_player).to eq true
    end

    it "should be false for a player without chips" do
      expect(@a_pair_of_2s.bet(1).can_split? @poor_player).to eq false
    end
  end

end
