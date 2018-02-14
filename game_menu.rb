require_relative 'menu'

class GameMenu < Menu
  STRUCTURE = {
    '1' => {
      name: 'Hit',
      action: :handle_hit,
    },
    '2' => {
      name: 'Stand',
      action: :handle_stand,
    },
    '3' => {
      name: 'Open Cards',
      action: :handle_open_cards
    },
    'i' => {
      name: 'Score'
    },
    '0' => {
      name: 'Quit Game',
      action: :exit!
    }
  }.freeze

  def title
    'Your turn:'
  end

  def items
    STRUCTURE
  end

  private

  def handle_hit
    puts 'Hit'
  end

  def handle_stand
    puts 'Stand'
  end

  def handle_open_cards
    puts 'Open Cards'
  end

  def exit!
    puts 'Come Back Soon!'
    super
  end
end
