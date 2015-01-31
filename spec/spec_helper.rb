require 'data_mapper'
require 'rack/test'
require 'rspec-html-matchers'
require './lib/employee.rb'
require './lib/client.rb'
require './lib/timesheet.rb'
require './lib/lumberlogger.rb'
require './lumberyard_helpers.rb'
require './lumberyard.rb'

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
Employee.auto_upgrade!
Client.auto_upgrade!
TimeSheet.auto_upgrade!

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
end
