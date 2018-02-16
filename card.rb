# Card Class - represents card and calculates value
class Card
  attr_reader :rank, :suit

  FACE_VALUE = 10
  ACE_MIN_VALUE = 1
  ACE_MAX_VALUE = 11

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

  def get_value(current_score = 0)
    if ace?
      return current_score < 11 ? ACE_MAX_VALUE : ACE_MIN_VALUE
    end
    return FACE_VALUE if face?
    rank.to_i
  end

  def to_s
    "#{rank}#{suit}"
  end
end
