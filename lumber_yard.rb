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
  @message = "Please enter your username to get started"
  erb :home
end

get '/timesheets/new' do
  @clients = LumberYard::Client.new.get_all_clients
  erb :'timesheets/new'
end

get '/report/new' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.get_timesheet
  erb :'report/new'
end

get '/all_employee_report/new' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.get_timesheet
  erb :'all_employee_report/new'
end

get '/client/new' do
  erb :'client/new'
end

get '/employee/new' do
  erb :'employee/new'
end

post '/username/validate' do
  if !LumberYard::Employee.new.employee_exists?(params["username_name"])
    @message = ModelCitizen::Messages.new.get_message(:invalid_username)
    erb :home
  else
    @message = "Please select what you'd like to do"
    @employee = LumberYard::Employee.new.get_employee(params["username_name"])
    erb :index
  end
end

post '/timesheets/create' do
  @clients = LumberYard::Client.new.get_all_clients
  if !LumberYard::Timesheet.new.create_timesheet({
    username: params[:username],
    date: params[:date],
    hours: params[:hours],
    project_type: params[:project_type],
    client: params[:client]
    }).valid?
    @options = ModelCitizen::Messages.new
    @success = false
    @message = ModelCitizen::Messages.new.get_message(:invalid_timesheet)
    erb :'timesheets/form'
  else
    @options = ModelCitizen::Messages.new
    @success = true
    @message = ModelCitizen::Messages.new.get_message(:timesheet_success)
    erb :'timesheets/form'
  end
end

post '/employees/create' do
  @clients = LumberYard::Client.new.get_all_clients
  if !LumberYard::Employee.new.create_employee({
    first_name: params[:first_name],
    last_name: params[:last_name],
    username: params[:username],
    employee_type: params[:employee_type],
    }).valid?
    @options = ModelCitizen::Messages.new
    @success = false
    @message = ModelCitizen::Messages.new.get_message(:invalid_employee)
    erb :'employee/form'
  else
    @options = ModelCitizen::Messages.new
    @success = true
    @message = ModelCitizen::Messages.new.get_message(:employee_success)
    erb :'employee/form'
  end
end

post '/clients/create' do
  if !LumberYard::Client.new.create_client({
    name: params[:name],
    type: params[:type]
    }).valid?
    @options = ModelCitizen::Messages.new
    @success = false
    @message = ModelCitizen::Messages.new.get_message(:invalid_client)
    erb :'client/form'
  else
    @options = ModelCitizen::Messages.new
    @success = true
    @message = ModelCitizen::Messages.new.get_message(:client_success)
    erb :'client/form'
  end
end