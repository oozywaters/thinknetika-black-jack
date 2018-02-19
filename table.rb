require 'forwardable'
require_relative 'deck'
require_relative 'game'

# Table logic
class Table
  extend Forwardable
  def_delegators :@ui, :on_round_start, :on_round_end, :on_showdown, :on_second_turn, :on_rebuy

  attr_reader :bank, :round

  BET_SIZE = 10

  def initialize(player, dealer, ui)
    @player = player
    @dealer = dealer
    @game = Game.new(player, dealer)
    @round = 0
    @bank = 0
    @ui = ui
  end

  def start_new_round
    return rebuy(BET_SIZE) if need_rebuy?
    @showdown = false
    @second_turn = false
    @round += 1
    make_bets(BET_SIZE)
    deal_cards
    on_round_start
  end

  def hit
    deal_card_to_player(@player)
    stand
  end

  def stand
    @dealer.play(self)
    pass_turn_to_player
  end

  def open_cards
    @showdown = true
    @game.winner ? on_player_won(@game.winner) : on_draw
  end

  def rebuy(bet_size)
    return on_rebuy(@player, bet_size) if @player.bankroll < bet_size
    on_rebuy(@dealer, bet_size)
  end

  def dealer_hand
    return @dealer.hand.cards.map { '* ' }.join unless @showdown
    @dealer.hand
  end

  def dealer_score
    @game.dealer_score
  end

  def dealer_bankroll
    @dealer.bankroll
  end

  def player_hand
    @player.hand
  end

  def player_score
    @game.player_score
  end

  def player_bankroll
    @player.bankroll
  end

  def second_turn?
    @second_turn
  end

  def deal_cards
    @deck = Deck.new
    @player.cards = @deck.deal(2)
    @dealer.cards = @deck.deal(2)
  end

  def deal_card_to_player(player)
    player.take_card(*@deck.deal)
  end

  def on_player_won(winner)
    winner.take_bank(@bank)
    on_showdown(winner: winner, bank: bank)
  end

  def on_draw
    @player.take_bank(bank / 2)
    @dealer.take_bank(bank / 2)
    on_showdown(winner: nil, bank: bank)
  end

  def need_rebuy?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end

  private

  def make_bets(bet_size)
    @bank = 0
    @bank += @player.make_bet(bet_size)
    @bank += @dealer.make_bet(bet_size)
  end

  def pass_turn_to_player
    return if @showdown
    return open_cards unless @player.hand.can_take_card?
    @second_turn = true
    on_second_turn
  end
end
