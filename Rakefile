RSpec::Core::RakeTask.new

task :test => :spec

task :run do
  system 'ruby ./lumber_yard.rb'
end

task :server do
  system 'heroku run --app lumberyard-sinatra irb -I'
end

#When running above, input load './lumber_yard.rb'

task :default => :run
