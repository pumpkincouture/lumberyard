require_relative 'lib/lumberlogger.rb'
require_relative 'lib/client.rb'
require_relative 'lib/employee.rb'

module LumberYardHelpers

  def include_logger
    LumberLogger.new
  end

  def client_instance
    Client.new
  end

  def employee_instance
    Employee.new
  end

  def admin?(params)
    Employee.first(:username => params.downcase).admin?
  end

  def non_admin?(params)
    Employee.first(:username => params.downcase).non_admin?
  end

  def employee_exists?(params)
    !Employee.all(:username => params.downcase).empty? ? true : false
  end

  def find_employee(params)
    Employee.first(:username => params.downcase)
  end

  def get_correct_form(choice)
    forms = ["log_time", "time_report", "add_employee", "add_client", "employee_report"]
    forms[choice.to_i - 1].to_sym
  end

  def get_all_clients
    client_instance.get_all_clients
  end

  def get_timesheet
    include_logger.get_timesheet
  end

  def valid_employee?(attributes)
    employee_instance.create_employee(attributes).valid?
  end

  def valid_client?(attributes)
    client_instance.create_client(attributes).valid?
  end

  def valid_timesheet?(attributes)
    include_logger.create_timesheet(attributes).valid?
  end
end