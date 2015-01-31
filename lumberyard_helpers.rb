require_relative 'lib/lumberlogger.rb'

module LumberYardHelpers

  def include_logger
    LumberLogger.new
  end

  def admin?(params)
    include_logger.find_employee(params).employee_type == 'admin'
  end

  def non_admin?(params)
    include_logger.find_employee(params).employee_type == 'non_admin'
  end

  def employee_exists?(params)
    include_logger.employee_exists?(params)
  end

  def find_employee(params)
    include_logger.find_employee(params)
  end

  def get_correct_form(choice)
    forms = [:log_time, :time_report, :add_employee, :add_client, :employee_report]
    forms[choice.to_i - 1]
  end
end