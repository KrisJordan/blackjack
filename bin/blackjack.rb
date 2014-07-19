#!/usr/bin/env ruby

# Setup bundler
require File.expand_path('../load_paths', __FILE__)

require 'choice'
require 'kris_jordan/blackjack'

Choice.options do
  header ''
  header 'Options:'

  option :chips do
    long    '--chips=CHIPS'
    desc    '# of chips players begin with'
    cast Integer
    default 100
  end

  option :players do
    long    '--players=PLAYERS'
    desc    '# of players'
    cast Integer
    default 1
  end

  option :decks do
    long    '--decks=Decks'
    desc    '# of decks'
    cast Integer
    default 2
  end

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

KrisJordan::Blackjack::Game.play Choice[:players], 
                                 Choice[:chips], 
                                 Choice[:decks]
