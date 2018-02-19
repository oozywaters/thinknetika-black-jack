require_relative 'hand'

# Player class
class Player
  attr_reader :name, :hand, :bankroll

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
    @hand.add_card(card)
  end
end
