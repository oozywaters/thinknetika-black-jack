require 'forwardable'
require_relative 'deck'
require_relative 'game'

# Table logic
class Table
  extend Forwardable
  def_delegators :@ui, :on_round_start, :on_player_turn, :on_deal_card, :on_showdown, :on_second_turn, :on_rebuy

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
    pass_turn_to_player(@player)
  end

  def hit
    deal_card_to_player(@player)
    stand
  end

  def stand
    @second_turn = true
    pass_turn_to_player(@dealer)
    pass_turn_to_player(@player)
  end

  def open_cards
    @showdown = true
    winner = @game.winner
    winner ? winner.take_bank(@bank) : share_bank
    on_showdown(winner: winner, bank: bank)
  end

  def dealer_hand
    return @dealer.hand.cards.map { '* ' }.join unless @showdown
    @dealer.hand
  end

  def dealer_score
    @game.calculate_player_score(@dealer)
  end

  def dealer_bankroll
    @dealer.bankroll
  end

  def player_hand
    @player.hand
  end

  def player_score
    @game.calculate_player_score(@player)
  end

  def player_bankroll
    @player.bankroll
  end

  def second_turn?
    @second_turn
  end

  def deal_card_to_player(player)
    player.take_card(*@deck.deal)
    on_deal_card(player)
  end

  def need_rebuy?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end

  private

  def deal_cards
    @deck = Deck.new
    @player.cards = @deck.deal(2)
    @dealer.cards = @deck.deal(2)
  end

  def rebuy(bet_size)
    return on_rebuy(@player, bet_size) if @player.bankroll < bet_size
    on_rebuy(@dealer, bet_size)
  end

  def make_bets(bet_size)
    @bank = 0
    @bank += @player.make_bet(bet_size)
    @bank += @dealer.make_bet(bet_size)
  end

  def pass_turn_to_player(player)
    return if @showdown
    return open_cards unless @game.can_hit?(player)
    player == @dealer ? @dealer.play(self) : on_player_turn
  end

  def share_bank
    @player.take_bank(bank / 2)
    @dealer.take_bank(bank / 2)
  end
end
