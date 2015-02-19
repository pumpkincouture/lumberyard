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

module Rack
  module Test
    class Session
      alias_method :old_env_for, :env_for
      def rack_session
        @rack_session ||= {}
      end
      def rack_session=(hash)
        @rack_session = hash
      end
      def env_for(path, env)
        old_env_for(path, env).merge({'rack.session' => rack_session})
      end
    end
  end
end