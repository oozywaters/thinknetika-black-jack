require_relative 'player'
require_relative 'dealer'
require_relative 'table'
require_relative 'game_menu'

# Main App Class - manages ui and game
class App
  BANKROLL_AMOUNT = 100

  def initialize
    puts 'Welcome to BlackJack!'
    @table = init_table
    @game_menu = GameMenu.new(@table)
  end

  def run
    @table.start_new_round
  end

  def on_round_start
    puts 'Making bets...'
    puts 'Dealing cards...'
  end

  def on_deal_card(player)
    puts "#{player.name} takes a card..."
  end

  def on_player_turn
    show_info
    GameMenu.new(@table).display
  end

  def on_showdown(winner:, bank:)
    puts '------------------------------------------------'
    puts "| Your cards: #{@table.player_hand}, score: #{@table.player_score}"
    puts "| Dealer cards: #{@table.dealer_hand}, score: #{@table.dealer_score}"
    puts winner ? "| #{winner.name} wins $#{bank}!" : '| DRAW!'
    puts '------------------------------------------------'
    prompt_for_new_round
  end

  def on_rebuy(player, min_bankroll)
    puts "Player #{player.name} has insufficient bankroll ($#{min_bankroll} required). Please, rebuy."
  end

  private

  def init_table
    puts 'Enter your name:'
    name = gets.strip.chomp.capitalize
    raise if name.empty?
    player = Player.new(name, BANKROLL_AMOUNT)
    dealer = Dealer.new(BANKROLL_AMOUNT)
    Table.new(player, dealer, self)
  rescue RuntimeError
    puts 'Name cannot be blank. Please, try again.'
    retry
  end

  def show_info
    puts '------------------------------------------------'
    puts "| Your cards: #{@table.player_hand}, score: #{@table.player_score}, bankroll: $#{@table.player_bankroll}"
    puts "| Dealer cards: #{@table.dealer_hand}, bankroll: $#{@table.dealer_bankroll}"
    puts "| Bank: $#{@table.bank}"
    puts '------------------------------------------------'
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

  def on_quit_game
    puts 'See You Later!'
  end
end

App.new.run
