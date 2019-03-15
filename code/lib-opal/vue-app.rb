require 'opal'
require 'vue.js'
require 'tretris'
require 'native'

$document = $$[:document]

def Vue(options)
  `new Vue(#{options.to_n})`
end

$document.addEventListener(:DOMContentLoaded) do
  $document.querySelector(:body)[:innerHTML] = <<-HTML
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
          <td v-for="(cell, cell_index) in row" :style="{backgroundColor: cell.color}" :key="row_index + '-' + cell_index"></td>
        </tr>
      </tbody>
    </table>
  </div>
  HTML

  game = Tretris::Game.new
  app = Vue(
    el: '#app',
    data: {
      message: '',
      cells: Array.new(game.height) do
        Array.new(game.width) do
          {color: nil}.to_n
        end
      end
    },
  )

  render = -> {
    app.JS[:message] = "score: #{game.points}"
    app.JS[:message] = app.JS[:message] + " - GAME OVER" if game.over?

    game.height.times do |y|
      game.width.times do |x|
        color = game.lines[y][x].to_n
        app.JS[:cells][y][x].JS[:color] = color
      end
    end
  }

  $document.addEventListener(:keydown) do |event|
    key = {
      37 => :left,
      39 => :right,
      38 => :up,
      40 => :down,
    }[event.JS[:which]]

    game.move(key)
    render[]
  end

  @interval = $$.setInterval(-> {
    game.tick
    render[]

    $$.clearInterval(@interval) if game.over?
  }, 600)

  render[]

  $game = game
  $app = app
end
