require_relative 'player'

# Dealer AI logic
class Dealer < Player
  def initialize(bankroll)
    super('Dealer', bankroll)
  end

  def play(table)
    score = table.dealer_score
    table.deal_card_to_player(self) if score < 17
  end
end
