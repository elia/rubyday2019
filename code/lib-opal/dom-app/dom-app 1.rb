require 'opal'
require 'tretris'
require 'native'

$document = $$[:document]

class App
  def initialize(game)
    @game = game
  end

  def setup
    # setup DOM events
  end

  def start
    # start main loop with setInterval
  end

  def render
    # update the DOM
  end
end

$game = Tretris::Game.new
$app = App.new($game)

$document.addEventListener(:DOMContentLoaded) do
  $app.setup
  $app.start
end
