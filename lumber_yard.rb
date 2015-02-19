require 'sinatra'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

require_relative 'lib/client.rb'
require_relative 'lib/employee.rb'
require_relative 'lib/timesheet.rb'

include LumberYard

enable :sessions
use Rack::Flash

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

get '/timesheets/new' do
  @clients = LumberYard::Client.new.get_all_clients
  erb :'timesheets/new'
end

get '/report/show' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.get_timesheet
  erb :'report/show'
end

get '/all_employee_report/show' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.get_timesheet
  erb :'all_employee_report/show'
end

get '/client/new' do
  erb :'client/new'
end

get '/employee/new' do
  erb :'employee/new'
end

get '/home/index' do
  erb :index
end

post '/username/validate' do
  if !LumberYard::Employee.new.employee_exists?(params["username_name"])
    flash[:username_error] = ModelCitizen::Messages.new.get_message(:invalid_username)
    erb :home
  else
    employee = LumberYard::Employee.new.get_employee(params["username_name"])
    set_session_data(employee)
    erb :index
  end
end

post '/timesheets/create' do
  @clients = LumberYard::Client.new.get_all_clients

  if !LumberYard::Timesheet.new.create_timesheet({
    username: session[:employee_username],
    date: params[:date],
    hours: params[:hours],
    project_type: params[:project_type],
    client: params[:client]
    }).valid?
    flash[:timesheet_error] = ModelCitizen::Messages.new.get_message(:invalid_timesheet)
    redirect '/timesheets/new'
  else
    flash[:timesheet_success] = ModelCitizen::Messages.new.get_message(:timesheet_success)
    redirect '/home/index'
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
    flash[:employee_error] = ModelCitizen::Messages.new.get_message(:invalid_employee)
    redirect '/employee/new'
  else
    flash[:employee_success] = ModelCitizen::Messages.new.get_message(:employee_success)
    redirect '/home/index'
  end
end

post '/clients/create' do
  if !LumberYard::Client.new.create_client({
    name: params[:name],
    type: params[:type]
    }).valid?
    flash[:client_error] = ModelCitizen::Messages.new.get_message(:invalid_client)
    redirect '/client/new'
  else
    flash[:client_success] = ModelCitizen::Messages.new.get_message(:client_success)
    redirect '/home/index'
  end
end

def set_session_data(employee)
  set_username_session(employee)
  set_first_name_session(employee)
  set_type_session(employee)
end

private

def set_username_session(employee)
  session[:employee_username] = employee.username
end

def set_first_name_session(employee)
  session[:employee_first_name] = employee.first_name
end

def set_type_session(employee)
    session[:employee_type] = employee.employee_type
end