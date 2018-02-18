# Hand Class
class Hand
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def value
    @cards.reduce(0) { |sum, card| sum + card.get_value(sum) }
  end

  def add_card(card)
    return unless can_take_card?
    return unless card.is_a?(Card)
    @cards << card if @cards.size < 3
  end

  def to_s
    @cards.map(&:to_s).join
  end

  def can_take_card?
    cards.size < 3
  end
end
