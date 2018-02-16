require_relative 'hand'

# Player class
class Player
  attr_reader :name, :hand, :bankroll

  BLACK_JACK = 21

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def make_bet(amount)
    return 0 if amount > bankroll
    @bankroll -= amount
    amount
  end

  def take_bank(amount)
    @bankroll += amount
  end

  def cards=(cards)
    @hand = Hand.new(cards)
  end

  def take_card(card)
    @hand.add_card(card) if can_take_card?
  end

  def score
    @hand&.value || 0
  end

  def can_take_card?
    @hand.cards.size < 3
  end

  def <=>(other)
    return if score == other.score
    if busted?
      other unless other.busted?
    elsif other.busted?
      self
    else
      score > other.score ? self : other
    end
  end

  def busted?
    score > BLACK_JACK
  end

  def black_jack?
    score == BLACK_JACK
  end
end
