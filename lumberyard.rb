require 'sinatra'
require_relative 'lumberyard_helpers.rb'

include LumberYardHelpers

get '/' do
  @title = "LumberYard"
  erb :home
end

get '/username' do
  get_employee(params["username_name"])
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
  @time_sheet = get_timesheet
  @clients = get_all_clients
  choice = params["option"]
  erb get_correct_form(choice)
end

post '/billing' do
  @clients = get_all_clients
  until valid_timesheet?({
    username: params[:username],
    date: params[:date],
    hours: params[:hours],
    project_type: params[:project_type],
    client: params[:client]
    })
    redirect '/billing'
  end
  erb :billing_success
end

post '/add_employee' do
  @clients = get_all_clients
  until valid_employee?({
    first_name: params[:first_name],
    last_name: params[:last_name],
    username: params[:username],
    employee_type: params[:employee_type],
    })
    redirect '/add_employee'
  end
  erb :add_employee_success
end

post '/add_client' do
  until valid_client?({
    name: params[:name],
    type: params[:type]
    })
    redirect '/add_client'
  end
  erb :add_client_success
end
