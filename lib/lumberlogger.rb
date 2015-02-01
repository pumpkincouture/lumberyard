require 'data_mapper'
require 'date'
require 'timesheet'

class LumberLogger

  def create_employee(attributes)
    Employee.create(
      :first_name => attributes.fetch(:first_name),
      :last_name => attributes.fetch(:last_name),
      :username => attributes.fetch(:username),
      :employee_type => attributes.fetch(:employee_type)
      )
  end

  def create_client(attributes)
    Client.create(
      :name => attributes.fetch(:name),
      :type => attributes.fetch(:type)
      )
  end

  def create_timesheet(attributes)
    TimeSheet.create(
      :username => attributes.fetch(:username),
      :date => attributes.fetch(:date),
      :hours => attributes.fetch(:hours),
      :project_type => attributes.fetch(:project_type),
      :client => attributes.fetch(:client)
      )
  end

  def find_client(client)
    get_client_record(client)
  end

  def find_employee(employee)
    get_employee_record(employee)
  end

  def employee_exists?(employee)
    employee_in_database?(employee)
  end

  def client_exists?(client)
    client_in_database?(client)
  end

  def get_all_clients
    Client.all
  end

  def get_timesheet
     TimeSheet.all(:date => get_this_month)
  end

  private

  def get_employee_record(employee)
    Employee.first(:username => employee.downcase)
  end

  def get_client_record(client)
    Client.first(:name => client.capitalize)
  end

  def employee_in_database?(employee)
    !Employee.all(:username => employee.downcase).empty? ? true : false
  end

  def client_in_database?(client)
    !Client.all(:name => client.capitalize).empty? ? true : false
  end

  def get_this_month
    Date.today.month.to_s
  end
end