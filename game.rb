# Game Class represents game logic
class Game
  BET_SIZE = 10

  def initialize(player, dealer, table)
    @player = player
    @dealer = dealer
    @table = table
  end

  def start_new_round
    return @table.rebuy(BET_SIZE) if over?
    @table.make_bets(BET_SIZE)
    @table.deal_cards
    @second_turn = false
    @showdown = false
    yield
  end

  def hit
    @table.deal_card_to_player(@player)
    stand
  end

  def stand
    dealer_play
    pass_turn_to_player
  end

  def pass_turn_to_player
    return if @showdown
    return open_cards unless @player.hand.can_take_card?
    @second_turn = true
    @table.on_second_turn
  end

  def open_cards
    @showdown = true
    winner ? @table.on_player_won(winner) : @table.on_draw
  end

  def winner
    return if @player.score == @dealer.score
    if @player.busted?
      @dealer unless @dealer.busted?
    elsif @dealer.busted?
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

  def over?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end

  private

  def dealer_play
    @table.deal_card_to_player(@dealer) if @dealer.score < 17
  end
end
