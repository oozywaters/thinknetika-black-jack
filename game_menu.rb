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
      name: 'Quite Game',
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
    return SECOND_TURN_STRUCTURE if @game.second_turn?
    STRUCTURE
  end

  private

  def render
    if @game.finished?
      handle_showdown
    else
      puts "Your cards: #{@game.player_hand}, score: #{@game.player_score}"
      puts "Dealer cards: #{@game.dealer_hand}"
      super
    end
  end

  def handle_showdown
    show_results
    return exit! unless start_new_game
    puts 'Starting new game...'
    @game.start_new_game
  end

  def show_results
    puts "Your cards: #{@game.player_hand}, score: #{@game.player_score}"
    puts "Dealer cards: #{@game.dealer_hand}, score: #{@game.dealer_score}"
    winner = @game.winner
    puts winner ? "#{winner.name} wins!" : 'DRAW!'
  end

  def start_new_game
    @result = false
    loop do
      puts 'Do you want to continue? [Y/N]'
      choice = gets.chomp
      if choice == 'Y'
        @result = true
        break
      elsif choice == 'N'
        @result = false
        break
      else
        puts 'There is no such option. Please, try again.'
      end
    end
    @result
  end

  def handle_hit
    @game.hit
  end

  def handle_stand
    @game.stand
  end

  def open_cards
    @game.open_cards
  end

  def exit!
    puts 'Come Back Soon!'
    super
  end
end
