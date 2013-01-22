require "rack"
require "rufus/scheduler"

# start http server in background thread
server = Rack::Server.new(
  :config => File.expand_path("../config.ru", __FILE__),
  :Port   => ENV["PORT"]
)
server_thread = Thread.new { server.start }

# start scheduler in foreground
scheduler = Rufus::Scheduler.start_new
scheduler.every '1h' do
	`ruby 'bin/snoozer.rb'`
end
scheduler.join

# stop http server
server.stop
server_thread.join
