# Game Class represents game logic
class Game
  BLACK_JACK = 21
  BET_SIZE = 10
  FACE_VALUE = 10
  ACE_MIN_VALUE = 1
  ACE_MAX_VALUE = 11

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
    deal_card_to_player(@player)
    stand
  end

  def stand
    @dealer.play(self)
    pass_turn_to_player
  end

  def open_cards
    @showdown = true
    winner ? @table.on_player_won(winner) : @table.on_draw
  end

  def deal_card_to_player(player)
    @table.deal_card_to_player(player)
  end

  def player_score
    calculate_score(@player)
  end

  def dealer_score
    calculate_score(@dealer)
  end

  def calculate_score(player)
    calculate_hand_value(player.hand)
  end

  def calculate_hand_value(hand)
    sorted_cards = hand.cards.sort_by { |card| card.ace? ? 1 : 0 }
    sorted_cards.reduce(0) { |sum, card| sum + calculate_card_value(card, sum) }
  end

  def calculate_card_value(card, current_score = 0)
    if card.ace?
      # AJA hand should return 12, not 22
      return -9 if current_score == BLACK_JACK
      return current_score < 11 ? ACE_MAX_VALUE : ACE_MIN_VALUE
    end
    return FACE_VALUE if card.face?
    card.rank.to_i
  end

  def winner
    return if player_score == dealer_score
    if busted?(@player)
      @dealer unless busted?(@dealer)
    elsif busted?(@dealer)
      @player
    else
      player_score > dealer_score ? @player : @dealer
    end
  end

  def showdown?
    @showdown
  end

  def second_turn?
    @second_turn
  end

  def busted?(player)
    calculate_score(player) > BLACK_JACK
  end

  def over?
    @player.bankroll < BET_SIZE || @dealer.bankroll < BET_SIZE
  end

  private

  def pass_turn_to_player
    return if @showdown
    return open_cards unless @player.hand.can_take_card?
    @second_turn = true
    @table.on_second_turn
  end
end
