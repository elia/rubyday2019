require 'opal'
require 'tretris'
require 'native'

$document = $$[:document]

class App
  def initialize(game)
    @game = game
  end

  def setup
    $document.querySelector(:body)[:innerHTML] = table_html # <<<<<<<<<<<<

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
    <<-HTML
      <style>
      body { font-family: sans-serif; text-align: center;}
      table { margin: auto; border: 1px dotted; }
      td { width: 30px; height: 30px; }
      .filled { background: gray; }
      </style>

      <h1>TRETRIS</h1>
      <br><br>
      <table>
        #{%{<tr>#{"<td></td>" * @game.width}</tr>} * @game.height}
      </table>
    HTML
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
