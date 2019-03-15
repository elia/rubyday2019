$:.unshift "#{__dir__}/../lib"
require 'tretris'
require 'io/console'

term_height, term_width = IO.console.winsize
width = 20
height = 30
padding = ' ' * ((term_width - 1 - width)/2)

game = Tretris::Game.new h: height, w: width / 2

render_line = -> line, raw: false {
  line = line.ljust(width + 2).center(term_width) unless raw
  $stdout.print "#{line}\r\n"
}

render_score = -> score {
  render_line["Points: #{score}"]
}

render_next_shape = -> shape_name {
  render_line["Next: #{shape_name}"]
}

# https://en.wikipedia.org/wiki/Tetris#Tetromino_colors
# https://stackoverflow.com/a/33206814
colors = [
  "\033[36;1m▓\033[0m",
  "\033[34;1m▓\033[0m",
  "\033[33;1m▓\033[0m",
  "\033[35;1m▓\033[0m",
].shuffle
color_map = {}
moves = []

render_grid = -> grid {
  grid.each do |line|
    cells = line.map do |cell|
      char = cell ? (color_map[cell] ||= colors.shift) : ' '
      char * 2
    end.join('')
    render_line["#{padding}|#{cells}|#{padding}", raw: true]
  end
  render_line["#{padding}\\#{'-' * game.width * 2}/#{padding}"]
}

rendering = false
render = -> game {
  next if rendering
  rendering = true
  print "\033[0;0f" # clear the screen
  render_score[game.points]
  render_next_shape[game.next_shape.name]
  render_line['']
  render_grid[game.lines]
  3.times { render_line[''] } # clear some lines after
  rendering = false
}

trap('INT') { exit }

ticker = Thread.new do
  loop do
    sleep 0.6
    game.tick
    render[game]

    if game.over?
      warn " score: #{game.points} - GAME OVER ".center(term_width, "~")
      exit 1
    end
  end
end

mover = Thread.new do
  loop do
    if moves.any?
      moves.each { |move| game.move(move) }
      render[game]
      moves = []
    end
    sleep 0.1
  end
end

while command = $stdin.getch
  # escape seqs have more than a single char
  command << $stdin.getch if command == "\e"
  command << $stdin.getch if command == "\e["
  moves <<
    case command
    when 'a', "\e[D" then :left
    when 'd', "\e[C" then :right
    when 'w', "\e[A" then :up
    when 's', "\e[B" then :down
    when "\u0003" then exit # CTRL+C
    else nil
    end
end
