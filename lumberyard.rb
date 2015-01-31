require 'sinatra'
require_relative 'lib/lumberlogger.rb'

get '/' do
  @title = "LumberYard"
  erb :home
end

post '/username' do
  @lumberlogger = LumberLogger.new
  if !@lumberlogger.employee_exists?(params["username_name"])
    erb :user_not_found
  elsif admin?(params["username_name"])
    @employee = @lumberlogger.find_employee(params["username_name"])
    erb :admin_form
  else
    @employee = @lumberlogger.find_employee(params["username_name"])
    erb :nonadmin_form
  end
end

private

def admin?(params)
  @lumberlogger.find_employee(params).employee_type == 'admin'
end