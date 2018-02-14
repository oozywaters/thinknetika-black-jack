require_relative 'hand'

class Player
  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def receive_cards(cards)
    @hand = Hand.new(cards)
  end
end
