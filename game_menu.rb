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
      name: 'Showdown',
      action: :handle_showdown
    },
    'i' => {
      name: 'Score'
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
    'Your turn:'
  end

  def items
    STRUCTURE
  end

  private

  def render
    start_new_game if @game.finished?
    puts "Your cards: #{@game.player_hand}, score: #{@game.player_hand.value}"
    puts "Dealer cards: #{@game.dealer_hand}, score: #{@game.dealer_hand.value}"
    super
  end

  def show_results
    puts "Your cards: #{@game.player_hand}, score: #{@game.player_hand.value}"
    puts "Dealer cards: #{@game.dealer_hand}, score: #{@game.dealer_hand.value}"
  end

  def start_new_game
    show_results
    puts 'Starting new game...'
    # @game = Game.new
  end

  def handle_hit
    @game.hit
  end

  def handle_stand
    @game.stand
  end

  def handle_showdown
    @game.showdown
  end

  def exit!
    puts 'Come Back Soon!'
    super
  end
end
