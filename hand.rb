# Hand Class
class Hand
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def add_card(card)
    return unless card.is_a?(Card)
    @cards << card if can_take_card?
  end

  def to_s
    @cards.map(&:to_s).join
  end

  def can_take_card?
    cards.size < 3
  end
end
