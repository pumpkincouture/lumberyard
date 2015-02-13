require 'rack/test'
require './lib/employee.rb'
require './lib/client.rb'
require './lib/timesheet.rb'
require './lumber_yard.rb'

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
Employee.auto_upgrade!
Client.auto_upgrade!
Timesheet.auto_upgrade!

ENV['RACK_ENV'] = 'test'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.failure_color = :red
  config.success_color = :green
  config.detail_color = :yellow
  config.tty = true
  config.color = true
  config.formatter = :documentation
  config.include Rack::Test::Methods
  config.order = :rand
end
