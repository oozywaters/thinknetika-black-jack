require_relative 'deck'
require_relative 'hand'

class Game
  attr_reader :bank

  BLACK_JACK = 21
  BET_SIZE = 10

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
    @bank = 0
    @showdown = false
    start_new_game
  end

  def start_new_game
    @deck = Deck.new
    @bank = 0
    @winner = nil
    @bank += @player.make_bet(BET_SIZE)
    @bank += @dealer.make_bet(BET_SIZE)
    @player.receive_cards(@deck.deal(2))
    @dealer.receive_cards(@deck.deal(2))
    @second_turn = false
    @showdown = false
  end

  def hit
    return if @showdown
    @player.take_card(*@deck.deal)
    stand
  end

  def stand
    return if @showdown
    dealer_play
    second_turn
  end

  def dealer_play
    @dealer.take_card(*@deck.deal) if @dealer.score < 17
  end

  def dealer_hand
    return @dealer.hand.cards.map { '* ' }.join unless @showdown
    @dealer.hand
  end

  def dealer_score
    @dealer.score
  end

  def dealer_bankroll
    @dealer.bankroll
  end

  def player_hand
    @player.hand
  end

  def player_score
    @player.score
  end

  def player_bankroll
    @player.bankroll
  end

  def second_turn
    return if @showdown
    return open_cards if !@player.can_take_card? || second_turn?
    @second_turn = true
  end

  def open_cards
    @showdown = true
    if winner
      winner.take_bank(@bank)
    else
      @player.take_bank(@bank / 2)
      @dealer.take_bank(@bank / 2)
    end
  end

  def winner
    return unless showdown?
    @winner ||=
      if @player.score > BLACK_JACK
        @dealer if @dealer.score <= BLACK_JACK
      elsif @player.score == BLACK_JACK
        @player if @dealer.score != BLACK_JACK
      elsif @dealer.score > BLACK_JACK
        @player
      else
        @player.score > @dealer.score ? @player : @dealer
      end
  end

  def showdown?
    @showdown
  end

  def second_turn?
    @second_turn
  end

  alias finished? showdown?
end
