require_relative 'card'

# Deck Class - builds deck and shuffles cards
class Deck
  attr_reader :cards

  SUITS = %w[♦ ♣ ♠ ♥].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize
    @cards = build_deck
  end

  def deal(amount = 1)
    cards.pop(amount)
  end

  private

  def build_deck
    cards = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end
end
