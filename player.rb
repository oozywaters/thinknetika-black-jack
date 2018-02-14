require_relative 'hand'

class Player
  attr_reader :name, :hand

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
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
end
