require 'sinatra'
require_relative 'lib/client.rb'
require_relative 'lib/employee.rb'
require_relative 'lib/timesheet.rb'

include LumberYard

DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/time_logger.db")

LumberYard::Client.new
LumberYard::Employee.new
LumberYard::Timesheet.new

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @title = "LumberYard"
  erb :home
end

post '/username' do
  if !LumberYard::Employee.new.employee_exists?(params["username_name"])
    erb :user_not_found
  elsif LumberYard::Employee.new.admin?(params["username_name"])
    @employee = LumberYard::Employee.new.get_employee(params["username_name"])
    erb :admin_form
  else
    @employee = LumberYard::Employee.new.get_employee(params["username_name"])
    erb :nonadmin_form
  end
end

post '/selection' do
  @time_sheet = LumberYard::Timesheet.new.get_timesheet
  @clients = LumberYard::Client.new.get_all_clients
  choice = params["option"]
  erb get_correct_form(choice)
end

get '/billing_failure' do
  @clients = LumberYard::Client.new.get_all_clients
  erb :billing_failure
end

post '/billing' do
  @clients = LumberYard::Client.new.get_all_clients
  until LumberYard::Timesheet.new.create_timesheet({
    username: params[:username],
    date: params[:date],
    hours: params[:hours],
    project_type: params[:project_type],
    client: params[:client]
    }).valid?
    redirect '/billing_failure'
  end
  erb :billing_success
end

get '/add_employee_failure' do
  @clients = LumberYard::Client.new.get_all_clients
  erb :add_employee_failure
end

post '/add_employee' do
  @clients = LumberYard::Client.new.get_all_clients
  until LumberYard::Employee.new.create_employee({
    first_name: params[:first_name],
    last_name: params[:last_name],
    username: params[:username],
    employee_type: params[:employee_type],
    }).valid?
    redirect '/add_employee_failure'
  end
  erb :add_employee_success
end

get '/add_client_failure' do
  erb :add_client_failure
end

post '/add_client' do
  until LumberYard::Client.new.create_client({
    name: params[:name],
    type: params[:type]
    }).valid?
    redirect '/add_client_failure'
  end
  erb :add_client_success
end

private

def get_correct_form(choice)
    forms = ["log_time", "time_report", "add_employee", "add_client", "employee_report"]
    forms[choice.to_i - 1].to_sym
end
