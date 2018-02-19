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
      action: :close!
    }
  }.freeze

  def initialize(table)
    @table = table
  end

  def title
    "Round ##{@table.round} - Your turn:"
  end

  def items
    return SECOND_TURN_STRUCTURE if @table.second_turn?
    FIRST_TURN_STRUCTURE
  end

  private

  def handle_hit
    close!
    @table.hit
  end

  def handle_stand
    close!
    @table.stand
  end

  def open_cards
    close!
    @table.open_cards
  end
end
