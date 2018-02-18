require_relative 'player'

# Dealer AI logic
class Dealer < Player
  def initialize(bankroll)
    super('Dealer', bankroll)
  end

  def play(game)
    score = game.calculate_hand_value(hand)
    game.deal_card_to_player(self) if score < 17
  end
end
