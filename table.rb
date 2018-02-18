require 'forwardable'
require_relative 'deck'
require_relative 'game'

# Table logic
class Table
  extend Forwardable
  def_delegators :@ui, :on_round_start, :on_round_end, :on_showdown, :on_second_turn, :on_game_over

  attr_reader :bank, :round

  BET_SIZE = 10

  def initialize(player, dealer, ui)
    @player = player
    @dealer = dealer
    @game = Game.new(player, dealer, self)
    @round = 0
    @bank = 0
    @ui = ui
  end

  def start_new_round
    @round += 1
    @game.start_new_round
    on_round_start
    # # return on_game_over if over?
    # @round += 1
    # @bank = 0
    # make_bets
    # deal_cards
    # @game.start_new_round(@deck) { on_round_start }
    # # @second_turn = false
    # # @showdown = false
    # # return open_cards if @player.black_jack?
    # # on_round_start
  end

  def hit
    @game.hit
  end

  def stand
    @game.stand
  end

  def open_cards
    @game.open_cards
  end

  def dealer_hand
    return @dealer.hand.cards.map { '* ' }.join unless @game.showdown?
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

  def second_turn?
    @game.second_turn?
  end

  def deal_cards
    @deck = Deck.new
    @player.cards = @deck.deal(2)
    @dealer.cards = @deck.deal(2)
  end

  def deal_card_to_player(player)
    player.take_card(*@deck.deal)
  end

  def make_bets
    @bank += @player.make_bet(BET_SIZE)
    @bank += @dealer.make_bet(BET_SIZE)
  end

  def on_player_won
    @player.take_bank(@bank)
    on_showdown(winner: @player, bank: @bank)
    @bank = 0
  end

  def on_player_lost
    @dealer.take_bank(@bank)
    on_showdown(winner: @dealer, bank: @bank)
    @bank = 0
  end

  def on_draw
    @player.take_bank(BET_SIZE)
    @dealer.take_bank(BET_SIZE)
    on_showdown(winner: nil, bank: @bank)
    @bank = 0
  end

  private

  def end_round
    over? ? on_game_over(winner) : on_round_end
  end

  def over?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end
end
