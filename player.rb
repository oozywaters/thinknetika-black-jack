require_relative 'hand'

class Player
  attr_reader :name, :hand, :bankroll

  BLACK_JACK = 21

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def make_bet(amount)
    if bankroll > amount
      @bankroll -= amount
      amount
    end
  end

  def take_bank(amount)
    @bankroll += amount
  end

  def receive_cards(cards)
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
    else
      score > other.score ? self : other
    end
  end

  def busted?
    score > BLACK_JACK
  end
end
