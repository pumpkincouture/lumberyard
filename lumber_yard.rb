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

get '/report' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.current_month_employee_timesheet(LumberYard::Timesheet.new.current_month, session[:employee_username])
  erb :'report/show'
end

get '/reports/all_employees' do
  @options = ModelCitizen::Messages.new
  @time_sheet = LumberYard::Timesheet.new.current_month_timesheet(LumberYard::Timesheet.new.current_month)
  erb :'all_employee_report/show'
end

get '/timesheets/new' do
  @clients = LumberYard::Client.new.find_clients
  erb :'timesheets/new'
end

get '/clients/new' do
  erb :'client/new'
end

get '/employees/new' do
  erb :'employee/new'
end

get '/login' do
  erb :index
end

post '/username' do
  if !LumberYard::Employee.new.employee_exists?(params["username_name"])
    flash[:username_error] = ModelCitizen::Messages.new.get_message(:invalid_username)
    erb :home
  else
    employee = LumberYard::Employee.new.find_employee(params["username_name"])
    set_session_data(employee)
    redirect '/login'
  end
end

post '/timesheets' do
  @clients = LumberYard::Client.new.find_clients

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
    redirect '/login'
  end
end

post '/employees' do
  @clients = LumberYard::Client.new.find_clients
  if !LumberYard::Employee.new.create_employee({
    first_name: params[:first_name],
    last_name: params[:last_name],
    username: params[:username],
    employee_type: params[:employee_type],
    }).valid?
    flash[:employee_error] = ModelCitizen::Messages.new.get_message(:invalid_employee)
    redirect '/employees/new'
  else
    flash[:employee_success] = ModelCitizen::Messages.new.get_message(:employee_success)
    redirect '/login'
  end
end

post '/clients' do
  if !LumberYard::Client.new.create_client({
    name: params[:name],
    type: params[:type]
    }).valid?
    flash[:client_error] = ModelCitizen::Messages.new.get_message(:invalid_client)
    redirect '/clients/new'
  else
    flash[:client_success] = ModelCitizen::Messages.new.get_message(:client_success)
    redirect '/login'
  end
end

def set_session_data(employee)
  session[:employee_first_name] = employee.first_name
  session[:employee_username] = employee.username
  session[:employee_type] = employee.employee_type
end