require 'forwardable'
require_relative 'deck'
require_relative 'game'

# Table logic
class Table
  extend Forwardable
  def_delegators :@ui, :on_round_start, :on_round_end, :on_showdown, :on_second_turn, :on_rebuy

  attr_reader :bank, :round

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
    @game.start_new_round { on_round_start }
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

  def rebuy(bet_size)
    return on_rebuy(@player, bet_size) if @player.bankroll < bet_size
    on_rebuy(@dealer, bet_size)
  end

  def dealer_hand
    return @dealer.hand.cards.map { '* ' }.join unless @game.showdown?
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
    @game.second_turn?
  end

  def deal_cards
    @deck = Deck.new
    @player.cards = @deck.deal(2)
    @dealer.cards = @deck.deal(2)
  end

  def make_bets(bet_size)
    @bank = 0
    @bank += @player.make_bet(bet_size)
    @bank += @dealer.make_bet(bet_size)
  end

  def deal_card_to_player(player)
    player.take_card(*@deck.deal)
  end

  def on_player_won(winner)
    winner.take_bank(@bank)
    on_showdown(winner: winner, bank: bank)
    @bank = 0
  end

  def on_draw
    @player.take_bank(bank / 2)
    @dealer.take_bank(bank / 2)
    on_showdown(winner: nil, bank: bank)
    @bank = 0
  end
end
