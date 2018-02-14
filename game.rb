require_relative 'deck'
require_relative 'hand'

class Game
  attr_reader :player_hand, :dealer_hand

  def initialize(player, dealer)
    @deck = Deck.new
    @player_hand = Hand.new(@deck.deal(2))
    @dealer_hand = Hand.new(@deck.deal(2))
    @showdown = false
  end

  def hit
    return if @showdown
    @player_hand.take_card(*@deck.deal)
    stand
  end

  def stand
    return if @showdown
    # Dealer's logic
    if @dealer_hand.value < 17
      @dealer_hand.take_card(*@deck.deal)
    elsif @dealer_hand.value >= 17
      showdown
    end
  end

  def showdown
    @showdown = true
  end

  def finished?
    @showdown
  end
end
