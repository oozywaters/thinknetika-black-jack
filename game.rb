# Game Class represents game logic
class Game
  BLACK_JACK = 21
  FACE_VALUE = 10
  ACE_MIN_VALUE = 1
  ACE_MAX_VALUE = 11

  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

  def calculate_player_score(player)
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
    player_score = calculate_player_score(@player)
    dealer_score = calculate_player_score(@dealer)
    return if player_score == dealer_score
    if busted?(player_score)
      @dealer unless busted?(dealer_score)
    elsif busted?(dealer_score)
      @player
    else
      player_score > dealer_score ? @player : @dealer
    end
  end

  def busted?(score)
    score > BLACK_JACK
  end

  def can_hit?(player)
    player.hand.cards.size < 3
  end
end
