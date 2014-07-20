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

Game = KrisJordan::Blackjack::Game
GameJournal = KrisJordan::Blackjack::GameJournal

if GameJournal.in_progress?
  begin
    resume = nil
    until resume != nil
      puts ""
      puts "Game in progress, resume?"
      puts "[Y]es"
      puts "[N]o"
      resume_input = $stdin.gets.chomp.downcase
      case resume_input
      when 'y'
        resume = true
      when 'n'
        resume = false
      end
    end
  rescue Interrupt, NameError
    exit
  end
else
  resume = false
end

if resume
  game = GameJournal.resumed_game
else
  game = Game.new(
    Choice[:players], 
    Choice[:chips],
    Choice[:decks]
  )
end

game.play resume
