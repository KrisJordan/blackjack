require 'kris_jordan'

require 'kris_jordan/blackjack/card'
require 'kris_jordan/blackjack/hand'
require 'kris_jordan/blackjack/deck'
require 'kris_jordan/blackjack/dealer'
require 'kris_jordan/blackjack/player'
require 'kris_jordan/blackjack/state'
require 'kris_jordan/blackjack/round'
require 'kris_jordan/blackjack/game'

module KrisJordan
  module Blackjack
    def self.version_string
      "KrisJordan's Blackjack version #{KrisJordan::Blackjack::VERSION}"
    end
  end
end
