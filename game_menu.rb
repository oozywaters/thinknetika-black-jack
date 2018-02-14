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
    start_new_game if @game.showdown?
    puts "Your cards: #{@game.player.hand}, score: #{@game.player.score}"
    puts "Dealer cards: #{@game.dealer.hand}, score: #{@game.dealer.score}"
    super
  end

  def show_results
    puts "Your cards: #{@game.player.hand}, score: #{@game.player.score}"
    puts "Dealer cards: #{@game.dealer.hand}, score: #{@game.dealer.score}"
    winner = @game.winner
    puts winner ? "#{winner.name} wins!" : 'DRAW!'
  end

  def start_new_game
    show_results
    puts 'Starting new game...'
    @game.start_new_game
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
