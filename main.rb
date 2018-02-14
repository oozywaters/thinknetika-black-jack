require_relative 'deck'
require_relative 'hand'
require_relative 'game_menu'

class App
  def initialize
    @menu = GameMenu.new
  end

  def run
    @menu.display
  end
end

App.new.run
