require_relative 'menu'

# Game menu
class GameMenu < Menu
  FIRST_TURN_STRUCTURE = {
    '1' => {
      name: 'Hit',
      action: :handle_hit
    },
    '2' => {
      name: 'Stand',
      action: :handle_stand
    },
    '3' => {
      name: 'Showdown',
      action: :open_cards
    },
    '0' => {
      name: 'Quit Game',
      action: :exit!
    }
  }.freeze

  SECOND_TURN_STRUCTURE = {
    '1' => {
      name: 'Hit',
      action: :handle_hit
    },
    '2' => {
      name: 'Showdown',
      action: :open_cards
    },
    '0' => {
      name: 'Quit Game',
      action: :exit!
    }
  }.freeze

  def initialize(game)
    @game = game
  end

  def title
    "Round ##{@game.round} - Your turn:"
  end

  def items
    return SECOND_TURN_STRUCTURE if @game.second_turn?
    FIRST_TURN_STRUCTURE
  end

  private

  def handle_hit
    @game.hit
  end

  def handle_stand
    @game.stand
  end

  def open_cards
    @game.open_cards
  end
end
