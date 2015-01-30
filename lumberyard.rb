require 'sinatra'
require_relative 'lib/lumberlogger.rb'

get '/' do
  @title = "LumberYard"
  erb :home
end

post '/username' do
  @lumberlogger = LumberLogger.new
  if @lumberlogger.find_employee(params["username_name"]) == false
    erb :user_not_found
  else
    erb :success
  end
end