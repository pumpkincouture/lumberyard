class Employee
  def initialize(attributes)
    @attributes = attributes
  end

  def valid?
    valid_employee_type? && valid_employee_fields?
  end

  private

  def valid_employee_type?
    ['admin', 'non-admin'].include?(@attributes[:employee_type])
  end

  def valid_employee_fields?
    valid_name_attributes? && valid_username?
  end

  def valid_name_attributes?
    !@attributes[:last_name].nil? && !@attributes[:last_name].empty? &&
     !@attributes[:first_name].nil? && !@attributes[:first_name].empty?
  end

  def valid_username?
    !@attributes[:username].nil? && !@attributes[:username].empty?
  end
end