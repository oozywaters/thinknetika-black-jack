require_relative 'deck'
require_relative 'hand'

class App
  def run
    # print 'Hello! Please, Enter Your Name: '
    # @username = gets.chomp
    deck = Deck.new
    player_hand = Hand.new(deck.deal(3))
    puts player_hand.to_s
    puts player_hand.value
  end

  private

  def start_game
    puts "Player's cards: "
  end

  def display_cards(cards)
    cards.each { |card| print card.to_s }
    puts ''
  end
end

App.new.run
