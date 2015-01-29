require 'data_mapper'

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
      :project_type => attributes.fetch(:project_type)
      )
  end

  def find_client(client)
    client_in_database?(client) ? get_client_record(client) : false
  end

  def find_employee(employee)
    employee_in_database?(employee) ? get_employee_record(employee) : false
  end

  def employee_exists?(employee)
    employee_in_database?(employee)
  end

  def client_exists?(client)
    client_in_database?(client)
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
end