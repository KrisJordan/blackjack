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

  option :verbose do
    long '--verbose'
    desc 'Resume game and print all events'
  end

  option :help do
    long '--help'
    desc 'Show this message'
  end
end

Game = KrisJordan::Blackjack::Game
GameJournal = KrisJordan::Blackjack::GameJournal
def main
  if GameJournal.in_progress?
    resume = nil

    # Verbose mode always resumes, if possible
    if Choice[:verbose]
      resume = true
    end

    begin
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
    puts Choice[:verbose]
    game = GameJournal.resumed_game Choice[:verbose]
  else
    game = Game.new(
      Choice[:chips],
      Choice[:players], 
      Choice[:decks]
    )
    GameJournal.begin(game)
  end

  game.play
end

main
