require_relative 'player'
require_relative 'game'
require_relative 'game_menu'

class App
  BANKROLL_AMOUNT = 100

  def initialize
    puts 'Welcome to BlackJack!'
    @game_menu = GameMenu.new(init_game)
  end

  def init_game
    puts 'Enter your name:'
    name = gets.strip.chomp.capitalize
    raise if name.empty?
    player = Player.new(name, BANKROLL_AMOUNT)
    dealer = Player.new('Dealer', BANKROLL_AMOUNT)
    Game.new(player, dealer)
  rescue RuntimeError
    puts 'Name cannot be blank. Please, try again.'
    retry
  end

  def run
    @game_menu.display
  end
end

App.new.run
