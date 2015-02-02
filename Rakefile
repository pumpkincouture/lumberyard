task :run do
  system 'ruby ./lumberyard.rb'
end

task :server do
  system 'heroku run --app lumberyard-sinatra irb -I'
end

#When running above, input load './lumberyard.rb'

task :default => :run
