require_relative 'deck'
require_relative 'hand'
require_relative 'game_menu'

class App
  def initialize
    @menu = GameMenu.new
  end

  def run
    # print 'Hello! Please, Enter Your Name: '
    # @username = gets.chomp
    deck = Deck.new
    player_hand = Hand.new(deck.deal(3))
    puts player_hand.to_s
    puts player_hand.value
    @menu.display
  end
end

App.new.run
