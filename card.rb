# Card Class - represents card and calculates value
class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def face?
    %w[J Q K].include?(@rank)
  end

  def ace?
    @rank == 'A'
  end

  def to_s
    "#{rank}#{suit}"
  end
end
