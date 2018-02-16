require_relative 'player'
require_relative 'game'
require_relative 'game_menu'

# Main App Class - manages ui and game
class App
  BANKROLL_AMOUNT = 100

  def initialize
    puts 'Welcome to BlackJack!'
    @game = init_game
    @game_menu = GameMenu.new(@game)
  end

  def run
    @game.start_new_round
  end

  private

  def init_game
    puts 'Enter your name:'
    name = gets.strip.chomp.capitalize
    raise if name.empty?
    player = Player.new(name, BANKROLL_AMOUNT)
    dealer = Player.new('Dealer', BANKROLL_AMOUNT)
    Game.new(player, dealer, self)
  rescue RuntimeError
    puts 'Name cannot be blank. Please, try again.'
    retry
  end

  def show_info
    puts '------------------------------------------------'
    puts "| Your cards: #{@game.player_hand}, score: #{@game.player_score}, bankroll: $#{@game.player_bankroll}"
    puts "| Dealer cards: #{@game.dealer_hand}, bankroll: $#{@game.dealer_bankroll}"
    puts "| Bank: $#{@game.bank}"
    puts '------------------------------------------------'
  end

  def on_round_start
    puts 'Dealing cards...'
    show_info
    @game_menu.display
  end

  def on_round_end
    prompt_for_new_round
  end

  def on_showdown(winner)
    puts '------------------------------------------------'
    puts "| Your cards: #{@game.player_hand}, score: #{@game.player_score}"
    puts "| Dealer cards: #{@game.dealer_hand}, score: #{@game.dealer_score}"
    puts winner ? "| #{winner.name} wins $#{@game.bank}!" : '| DRAW!'
    puts '------------------------------------------------'
  end

  def on_second_turn
    show_info
  end

  def on_quit_game
    @game_menu.close!
    puts 'See You Later!'
  end

  def on_game_over(winner)
    @game_menu.close!
    puts 'GAME OVER'
    puts "#{winner.name} won all the money!"
  end

  def prompt_for_new_round
    loop do
      puts 'Do you want to continue? [Y/N]'
      choice = gets.chomp
      if choice == 'Y'
        run
        break
      elsif choice == 'N'
        on_quit_game
        break
      else
        puts 'There is no such option. Please, try again.'
      end
    end
  end
end

App.new.run
