$:.push File.expand_path("../lib", __FILE__)

require "kris_jordan/blackjack"
require "kris_jordan/blackjack/version"

Gem::Specification.new do |s|
  s.name          = "kris_jordan_blackjack"
  s.version       = KrisJordan::Blackjack::VERSION
  s.authors       = ["Kris Jordan"]
  s.email         = ["krisjordan@gmail.com"]

  s.summary       = "A simple game of blackjack."
  s.description   = "Laying cards around the table."
  s.homepage      = "http://github.com/krisjordan/everett"

  s.files         = Dir.glob "lib/**/*.rb"
  s.require_paths = ["lib"]
end
