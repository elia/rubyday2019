require 'opal'
require 'tretris'
require 'native'

$document = $$[:document]

class App
  def initialize(game)
    @game = game
    @cells = {}
    @colors = {}
  end

  def setup
    $document.querySelector(:body)[:innerHTML] = table_html

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
      <h3></h3>
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
    $document.querySelector(:h3).innerText =
      "score: #{@game.points}#{" - GAME OVER" if @game.over?}"

    @game.height.times do |y|
      @game.width.times do |x|
        color = @game.lines[y][x]

        @cells[[x,y]] ||= $document.querySelector(
          "tr:nth-child(#{y+1}) td:nth-child(#{x+1})"
        )

        if color
          @cells[[x,y]].classList.add(color)
          @colors[[x,y]] = color
        else
          @cells[[x,y]].classList.remove(@colors[[x,y]])
          @colors[[x,y]] = nil
        end
      end
    end
  end
end

$game = Tretris::Game.new
$app = App.new($game)

$document.addEventListener(:DOMContentLoaded) do
  $app.setup
  $app.start
end
