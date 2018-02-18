class Game
  def initialize(player, dealer, table)
    @player = player
    @dealer = dealer
    @table = table
  end

  def start_new_round
    @table.deal_cards
    @table.make_bets
    @second_turn = false
    @showdown = false
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
    return open_cards unless @player.can_take_card?
    @second_turn = true
    @table.on_second_turn
  end

  def open_cards
    @showdown = true
    if winner
      winner == @player ? @table.on_player_won : @table.on_player_lost
    else
      @table.on_draw
    end
    @table.on_round_end
    # on_showdown(winner)
    # end_round
  end

  def winner
    @player <=> @dealer
  end

  def showdown?
    @showdown
  end

  def second_turn?
    @second_turn
  end

  private

  def dealer_play
    @table.deal_card_to_player(@dealer) if @dealer.score < 17
  end
end
