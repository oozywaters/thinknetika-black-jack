class Hand
  def initialize(cards)
    @cards = cards
  end

  def value
    @cards.reduce(0) { |sum, card| sum + card.get_value(sum) }
  end

  def to_s
    @cards.map(&:to_s).join
  end
end
