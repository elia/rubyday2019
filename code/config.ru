require 'bundler/setup'
require 'opal'

Opal::Config.arity_check_enabled = true

run Opal::SimpleServer.new { |server|
  server.append_path 'lib'
  server.append_path 'lib-opal'
  server.main = ENV['OPAL_APP'] or raise("Please set OPAL_APP")
}
