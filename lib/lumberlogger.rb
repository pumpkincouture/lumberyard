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

  def employee_exists?(employee)
    !Employee.all(:username => employee.downcase).empty? ? true : false
  end

  def client_exists?(client)
    !Client.all(:name => client.capitalize).empty? ? true : false
  end
end