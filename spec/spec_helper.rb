require 'data_mapper'
require 'rack/test'
require './lib/employee.rb'
require './lib/client.rb'
require './lib/timesheet.rb'
require './lib/lumberlogger.rb'

require File.expand_path '../../lumberyard.rb', __FILE__
ENV['RACK_ENV'] = 'test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.finalize
Employee.auto_upgrade!
Client.auto_upgrade!
TimeSheet.auto_upgrade!

RSpec.configure do |config|
  config.failure_color = :red
  config.success_color = :green
  config.detail_color = :yellow
  config.tty = true
  config.color = true
  config.formatter = :documentation
end