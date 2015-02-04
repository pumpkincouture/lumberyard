require_relative 'lib/lumberlogger.rb'

module LumberYardHelpers

  def include_logger
    LumberLogger.new
  end

  def admin?(params)
    include_logger.find_employee(params).employee_type == "admin"
  end

  def non_admin?(params)
    include_logger.find_employee(params).employee_type == "non-admin"
  end

  def employee_exists?(params)
    include_logger.employee_exists?(params)
  end

  def find_employee(params)
    include_logger.find_employee(params)
  end

  def get_correct_form(choice)
    forms = ["log_time", "time_report", "add_employee", "add_client", "employee_report"]
    forms[choice.to_i - 1].to_sym
  end

  def get_all_clients
    include_logger.get_all_clients
  end

  def get_timesheet
    include_logger.get_timesheet
  end

  def valid_employee?(attributes)
    include_logger.create_employee(attributes).valid?
  end

  def valid_client?(attributes)
    include_logger.create_client(attributes).valid?
  end

  def valid_timesheet?(attributes)
    include_logger.create_timesheet(attributes).valid?
  end
end