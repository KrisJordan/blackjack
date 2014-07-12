require 'kris_jordan'

require 'kris_jordan/blackjack/card'
require 'kris_jordan/blackjack/hand'
require 'kris_jordan/blackjack/deck'

module KrisJordan
  module Blackjack
    def self.version_string
      "KrisJordan's Blackjack version #{KrisJordan::Blackjack::VERSION}"
    end
  end
end
