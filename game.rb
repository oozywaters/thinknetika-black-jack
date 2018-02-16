require 'forwardable'
require_relative 'deck'
require_relative 'hand'

# Game logic
class Game
  extend Forwardable
  def_delegators :@ui, :on_round_start, :on_round_end, :on_showdown, :on_second_turn, :on_game_over

  attr_reader :bank, :round

  BET_SIZE = 10

  def initialize(player, dealer, ui)
    @player = player
    @dealer = dealer
    @round = 0
    @ui = ui
  end

  def start_new_round
    return on_game_over if over?
    @round += 1
    @bank = 0
    make_bets
    deal_cards
    @second_turn = false
    @showdown = false
    on_round_start
  end

  def hit
    return if @showdown
    @player.take_card(*@deck.deal)
    stand
  end

  def stand
    return if @showdown
    dealer_play
    pass_turn_to_player
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

  def open_cards
    @showdown = true
    if winner
      winner.take_bank(@bank)
    else
      @player.take_bank(@bank / 2)
      @dealer.take_bank(@bank / 2)
    end
    on_showdown(winner)
    end_round
  end

  def second_turn?
    @second_turn
  end

  private

  def deal_cards
    @deck = Deck.new
    @player.cards = @deck.deal(2)
    @dealer.cards = @deck.deal(2)
  end

  def make_bets
    @bank += @player.make_bet(BET_SIZE)
    @bank += @dealer.make_bet(BET_SIZE)
  end

  def pass_turn_to_player
    return if @showdown
    return open_cards if !@player.can_take_card? || second_turn?
    @second_turn = true
    on_second_turn
  end

  def winner
    @player <=> @dealer
  end

  def end_round
    over? ? on_game_over(winner) : on_round_end
  end

  def showdown?
    @showdown
  end

  def over?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end

  alias finished? showdown?
end
