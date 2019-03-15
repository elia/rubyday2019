require 'opal'
require 'tretris'
require 'native'
require 'vue.js'

def Vue(options)
  `new Vue(#{options.to_n})`
end

$document = $$[:document]

class App
  def initialize(game)
    @game = game
    @cells = {}
    @colors = {}
  end

  def setup
    $document.querySelector(:body)[:innerHTML] = table_html

    @vue = Vue(
      el: '#app',
      data: {
        message: '',
        cells: Array.new(@game.height) do
          Array.new(@game.width) do
            {color: nil}.to_n
          end
        end
      },
    )

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
      </style>

      <div id="app">
        <h1>TRETRIS</h1>
        <h3>{{message}}</h3>
        <table>
          <tbody>
            <tr v-for="(row, row_index) in this.cells" :key="row_index">
              <td
                v-for="(cell, cell_index) in row"
                :style="{backgroundColor: cell.color}"
                :key="row_index + '-' + cell_index"
              ></td>
            </tr>
          </tbody>
        </table>
      </div>
    HTML
  end

  def start
    @interval = $$.setInterval(-> {
      @game.tick
      render
    }, 600)
  end

  def render
    @vue.JS[:message] = "score: #{@game.points}#{" - GAME OVER" if @game.over?}"

    @game.height.times do |y|
      @game.width.times do |x|
        color = @game.lines[y][x].to_n
        @vue.JS[:cells][y][x].JS[:color] = color
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
