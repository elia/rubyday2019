require 'opal'
require 'tretris'
require 'native'

$document = $$[:document]

class App
  def initialize(game)
    @game = game
  end

  def setup
    # write table_html to the DOM

    $document.addEventListener(:keydown) do |event|
      key = {
        37 => :left,
        39 => :right,
        38 => :up,
        40 => :down,
      }[event.JS[:which]]

      @game.move(key)
      render
    end
  end

  def table_html
    # build the initial HTML
  end

  def start
    @interval = $$.setInterval(-> {
      @game.tick
      render
    }, 600)
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
