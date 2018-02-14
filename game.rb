require_relative 'deck'
require_relative 'hand'

class Game
  attr_reader :player, :dealer

  BLACK_JACK = 21

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @showdown = false
    start_new_game
  end

  def start_new_game
    @deck = Deck.new
    @player.receive_cards(@deck.deal(2))
    @dealer.receive_cards(@deck.deal(2))
    @second_turn = false
  end

  def hit
    return if @showdown
    @player.take_card(*@deck.deal)
    stand
  end

  def stand
    return if @showdown
    # Dealer's logic
    dealer_play
    showdown if !@player.can_take_card? && @second_turn
    @second_turn = true
  end

  def dealer_play
    @dealer.take_card(*@deck.deal) if @dealer.score < 17
  end

  def showdown
    @showdown = true
  end

  def winner
    return unless showdown?
    return if draw?
    if @player.score == BLACK_JACK
      @player
    elsif @player.score > @dealer.score
      @player
    else
      @dealer
    end
  end

  def draw?
    (@player.score > BLACK_JACK && @dealer.score > BLACK_JACK) || (@player.score == @dealer.score)
  end

  def showdown?
    @showdown
  end
end
