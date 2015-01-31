require 'sinatra'
require_relative 'lumberyard_helpers.rb'

include LumberYardHelpers

get '/' do
  @title = "LumberYard"
  erb :home
end

post '/username' do
  if !employee_exists?(params["username_name"])
    erb :user_not_found
  elsif admin?(params["username_name"])
    @employee = find_employee(params["username_name"])
    erb :admin_form
  else
    @employee = find_employee(params["username_name"])
    erb :nonadmin_form
  end
end

post '/selection' do
  choice = params["option"]
  erb get_correct_form(choice)
end

