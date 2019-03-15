require 'opal'
require 'tretris'
require 'native'

$document = $$[:document]

class App
  def initialize(game)
    @game = game
  end
end

$game = Tretris::Game.new
$app = App.new($game)
